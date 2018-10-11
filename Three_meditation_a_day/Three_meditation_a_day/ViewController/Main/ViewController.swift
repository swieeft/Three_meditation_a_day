//
//  ViewController.swift
//  Three_meditation_a_day
//
//  Created by Park GilNam on 2018. 1. 6..
//  Copyright © 2018년 ParkGilNam. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SelectDateSendDelegate {
    
    @IBOutlet weak var navigationTitleButton: UIButton!
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var dayViewCollection:[CalenderView] = []
    
    var dayViews:[[CalenderView]] = [[CalenderView]]()
    var meditation:[MeditationData] = [MeditationData]()
    var selectDate:Date = Date.init()
    
    fileprivate var user:KOUser? = nil
    fileprivate var doneSignup:Bool = false
    fileprivate var singleTapGesture: UITapGestureRecognizer!
    fileprivate var accessToken:NSNumber?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        todayButton.layer.borderColor = UIColor(red: 0.53, green: 0.035, blue: 0.035, alpha: 1).cgColor
        todayButton.layer.borderWidth = 1
        todayButton.layer.cornerRadius = 27/2
        todayButton.layer.masksToBounds = true
        
        let currentDate = Date.init()
        
        selectDate = currentDate
        UserDefaults.standard.set(currentDate, forKey: ForKey.selectDate.string)
        
        self.navigationItem.addLeftItem(image: UIImage(named: "logout.png")!, target: self, action: #selector(logoutAction(sender:)))
        self.navigationItem.addRight(image: UIImage(named: "settings.png")!, target: self, action: #selector(settingAction(sender:)))
        
        addViewGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationTitleSetting(date: selectDate)
    }
    
    //calender view click gesture add
    func addViewGesture() {
        
        var weekViews:[CalenderView] = []
        
        for i in 0..<dayViewCollection.count {
            let dayView = dayViewCollection[i]
            
            weekViews.append(dayView)
            
            if (i + 1) % 7 == 0 {
                dayViews.append(weekViews)
                weekViews.removeAll()
            }
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(goDetailPage(sender:)))
            dayView.addGestureRecognizer(gesture)
        }
    }
    
    //logout button click
    @objc func logoutAction(sender:UIBarButtonItem) {
        let refreshAlert = UIAlertController(title: "로그아웃", message: "로그아웃을 하시겠습니까?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "예", style: .default, handler: { (action: UIAlertAction!) in
            self.logout()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "아니요", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    @objc func settingAction(sender:UIBarButtonItem) {
        let storyboard  = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Setting")
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func logout() {
        KOSession.shared().logoutAndClose { [weak self] (success, error) -> Void in
            _ = self?.navigationController?.popViewController(animated: true)
        }
    }
    
    //navigation title 세팅
    func navigationTitleSetting(date:Date) {
    
        activityIndicator.startAnimating()
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: DateFormat.localeIdentifier.format) as Locale?
        formatter.dateFormat = DateFormat.yearMonth.format
        
        let dateString = formatter.string(from: date)
        
        navigationTitleButton.setTitle("\(dateString)", for: UIControlState.normal)
        
        selectDate = date
        
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.dateComponents([.year, .month], from: self.selectDate)
        
        guard let _ = date.year, let _ = date.month else {
            return
        }
        
        let guestLogin = UserDefaults.standard.bool(forKey: ForKey.guestLogin.string)
        
        if guestLogin {
            setViewCalender(date: date)
            self.activityIndicator.stopAnimating()
        } else {
            getDayMeditationStatusCheckData(date:date)
        }
    }
    
    fileprivate func requestMe(_ displayResult: Bool = false) {
        KOSessionTask.meTask { [weak self] (user, error) -> Void in
            if let error = error as NSError? {
                print(error)
            } else {
                if displayResult {
                    print((user as! KOUser).description)
                }

                self?.user = user as? KOUser
                UserDefaults.standard.set(self?.user?.email ?? "--", forKey: ForKey.kakaoEmail.string)

                DispatchQueue.main.async(execute: {
                    self?.viewDidAppear(true)
                })
            }
        }
    }
    
    //묵상 입력 상태를 가져옴
    func getDayMeditationStatusCheckData(date:DateComponents)  {
        guard let userid = UserDefaults.standard.string(forKey: ForKey.kakaoEmail.string) else {
            requestMe()
            self.activityIndicator.stopAnimating()
            return
        }
        
        let urlComponents = NSURLComponents(string: Api.Url.host.searchCurrentMonthMeditation)!
        urlComponents.queryItems = [
            URLQueryItem(name: JsonKey.userid.string, value: userid),
            URLQueryItem(name: JsonKey.year.string, value: String(describing: (date.year)!)),
            URLQueryItem(name: JsonKey.month.string, value: String(describing: (date.month)!)),
        ]
        
        Api.getData(data: self.meditation, urlComponents: urlComponents, httpMethod: Api.httpMethod.get.string) { (data, success) in
            if success == false {
                return
            }
            
            self.meditation = data
            
            DispatchQueue.main.async(execute: {
                self.setViewCalender(date: date, meditation: self.meditation)
                self.activityIndicator.stopAnimating()
                self.view.setNeedsDisplay()
            })
        }
    }
    
    //캘린더 생성
    func setViewCalender(date:DateComponents, meditation:[MeditationData]? = nil) {
        let weekData = WeekData()
        weekData.setData(date: date)
        
        var day:Int = 1
        
        for weekOfMonth in 0..<dayViews.count {
            let weekOfMonthViews = dayViews[weekOfMonth]

            for weekDay in 0..<weekOfMonthViews.count {
                let view = weekOfMonthViews[weekDay]
                
                if view.setView(date: date, weekDate: weekData, weekOfMonth: weekOfMonth, weekDay: weekDay, meditation:meditation, day:day) {
                    day += 1
                }
            }
        }
    }

    //날짜를 선택하면 Detail page로 이동
    @objc func goDetailPage(sender:UIGestureRecognizer) {
        guard let view = sender.view as? CalenderView else {
            return
        }
        
        guard let day = view.dayLabel.text, day == "" else {
            return
        }
        
        let calendar = Calendar(identifier: .gregorian)
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.yearMonthDay.format
        
        let date = calendar.dateComponents([.year, .month], from: self.selectDate)
        
        guard let year = date.year, let month = date.month else {
            return
        }
        
        guard let clickDate = formatter.date(from: "\(year)-\(month)-\(day)") else {
            return
        }
        
        let currentDate = Date.init()
        
        if clickDate <= currentDate{
            let storyboard  = UIStoryboard(name: "Main", bundle: nil)
            
            formatter.dateFormat = DateFormat.yearMonthDayDat.format
            let dateString = formatter.string(from: clickDate)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "Detail")
            vc.navigationItem.title = dateString
            
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
    //월 선택 창에서 선택된 데이터로 타이틀 세팅
    func selectDateSend(selectDate: Date) {
        navigationTitleSetting(date:selectDate)
    }
    
    //월 선택창 열기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectDatePopup" {
            let viewController : SelectDatePopupViewController = segue.destination as! SelectDatePopupViewController
            viewController.delegate = self
        }
    }
    
    //손가락 왼쪽 -> 오른쪽 드래그 시 이전 달로 캘린더 변경
    @IBAction func swipeGestureRightAction(_ sender: UISwipeGestureRecognizer) {
        swipeNewDate(isRight: true)
    }
    
    //손가락 오른쪽 -> 왼쪽 드래그 시 다음 달로 캘린더 변경
    @IBAction func swipeGestureLeftAction(_ sender: UISwipeGestureRecognizer) {
        swipeNewDate(isRight: false)
    }
    
    func swipeNewDate(isRight:Bool) {
        guard let newDate = Utils.getNewDate(isRight: isRight, selectDate: self.selectDate) else {
            return
        }
        
        navigationTitleSetting(date:newDate)
    }
    
    //캘린더를 오늘 날짜의 월로 이동
    @IBAction func todayAction(_ sender: Any) {
        let currentDate = Date.init()
        navigationTitleSetting(date:currentDate)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

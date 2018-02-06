//
//  ViewController.swift
//  Three_meditation_a_day
//
//  Created by Park GilNam on 2018. 1. 6..
//  Copyright © 2018년 ParkGilNam. All rights reserved.
//

import UIKit

protocol SelectDateSendDelegate {
    func selectDateSend(selectDate:Date)
}

class ViewController: UIViewController, SelectDateSendDelegate {
    
    @IBOutlet weak var navigationTitleButton: UIButton!
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //1주차
    @IBOutlet weak var sunday1Weeks: CalenderView!
    @IBOutlet weak var monday1Weeks: CalenderView!
    @IBOutlet weak var tuesday1Weeks: CalenderView!
    @IBOutlet weak var wednesday1Weeks: CalenderView!
    @IBOutlet weak var thursday1Weeks: CalenderView!
    @IBOutlet weak var firday1Weeks: CalenderView!
    @IBOutlet weak var saturday1Weeks: CalenderView!
    
    //2주차
    @IBOutlet weak var sunday2Weeks: CalenderView!
    @IBOutlet weak var monday2Weeks: CalenderView!
    @IBOutlet weak var tuesday2Weeks: CalenderView!
    @IBOutlet weak var wednesday2Weeks: CalenderView!
    @IBOutlet weak var thursday2Weeks: CalenderView!
    @IBOutlet weak var firday2Weeks: CalenderView!
    @IBOutlet weak var saturday2Weeks: CalenderView!
    
    //3주차
    @IBOutlet weak var sunday3Weeks: CalenderView!
    @IBOutlet weak var monday3Weeks: CalenderView!
    @IBOutlet weak var tuesday3Weeks: CalenderView!
    @IBOutlet weak var wednesday3Weeks: CalenderView!
    @IBOutlet weak var thursday3Weeks: CalenderView!
    @IBOutlet weak var firday3Weeks: CalenderView!
    @IBOutlet weak var saturday3Weeks: CalenderView!
    
    //4주차
    @IBOutlet weak var sunday4Weeks: CalenderView!
    @IBOutlet weak var monday4Weeks: CalenderView!
    @IBOutlet weak var tuesday4Weeks: CalenderView!
    @IBOutlet weak var wednesday4Weeks: CalenderView!
    @IBOutlet weak var thursday4Weeks: CalenderView!
    @IBOutlet weak var firday4Weeks: CalenderView!
    @IBOutlet weak var saturday4Weeks: CalenderView!
    
    //5주차
    @IBOutlet weak var sunday5Weeks: CalenderView!
    @IBOutlet weak var monday5Weeks: CalenderView!
    @IBOutlet weak var tuesday5Weeks: CalenderView!
    @IBOutlet weak var wednesday5Weeks: CalenderView!
    @IBOutlet weak var thursday5Weeks: CalenderView!
    @IBOutlet weak var firday5Weeks: CalenderView!
    @IBOutlet weak var saturday5Weeks: CalenderView!
    
    //6주차
    @IBOutlet weak var sunday6Weeks: CalenderView!
    @IBOutlet weak var monday6Weeks: CalenderView!
    @IBOutlet weak var tuesday6Weeks: CalenderView!
    @IBOutlet weak var wednesday6Weeks: CalenderView!
    @IBOutlet weak var thursday6Weeks: CalenderView!
    @IBOutlet weak var firday6Weeks: CalenderView!
    @IBOutlet weak var saturday6Weeks: CalenderView!
    
    var dayViews:[[CalenderView]] = [[CalenderView]]()
    var meditation:[MeditationStruct] = [MeditationStruct]()
    var selectDate:Date = Date.init()
    
    fileprivate var user:KOUser? = nil
    fileprivate var doneSignup:Bool = false
    fileprivate var singleTapGesture: UITapGestureRecognizer!
    fileprivate var accessToken:NSNumber?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dayViews = [[sunday1Weeks, monday1Weeks, tuesday1Weeks, wednesday1Weeks, thursday1Weeks, firday1Weeks, saturday1Weeks],
        [sunday2Weeks, monday2Weeks, tuesday2Weeks, wednesday2Weeks, thursday2Weeks, firday2Weeks, saturday2Weeks],
        [sunday3Weeks, monday3Weeks, tuesday3Weeks, wednesday3Weeks, thursday3Weeks, firday3Weeks, saturday3Weeks],
        [sunday4Weeks, monday4Weeks, tuesday4Weeks, wednesday4Weeks, thursday4Weeks, firday4Weeks, saturday4Weeks],
        [sunday5Weeks, monday5Weeks, tuesday5Weeks, wednesday5Weeks, thursday5Weeks, firday5Weeks, saturday5Weeks],
        [sunday6Weeks, monday6Weeks, tuesday6Weeks, wednesday6Weeks, thursday6Weeks, firday6Weeks/*, saturday6Weeks*/]]
        
        todayButton.layer.borderColor = UIColor(red: 0.53, green: 0.035, blue: 0.035, alpha: 1).cgColor
        todayButton.layer.borderWidth = 1
        todayButton.layer.cornerRadius = 27/2
        todayButton.layer.masksToBounds = true
        
        let currentDate = Date.init()
        
        selectDate = currentDate
        UserDefaults.standard.set(currentDate, forKey: Define.forKeyStruct.selectDate)
        
        addNavigationItem()
        
        addViewGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationTitleSetting(date: selectDate)
    }
    
    func addNavigationItem() {
        let logoutButton: UIButton = UIButton(type: UIButtonType.custom)
        logoutButton.setImage(UIImage(named: "logout.png")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        logoutButton.addTarget(self, action: #selector(logoutAction(sender:)), for: UIControlEvents.touchUpInside)
        logoutButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        let logoutBarButton = UIBarButtonItem(customView: logoutButton)
        logoutBarButton.tintColor = UIColor.white
        
        self.navigationItem.leftBarButtonItem = logoutBarButton
        
        let settingButton: UIButton = UIButton(type: UIButtonType.custom)
        settingButton.setImage(UIImage(named: "settings.png")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        settingButton.addTarget(self, action: #selector(settingAction(sender:)), for: UIControlEvents.touchUpInside)
        settingButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        let settingBarButton = UIBarButtonItem(customView: settingButton)
        settingBarButton.tintColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = settingBarButton
    }
    
    //calender view click gesture add
    func addViewGesture() {

        for weekViewsIndex in 0..<dayViews.count {
            let weekViews = dayViews[weekViewsIndex]
            
            for viewIndex in 0..<weekViews.count {
                let view = weekViews[viewIndex]
                
                let gesture = UITapGestureRecognizer(target: self, action: #selector(goDetailPage(sender:)))
                view.addGestureRecognizer(gesture)
            }
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
        
        present(refreshAlert, animated: true, completion: nil)
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
        formatter.locale = NSLocale(localeIdentifier: Define.dateFormat.localeIdentifier) as Locale!
        formatter.dateFormat = Define.dateFormat.yearMonth
        
        let dateString = formatter.string(from: date)
        
        navigationTitleButton.setTitle("\(dateString)", for: UIControlState.normal)
        
        selectDate = date
        
        getDayMeditationStatusCheckData()
    }
    
    //묵상 입력 상태를 가져옴
    func getDayMeditationStatusCheckData()  {
        
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.dateComponents([.year, .month], from: self.selectDate)
        
        if date.year == nil || date.month == nil {
            return
        }
        
        let userid = UserDefaults.standard.string(forKey: Define.forKeyStruct.kakaoEmail)
        
        let urlComponents = NSURLComponents(string: Define.webServer.searchCurrentMonthMeditation)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: Define.jsonKey.userid, value: userid!),
            URLQueryItem(name: Define.jsonKey.year, value: String(describing: (date.year)!)),
            URLQueryItem(name: Define.jsonKey.month, value: String(describing: (date.month)!)),
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = Define.webServer.get
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            guard let data = data else { return }
            
            do {
                self.meditation = try JSONDecoder().decode([MeditationStruct].self, from: data)
            } catch {
                print("Parsing error \(error)")
            }
            
            DispatchQueue.main.async(execute: {
                self.setViewCalender(date: date, meditation: self.meditation)
                self.activityIndicator.stopAnimating()
            })
        });
        task.resume()
    }
    
    //캘린더 생성
    func setViewCalender(date:DateComponents, meditation:[MeditationStruct]) {
        
        var lastDay:Int = 0
        
        switch date.month! {
        case 1, 3, 5, 7, 8, 10, 12:
            lastDay = 31
        case 4, 6, 9, 11:
            lastDay = 30
        default:
            if  date.year! % 400 == 0 || date.year! % 4 == 0 && date.year! % 100 != 0 {
                lastDay = 29
            } else {
                lastDay = 28
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = Define.dateFormat.yearMonthDay
        
        let firstDay:Int = 1
        
        let startDate = formatter.date(from: "\(date.year!)-\(date.month!)-\(firstDay)")
        let endDate = formatter.date(from: "\(date.year!)-\(date.month!)-\(lastDay)")
        
        if startDate != nil && endDate != nil {
            let calendar = Calendar(identifier: .gregorian)
            
            let startDateWeek = calendar.dateComponents([.weekOfMonth, .weekday], from: startDate!)
            let endDateWeek = calendar.dateComponents([.weekOfMonth, .weekday], from: endDate!)
            
            let currentWeek = calendar.dateComponents([.weekOfMonth, .weekday], from: Date.init())
            let currentDate = calendar.dateComponents([.year, .month], from: Date.init())

            let startDateWeekOfMonth = startDateWeek.weekOfMonth! - 1
            let startDateWeekDay = startDateWeek.weekday! - 1
            let endDateWeekOfMonth = endDateWeek.weekOfMonth! - 1
            let endDateWeekDay = endDateWeek.weekday! - 1
            let currentDateWeekOfMonth = currentWeek.weekOfMonth! - 1
            let currentDateWeekDay = currentWeek.weekday! - 1

            var day:Int = 1
            
            for weekOfMonth in 0..<dayViews.count {
                let weekOfMonthViews = dayViews[weekOfMonth]

                if weekOfMonth < startDateWeekOfMonth || weekOfMonth > endDateWeekOfMonth {
                    for weekDay in 0..<weekOfMonthViews.count {
                        let view = weekOfMonthViews[weekDay]
                        view.dayLabel.text = ""
                        view.morningLable.isHidden = true
                        view.afternoonLabel.isHidden = true
                        view.eveningLabel.isHidden = true
                        view.layer.borderWidth = 0
                        view.layer.borderColor = UIColor.white.cgColor
                    }
                    continue
                }

                for weekDay in 0..<weekOfMonthViews.count {

                    let view = weekOfMonthViews[weekDay]
                    
                    view.morningLable.isHidden = true
                    view.afternoonLabel.isHidden = true
                    view.eveningLabel.isHidden = true

                    if currentDateWeekOfMonth == weekOfMonth
                        && currentDateWeekDay == weekDay
                        && currentDate.year == date.year
                        && currentDate.month == date.month {
                        
                        view.layer.borderWidth = 3
                        view.layer.borderColor = UIColor(red: 0.53, green: 0.035, blue: 0.035, alpha: 1).cgColor
                    } else {
                        view.layer.borderWidth = 0
                        view.layer.borderColor = UIColor.white.cgColor

                        switch weekDay {
                        case 0 :
                            view.dayLabel.textColor = UIColor.red
                        case 6:
                            view.dayLabel.textColor = UIColor.blue
                        default :
                            view.dayLabel.textColor = UIColor.black
                        }
                    }

                    if weekDay < startDateWeekDay && weekOfMonth == startDateWeekOfMonth {
                        view.dayLabel.text = ""
                    } else if weekDay > endDateWeekDay && weekOfMonth == endDateWeekOfMonth {
                        view.dayLabel.text = ""
                    } else {
                        view.dayLabel.text = String(day)
                        
                        let todayMeditationArr = meditation.filter{$0.day == day}
                        
                        if todayMeditationArr.count > 0 {
                            
                            let todayMeditation = todayMeditationArr[0]
                            
                            if todayMeditation.morning != "" {
                                view.morningLable.isHidden = false
                            }
                            if todayMeditation.afternoon != "" {
                                view.afternoonLabel.isHidden = false
                                view.setNeedsDisplay()
                            }
                            if todayMeditation.evening != "" {
                                view.eveningLabel.isHidden = false
                                view.setNeedsDisplay()
                            }
                        }
                        
                        day += 1
                    }
                }
            }
        }
    }

    //날짜를 선택하면 Detail page로 이동
    @objc func goDetailPage(sender:UIGestureRecognizer) {
        let view = sender.view as? CalenderView
        
        if view == nil {
            return
        }
    
        let day = view?.dayLabel.text
        
        if day == nil {
            return
        }
        
        if day! != "" {
            let calendar = Calendar(identifier: .gregorian)
            let formatter = DateFormatter()
            formatter.dateFormat = Define.dateFormat.yearMonthDay

            let date = calendar.dateComponents([.year, .month], from: self.selectDate)
            let clickDate = formatter.date(from: "\(date.year!)-\(date.month!)-\(day!)")
            let currentDate = Date.init()

            if clickDate == nil {
                return
            }

            if clickDate! <= currentDate{
                let storyboard  = UIStoryboard(name: "Main", bundle: nil)

                formatter.dateFormat = Define.dateFormat.yearMonthDayDat
                let dateString = formatter.string(from: clickDate!)

                let vc = storyboard.instantiateViewController(withIdentifier: "Detail")
                vc.navigationItem.title = dateString

                self.navigationController!.pushViewController(vc, animated: true)
            }
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

        let lastDate = getSwipeGestureActionDate(isRight: true)
        
        if lastDate != nil {
            navigationTitleSetting(date:lastDate!)
        }
    }
    
    //손가락 오른쪽 -> 왼쪽 드래그 시 다음 달로 캘린더 변경
    @IBAction func swipeGestureLeftAction(_ sender: UISwipeGestureRecognizer) {
        
        let nextDate = getSwipeGestureActionDate(isRight: false)
        
        if nextDate != nil {
            navigationTitleSetting(date:nextDate!)
        }
    }
    
    //swipe 시 날짜 생성
    func getSwipeGestureActionDate(isRight:Bool) -> Date? {
        
        let calendar = Calendar(identifier: .gregorian)
        let formatter = DateFormatter()
        formatter.dateFormat = Define.dateFormat.yearMonthDay
        
        let date = calendar.dateComponents([.year, .month, .day], from: self.selectDate)
        
        var year = 0
        var month = 0
        
        if isRight {
            if date.month! == 1 {
                year = date.year! - 1
                month = 12
            } else {
                year = date.year!
                month = date.month! - 1
            }
        } else {
            if date.month! == 12 {
                year = date.year! + 1
                month = 1
            } else {
                year = date.year!
                month = date.month! + 1
            }
        }
        
        if year < 2018 {
            return nil
        } else if year == 2018 && month == 1 {
            return nil
        }
        else {
            let swipeDate = formatter.date(from: "\(year)-\(month)-\(date.day!)")
        
            return swipeDate
        }
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

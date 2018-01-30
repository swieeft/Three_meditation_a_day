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
    
    //1주차
    @IBOutlet weak var sunday1Weeks: UIButton!
    @IBOutlet weak var monday1Weeks: UIButton!
    @IBOutlet weak var tuesday1Weeks: UIButton!
    @IBOutlet weak var wednesday1Weeks: UIButton!
    @IBOutlet weak var thursday1Weeks: UIButton!
    @IBOutlet weak var firday1Weeks: UIButton!
    @IBOutlet weak var saturday1Weeks: UIButton!
    
    //2주차
    @IBOutlet weak var sunday2Weeks: UIButton!
    @IBOutlet weak var monday2Weeks: UIButton!
    @IBOutlet weak var tuesday2Weeks: UIButton!
    @IBOutlet weak var wednesday2Weeks: UIButton!
    @IBOutlet weak var thursday2Weeks: UIButton!
    @IBOutlet weak var firday2Weeks: UIButton!
    @IBOutlet weak var saturday2Weeks: UIButton!
    
    //3주차
    @IBOutlet weak var sunday3Weeks: UIButton!
    @IBOutlet weak var monday3Weeks: UIButton!
    @IBOutlet weak var tuesday3Weeks: UIButton!
    @IBOutlet weak var wednesday3Weeks: UIButton!
    @IBOutlet weak var thursday3Weeks: UIButton!
    @IBOutlet weak var firday3Weeks: UIButton!
    @IBOutlet weak var saturday3Weeks: UIButton!
    
    //4주차
    @IBOutlet weak var sunday4Weeks: UIButton!
    @IBOutlet weak var monday4Weeks: UIButton!
    @IBOutlet weak var tuesday4Weeks: UIButton!
    @IBOutlet weak var wednesday4Weeks: UIButton!
    @IBOutlet weak var thursday4Weeks: UIButton!
    @IBOutlet weak var firday4Weeks: UIButton!
    @IBOutlet weak var saturday4Weeks: UIButton!
    
    //5주차
    @IBOutlet weak var sunday5Weeks: UIButton!
    @IBOutlet weak var monday5Weeks: UIButton!
    @IBOutlet weak var tuesday5Weeks: UIButton!
    @IBOutlet weak var wednesday5Weeks: UIButton!
    @IBOutlet weak var thursday5Weeks: UIButton!
    @IBOutlet weak var firday5Weeks: UIButton!
    @IBOutlet weak var saturday5Weeks: UIButton!
    
    //6주차
    @IBOutlet weak var sunday6Weeks: UIButton!
    @IBOutlet weak var monday6Weeks: UIButton!
    @IBOutlet weak var tuesday6Weeks: UIButton!
    @IBOutlet weak var wednesday6Weeks: UIButton!
    @IBOutlet weak var thursday6Weeks: UIButton!
    @IBOutlet weak var firday6Weeks: UIButton!
    @IBOutlet weak var saturday6Weeks: UIButton!
    
    var daysButtons:[[UIButton]] = [[UIButton]]()
    var selectDate:Date = Date.init()
    
    fileprivate var user:KOUser? = nil
    fileprivate var doneSignup:Bool = false
    fileprivate var singleTapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        daysButtons = [[sunday1Weeks, monday1Weeks, tuesday1Weeks, wednesday1Weeks, thursday1Weeks, firday1Weeks, saturday1Weeks],
        [sunday2Weeks, monday2Weeks, tuesday2Weeks, wednesday2Weeks, thursday2Weeks, firday2Weeks, saturday2Weeks],
        [sunday3Weeks, monday3Weeks, tuesday3Weeks, wednesday3Weeks, thursday3Weeks, firday3Weeks, saturday3Weeks],
        [sunday4Weeks, monday4Weeks, tuesday4Weeks, wednesday4Weeks, thursday4Weeks, firday4Weeks, saturday4Weeks],
        [sunday5Weeks, monday5Weeks, tuesday5Weeks, wednesday5Weeks, thursday5Weeks, firday5Weeks, saturday5Weeks],
        [sunday6Weeks, monday6Weeks, tuesday6Weeks, wednesday6Weeks, thursday6Weeks, firday6Weeks, saturday6Weeks]]
         
        let currentDate = Date.init()
        
        UserDefaults.standard.set(currentDate, forKey: Define.forKeyStruct.selectDate)
        
        navigationTitleSetting(date: currentDate)
        
        let logoutButton = UIBarButtonItem(title: "로그아웃", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logoutAction(sender:)))
        self.navigationItem.leftBarButtonItem = logoutButton
        
        requestMe()
    }
    
    fileprivate func requestMe(_ displayResult: Bool = false) {
        
        KOSessionTask.meTask { [weak self] (user, error) -> Void in
            if let error = error as NSError? {
                print(error)
                self?.doneSignup = false
            } else {
                if displayResult {
                    print((user as! KOUser).description)
                }

                self?.doneSignup = true
                self?.user = (user as! KOUser)

                UserDefaults.standard.set(self?.user?.email ?? "--", forKey: Define.forKeyStruct.kakaoEmail)
            }
        }
    }
    
    @objc func logoutAction(sender:UIBarButtonItem) {
        KOSession.shared().logoutAndClose { [weak self] (success, error) -> Void in
            _ = self?.navigationController?.popViewController(animated: true)
        }
    } 
    
    //navigation title 세팅
    func navigationTitleSetting(date:Date) {
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: Define.dateFormat.localeIdentifier) as Locale!
        formatter.dateFormat = Define.dateFormat.yearMonth
        
        let dateString = formatter.string(from: date)
        
        navigationTitleButton.setTitle("\(dateString)", for: UIControlState.normal)
        
        selectDate = date
        
        setViewCalender()
    }
    
    //캘린더 생성
    func setViewCalender() {
        
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.dateComponents([.year, .month], from: self.selectDate)
        
        if date.year == nil || date.month == nil {
            return
        }
        
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
            
            for weekOfMonth in 0..<daysButtons.count {
                let weekOfMonthButtons = daysButtons[weekOfMonth]
                
                if weekOfMonth < startDateWeekOfMonth || weekOfMonth > endDateWeekOfMonth {
                    for weekDay in 0..<weekOfMonthButtons.count {
                        let button = weekOfMonthButtons[weekDay]
                        button.setTitle(nil, for: UIControlState.normal)
                    }
                    continue
                }
                
                for weekDay in 0..<weekOfMonthButtons.count {
                    
                    let button = weekOfMonthButtons[weekDay]
                    
                    if currentDateWeekOfMonth == weekOfMonth && currentDateWeekDay == weekDay && currentDate.year == date.year && currentDate.month == date.month{
                        button.backgroundColor = UIColor(red: 0.53, green: 0.035, blue: 0.035, alpha: 1)
                        button.setTitleColor(UIColor.white, for: UIControlState.normal)
                        button.layer.cornerRadius = 10
                    } else {
                        button.backgroundColor = UIColor.white
                        
                        switch weekDay {
                        case 0 :
                            button.setTitleColor(UIColor.red, for: UIControlState.normal)
                        case 6:
                            button.setTitleColor(UIColor.blue, for: UIControlState.normal)
                        default :
                            button.setTitleColor(UIColor.black, for: UIControlState.normal)
                        }
                        
                        button.layer.cornerRadius = 0
                    }
                    
                    if weekDay < startDateWeekDay && weekOfMonth == startDateWeekOfMonth {
                        button.setTitle(nil, for: UIControlState.normal)
                    } else if weekDay > endDateWeekDay && weekOfMonth == endDateWeekOfMonth {
                        button.setTitle(nil, for: UIControlState.normal)
                    } else {
                        button.setTitle("\(day)", for: UIControlState.normal)
                        day += 1
                    }
                }
            }
        }
    }

    //날짜를 선택하면 Detail page로 이동
    @IBAction func goDetailPage(_ sender: UIButton) {
        
        if sender.currentTitle != nil {
            let calendar = Calendar(identifier: .gregorian)
            let formatter = DateFormatter()
            formatter.dateFormat = Define.dateFormat.yearMonthDay
        
            let date = calendar.dateComponents([.year, .month], from: self.selectDate)
            let clickDate = formatter.date(from: "\(date.year!)-\(date.month!)-\(sender.currentTitle!)")
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
        
        let swipeDate = formatter.date(from: "\(year)-\(month)-\(date.day!)")
        
        return swipeDate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

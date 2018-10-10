//
//  CalenderView.swift
//  Three_meditation_a_day
//
//  Created by Park GilNam on 2018. 2. 2..
//  Copyright © 2018년 ParkGilNam. All rights reserved.
//

import UIKit

class CalenderView: UIView {

    @IBOutlet var calenderView: CalenderView!
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var morningLable: UILabel!
    @IBOutlet weak var afternoonLabel: UILabel!
    @IBOutlet weak var eveningLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Init()
    }
    
    private func Init() {
        Bundle.main.loadNibNamed("CalenderView", owner: self, options: nil)
        self.addSubview(calenderView)
        
        calenderView.frame = self.bounds
        calenderView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        dayLabel.text = ""
    }
    
    func setView(date:DateComponents, weekDate:WeekData, weekOfMonth:Int, weekDay:Int, meditation:[MeditationStruct]? = nil, day:Int) -> Bool {
        guard let year = date.year, let month = date.month else {
            return false
        }
        
        setCelar()
        
        if setCurrentDay(weekDate: weekDate, weekOfMonth: weekOfMonth, weekDay: weekDay, year: year, month: month) == false {
            return false
        }
        
        setDayColor(weekDay: weekDay)
        
        return setDayText(weekDate: weekDate, weekOfMonth: weekOfMonth, weekDay: weekDay, meditation:meditation, day:day)
    }
    
    private func setCelar() {
        dayLabel.text = ""
        morningLable.isHidden = true
        afternoonLabel.isHidden = true
        eveningLabel.isHidden = true
    }
    
    private func setCurrentDay(weekDate:WeekData, weekOfMonth:Int, weekDay:Int, year:Int, month:Int) -> Bool {
        guard let currentWeekOfMonth = weekDate.currentWeekOfMonth, let currentWeekDay = weekDate.currentWeekDay, let currentYear = weekDate.currentWeek?.year, let currentMonth = weekDate.currentWeek?.month else {
            return false
        }
        
        if currentWeekOfMonth == weekOfMonth && currentWeekDay == weekDay && currentYear == year && currentMonth == month {
            layer.borderWidth = 3
            layer.borderColor = UIColor(red: 0.53, green: 0.035, blue: 0.035, alpha: 1).cgColor
        } else {
            layer.borderWidth = 0
            layer.borderColor = UIColor.white.cgColor
        }
        
        return true
    }
    
    private func setDayColor(weekDay:Int) {
        switch weekDay {
        case 0 :
            dayLabel.textColor = UIColor.red
        case 6:
            dayLabel.textColor = UIColor.blue
        default :
            dayLabel.textColor = UIColor.black
        }
    }
    
    private func setDayText(weekDate:WeekData, weekOfMonth:Int, weekDay:Int, meditation:[MeditationStruct]? = nil, day:Int) -> Bool {
        guard let startWeekOfMonth = weekDate.startWeekOfMonth, let startWeekDay = weekDate.startWeekDay else {
            return false
        }
        
        guard let endWeekOfMonth = weekDate.endWeekOfMonth, let endWeekDay = weekDate.endWeekDay else {
            return false
        }
        
        if weekDay < startWeekDay && weekOfMonth == startWeekOfMonth {
            dayLabel.text = ""
            return false
        } else if weekDay > endWeekDay && weekOfMonth == endWeekOfMonth {
            dayLabel.text = ""
            return false
        } else {
            dayLabel.text = String(day)
            
            setWrittenContemplationLabel(day:day, meditation:meditation)
            return true
        }
    }
    
    private func setWrittenContemplationLabel(day:Int, meditation:[MeditationStruct]? = nil) {
        let guestLogin = UserDefaults.standard.bool(forKey: ForKey.guestLogin.string)
        
        if guestLogin {
            return
        }
        
        let todayMeditationArr = meditation!.filter{$0.day == day}
        
        if todayMeditationArr.count > 0 {
            let todayMeditation = todayMeditationArr[0]
            
            morningLable.isHidden = todayMeditation.morning != "" ?  false : true
            afternoonLabel.isHidden = todayMeditation.afternoon != "" ?  false : true
            eveningLabel.isHidden = todayMeditation.evening != "" ?  false : true
            
            setNeedsDisplay()
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

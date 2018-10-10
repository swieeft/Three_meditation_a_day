//
//  WeekData.swift
//  Three_meditation_a_day
//
//  Created by 박길남 on 10/10/2018.
//  Copyright © 2018 ParkGilNam. All rights reserved.
//

import Foundation
import UIKit

class WeekData {
    var startWeek:DateComponents?
    var endWeek:DateComponents?
    var currentWeek:DateComponents?
   
    var startWeekOfMonth:Int?
    var startWeekDay:Int?
    
    var endWeekOfMonth:Int?
    var endWeekDay:Int?
    
    var currentWeekOfMonth:Int?
    var currentWeekDay:Int?
    
    func setData(date:DateComponents) {
        guard let year = date.year, let month = date.month else {
            return
        }
        
        let firstDay:Int = 1
        let lastDay:Int = Utils.getLastDay(year: year, month: month)
        
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.yearMonthDay.format
        
        guard let startDate = formatter.date(from: "\(year)-\(month)-\(firstDay)"), let endDate = formatter.date(from: "\(year)-\(month)-\(lastDay)") else {
            return
        }
        
        
        let calendar = Calendar(identifier: .gregorian)
//        let currentDate = calendar.dateComponents([.year, .month], from: Date.init())
        
        startWeek = calendar.dateComponents([.weekOfMonth, .weekday], from: startDate)
        if let weekMonth = startWeek?.weekOfMonth, let weekDay = startWeek?.weekday {
            startWeekOfMonth = weekMonth - 1
            startWeekDay = weekDay - 1
        }

        endWeek = calendar.dateComponents([.weekOfMonth, .weekday], from: endDate)
        if let weekMonth = endWeek?.weekOfMonth, let weekDay = endWeek?.weekday {
            endWeekOfMonth = weekMonth - 1
            endWeekDay = weekDay - 1
        }
        
        currentWeek = calendar.dateComponents([.weekOfMonth, .weekday, .year, .month, .day], from: Date.init())
        if let weekMonth = currentWeek?.weekOfMonth, let weekDay = currentWeek?.weekday {
            currentWeekOfMonth = weekMonth - 1
            currentWeekDay = weekDay - 1
        }
        
//        let startDateWeekOfMonth = startDateWeek.weekOfMonth! - 1
//        let startDateWeekDay = startDateWeek.weekday! - 1
//        let endDateWeekOfMonth = endDateWeek.weekOfMonth! - 1
//        let endDateWeekDay = endDateWeek.weekday! - 1
//        let currentDateWeekOfMonth = currentWeek.weekOfMonth! - 1
//        let currentDateWeekDay = currentWeek.weekday! - 1
    }
}

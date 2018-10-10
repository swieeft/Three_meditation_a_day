//
//  GetNewDate.swift
//  Three_meditation_a_day
//
//  Created by 박길남 on 10/10/2018.
//  Copyright © 2018 ParkGilNam. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    static func getNewDate(isRight:Bool, selectDate:Date) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.yearMonthDay.format
        
        let date = calendar.dateComponents([.year, .month, .day], from: selectDate)
        
        guard let year = date.year, let month = date.month else {
            return nil
        }
        
        var newYear = 0
        var newMonth = 0
        
        if isRight {
            newYear = month == 1 ? year - 1 : year
            newMonth = month == 1 ? 12 : month - 1
        } else {
            newYear = month == 12 ? year + 1 : year
            newMonth = month == 12 ? 1 : month + 1
        }
        
        if newYear < 2018 || (newYear == 2018 && newMonth == 1) {
            return nil
        } else {
            let newDate = formatter.date(from: "\(newYear)-\(newMonth)-\(date.day!)")
            return newDate
        }
    }
    
    static func getLastDay(year:Int, month:Int) -> Int {
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            return 31
        case 4, 6, 9, 11:
            return 30
        default:
            return (year % 400 == 0) || (year % 4 == 0) && (year % 100 != 0) ? 29 : 28
        }
    }
}

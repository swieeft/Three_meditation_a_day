//
//  Define.swift
//  Three_meditation_a_day
//
//  Created by Park GilNam on 2018. 1. 12..
//  Copyright © 2018년 ParkGilNam. All rights reserved.
//

import UIKit

enum ForKey {
    case selectDate
    case morningTime
    case afternoonTime
    case eveningTime
    case morningSwitchIsOn
    case afternoonSwitchIsOn
    case eveningSwitchIsOn
    case kakaoEmail
    case accessToken
    case guestLogin
    
    var string:String {
        switch self {
        case .selectDate: return "selectDate"
        case .morningTime: return "morningTime"
        case .afternoonTime: return "afternoonTime"
        case .eveningTime: return "eveningTime"
        case .morningSwitchIsOn: return "morningSwitchIsOn"
        case .afternoonSwitchIsOn: return "afternoonSwitchIsOn"
        case .eveningSwitchIsOn: return "eveningSwitchIsOn"
        case .kakaoEmail: return "kakaoEmail"
        case .accessToken: return "accessToken"
        case .guestLogin: return "guestLogin"
        }
    }
}

enum DateFormat {
    case localeIdentifier
    case yearMonth
    case day
    case time
    case yearMonthDay
    case yearMonthDayDat
    
    var format:String {
        switch self {
        case .localeIdentifier: return "ko_KR"
        case .yearMonth: return "yyyy. MM"
        case .day: return "d"
        case .time: return "a hh:mm"
        case .yearMonthDay: return "yyyy-MM-dd"
        case .yearMonthDayDat: return "yyyy. MM. dd"
        }
    }
}

enum NotiInfo {
    case morning
    case afternoon
    case evening
    
    var id:String {
        switch self {
        case .morning: return "morningNoti"
        case .afternoon: return "afternoonNoti"
        case .evening: return "eveningNoti"
        }
    }
    
    var title:String {
        switch self {
        case .morning: return "하루를 깨우는 아침묵상 한끼"
        case .afternoon: return "졸린 오후의 점심묵상 한잔"
        case .evening: return "하루를 되돌아 보며 저녁묵상 만찬"
        }
    }
    
    var body:String {
        switch self {
        case .morning: return "아침 일찍 피곤하시죠? 그래도 아침은 먹어야 힘이 나죠!\n아침에 묵상 한끼 어떠세요?"
        case .afternoon: return "오전에 일에 치이고 사람에 치이고...\n점심도 먹고 졸린 시간 묵상 한잔으로 피로를 날리세요!"
        case .evening: return "오늘 하루도 고생 많았어요. 이제 저녁 만찬을 즐길 시간이에요.\n오늘 하루를 돌아보며 묵상 만찬을 즐겨보세요."
        }
    }
}

enum CurrentTime {
    case morning
    case afternoon
    case evening
    
    var tag:Int {
        switch self {
        case .morning: return 0
        case .afternoon: return 1
        case .evening: return 2
        }
    }
}

enum Api {
    enum Url:String {
        case host = "http://13.124.215.178:80/"
        
        var searchTodayBibleVerses:String {
            return self.rawValue + "search/todaybibleverses"
        }
        
        var searchTodayMeditation:String {
            return self.rawValue + "search/todaymeditation"
        }
        
        var searchCurrentMonthMeditation:String {
            return self.rawValue + "search/currentMonthMeditation"
        }
        
        var saveMorningMeditation:String {
            return self.rawValue + "save/morningmeditation"
        }
        
        var saveAfternoonMeditation:String {
            return self.rawValue + "save/afternoonmeditation"
        }
        
        var saveEveningMeditation:String {
            return self.rawValue + "save/eveningmeditation"
        }
        
        var userRegister:String {
            return self.rawValue + "user/register"
        }
    }
    
    enum httpMethod {
        case get
        case post
        
        var string:String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            }
        }
    }
    
    static func getData<T:Decodable>(data:T, urlComponents:NSURLComponents, httpMethod:String, completion: @escaping (_ data:T, _ success:Bool) -> Void) {
        var tempData:T = data
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            guard let data = data else { return }
            
            do {
                tempData = try JSONDecoder().decode(T.self, from: data)
            } catch {
                print("Parsing error \(error)")
                
                DispatchQueue.main.async(execute: {
                    completion(tempData, false)
                })
            }
            
            DispatchQueue.main.async(execute: {
                completion(tempData, true)
            })
        });
        task.resume()
    }
    
    static func getData<T:Decodable>(data:T, urlComponents:NSURLComponents, httpMethod:String, body:Data, completion: @escaping (_ data:T, _ success:Bool) -> Void) {
        var tempData:T = data
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = httpMethod
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            guard let data = data else { return }
            
            do {
                tempData = try JSONDecoder().decode(T.self, from: data)
            } catch {
                print("Parsing error \(error)")
                
                DispatchQueue.main.async(execute: {
                    completion(tempData, false)
                })
            }
            
            DispatchQueue.main.async(execute: {
                completion(tempData, true)
            })
        });
        task.resume()
    }
}

enum SessionConstants {
    case clientSecret
    
    var string:String {
        switch self {
        case .clientSecret: return "bpN0WqF6IbWtjVa0tsoe0zrD0PdFV2Eh"
        }
    }
}

enum JsonKey {
    case userid
    case year
    case month
    case day
    case morning
    case afternoon
    case evening
    case accesstoken
    case pass
    
    var string:String {
        switch self {
        case .userid: return "userid"
        case .year: return "year"
        case .month: return "month"
        case .day: return "day"
        case .morning: return "morning"
        case .afternoon: return "afternoon"
        case .evening: return "evening"
        case .accesstoken: return "accesstoken"
        case .pass: return "pass"
        }
    }
}

enum CustomCell {
    enum Info {
        case detail
        case bibleVerses
        case copyright
        
        var id:String {
            switch self {
            case .detail: return "DetailCell"
            case .bibleVerses: return "BibleVersesCell"
            case .copyright: return "CopyrightCell"
            }
        }
        
        var nib:String {
            switch self {
            case .detail: return "DetailTableViewCell"
            case .bibleVerses: return "BibleVersesTableViewCell"
            case .copyright: return "CopyrightTableViewCell"
            }
        }
    }
    
    enum images {
        case morning
        case afternoon
        case evening
        
        var basicName:String {
            switch self {
            case .morning: return "Morning.png"
            case .afternoon: return "Afternoon.png"
            case .evening: return "Evening.png"
            }
        }
        
        var alarmName:String {
            switch self {
            case .morning: return "MorningAlarm.png"
            case .afternoon: return "AfternoonAlarm.png"
            case .evening: return "EveningAlarm.png"
            }
        }
    }
    
    enum title {
        case morning
        case afternoon
        case evening
        case morningAlarm
        case afternoonAlarm
        case eveningAlarm
        case bibleVersesBasic
        case bibleVersesExpand
        case bibleVersesFolding
        
        var string:String {
            switch self {
            case .morning: return "아침묵상"
            case .afternoon: return "점심묵상"
            case .evening: return "저녁묵상"
            case .morningAlarm: return "아침묵상 알림"
            case .afternoonAlarm: return "점심묵상 알림"
            case .eveningAlarm: return "저녁묵상 알림"
            case .bibleVersesBasic: return "오늘의 말씀"
            case .bibleVersesExpand: return "오늘의 말씀 ▼"
            case .bibleVersesFolding: return "오늘의 말씀 ▲"
            }
        }
    }
}

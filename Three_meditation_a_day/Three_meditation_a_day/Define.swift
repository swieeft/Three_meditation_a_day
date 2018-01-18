//
//  Define.swift
//  Three_meditation_a_day
//
//  Created by Park GilNam on 2018. 1. 12..
//  Copyright © 2018년 ParkGilNam. All rights reserved.
//

import UIKit

class Define: NSObject {
    
    struct forKeyStruct {
        static let selectDate = "selectDate"
        
        static let morningTime = "morningTime"
        static let afternoonTime = "afternoonTime"
        static let eveningTime = "eveningTime"
        
        static let morningSwitchIsOn = "morningSwitchIsOn"
        static let afternoonSwitchIsOn = "afternoonSwitchIsOn"
        static let eveningSwitchIsOn = "eveningSwitchIsOn"
        
        static let kakaoEmail = "kakaoEmail"
    }
    
    struct dateFormat {
        static let localeIdentifier = "ko_KR"
        static let yearMonth = "yyyy. MM"
        static let day = "d"
        static let time = "a hh:mm"
    }
    
    struct notificationStruct {
        static let morningNotiId = "morningNoti"
        static let afternoonNotiId = "afternoonNoti"
        static let eveningNotiId = "eveningNoti"
        
        static let morningTitle = "하루를 꺠우는 아침묵상 한끼"
        static let afternoonTitle = "졸린 오후의 점심묵상 한잔"
        static let eveningTitle = "하루를 되돌아 보며 저녁묵상 만찬"
        
        static let morningBody = "아침 일찍 피곤하시죠? 그래도 아침은 먹어야 힘이 나죠!\n아침에 묵상 한끼 어떠세요?"
        static let afternoonBody = "오전에 일에 치이고 사람에 치이고...\n점심도 먹고 졸린 시간 묵상 한잔으로 피로를 날리세요!"
        static let eveningBody = "오늘 하루도 고생 많았어요. 이제 저녁 만찬을 즐길 시간이에요.\n오늘 하루를 돌아보며 묵상 만찬을 즐겨보세요."
    }
    
    struct customCellStruct {
        static let detailCellId = "DetailCell"
        static let bibleVersesCellId = "BibleVersesCell"
        
        static let detailCellNib = "DetailTableViewCell"
        static let bibleVersesCellNib = "BibleVersesTableViewCell"
        
        static let bibleVersesCellTitle1 = "오늘의 말씀 ▼"
        static let bibleVersesCellTitle2 = "오늘의 말씀 ▲"
        static let bibleVersesCellTitle3 = "오늘의 말씀"
        
        static let morningImg = "Morning.png"
        static let afternoonImg = "Afternoon.png"
        static let eveningImg = "Evening.png"
        
        static let morningTitle = "아침묵상"
        static let afternoonTitle = "점심묵상"
        static let eveningTitle = "저녁묵상"
        
        static let morningAlarmImg = "MorningAlarm.png"
        static let afternoonAlarmImg = "AfternoonAlarm.png"
        static let eveningAlarmImg = "EveningAlarm.png"
        
        static let morningAlarmTitle = "아침묵상 알림"
        static let afternoonAlarmTitle = "점심묵상 알림"
        static let eveningAlarmTitle = "저녁묵상 알림"
    }
}

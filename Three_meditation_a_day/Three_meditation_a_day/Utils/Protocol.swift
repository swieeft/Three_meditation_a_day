//
//  Protocol.swift
//  Three_meditation_a_day
//
//  Created by 박길남 on 11/10/2018.
//  Copyright © 2018 ParkGilNam. All rights reserved.
//

import Foundation
import UIKit

protocol SelectDateSendDelegate {
    func selectDateSend(selectDate:Date)
}

protocol SaveDataSendDelegate {
    func saveDataSendDelegate(bibleVerses:String, meditation:String, date:DateComponents, currentTime:Int)
}

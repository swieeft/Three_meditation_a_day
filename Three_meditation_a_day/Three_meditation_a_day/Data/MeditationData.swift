//
//  MeditationData.swift
//  Three_meditation_a_day
//
//  Created by 박길남 on 11/10/2018.
//  Copyright © 2018 ParkGilNam. All rights reserved.
//

import Foundation
import UIKit

struct MeditationData:Decodable {
    let _id:String
    let userid:String
    let year:Int
    let month:Int
    let day:Int
    let morning:String
    let afternoon:String
    let evening:String
}

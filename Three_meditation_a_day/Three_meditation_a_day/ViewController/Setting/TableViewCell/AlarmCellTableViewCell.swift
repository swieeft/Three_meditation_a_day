//
//  AlarmCellTableViewCell.swift
//  Three_meditation_a_day
//
//  Created by Park GilNam on 2018. 1. 16..
//  Copyright © 2018년 ParkGilNam. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmCellTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var onoffSwitch: UISwitch!
    
    var cellTag:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func switchOnOffAction(_ sender: UISwitch) {
        
        let switchOnOff = sender.isOn
        let switchTag = sender.tag
        
        var title:String = ""
        var body:String = ""
        var notiId:String = ""
        var timeKey:String = ""
        var switchKey:String = ""
        
        switch switchTag {
        case 10:
            title = NotiInfo.morning.title
            body = NotiInfo.morning.body
            notiId = NotiInfo.morning.id
            timeKey = ForKey.morningTime.string
            switchKey = ForKey.morningSwitchIsOn.string
        case 11:
            title = NotiInfo.afternoon.title
            body = NotiInfo.afternoon.body
            notiId = NotiInfo.afternoon.id
            timeKey = ForKey.afternoonTime.string
            switchKey = ForKey.afternoonSwitchIsOn.string
        default:
            title = NotiInfo.evening.title
            body = NotiInfo.evening.body
            notiId = NotiInfo.evening.id
            timeKey = ForKey.eveningTime.string
            switchKey = ForKey.eveningSwitchIsOn.string
        }
        
        if let time = UserDefaults.standard.object(forKey: timeKey) as? Date {
            notificationSetting(date: time, title: title, body: body, identifier: notiId, isOn: switchOnOff)
        }
        
        UserDefaults.standard.set(switchOnOff, forKey: switchKey)
    }
    
    func notificationSetting(date:Date, title:String, body:String, identifier:String, isOn:Bool) {
        
        if isOn == true {
            let notification = UNMutableNotificationContent()
            notification.title = title
            notification.body = body
            
            let triggerDate = Calendar.current.dateComponents([.hour,.minute], from: date)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            
            let request = UNNotificationRequest(identifier: identifier, content: notification, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

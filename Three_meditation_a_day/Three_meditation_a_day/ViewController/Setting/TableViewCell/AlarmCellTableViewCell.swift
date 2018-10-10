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
        
        switch switchTag {
        case 10:
            let time:Date? = UserDefaults.standard.object(forKey: ForKey.morningTime.string) as? Date
            if time != nil {
                notificationSetting(date: time!, title: NotiInfo.morning.title, body: NotiInfo.morning.body, identifier: NotiInfo.morning.id, isOn: switchOnOff)
            }
            UserDefaults.standard.set(switchOnOff, forKey: ForKey.morningSwitchIsOn.string)
        case 11:
            let time:Date? = UserDefaults.standard.object(forKey: ForKey.afternoonTime.string) as? Date
            if time != nil {
                notificationSetting(date: time!, title: NotiInfo.afternoon.title, body: NotiInfo.afternoon.body, identifier: NotiInfo.afternoon.id, isOn: switchOnOff)
            }
            UserDefaults.standard.set(switchOnOff, forKey: ForKey.afternoonSwitchIsOn.string)
        default:
            let time:Date? = UserDefaults.standard.object(forKey: ForKey.eveningTime.string) as? Date
            if time != nil {
                notificationSetting(date: time!, title: NotiInfo.evening.title, body: NotiInfo.evening.body, identifier: NotiInfo.evening.id, isOn: switchOnOff)
            }
            UserDefaults.standard.set(switchOnOff, forKey: ForKey.eveningSwitchIsOn.string)
        }
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

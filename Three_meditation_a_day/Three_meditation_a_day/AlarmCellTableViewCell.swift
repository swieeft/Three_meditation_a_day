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
            let time:Date? = UserDefaults.standard.object(forKey: Define.forKeyStruct.morningTime) as? Date
            if time != nil {
                notificationSetting(date: time!, title: Define.notificationStruct.morningTitle, body: Define.notificationStruct.morningBody, identifier: Define.notificationStruct.morningNotiId, isOn: switchOnOff)
            }
            UserDefaults.standard.set(switchOnOff, forKey: Define.forKeyStruct.morningSwitchIsOn)
        case 11:
            let time:Date? = UserDefaults.standard.object(forKey: Define.forKeyStruct.afternoonTime) as? Date
            if time != nil {
                notificationSetting(date: time!, title: Define.notificationStruct.afternoonTitle, body: Define.notificationStruct.afternoonBody, identifier: Define.notificationStruct.afternoonNotiId, isOn: switchOnOff)
            }
            UserDefaults.standard.set(switchOnOff, forKey: Define.forKeyStruct.afternoonSwitchIsOn)
        default:
            let time:Date? = UserDefaults.standard.object(forKey: Define.forKeyStruct.eveningTime) as? Date
            if time != nil {
                notificationSetting(date: time!, title: Define.notificationStruct.eveningTitle, body: Define.notificationStruct.eveningBody, identifier: Define.notificationStruct.eveningNotiId, isOn: switchOnOff)
            }
            UserDefaults.standard.set(switchOnOff, forKey: Define.forKeyStruct.eveningSwitchIsOn)
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

//
//  SelectTimePopupViewController.swift
//  Three_meditation_a_day
//
//  Created by Park GilNam on 2018. 1. 16..
//  Copyright © 2018년 ParkGilNam. All rights reserved.
//

import UIKit
import UserNotifications

class SelectTimePopupViewController: UIViewController {
    
    @IBOutlet weak var selectTimePicker: UIDatePicker!
    
    var SelectCellTag:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        let saveButton = UIBarButtonItem(title: "저장", style: UIBarButtonItemStyle.plain, target: self, action: #selector(saveAction(sender:)))
        self.navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(title: "취소", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelAction(sender:)))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        selectTimePicker.backgroundColor = UIColor(red: 0.53, green: 0.035, blue: 0.035, alpha: 1)
        selectTimePicker.setValue(UIColor.white, forKeyPath: "textColor")
    }
    
    @objc func saveAction(sender:UIBarButtonItem) {
        
        let selectTime = selectTimePicker.date
        
        var forKey = ""
        var title = ""
        var body = ""
        var id = ""
        
        switch SelectCellTag {
        case 10:
            forKey = ForKey.morningTime.string
            title = NotiInfo.morning.title
            body = NotiInfo.morning.body
            id = NotiInfo.morning.id
        case 11:
            forKey = ForKey.afternoonTime.string
            title = NotiInfo.afternoon.title
            body = NotiInfo.afternoon.body
            id = NotiInfo.afternoon.id
        default:
            forKey = ForKey.eveningTime.string
            title = NotiInfo.evening.title
            body = NotiInfo.evening.body
            id = NotiInfo.evening.id
        }
        
        UserDefaults.standard.set(selectTime, forKey: forKey)
        notificationSetting(date: selectTime, title: title, body: body, identifier: id)
        
        self.navigationController!.popViewController(animated: true)
    }
    
    func notificationSetting(date:Date, title:String, body:String, identifier:String) {
        
        let notification = UNMutableNotificationContent()
        notification.title = title
        notification.body = body
        notification.sound = UNNotificationSound.default()
        
        let triggerDate = Calendar.current.dateComponents([.hour,.minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        
        let request = UNNotificationRequest(identifier: identifier, content: notification, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    @objc func cancelAction(sender:UIBarButtonItem) {
        self.navigationController!.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

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
        
        switch SelectCellTag {
        case 10:
            UserDefaults.standard.set(selectTime, forKey: Define.forKeyStruct.morningTime)
            notificationSetting(date: selectTime, title: Define.notificationStruct.morningTitle, body: Define.notificationStruct.morningBody, identifier: Define.notificationStruct.morningNotiId)
        case 11:
            UserDefaults.standard.set(selectTime, forKey: Define.forKeyStruct.afternoonTime)
            notificationSetting(date: selectTime, title: Define.notificationStruct.afternoonTitle, body: Define.notificationStruct.afternoonBody, identifier: Define.notificationStruct.afternoonNotiId)
        default:
            UserDefaults.standard.set(selectTime, forKey: Define.forKeyStruct.eveningTime)
            notificationSetting(date: selectTime, title: Define.notificationStruct.eveningTitle, body: Define.notificationStruct.eveningBody, identifier: Define.notificationStruct.eveningNotiId)
        }
        
        self.navigationController!.popViewController(animated: true)
    }
    
    func notificationSetting(date:Date, title:String, body:String, identifier:String) {
        
        let notification = UNMutableNotificationContent()
        notification.title = title
        notification.body = body
        notification.sound = UNNotificationSound.default()
        
        let triggerDate = Calendar.current.dateComponents([.hour,.minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
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

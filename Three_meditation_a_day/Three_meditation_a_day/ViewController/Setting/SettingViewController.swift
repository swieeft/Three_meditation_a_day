//
//  SettingViewController.swift
//  Three_meditation_a_day
//
//  Created by Park GilNam on 2018. 1. 9..
//  Copyright © 2018년 ParkGilNam. All rights reserved.
//

import UIKit
import UserNotifications

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "설정"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        settingTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCellTableViewCell
        
        var imageName = ""
        var title = ""
        var alarm = ""
        var isOn = ""
        var tag = 0
        
        switch indexPath.row {
        case 0:
            imageName = CustomCell.images.morning.alarmName
            title = CustomCell.title.morningAlarm.string
            alarm = ForKey.morningTime.string
            isOn = ForKey.morningSwitchIsOn.string
            tag = 10
        case 1:
            imageName = CustomCell.images.afternoon.alarmName
            title = CustomCell.title.afternoonAlarm.string
            alarm = ForKey.afternoonTime.string
            isOn = ForKey.afternoonSwitchIsOn.string
            tag = 11
        default:
            imageName = CustomCell.images.evening.alarmName
            title = CustomCell.title.eveningAlarm.string
            alarm = ForKey.eveningTime.string
            isOn = ForKey.eveningSwitchIsOn.string
            tag = 12
        }
        
        cell.imgView.image = UIImage(named:imageName)
        cell.titleLabel.text = title
        cell.alarmLabel.text = getSaveTime(forKey: alarm)
        cell.onoffSwitch.isOn = UserDefaults.standard.bool(forKey: isOn)
        cell.onoffSwitch.tag = tag
        cell.cellTag = tag

        
        cell.imgView.layer.cornerRadius = 50 / 2
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    //설정한 시간을 가져옴
    func getSaveTime(forKey:String) -> String {
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: DateFormat.localeIdentifier.format) as Locale?
        formatter.dateFormat = DateFormat.time.format
        
        guard let time = UserDefaults.standard.object(forKey: forKey) as? Date else {
            return "시간설정"
        }
        
        let timeString = formatter.string(from: time)
        return timeString
    }
    
    //설정한 값으로 스위치 버튼 값 변경
    func getSwitchOnOff(forKey:String) -> Bool {
        return UserDefaults.standard.bool(forKey: forKey)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! AlarmCellTableViewCell
            
        let storyboard  = UIStoryboard(name: "Main", bundle: nil)
            
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectTimePopup") as! SelectTimePopupViewController
        vc.navigationItem.title = cell.titleLabel.text
        vc.SelectCellTag = cell.cellTag
            
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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

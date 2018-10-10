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
        
        cell.imgView.layer.cornerRadius = 50 / 2
        
        switch indexPath.row {
        case 0:
            cell.imgView.image = UIImage(named:CustomCell.images.morning.alarmName)
            cell.titleLabel.text = CustomCell.title.morningAlarm.string
            cell.alarmLabel.text = getSaveTime(forKey: ForKey.morningTime.string)
            cell.onoffSwitch.isOn = getSwitchOnOff(forKey: ForKey.morningSwitchIsOn.string)
            cell.onoffSwitch.tag = 10
            cell.cellTag = 10
        case 1:
            cell.imgView.image = UIImage(named:CustomCell.images.afternoon.alarmName)
            cell.titleLabel.text = CustomCell.title.afternoonAlarm.string
            cell.alarmLabel.text = getSaveTime(forKey: ForKey.afternoonTime.string)
            cell.onoffSwitch.isOn = getSwitchOnOff(forKey: ForKey.afternoonSwitchIsOn.string)
            cell.onoffSwitch.tag = 11
            cell.cellTag = 11
        default:
            cell.imgView.image = UIImage(named:CustomCell.images.evening.alarmName)
            cell.titleLabel.text = CustomCell.title.eveningAlarm.string
            cell.alarmLabel.text = getSaveTime(forKey: ForKey.eveningTime.string)
            cell.onoffSwitch.isOn = getSwitchOnOff(forKey: ForKey.eveningSwitchIsOn.string)
            cell.onoffSwitch.tag = 12
            cell.cellTag = 12
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    //설정한 시간을 가져옴
    func getSaveTime(forKey:String) -> String {
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: DateFormat.localeIdentifier.format) as Locale?
        formatter.dateFormat = DateFormat.time.format
        
        let time:Date? = UserDefaults.standard.object(forKey: forKey) as? Date
        
        if time != nil
        {
            let timeString = formatter.string(from: time!)
            return timeString
        } else {
            return "시간설정"
        }
    }
    
    //설정한 값으로 스위치 버튼 값 변경
    func getSwitchOnOff(forKey:String) -> Bool{
        let isOn:Bool? = UserDefaults.standard.bool(forKey: forKey)
        
        if isOn != nil {
            return isOn!
        } else {
            return true
        }
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

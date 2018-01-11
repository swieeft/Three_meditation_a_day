//
//  SettingViewController.swift
//  Three_meditation_a_day
//
//  Created by Park GilNam on 2018. 1. 9..
//  Copyright © 2018년 ParkGilNam. All rights reserved.
//

import UIKit

struct forKeyStruct {
    static let morningTime = "morningTime"
    static let afternoonTime = "afternoonTime"
    static let eveningTime = "eveningTime"
    
    static let morningSwitchIsOn = "morningSwitchIsOn"
    static let afternoonSwitchIsOn = "afternoonSwitchIsOn"
    static let eveningSwitchIsOn = "eveningSwitchIsOn"
}

class SettingViewController: UIViewController{
    
    @IBOutlet weak var morningButton: UIButton!
    @IBOutlet weak var afternoonButton: UIButton!
    @IBOutlet weak var eveningButton: UIButton!
    @IBOutlet weak var morningSwitch: UISwitch!
    @IBOutlet weak var afternoonSwitch: UISwitch!
    @IBOutlet weak var eveningSwitch: UISwitch!
    
    @IBOutlet weak var selectTimePicker: UIDatePicker!
    
    var buttonTag = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectTimePicker.isHidden = true
        
        self.navigationItem.title = "설정"
        
        morningButton.layer.cornerRadius = 10
        afternoonButton.layer.cornerRadius = 10
        eveningButton.layer.cornerRadius = 10
        
        selectTimePicker.setValue(UIColor.white, forKeyPath: "textColor")
        selectTimePicker.backgroundColor = UIColor(red: 0.53, green: 0.035, blue: 0.035, alpha: 1)
        
        setButtonTitleTime(forKey: forKeyStruct.morningTime, button: morningButton)
        setButtonTitleTime(forKey: forKeyStruct.afternoonTime, button: afternoonButton)
        setButtonTitleTime(forKey: forKeyStruct.eveningTime, button: eveningButton)
        
        setSwitchOnOff(forKey: forKeyStruct.morningSwitchIsOn, switchControl: morningSwitch, button: morningButton)
        setSwitchOnOff(forKey: forKeyStruct.afternoonSwitchIsOn, switchControl: afternoonSwitch, button: afternoonButton)
        setSwitchOnOff(forKey: forKeyStruct.eveningSwitchIsOn, switchControl: eveningSwitch, button: eveningButton)
    }
    
    //설정한 시간으로 버튼의 타이틀 변경
    func setButtonTitleTime(forKey:String, button:UIButton) {
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale!
        formatter.dateFormat = "a hh:mm"
        
        let time:Date? = UserDefaults.standard.object(forKey: forKey) as? Date
        
        if time != nil
        {
            let timeString = formatter.string(from: time!)
            button.setTitle(timeString, for: UIControlState.normal)
        } else {
            button.setTitle("시간설정", for: UIControlState.normal)
        }
    }
    
    //설정한 값으로 스위치 버튼 값 변경
    func setSwitchOnOff(forKey:String, switchControl:UISwitch, button:UIButton) {
        let isOn:Bool? = UserDefaults.standard.bool(forKey: forKey)
        
        if isOn != nil {
            switchControl.isOn = isOn!
        } else {
            switchControl.isOn = true
        }
        
        if switchControl.isOn {
            button.isEnabled = true
            button.setTitleColor(UIColor.white, for: UIControlState.normal)
        } else {
            button.isEnabled = false
            button.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        }
    }
    
    //시간 설정 창 숨기기/보이기
    @IBAction func showTimePickerAction(_ sender: UIButton) {
        if selectTimePicker.isHidden == false {
            selectTimePicker.isHidden = true
        } else {
            selectTimePicker.isHidden = false
        }
        
        buttonTag = sender.tag
    }
    
    //시간 설정 창에서 선택된 시간을 버튼에 표시 및 값 저장
    @IBAction func selectTimeAction(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale!
        formatter.dateFormat = "a hh:mm"

        let dateString = formatter.string(from: sender.date)

        switch buttonTag {
        case 1:
            morningButton.setTitle(dateString, for: UIControlState.normal)
            UserDefaults.standard.set(sender.date, forKey: forKeyStruct.morningTime)
        case 2:
            afternoonButton.setTitle(dateString, for: UIControlState.normal)
            UserDefaults.standard.set(sender.date, forKey: forKeyStruct.afternoonTime)
        default:
            eveningButton.setTitle(dateString, for: UIControlState.normal)
            UserDefaults.standard.set(sender.date, forKey: forKeyStruct.eveningTime)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        selectTimePicker.isHidden = true
    }
    
    //스위치 상태에 따른 시간 설정 버튼 활성 상태 변경 및 스위치 상태 저장
    @IBAction func switchAction(_ sender: UISwitch) {
        var button:UIButton!
        
        if sender.tag == 10 {
            button = morningButton
            UserDefaults.standard.set(sender.isOn, forKey: forKeyStruct.morningSwitchIsOn)
        } else if sender.tag == 11 {
            button = afternoonButton
            UserDefaults.standard.set(sender.isOn, forKey: forKeyStruct.afternoonSwitchIsOn)
        } else {
            button = eveningButton
            UserDefaults.standard.set(sender.isOn, forKey: forKeyStruct.eveningSwitchIsOn)
        }
        
        switchOnOffAction(switchControl: sender, button: button)
    }
    
    //시간 설정 버튼 활성 상태 변경
    func switchOnOffAction(switchControl:UISwitch, button:UIButton)
    {
        if switchControl.isOn {
            button.isEnabled = true
            button.setTitleColor(UIColor.white, for: UIControlState.normal)
        } else {
            button.isEnabled = false
            button.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        }
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

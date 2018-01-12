//
//  SelectDatePopupViewController.swift
//  Three_meditation_a_day
//
//  Created by Park GilNam on 2018. 1. 11..
//  Copyright © 2018년 ParkGilNam. All rights reserved.
//

import UIKit


class SelectDatePopupViewController: UIViewController {
    var delegate:SelectDateSendDelegate?
    
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var selectDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let selectDate:Date? = UserDefaults.standard.object(forKey: Define.forKeyStruct.selectDate) as? Date
        
        if selectDate != nil {
            selectDatePicker.date = selectDate!
        }
        
        selectDatePicker.backgroundColor = UIColor(red: 0.53, green: 0.035, blue: 0.035, alpha: 1)
        selectDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        applyButton.backgroundColor = UIColor(red: 0.53, green: 0.035, blue: 0.035, alpha: 1)
        applyButton.layer.borderColor = UIColor.white.cgColor
        applyButton.layer.borderWidth = 1
        
        cancelButton.backgroundColor = UIColor(red: 0.53, green: 0.035, blue: 0.035, alpha: 1)
        cancelButton.layer.borderColor = UIColor.white.cgColor
        cancelButton.layer.borderWidth = 1
    }

    @IBAction func applyAction(_ sender: Any) {
        let selectDate = selectDatePicker.date

        delegate?.selectDateSend(selectDate:selectDate)
        
        UserDefaults.standard.set(selectDate, forKey: Define.forKeyStruct.selectDate)
        
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
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

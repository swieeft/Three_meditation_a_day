//
//  SettingViewController.swift
//  Three_meditation_a_day
//
//  Created by Park GilNam on 2018. 1. 9..
//  Copyright © 2018년 ParkGilNam. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController{
    
    @IBOutlet weak var morningButton: UIButton!
    @IBOutlet weak var afternoonButton: UIButton!
    @IBOutlet weak var eveningButton: UIButton!
    
    @IBOutlet weak var morningSwitch: UISwitch!
    @IBOutlet weak var afternoonSwitch: UISwitch!
    @IBOutlet weak var eveningSwitch: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

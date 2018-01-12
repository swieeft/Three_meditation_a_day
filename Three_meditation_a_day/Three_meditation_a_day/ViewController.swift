//
//  ViewController.swift
//  Three_meditation_a_day
//
//  Created by Park GilNam on 2018. 1. 6..
//  Copyright © 2018년 ParkGilNam. All rights reserved.
//

import UIKit

protocol SelectDateSendDelegate {
    func selectDateSend(selectDate:Date)
}

class ViewController: UIViewController, SelectDateSendDelegate {
    
    @IBOutlet weak var navigationTitleButton: UIButton!
    
    //1주차
    @IBOutlet weak var sunday1Weeks: UIButton!
    @IBOutlet weak var monday1Weeks: UIButton!
    @IBOutlet weak var tuesday1Weeks: UIButton!
    @IBOutlet weak var wednesday1Weeks: UIButton!
    @IBOutlet weak var thursday1Weeks: UIButton!
    @IBOutlet weak var firday1Weeks: UIButton!
    @IBOutlet weak var saturday1Weeks: UIButton!
    
    //2주차
    @IBOutlet weak var sunday2Weeks: UIButton!
    @IBOutlet weak var monday2Weeks: UIButton!
    @IBOutlet weak var tuesday2Weeks: UIButton!
    @IBOutlet weak var wednesday2Weeks: UIButton!
    @IBOutlet weak var thursday2Weeks: UIButton!
    @IBOutlet weak var firday2Weeks: UIButton!
    @IBOutlet weak var saturday2Weeks: UIButton!
    
    //3주차
    @IBOutlet weak var sunday3Weeks: UIButton!
    @IBOutlet weak var monday3Weeks: UIButton!
    @IBOutlet weak var tuesday3Weeks: UIButton!
    @IBOutlet weak var wednesday3Weeks: UIButton!
    @IBOutlet weak var thursday3Weeks: UIButton!
    @IBOutlet weak var firday3Weeks: UIButton!
    @IBOutlet weak var saturday3Weeks: UIButton!
    
    //4주차
    @IBOutlet weak var sunday4Weeks: UIButton!
    @IBOutlet weak var monday4Weeks: UIButton!
    @IBOutlet weak var tuesday4Weeks: UIButton!
    @IBOutlet weak var wednesday4Weeks: UIButton!
    @IBOutlet weak var thursday4Weeks: UIButton!
    @IBOutlet weak var firday4Weeks: UIButton!
    @IBOutlet weak var saturday4Weeks: UIButton!
    
    //5주차
    @IBOutlet weak var sunday5Weeks: UIButton!
    @IBOutlet weak var monday5Weeks: UIButton!
    @IBOutlet weak var tuesday5Weeks: UIButton!
    @IBOutlet weak var wednesday5Weeks: UIButton!
    @IBOutlet weak var thursday5Weeks: UIButton!
    @IBOutlet weak var firday5Weeks: UIButton!
    @IBOutlet weak var saturday5Weeks: UIButton!
    
    //6주차
    @IBOutlet weak var sunday6Weeks: UIButton!
    @IBOutlet weak var monday6Weeks: UIButton!
    @IBOutlet weak var tuesday6Weeks: UIButton!
    @IBOutlet weak var wednesday6Weeks: UIButton!
    @IBOutlet weak var thursday6Weeks: UIButton!
    @IBOutlet weak var firday6Weeks: UIButton!
    @IBOutlet weak var saturday6Weeks: UIButton!
    
    var daysButtons:[[UIButton]] = [[UIButton]]()
    var selectDate:Date = Date.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        daysButtons = [[sunday1Weeks, monday1Weeks, tuesday1Weeks, wednesday1Weeks, thursday1Weeks, firday1Weeks, saturday1Weeks],
        [sunday2Weeks, monday2Weeks, tuesday2Weeks, wednesday2Weeks, thursday2Weeks, firday2Weeks, saturday2Weeks],
        [sunday3Weeks, monday3Weeks, tuesday3Weeks, wednesday3Weeks, thursday3Weeks, firday3Weeks, saturday3Weeks],
        [sunday4Weeks, monday4Weeks, tuesday4Weeks, wednesday4Weeks, thursday4Weeks, firday4Weeks, saturday4Weeks],
        [sunday5Weeks, monday5Weeks, tuesday5Weeks, wednesday5Weeks, thursday5Weeks, firday5Weeks, saturday5Weeks],
        [sunday6Weeks, monday6Weeks, tuesday6Weeks, wednesday6Weeks, thursday6Weeks, firday6Weeks, saturday6Weeks]]
         
        let currentDate = Date.init()
        
        UserDefaults.standard.set(currentDate, forKey: "selectDate")
        
        navigationTitleSetting(currentDate: currentDate)
        currentDateSetting(currentDate: currentDate)
    }
    
    func navigationTitleSetting(currentDate:Date) {
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale!
        formatter.dateFormat = "YYYY. MM"
        
        let dateString = formatter.string(from: currentDate)
        
        navigationTitleButton.setTitle("\(dateString)", for: UIControlState.normal)
        
        selectDate = currentDate
    }
    
    func currentDateSetting(currentDate:Date) {
        let calendar = Calendar(identifier: .gregorian)
        
        let weekDay = calendar.dateComponents([.weekday], from: currentDate)
        let weekOfMonth = calendar.dateComponents([.weekOfMonth], from: currentDate)
        
        let weekOfMonthButtons = daysButtons[weekOfMonth.weekOfMonth! - 1]
        let button = weekOfMonthButtons[weekDay.weekday! - 1]
    
        button.backgroundColor = UIColor(red: 0.53, green: 0.035, blue: 0.035, alpha: 1)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.layer.cornerRadius = 10
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale!
        formatter.dateFormat = "d"
        
        let dayString = formatter.string(from: currentDate)
        
        button.setTitle(dayString, for: UIControlState.normal)
    }

    @IBAction func goDetailPage(_ sender: UIButton) {
        
        if sender.currentTitle != nil {
            let storyboard  = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "Detail")
            vc.navigationItem.title = "\(navigationTitleButton.title(for: UIControlState.normal)!). \(sender.currentTitle!)"
            
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
    func selectDateSend(selectDate: Date) {
        navigationTitleSetting(currentDate:selectDate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectDatePopup" {
            
            let viewController : SelectDatePopupViewController = segue.destination as! SelectDatePopupViewController
            
            viewController.delegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


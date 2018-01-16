//
//  LoginViewController.swift
//  Three_meditation_a_day
//
//  Created by Park GilNam on 2018. 1. 16..
//  Copyright © 2018년 ParkGilNam. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var kakaoLoginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        kakaoLoginButton.layer.cornerRadius = 3
    }
    
    @IBAction func kakaoLoginAction(_ sender: Any) {
        let session: KOSession = KOSession.shared();
        
        if session.isOpen() {
            session.close()
        }
        
        session.open(completionHandler: { (error) -> Void in
            
            if !session.isOpen() {
                switch ((error as NSError!).code) {
                case Int(KOErrorCancelled.rawValue):
                    break;
                default:
                    break;
                }
            }
        }, authTypes: [NSNumber(value: KOAuthType.talk.rawValue), NSNumber(value: KOAuthType.account.rawValue)])
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

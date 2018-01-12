//
//  WriteMeditationViewController.swift
//  Three_meditation_a_day
//
//  Created by Park GilNam on 2018. 1. 12..
//  Copyright © 2018년 ParkGilNam. All rights reserved.
//

import UIKit

class WriteMeditationViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var contentsTextViewBottomMargin: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentsTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(noti:NSNotification) {
        
        let notiInfo = noti.userInfo! as NSDictionary
        let keyboardFrame = notiInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let height = keyboardFrame.size.height
        
        contentsTextViewBottomMargin.constant = height + 15
        
        let animationDuration = notiInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(noti:NSNotification) {
        contentsTextViewBottomMargin.constant = 20
        
        let notiInfo = noti.userInfo! as NSDictionary
        let animationDuration = notiInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
    }
    
    @IBAction func allDeleteAction(_ sender: Any) {
        contentsTextView.text = ""
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

//
//  WriteMeditationViewController.swift
//  Three_meditation_a_day
//
//  Created by Park GilNam on 2018. 1. 12..
//  Copyright © 2018년 ParkGilNam. All rights reserved.
//

import UIKit

class WriteMeditationViewController: UIViewController, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var writeMeditationTableView: UITableView!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var contentsViewBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var bibleVersesCellHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let saveButton = UIBarButtonItem(title: "저장", style: UIBarButtonItemStyle.plain, target: self, action: #selector(saveAction(sender:)))
        let separatorButton = UIBarButtonItem(title: "|", style: UIBarButtonItemStyle.plain, target: self, action: nil )
        let bibleVersesButton = UIBarButtonItem(title: "말씀보기 ▼", style: UIBarButtonItemStyle.plain, target: self, action: #selector(viewBibleVersesAction(sender:)))
        
        self.navigationItem.rightBarButtonItems = [saveButton, separatorButton, bibleVersesButton]
        
        writeMeditationTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        contentsTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        writeMeditationTableView.register(UINib(nibName: Define.customCellStruct.bibleVersesCellNib, bundle:nil), forCellReuseIdentifier: Define.customCellStruct.bibleVersesCellId)
        
        writeMeditationTableView.rowHeight = UITableViewAutomaticDimension
        
        writeMeditationTableView.delegate = self
        writeMeditationTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: Define.customCellStruct.bibleVersesCellId, for: indexPath) as! BibleVersesTableViewCell
        
        cell.contentsLabel.text = "1. gkgkgkgkggk\n2.fjfjgjjsjsjgs\n3.dskfdfjlfjdsfjkfsl\n3.dskfdfjlfjdsfjkfsl\n3.dskfdfjlfjdsfjkfsl\n3.dskfdfjlfjdsfjkfsl"
        cell.contentsLabel.numberOfLines = 0
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing()
    }
    
    @objc func keyboardWillShow(noti:NSNotification) {
        
        let notiInfo = noti.userInfo! as NSDictionary
        let keyboardFrame = notiInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let height = keyboardFrame.size.height
        
        contentsViewBottomMargin.constant = height
        
        let animationDuration = notiInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(noti:NSNotification) {
        
        contentsViewBottomMargin.constant = 0
        
        let notiInfo = noti.userInfo! as NSDictionary
        let animationDuration = notiInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func saveAction(sender:UIBarButtonItem) {
        endEditing()
    }
    
    @objc func viewBibleVersesAction(sender:UIBarButtonItem) {
        if bibleVersesCellHeight.constant == 0 {
            sender.title = "말씀보기 ▲"
            bibleVersesCellHeight.constant = 200
        } else {
            sender.title = "말씀보기 ▼"
            bibleVersesCellHeight.constant = 0
        }
        
    }
    
    func endEditing() {
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

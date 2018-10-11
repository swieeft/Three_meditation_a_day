//
//  WriteMeditationViewController.swift
//  Three_meditation_a_day
//
//  Created by Park GilNam on 2018. 1. 12..
//  Copyright © 2018년 ParkGilNam. All rights reserved.
//

import UIKit

class WriteMeditationViewController: UIViewController, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, SaveDataSendDelegate {

    @IBOutlet weak var writeMeditationTableView: UITableView!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var contentsViewBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var bibleVersesCellHeight: NSLayoutConstraint!
    
    var dateComponents:DateComponents?
    var currentTime:Int = 0
    var bibleVerses:String = ""
    var meditation:String = ""
    var cellHeight:CGFloat = 0.0
    var statusBarHeight:CGFloat = 20.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton = UIBarButtonItem(title: " 저장", style: UIBarButtonItemStyle.plain, target: self, action: #selector(saveAction(sender:)))
        let bibleVersesButton = UIBarButtonItem(title: "말씀보기 ▼", style: UIBarButtonItemStyle.plain, target: self, action: #selector(viewBibleVersesAction(sender:)))
        
        self.navigationItem.rightBarButtonItems = [saveButton, bibleVersesButton]
        
        writeMeditationTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height { //1136(5 or 5S or 5C), 1334(6/6S/7/8), 2208(6+/6S+/7+/8+), 2436(x)
            case 2436:
                statusBarHeight = 44.0
            default:
                statusBarHeight = 20.0
            }
        }
        
        var naviHeight:CGFloat = statusBarHeight //statusBar 높이
        if(self.navigationController != nil){
            naviHeight += (self.navigationController?.navigationBar.frame.size.height)!//네비게이션바 높이
        }
            
        bibleVersesCellHeight.constant = naviHeight
        
        contentsTextView.delegate = self
        contentsTextView.layer.borderWidth = 5
        contentsTextView.layer.borderColor = UIColor(red: 0.53, green: 0.035, blue: 0.035, alpha: 1).cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        writeMeditationTableView.register(UINib(nibName: CustomCell.Info.bibleVerses.nib, bundle:nil), forCellReuseIdentifier: CustomCell.Info.bibleVerses.id)
        
        writeMeditationTableView.rowHeight = UITableViewAutomaticDimension
        
        writeMeditationTableView.delegate = self
        writeMeditationTableView.dataSource = self
        
        contentsTextView.text = meditation
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.Info.bibleVerses.id, for: indexPath) as! BibleVersesTableViewCell
        
        cell.contentsLabel.text = bibleVerses
        cell.contentsLabel.numberOfLines = 0
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cellHeight = cell.frame.size.height
        
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

        accessTokenCheck()
        
        endEditing()
    }
    
    fileprivate func accessTokenCheck() {
        
        KOSessionTask.accessTokenInfoTask(completionHandler: {(accessTokenInfo, error) -> Void in
            if let error = error as NSError? {
                print(error)
                return
            } else {
                if accessTokenInfo == nil {
                    return
                }
                
                self.saveMeditation(accessToken: (accessTokenInfo?.id!)!)
            }
        })
    }
    
    func saveMeditation(accessToken:NSNumber) {
        guard let _ = dateComponents else {
            return
        }
        
        let userid = UserDefaults.standard.string(forKey: ForKey.kakaoEmail.string)
        
        var urlString = ""
        var queryItemName:String = ""
        
        switch currentTime {
        case 0:
            urlString = Api.Url.host.saveMorningMeditation
            queryItemName = JsonKey.morning.string
        case 1:
            urlString = Api.Url.host.saveAfternoonMeditation
            queryItemName = JsonKey.afternoon.string
        case 2:
            urlString = Api.Url.host.saveEveningMeditation
            queryItemName = JsonKey.evening.string
        default:
            return
        }
        
        if urlString == "" || queryItemName == "" {
            return
        }
        
        let pass = userid! + "token" + String(describing: accessToken)
        
        var json = [String:Any]()
        json[JsonKey.userid.string] = userid
        json[JsonKey.pass.string] = pass
        json[JsonKey.year.string] = String(describing: (dateComponents?.year!)!)
        json[JsonKey.month.string] = String(describing: (dateComponents?.month!)!)
        json[JsonKey.day.string] = String(describing: (dateComponents?.day!)!)
        json[queryItemName] = contentsTextView.text
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            
            let result:ResultData = ResultData(result: 0)
            guard let urlComponents = NSURLComponents(string: urlString) else {
                return
            }
            
            Api.getData(data: result, urlComponents: urlComponents, httpMethod: Api.httpMethod.post.string, body: data) { (data, success) in
                if success == false {
                    return
                }
                
                let title = data.result == 0 ? "저장실패" : "저장성공"
                let message = data.result == 0 ? "묵상 저장을 실패하였습니다.\n잠시 후 다시 시도해주세요." : "묵상 내용을 저장하였습니다."
                
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: UIAlertActionStyle.default)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
            }
        } catch {
            print("JSON Serialization fail...")
        }
    }
    
    @objc func viewBibleVersesAction(sender:UIBarButtonItem) {
        
        if UIDevice().userInterfaceIdiom == .phone {
            statusBarHeight = UIScreen.main.nativeBounds.height == 2436 ? 44.0 : 20.0 //1136(5 or 5S or 5C), 1334(6/6S/7/8), 2208(6+/6S+/7+/8+), 2436(x)
        }
        
        var naviHeight:CGFloat = statusBarHeight
        
        if(self.navigationController != nil){
            naviHeight += (self.navigationController?.navigationBar.frame.size.height)!//네비게이션바 높이
        }
        
        if bibleVersesCellHeight.constant == naviHeight {
            sender.title = "말씀보기 ▲"
            bibleVersesCellHeight.constant = cellHeight
        } else {
            sender.title = "말씀보기 ▼"
            bibleVersesCellHeight.constant = naviHeight
        }
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func endEditing() {
        self.view.endEditing(true)
    }
    
    func saveDataSendDelegate(bibleVerses:String, meditation:String, date:DateComponents, currentTime:Int) {
        self.bibleVerses = bibleVerses
        self.meditation = meditation
        self.dateComponents = date
        self.currentTime = currentTime
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

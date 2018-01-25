//
//  WriteMeditationViewController.swift
//  Three_meditation_a_day
//
//  Created by Park GilNam on 2018. 1. 12..
//  Copyright © 2018년 ParkGilNam. All rights reserved.
//

import UIKit

protocol SaveDataSendDelegate {
    func saveDataSendDelegate(bibleVerses:String, meditation:String, date:DateComponents, currentTime:Int)
}

struct resultStruct:Decodable {
    let result:Int
}

class WriteMeditationViewController: UIViewController, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, SaveDataSendDelegate {

    @IBOutlet weak var writeMeditationTableView: UITableView!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var contentsViewBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var bibleVersesCellHeight: NSLayoutConstraint!
    
    var dateComponents:DateComponents?
    var currentTime:Int = 0
    var bibleVerses:String = ""
    var meditation:String = ""
    
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
        
        contentsTextView.text = meditation
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: Define.customCellStruct.bibleVersesCellId, for: indexPath) as! BibleVersesTableViewCell
        
        cell.contentsLabel.text = bibleVerses
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

        saveMeditation()
        
        endEditing()
    }
    
    func saveMeditation() {
        if dateComponents == nil {
            return
        }
        
        let userid = UserDefaults.standard.string(forKey: Define.forKeyStruct.kakaoEmail)
        
        var urlString = ""
        var queryItemName:String = ""
        
        switch currentTime {
        case 0:
            urlString = Define.webServer.saveMorningMeditation
            queryItemName = Define.jsonKey.morning
        case 1:
            urlString = Define.webServer.saveAfternoonMeditation
            queryItemName = Define.jsonKey.afternoon
        case 2:
            urlString = Define.webServer.saveEveningMeditation
            queryItemName = Define.jsonKey.evening
        default:
            urlString = ""
            queryItemName = ""
        }
        
        if urlString == "" || queryItemName == ""{
            return
        }
        
        let urlComponents = NSURLComponents(string: urlString)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: Define.jsonKey.userid, value: userid),
            URLQueryItem(name: Define.jsonKey.year, value: String(describing: (dateComponents?.year!)!)),
            URLQueryItem(name: Define.jsonKey.month, value: String(describing: (dateComponents?.month!)!)),
            URLQueryItem(name: Define.jsonKey.day, value: String(describing: (dateComponents?.day!)!)),
            URLQueryItem(name: queryItemName, value: contentsTextView.text)
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = Define.webServer.get
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            guard let data = data else { return }
            
            do {
                let result:resultStruct = try JSONDecoder().decode(resultStruct.self, from: data)
                
                var title = ""
                var message = ""
                if result.result == 0 {
                    title = "저장실패"
                    message = "묵상 저장을 실패하였습니다.\n잠시 후 다시 시도해주세요."
                } else {
                    title = "저장성공"
                    message = "묵상 내용을 저장하였습니다."
                }
                
                let dialog = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: UIAlertActionStyle.default)
                
                dialog.addAction(action)
                
                self.present(dialog, animated: true, completion: nil)
            } catch {
                print("Parsing error \(error)")
            }
        });
        task.resume()
    }
    
    @objc func viewBibleVersesAction(sender:UIBarButtonItem) {
        if bibleVersesCellHeight.constant == 0 {
            sender.title = "말씀보기 ▲"
            bibleVersesCellHeight.constant = 200
        } else {
            sender.title = "말씀보기 ▼"
            bibleVersesCellHeight.constant = 0
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
        
        print("test")
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

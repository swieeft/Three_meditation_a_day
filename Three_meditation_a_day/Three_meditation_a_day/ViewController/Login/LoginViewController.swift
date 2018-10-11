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
    
    @IBAction func guestLoginAction(_ sender: Any) {
    
        UserDefaults.standard.set(true, forKey: ForKey.guestLogin.string)
        
        let refreshAlert = UIAlertController(title: "Guest Login", message: "Guest로 로그인 하시면 기능에 제한이 있습니다.\n로그인 하시겠습니까?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "예", style: .default, handler: { (action: UIAlertAction!) in
            let storyboard  = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Main")
            self.navigationController!.pushViewController(vc, animated: true)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "아니요", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func kakaoLoginAction(_ sender: Any) {
        
        let session: KOSession = KOSession.shared();
        
        if session.isOpen() {
            session.close()
        }
        
        session.open(completionHandler: { (error) -> Void in
            if !session.isOpen() {
                switch ((error as NSError?)?.code) {
                case Int(KOErrorCancelled.rawValue):
                    break
                default:
                    break
                }
            }
            
            self.accessTokenCheck()
            
            UserDefaults.standard.set(false, forKey: ForKey.guestLogin.string)
            
        }, authTypes: [NSNumber(value: KOAuthType.talk.rawValue), NSNumber(value: KOAuthType.account.rawValue)])
    }
    
    func register(userid:String?, accessToken:NSNumber?) {

        guard let _ = userid, let _ = accessToken else {
            return
        }
        
        var json = [String:Any]()
        json[JsonKey.userid.string] = userid
        json[JsonKey.accesstoken.string] = String(describing: accessToken!)

        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            
            let result:ResultData = ResultData(result: 0)
            guard let urlComponents = NSURLComponents(string: Api.Url.host.userRegister) else {
                return
            }
            
            Api.getData(data: result, urlComponents: urlComponents, httpMethod: Api.httpMethod.post.string, body: data) { (data, success) in
                if success == false {
                    return
                }
                
                print(data.result)
            }
        } catch {

        }
    }
    
    fileprivate func accessTokenCheck() {
        KOSessionTask.accessTokenInfoTask(completionHandler: {(accessTokenInfo, error) -> Void in
            if let error = error as NSError? {
                print(error)
                return
            } else {
                guard let _ = accessTokenInfo else {
                    return
                }
                
                UserDefaults.standard.set(accessTokenInfo?.id, forKey: ForKey.accessToken.string)
                self.requestMe(accessToken: accessTokenInfo?.id)
            }
        })
    }
    
    fileprivate func requestMe(_ displayResult: Bool = false, accessToken:NSNumber?) {
        KOSessionTask.meTask { [weak self] (user, error) -> Void in
            if let error = error as NSError? {
                print(error)
            } else {
                if displayResult {
                    print((user as! KOUser).description)
                }
                
                let koUser = user as! KOUser
                
                UserDefaults.standard.set(koUser.email ?? "--", forKey: ForKey.kakaoEmail.string)
                self?.register(userid: koUser.email, accessToken: accessToken)
            }
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

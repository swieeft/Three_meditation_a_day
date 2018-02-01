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
            
            self.accessTokenCheck()
            
        }, authTypes: [NSNumber(value: KOAuthType.talk.rawValue), NSNumber(value: KOAuthType.account.rawValue)])
    }
    
    func register(userid:String?, accessToken:NSNumber?) {

        if userid == nil || accessToken == nil {
            return
        }
        
        var json = [String:Any]()
        json[Define.jsonKey.userid] = userid
        json[Define.jsonKey.accesstoken] = String(describing: accessToken!)

        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])

            var request = URLRequest(url: URL(string: Define.webServer.userRegister)!)
            request.httpMethod = Define.webServer.post
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

            print(json)

            let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
                guard let data = data else { return }

                do {
                    let result:resultStruct = try JSONDecoder().decode(resultStruct.self, from: data)
                    print(result.result)
                } catch {
                    print("Parsing error \(error)")
                }
            });
            task.resume()
        } catch {

        }
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
                
                //UserDefaults.standard.set(accessTokenInfo?.id, forKey: Define.forKeyStruct.accessToken)
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
                
                UserDefaults.standard.set(koUser.email ?? "--", forKey: Define.forKeyStruct.kakaoEmail)
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

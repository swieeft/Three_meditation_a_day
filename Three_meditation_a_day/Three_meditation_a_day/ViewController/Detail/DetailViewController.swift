//
//  DetailViewController.swift
//  Three_meditation_a_day
//
//  Created by Park GilNam on 2018. 1. 12..
//  Copyright © 2018년 ParkGilNam. All rights reserved.
//

import UIKit

struct TodayBibleVersesStruct:Decodable {
    let _id:String
    let year:Int
    let month:Int
    let day:Int
    let bibleverses:String
}

struct MeditationStruct:Decodable {
    let _id:String
    let userid:String
    let year:Int
    let month:Int
    let day:Int
    let morning:String
    let afternoon:String
    let evening:String
}

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var delegate:SaveDataSendDelegate?
    
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var bibleVersesCellHeight:Bool = false
    
    var todayBibleVersesData:TodayBibleVersesStruct?
    var meditationData:MeditationStruct?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailTableView.register(UINib(nibName: CustomCell.Info.detail.nib, bundle:nil), forCellReuseIdentifier: CustomCell.Info.detail.id)
        detailTableView.register(UINib(nibName: CustomCell.Info.bibleVerses.nib, bundle:nil), forCellReuseIdentifier: CustomCell.Info.bibleVerses.id)
        detailTableView.register(UINib(nibName: CustomCell.Info.copyright.nib, bundle:nil), forCellReuseIdentifier: CustomCell.Info.copyright.id)
        
        detailTableView.rowHeight = UITableViewAutomaticDimension
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        
        activityIndicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getTodayBibleVersesWebResponse()
        getTodayMeditationWebResponse()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let defaultCell:UITableViewCell
        
        if indexPath.row == 0 { //말씀구절 셀
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.Info.bibleVerses.id, for: indexPath) as! BibleVersesTableViewCell
            
            if todayBibleVersesData == nil {
                cell.contentsLabel.text = ""
            } else {
                cell.contentsLabel.text = todayBibleVersesData?.bibleverses
            }
            
            if bibleVersesCellHeight == false {
                cell.titleLabel.text = CustomCell.title.bibleVersesExpand.string
                cell.contentsLabel.numberOfLines = 1
            } else {
                cell.titleLabel.text = CustomCell.title.bibleVersesFolding.string
                cell.contentsLabel.numberOfLines = 0
            }
            defaultCell = cell
        } else if indexPath.row == 4 { //저작권 표시 셀
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.Info.copyright.id, for: indexPath) as! CopyrightTableViewCell
            
            cell.copyrightLable.text = "본 제품에 사용한 「성경전서 개역개정판」의 저작권은\n재단법인 대한성서공회 소유이며 재단법인 대한성서공회의\n허락을 받고 사용하였음."
            
            defaultCell = cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.Info.detail.id, for: indexPath) as! DetailTableViewCell
            
            cell.contentsLabel.text = ""
            
            switch indexPath.row {
            case 1 :
                cell.imgView?.image = UIImage(named: CustomCell.images.morning.basicName)
                cell.titleLabel.text = CustomCell.title.morning.string
                if meditationData != nil {
                    cell.contentsLabel.text = meditationData?.morning
                }
                cell.tag = CurrentTime.morning.tag
            case 2 :
                cell.imgView?.image = UIImage(named: CustomCell.images.afternoon.basicName)
                cell.titleLabel.text = CustomCell.title.afternoon.string
                if meditationData != nil {
                    cell.contentsLabel.text = meditationData?.afternoon
                }
                cell.tag = CurrentTime.afternoon.tag
            default :
                cell.imgView?.image = UIImage(named: CustomCell.images.evening.basicName)
                cell.titleLabel.text = CustomCell.title.evening.string
                if meditationData != nil {
                    cell.contentsLabel.text = meditationData?.evening
                }
                cell.tag = CurrentTime.evening.tag
            }
            
            defaultCell = cell
        }
        
        defaultCell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return defaultCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            bibleVersesCellHeight = !bibleVersesCellHeight
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        } else if indexPath.row == 4 {
          //skip
        } else {
            
            let guestLogin = UserDefaults.standard.bool(forKey: ForKey.guestLogin.string)
            
            if guestLogin {
                return
            }
            
            let cell = tableView.cellForRow(at: indexPath) as! DetailTableViewCell
            
            let storyboard  = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "WriteMeditation")
            vc.navigationItem.title = cell.titleLabel.text
            
            self.delegate = vc as? SaveDataSendDelegate
            
            let date = getSelectDate()
            
            var meditation = ""
            
            if meditationData != nil {
                switch cell.tag {
                case 0 :
                    meditation = (meditationData?.morning)!
                case 1:
                    meditation = (meditationData?.afternoon)!
                case 2:
                    meditation = (meditationData?.evening)!
                default:
                    meditation = ""
                }
            }
            
            if todayBibleVersesData != nil {
                delegate?.saveDataSendDelegate(bibleVerses: (todayBibleVersesData?.bibleverses)!, meditation: meditation, date: date!, currentTime: cell.tag)
            }
            
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
    //오늘의 말씀을 받아옴
    func getTodayBibleVersesWebResponse() {
      
        let date = getSelectDate()
        
        if date == nil {
            return
        }
        
        let urlComponents = NSURLComponents(string: Api.Url.host.searchTodayBibleVerses)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: JsonKey.year.string, value: String(describing: (date?.year!)!)),
            URLQueryItem(name: JsonKey.month.string, value: String(describing: (date?.month!)!)),
            URLQueryItem(name: JsonKey.day.string, value: String(describing: (date?.day!)!)),
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = Api.httpMethod.get.string
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            guard let data = data else { return }
            
            do {
                self.todayBibleVersesData = try JSONDecoder().decode(TodayBibleVersesStruct.self, from: data)
            } catch {
                print("Parsing error \(error)")
            }
            
            DispatchQueue.main.async(execute: {
                self.detailTableView.reloadData()
                self.activityIndicator.stopAnimating()
            })
        });
        task.resume()
    }
    
    //오늘의 묵상 내용을 가져옴
    func getTodayMeditationWebResponse() {
        
        let guestLogin = UserDefaults.standard.bool(forKey: ForKey.guestLogin.string)
        
        if guestLogin {
            return
        }
        
        let date = getSelectDate()
        
        if date == nil {
            return
        }
        
        let userid = UserDefaults.standard.string(forKey: ForKey.kakaoEmail.string)
        
        let urlComponents = NSURLComponents(string: Api.Url.host.searchTodayMeditation)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: JsonKey.userid.string, value: userid),
            URLQueryItem(name: JsonKey.year.string, value: String(describing: (date?.year!)!)),
            URLQueryItem(name: JsonKey.month.string, value: String(describing: (date?.month!)!)),
            URLQueryItem(name: JsonKey.day.string, value: String(describing: (date?.day!)!)),
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = Api.httpMethod.get.string
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            guard let data = data else { return }
            
            do {
                self.meditationData = try JSONDecoder().decode(MeditationStruct.self, from: data)
            } catch {
                print("Parsing error \(error)")
            }
            
            DispatchQueue.main.async(execute: {
                self.detailTableView.reloadData()
                self.activityIndicator.stopAnimating()
            })
        });
        task.resume()
    }
    
    //날짜 데이터 만들기
    func getSelectDate() -> DateComponents? {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.yearMonthDayDat.format
        
        if self.navigationItem.title == nil {
            return nil
        }
        
        let selectDate = formatter.date(from: self.navigationItem.title!)
        
        if selectDate == nil {
            return nil
        }
        
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.dateComponents([.year, .month, .day], from: selectDate!)
        
        return date
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

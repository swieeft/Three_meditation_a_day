//
//  DetailViewController.swift
//  Three_meditation_a_day
//
//  Created by Park GilNam on 2018. 1. 12..
//  Copyright © 2018년 ParkGilNam. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var delegate:SaveDataSendDelegate?
    
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var bibleVersesCellHeight:Bool = false
    
    var todayBibleVersesData:TodayBibleVersesData?
    var meditationData:MeditationData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        setTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getTodayBibleVersesWebResponse()
        getTodayMeditationWebResponse()
    }
    
    func setTableView() {
        detailTableView.rowHeight = UITableViewAutomaticDimension
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        
        detailTableView.register(UINib(nibName: CustomCell.Info.detail.nib, bundle:nil), forCellReuseIdentifier: CustomCell.Info.detail.id)
        detailTableView.register(UINib(nibName: CustomCell.Info.bibleVerses.nib, bundle:nil), forCellReuseIdentifier: CustomCell.Info.bibleVerses.id)
        detailTableView.register(UINib(nibName: CustomCell.Info.copyright.nib, bundle:nil), forCellReuseIdentifier: CustomCell.Info.copyright.id)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = UITableViewCell()
        
        switch indexPath.row {
        case 0: // 말씀구절
            cell = setBibleVersesCell(tableView: tableView, indexPath: indexPath)
        case 1:
            let image = UIImage(named: CustomCell.images.morning.basicName)
            let title = CustomCell.title.morning.string
            let contents = meditationData != nil ? (meditationData?.morning)! : ""
            let tag = CurrentTime.morning.tag
            cell = setMeditationCell(tableView: tableView, indexPath: indexPath, image: image!, title: title, contents: contents, tag: tag)
        case 2:
            let image = UIImage(named: CustomCell.images.afternoon.basicName)
            let title = CustomCell.title.afternoon.string
            let contents = meditationData != nil ? (meditationData?.afternoon)! : ""
            let tag = CurrentTime.afternoon.tag
            cell = setMeditationCell(tableView: tableView, indexPath: indexPath, image: image!, title: title, contents: contents, tag: tag)
        case 3:
            let image = UIImage(named: CustomCell.images.evening.basicName)
            let title = CustomCell.title.evening.string
            let contents = meditationData != nil ? (meditationData?.evening)! : ""
            let tag = CurrentTime.evening.tag
            cell = setMeditationCell(tableView: tableView, indexPath: indexPath, image: image!, title: title, contents: contents, tag: tag)
        case 4: // 저작권 표시
            cell = setCopyrightCell(tableView: tableView, indexPath: indexPath)
        default:
            break
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func setBibleVersesCell(tableView:UITableView, indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.Info.bibleVerses.id, for: indexPath) as! BibleVersesTableViewCell
        
        cell.contentsLabel.text = todayBibleVersesData == nil ? "" : todayBibleVersesData?.bibleverses
        
        if bibleVersesCellHeight == false {
            cell.titleLabel.text = CustomCell.title.bibleVersesExpand.string
            cell.contentsLabel.numberOfLines = 1
        } else {
            cell.titleLabel.text = CustomCell.title.bibleVersesFolding.string
            cell.contentsLabel.numberOfLines = 0
        }
        
        return cell
    }
    
    func setCopyrightCell(tableView:UITableView, indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.Info.copyright.id, for: indexPath) as! CopyrightTableViewCell
        cell.copyrightLable.text = "본 제품에 사용한 「성경전서 개역개정판」의 저작권은\n재단법인 대한성서공회 소유이며 재단법인 대한성서공회의\n허락을 받고 사용하였음."
        
        return cell
    }
    
    func setMeditationCell(tableView:UITableView, indexPath:IndexPath, image:UIImage, title:String, contents:String, tag:Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.Info.detail.id, for: indexPath) as! DetailTableViewCell
        
        cell.imgView?.image = image
        cell.titleLabel.text = title
        cell.contentsLabel.text = contents
        cell.tag = tag
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            bibleVersesCellHeight = !bibleVersesCellHeight
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        case 4:
            break
        default:
            if UserDefaults.standard.bool(forKey: ForKey.guestLogin.string) {
                return
            }
            
            let cell = tableView.cellForRow(at: indexPath) as! DetailTableViewCell

            let storyboard  = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WriteMeditation")
            
            vc.navigationItem.title = cell.titleLabel.text
            
            self.delegate = vc as? SaveDataSendDelegate
            
            let date = getSelectDate()
            
            var meditation = ""
            
            if let data = meditationData {
                switch cell.tag {
                case 0 :
                    meditation = data.morning
                case 1:
                    meditation = data.afternoon
                case 2:
                    meditation = data.evening
                default:
                    meditation = ""
                }
            }
            
            if let data = todayBibleVersesData {
                delegate?.saveDataSendDelegate(bibleVerses: data.bibleverses, meditation: meditation, date: date!, currentTime: cell.tag)
            }
            
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
    //오늘의 말씀을 받아옴
    func getTodayBibleVersesWebResponse() {
      
        guard let date = getSelectDate(), let year = date.year, let month = date.month, let day = date.day else {
            return
        }
        
        let urlComponents = NSURLComponents(string: Api.Url.host.searchTodayBibleVerses)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: JsonKey.year.string, value: String(describing: year)),
            URLQueryItem(name: JsonKey.month.string, value: String(describing: month)),
            URLQueryItem(name: JsonKey.day.string, value: String(describing: day)),
        ]
        
        Api.getData(data: todayBibleVersesData, urlComponents: urlComponents, httpMethod: Api.httpMethod.get.string) { (data, result) in
            if result == false {
                return
            }
            
            self.todayBibleVersesData = data
            
            self.detailTableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    //오늘의 묵상 내용을 가져옴
    func getTodayMeditationWebResponse() {
        
        if UserDefaults.standard.bool(forKey: ForKey.guestLogin.string) {
            return
        }
        
        guard let date = getSelectDate(), let year = date.year, let month = date.month, let day = date.day else {
            return
        }
        
        let userid = UserDefaults.standard.string(forKey: ForKey.kakaoEmail.string)
        
        let urlComponents = NSURLComponents(string: Api.Url.host.searchTodayMeditation)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: JsonKey.userid.string, value: userid),
            URLQueryItem(name: JsonKey.year.string, value: String(describing: year)),
            URLQueryItem(name: JsonKey.month.string, value: String(describing: month)),
            URLQueryItem(name: JsonKey.day.string, value: String(describing: day)),
        ]
        
        Api.getData(data: meditationData, urlComponents: urlComponents, httpMethod: Api.httpMethod.get.string) { (data, result) in
            if result == false {
                return
            }
            
            self.meditationData = data
            
            self.detailTableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    //날짜 데이터 만들기
    func getSelectDate() -> DateComponents? {
        
        guard let title = self.navigationItem.title else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.yearMonthDayDat.format
        
        guard let selectDate = formatter.date(from: title) else {
            return nil
        }
        
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.dateComponents([.year, .month, .day], from: selectDate)
        
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

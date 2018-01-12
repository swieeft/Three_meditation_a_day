//
//  DetailViewController.swift
//  Three_meditation_a_day
//
//  Created by Park GilNam on 2018. 1. 12..
//  Copyright © 2018년 ParkGilNam. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var detailTableView: UITableView!
    
    var bibleVersesCellHeight:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailTableView.register(UINib(nibName:"DetailTableViewCell", bundle:nil), forCellReuseIdentifier: "DetailCell")
        detailTableView.register(UINib(nibName:"BibleVersesTableViewCell", bundle:nil), forCellReuseIdentifier: "BibleVersesCell")
        
        detailTableView.rowHeight = UITableViewAutomaticDimension
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let defaultCell:UITableViewCell
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BibleVersesCell", for: indexPath) as! BibleVersesTableViewCell
            cell.contentsLabel.text = "1. gkgkgkgkggk\n2.fjfjgjjsjsjgs\n3.dskfdfjlfjdsfjkfsl"
            if bibleVersesCellHeight == false {
                cell.titleLabel.text = "오늘의 말씀 ▼"
                cell.contentsLabel.numberOfLines = 1
            } else {
                cell.titleLabel.text = "오늘의 말씀 ▲"
                cell.contentsLabel.numberOfLines = 0
            }
            defaultCell = cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailTableViewCell
            cell.imgView?.image = UIImage(named: "Morning.png")
            cell.titleLabel.text = "아침묵상"
            cell.contentsLabel.text = "aaaaaaaaaaa"
            defaultCell = cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailTableViewCell
            cell.imgView?.image = UIImage(named: "Afternoon.png")
            cell.titleLabel.text = "점심묵상"
            cell.contentsLabel.text = "long long long long long long long long long long long long long long long long long long long long"
            defaultCell = cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailTableViewCell
            cell.imgView?.image = UIImage(named: "Evening.png")
            cell.titleLabel.text = "저녁묵상"
            cell.contentsLabel.text = "long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long"
            defaultCell = cell
        }
        
        defaultCell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return defaultCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            bibleVersesCellHeight = !bibleVersesCellHeight
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! DetailTableViewCell
            
            let storyboard  = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "WriteMeditation")
            vc.navigationItem.title = cell.titleLabel.text
            
            self.navigationController!.pushViewController(vc, animated: true)
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

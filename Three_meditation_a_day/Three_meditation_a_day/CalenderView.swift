//
//  CalenderView.swift
//  Three_meditation_a_day
//
//  Created by Park GilNam on 2018. 2. 2..
//  Copyright © 2018년 ParkGilNam. All rights reserved.
//

import UIKit

class CalenderView: UIView {

    @IBOutlet var calenderView: CalenderView!
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var morningLable: UILabel!
    @IBOutlet weak var afternoonLabel: UILabel!
    @IBOutlet weak var eveningLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CalenderView", owner: self, options: nil)
        addSubview(calenderView)
        calenderView.frame = self.bounds
        calenderView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

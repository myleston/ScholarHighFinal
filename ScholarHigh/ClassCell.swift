//
//  ClassCell.swift
//  ScholarHighPrototype1
//
//  Created by 広瀬陽一 on 2018/11/13.
//  Copyright © 2018 FRESHNESS. All rights reserved.
//

import UIKit

class ClassCell: UITableViewCell {
    
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var teacherNameLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupFontSize() {
        classNameLabel.adjustsFontSizeToFitWidth = true
        startTimeLabel.adjustsFontSizeToFitWidth = true
        endTimeLabel.adjustsFontSizeToFitWidth = true
        periodLabel.adjustsFontSizeToFitWidth = true
        teacherNameLabel.adjustsFontSizeToFitWidth = true
        placeLabel.adjustsFontSizeToFitWidth = true
    }
}

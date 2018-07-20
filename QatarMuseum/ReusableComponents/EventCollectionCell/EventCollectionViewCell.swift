//
//  EventCollectionViewCell.swift
//  QatarMuseum
//
//  Created by Exalture on 08/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var firstTitle: UILabel!
    @IBOutlet weak var titleLineView: UILabel!
    @IBOutlet weak var secondTitleLabel: UILabel!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var timingSecondLabel: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var verticalLineView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var groupSizeLabel: UILabel!
    
    
    
    func setEventCellValues() {
        firstTitle.textColor = UIColor(red: 236/255, green: 65/255, blue: 137/255, alpha: 1)
        titleLineView.backgroundColor = UIColor(red: 236/255, green: 65/255, blue: 137/255, alpha: 1)
        secondTitleLabel.textColor = UIColor(red: 236/255, green: 65/255, blue: 137/255, alpha: 1)
        verticalLineView.backgroundColor = UIColor(red: 129/255, green: 166/255, blue: 215, alpha: 1)
        timingLabel.isHidden = true
        timingSecondLabel.isHidden = false
        groupSizeLabel.isHidden = false
    }
    func setEducationCalendarValues() {
        firstTitle.textColor = UIColor.black
        titleLineView.backgroundColor = UIColor.black
        secondTitleLabel.textColor = UIColor.black
        verticalLineView.backgroundColor = UIColor.darkGray
        timingLabel.isHidden = true
        timingSecondLabel.isHidden = true
        groupSizeLabel.isHidden = false
        descriptionLabel.text = "Timimg: 8:30 am - 11:30 am (last entry 10:50)"
        groupSizeLabel.text = "Max. group size 25"
    }
}

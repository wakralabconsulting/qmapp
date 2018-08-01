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
    @IBOutlet weak var viewDetails: UIButton!
    
    var viewDetailsBtnAction : (()->())?
    
    func setEventCellValues() {
        firstTitle.font = UIFont.eventCellTitleFont
        secondTitleLabel.font = UIFont.eventCellTitleFont
        timingLabel.font = UIFont.exhibitionDateLabelFont
        secondTitleLabel.font = UIFont.exhibitionDateLabelFont
        descriptionLabel.font = UIFont.exhibitionDateLabelFont
        viewDetails.titleLabel?.font = UIFont.exhibitionDateLabelFont
        
        firstTitle.textColor = UIColor.eventTitlePink
        titleLineView.backgroundColor = UIColor.eventTitlePink
        secondTitleLabel.textColor = UIColor.eventTitlePink
        verticalLineView.backgroundColor = UIColor.eventlisBlue
        timingLabel.isHidden = true
        timingSecondLabel.isHidden = false
        groupSizeLabel.isHidden = false
    }
    func setEducationCalendarValues() {
        firstTitle.font = UIFont.eventCellTitleFont
        secondTitleLabel.font = UIFont.eventCellTitleFont
        timingLabel.font = UIFont.exhibitionDateLabelFont
        secondTitleLabel.font = UIFont.exhibitionDateLabelFont
        descriptionLabel.font = UIFont.exhibitionDateLabelFont
        groupSizeLabel.font = UIFont.exhibitionDateLabelFont
        viewDetails.titleLabel?.font = UIFont.exhibitionDateLabelFont
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
    
    @IBAction func didTapViewDetails(_ sender: UIButton) {
        self.viewDetails.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        self.viewDetailsBtnAction?()
    }
    @IBAction func viewDetailsButtonTouchDown(_ sender: UIButton) {
        self.viewDetails.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
}

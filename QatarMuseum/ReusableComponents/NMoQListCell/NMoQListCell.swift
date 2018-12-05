//
//  NMoQListCell.swift
//  QatarMuseums
//
//  Created by Developer on 28/11/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import UIKit

class NMoQListCell: UITableViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.font = UIFont.selfGuidedFont
        dayLabel.font  = UIFont.settingsUpdateLabelFont
        dateLabel.font = UIFont.sideMenuLabelFont
    }
    func setTourListDate(tourList: NMoQTour?) {
        titleLabel.text = tourList?.subtitle
        dayLabel.text = tourList?.title
        dateLabel.text = changeDateFormat(dateString: tourList?.eventDate)

        if ((tourList?.images?.count)! > 0) {
            if let imageUrl = tourList?.images![0]{
                cellImageView.kf.setImage(with: URL(string: imageUrl))
            }
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}

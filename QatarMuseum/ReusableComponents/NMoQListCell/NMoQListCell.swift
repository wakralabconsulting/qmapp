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
        setGradientLayer()
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
        if (cellImageView.image == nil) {
            cellImageView.image = UIImage(named: "default_imageX2")
        }
    }
    func setTourMiddleDate(tourList: NMoQTourDetail?) {
        titleLabel.text = tourList?.title?.replacingOccurrences(of: "<[^>]+>|&nbsp;|&|#039;", with: "", options: .regularExpression, range: nil)
        dayLabel.isHidden = true
        dateLabel.isHidden = true
        //dayLabel.text = tourList?.title
        //dateLabel.text = changeDateFormat(dateString: tourList?.eventDate)
        
        if ((tourList?.imageBanner?.count)! > 0) {
            if let imageUrl = tourList?.imageBanner![0]{
                cellImageView.kf.setImage(with: URL(string: imageUrl))
            }
        }
        if (cellImageView.image == nil) {
           cellImageView.image = UIImage(named: "default_imageX2")
        }
    }
    func setGradientLayer() {
        self.cellImageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        let width = self.bounds.width
        let height = self.bounds.height
        let sHeight:CGFloat = 60.0
        let shadow = UIColor.black.withAlphaComponent(0.6).cgColor
        let bottomImageGradient = CAGradientLayer()
        bottomImageGradient.frame = CGRect(x: 0, y: height - sHeight, width: width, height: sHeight)
        bottomImageGradient.colors = [UIColor.clear.cgColor, shadow]
        cellImageView.layer.insertSublayer(bottomImageGradient, at: 0)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}

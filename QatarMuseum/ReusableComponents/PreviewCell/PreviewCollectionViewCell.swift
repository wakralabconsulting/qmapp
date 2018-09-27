//
//  PreviewCollectionViewCell.swift
//  QatarMuseums
//
//  Created by Exalture on 13/09/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import UIKit

class PreviewCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var previewContentView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accessNumberLabel: UILabel!
    @IBOutlet weak var tourGuideImage: UIImageView!
    
    @IBOutlet weak var productionTitle: UILabel!
    @IBOutlet weak var productionDateTitle: UILabel!
    @IBOutlet weak var periodTitle: UILabel!
    @IBOutlet weak var techniqueTitle: UILabel!
    @IBOutlet weak var dimensionsTitle: UILabel!
    @IBOutlet weak var productionText: UILabel!
    @IBOutlet weak var productionDateText: UILabel!
    @IBOutlet weak var periodText: UILabel!
    @IBOutlet weak var techniqueText: UILabel!
    @IBOutlet weak var dimensionsText: UILabel!
    override func awakeFromNib() {
        
        
        previewContentView.clipsToBounds = true
        previewContentView.layer.cornerRadius = 10
        if #available(iOS 11.0, *) {
            previewContentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            let rectShape = CAShapeLayer()
            rectShape.bounds = previewContentView.frame
            rectShape.position = previewContentView.center
            rectShape.path = UIBezierPath(roundedRect: previewContentView.bounds,    byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
            previewContentView.layer.mask = rectShape
        }
    }
    func setPreviewData(tourGuideData: TourGuideFloorMap) {
        productionTitle.text = NSLocalizedString("PRODUCTION_LABEL", comment: "PRODUCTION_LABEL  in the Popup")
        productionDateTitle.text = NSLocalizedString("PRODUCTION_DATES_LABEL", comment: "PRODUCTION_DATES_LABEL  in the Popup")
        periodTitle.text = NSLocalizedString("PERIOD_STYLE_LABEL", comment: "PERIOD_STYLE_LABEL  in the Popup")
        titleLabel.text = tourGuideData.title?.replacingOccurrences(of: "<[^>]+>|&nbsp;", with: "", options: .regularExpression, range: nil)
        accessNumberLabel.text = tourGuideData.accessionNumber?.replacingOccurrences(of: "<[^>]+>|&nbsp;", with: "", options: .regularExpression, range: nil)
        productionText.text = tourGuideData.production
        productionDateText.text = tourGuideData.productionDates
        periodText.text = tourGuideData.periodOrStyle
        techniqueText.text = tourGuideData.techniqueAndMaterials
        dimensionsText.text = tourGuideData.dimensions
        
        titleLabel.font = UIFont.discoverButtonFont
        accessNumberLabel.font = UIFont.sideMenuLabelFont
        productionTitle.font = UIFont.clearButtonFont
        productionDateTitle.font = UIFont.clearButtonFont
        periodTitle.font = UIFont.clearButtonFont
        techniqueTitle.font = UIFont.clearButtonFont
        dimensionsTitle.font = UIFont.clearButtonFont
        productionText.font = UIFont.exhibitionDateLabelFont
        productionDateText.font = UIFont.exhibitionDateLabelFont
        periodText.font = UIFont.exhibitionDateLabelFont
        techniqueText.font = UIFont.exhibitionDateLabelFont
        dimensionsText.font = UIFont.exhibitionDateLabelFont
        if let imageUrl = tourGuideData.image {
            tourGuideImage.kf.setImage(with: URL(string: imageUrl))
        }
        
        
    }
}

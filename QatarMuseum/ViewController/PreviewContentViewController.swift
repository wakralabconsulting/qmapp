//
//  PreviewContentViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 03/10/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import UIKit

class PreviewContentViewController: UIViewController {

    @IBOutlet weak var previewContentView: UIView!
    @IBOutlet weak var titleLabel: UITextView!
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
    
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var productionHeight: NSLayoutConstraint!
    @IBOutlet weak var productionDateHeight: NSLayoutConstraint!
    @IBOutlet weak var periodHeight: NSLayoutConstraint!
    @IBOutlet weak var techniqueHeight: NSLayoutConstraint!
    @IBOutlet weak var dimensionHeight: NSLayoutConstraint!
    
    var tourGuideDict : TourGuideFloorMap!
    var pageIndex = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        setPreviewData()
    }
    func setUI() {
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

    func setPreviewData() {
        let tourGuideData = tourGuideDict
       
        
        
        
        
        titleLabel.text = tourGuideData?.title?.replacingOccurrences(of: "<[^>]+>|&nbsp;|&#039;", with: "", options: .regularExpression, range: nil)
        accessNumberLabel.text = tourGuideData?.accessionNumber?.replacingOccurrences(of: "<[^>]+>|&nbsp;|&#039;", with: "", options: .regularExpression, range: nil)
        if((tourGuideData?.production != nil) && (tourGuideData?.production != "")) {
             productionTitle.text = NSLocalizedString("PRODUCTION_LABEL", comment: "PRODUCTION_LABEL  in the Popup")
            productionText.text = tourGuideData?.production
            productionHeight.constant = 33
        } else {
            productionHeight.constant = 0
        }
        if((tourGuideData?.productionDates != nil) && (tourGuideData?.productionDates != "")) {
            productionDateTitle.text = NSLocalizedString("PRODUCTION_DATES_LABEL", comment: "PRODUCTION_DATES_LABEL  in the Popup")
            productionDateText.text = tourGuideData?.productionDates
            productionDateHeight.constant = 33
        } else {
            productionDateHeight.constant = 0
        }
        if((tourGuideData?.periodOrStyle != nil) && (tourGuideData?.periodOrStyle != "")) {
            periodTitle.text = NSLocalizedString("PERIOD_STYLE_LABEL", comment: "PERIOD_STYLE_LABEL  in the Popup")
            periodText.text = tourGuideData?.periodOrStyle
            periodHeight.constant = 33
        }else {
            periodHeight.constant = 0
        }
        if((tourGuideData?.techniqueAndMaterials != nil) && (tourGuideData?.techniqueAndMaterials != "")) {
            techniqueTitle.text = NSLocalizedString("TECHNIQUES_LABEL", comment: "TECHNIQUES_LABEL  in the Popup")
            techniqueText.text = tourGuideData?.techniqueAndMaterials
            techniqueHeight.constant = 50
        }else {
            techniqueHeight.constant = 0
        }
        if((tourGuideData?.dimensions != nil) && (tourGuideData?.dimensions != "")) {
            dimensionsTitle.text = NSLocalizedString("DIMENSIONS_LABEL", comment: "DIMENSIONS_LABEL  in the Popup")
            dimensionsText.text = tourGuideData?.dimensions
            dimensionHeight.constant = 33
        }else {
            dimensionHeight.constant = 0
        }
        
        
        
        
        
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
        if let imageUrl = tourGuideData?.image {
            tourGuideImage.kf.setImage(with: URL(string: imageUrl))
        }
        if(UIScreen.main.bounds.height <= 568) {
            titleLabel.font = UIFont.eventCellTitleFont
            accessNumberLabel.font = UIFont.exhibitionDateLabelFont
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}

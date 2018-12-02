//
//  PanelDetailCell.swift
//  QatarMuseums
//
//  Created by Exalture on 01/12/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import UIKit
import MapKit

class PanelDetailCell: UITableViewCell {
    @IBOutlet weak var topImg: UIImageView!
    
    @IBOutlet weak var topTitle: UITextView!
    @IBOutlet weak var topDescription: UITextView!
    @IBOutlet weak var interestedLabel: UILabel!
    @IBOutlet weak var notInterestedLabel: UILabel!
    @IBOutlet weak var interestSwitch: UISwitch!
    @IBOutlet weak var secondImg: UIImageView!
    @IBOutlet weak var secondTitle: UITextView!
    @IBOutlet weak var secondDescription: UITextView!
    @IBOutlet weak var dateTitle: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var venueTitle: UILabel!
    @IBOutlet weak var contactTitle: UILabel!
    @IBOutlet weak var contactNumberLabel: UILabel!
    @IBOutlet weak var contactEmailLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    
    @IBOutlet weak var secondTitleLine: UILabel!
    
    weak var detailSpecialEvent : PanelDiscussionDetailViewController?

    
    override func awakeFromNib() {
        topTitle.font = UIFont.selfGuidedFont
        topDescription.font = UIFont.collectionFirstDescriptionFont
        interestedLabel.font = UIFont.collectionFirstDescriptionFont
        notInterestedLabel.font = UIFont.collectionFirstDescriptionFont
        secondTitle.font = UIFont.selfGuidedFont
        secondDescription.font = UIFont.collectionFirstDescriptionFont
        dateTitle.font = UIFont.tryAgainFont
        dateText.font = UIFont.collectionFirstDescriptionFont
        venueTitle.font = UIFont.tryAgainFont
        contactTitle.font = UIFont.tryAgainFont
        contactNumberLabel.font = UIFont.collectionFirstDescriptionFont
        contactEmailLabel.font = UIFont.collectionFirstDescriptionFont
        topView.layer.cornerRadius = 7.0
        secondView.layer.cornerRadius = 7.0
        thirdView.layer.cornerRadius = 7.0
        topView.clipsToBounds = true
        secondView.clipsToBounds = true
        thirdView.clipsToBounds = true

    }
    func setPanelDetailCellContent(titleName: String?) {
        topImg.image = UIImage(named: "panel_discussion-1")
        topTitle.text = titleName
        topDescription.text = "This discussion is going to be about the grandeur and originality of Qatari Songs. The speakers will also demonstrate the various songs and the musical instruments used to create the songs."
        interestedLabel.text = "Register"
        notInterestedLabel.text = "Unregister"
        secondImg.image = UIImage(named: "panelDetail2")
        secondTitle.text = "Name of the Speaker"
        secondDescription.text = "Information of the Speaker. Information of the Speaker. Information of the Speaker."
        dateTitle.text = NSLocalizedString("DATE", comment: "DATE in Paneldetail Page")
        dateText.text = "28 March 2019"
        venueTitle.text = NSLocalizedString("VENUE", comment: "VENUE in Paneldetail Page")
        contactTitle.text = NSLocalizedString("CONTACT_TITLE", comment: "CONTACT_TITLE in Paneldetail Page")
        contactNumberLabel.text = "+97444525555"
        contactEmailLabel.text = "info@qm.org.qa"
        
    }
    func setTourSecondDetailCellContent(titleName: String?) {
        topImg.image = UIImage(named: "panel_discussion-1")
        topTitle.text = titleName
        topDescription.text = "This tour has been designed for introducing you to the exquisite art & culture of Qatar"
        interestedLabel.text = "Register"
        notInterestedLabel.text = "Unregister"
        secondImg.isHidden = true
        secondTitle.isHidden = true
        secondDescription.isHidden = true
        secondView.isHidden = true
        secondTitleLine.isHidden = true
        dateTitle.text = NSLocalizedString("DATE", comment: "DATE in Paneldetail Page")
        dateText.text = "28 March 2019"
        venueTitle.text = NSLocalizedString("LOCATION_TITLE", comment: "LOCATION_TITLE in Paneldetail Page")
        contactTitle.text = NSLocalizedString("CONTACT_TITLE", comment: "CONTACT_TITLE in Paneldetail Page")
        contactNumberLabel.text = "+97444525555"
        contactEmailLabel.text = "info@qm.org.qa"
        
        //self.topView.translatesAutoresizingMaskIntoConstraints = false
        
        let verticalSpace = NSLayoutConstraint(item: self.topView, attribute: .bottom, relatedBy: .equal, toItem: self.thirdView, attribute: .top, multiplier: 1, constant: -16)
        
        // activate the constraints
        NSLayoutConstraint.activate([verticalSpace])
        
    }
}

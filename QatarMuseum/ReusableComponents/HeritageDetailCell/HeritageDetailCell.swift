//
//  HeritageDetailCell.swift
//  QatarMuseums
//
//  Created by Exalture on 21/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class HeritageDetailCell: UITableViewCell {
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var middleTitleLabel: UILabel!
    
    @IBOutlet weak var titleDescriptionLabel: UITextView!
    @IBOutlet weak var midTitleDescriptionLabel: UITextView!
    @IBOutlet weak var sundayTimeLabel: UILabel!
    @IBOutlet weak var fridayTimeLabel: UILabel!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var middleLabelLine: UIView!
    
    @IBOutlet weak var titleBottomOnlyConstraint: NSLayoutConstraint!
    @IBOutlet weak var fridayLabel: UILabel!
    
    
    @IBOutlet weak var locationFirstLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var openingTimeTitleLabel: UILabel!
    @IBOutlet weak var openingTimeLine: UIView!
    @IBOutlet weak var contactTitleLabel: UILabel!
    @IBOutlet weak var contactLine: UIView!
    @IBOutlet weak var contactLabel: UILabel!

    @IBOutlet weak var locationFirstLabel: UILabel!

    @IBOutlet weak var subTitleHeight: NSLayoutConstraint!
    @IBOutlet weak var locationTotalTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationTotalBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationButton: UIButton!
    
    var favBtnTapAction : (()->())?
    var shareBtnTapAction : (()->())?
    var locationButtonTapAction : (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        setUi()
       // setPublicArtsDetailCellData()
        //setHeritageDetailCellData()
    }
    func setUi() {
        titleLabel.font = UIFont.settingsUpdateLabelFont
        titleDescriptionLabel.font = UIFont.englishTitleFont
        subTitleLabel.font = UIFont.englishTitleFont
        middleTitleLabel.font  = UIFont.englishTitleFont
        midTitleDescriptionLabel.font = UIFont.englishTitleFont
        openingTimeTitleLabel.font = UIFont.closeButtonFont
        sundayTimeLabel.font = UIFont.sideMenuLabelFont
        fridayTimeLabel.font = UIFont.sideMenuLabelFont
        locationTitleLabel.font = UIFont.closeButtonFont
        fridayLabel.font = UIFont.sideMenuLabelFont
        locationButton.titleLabel?.font = UIFont.sideMenuLabelFont
        contactTitleLabel.font = UIFont.closeButtonFont
        contactLabel.font = UIFont.sideMenuLabelFont
        
    }
    func setHeritageDetailData(heritageDetail: HeritageDetail) {
        titleBottomOnlyConstraint.isActive = false
        locationTotalTopConstraint.isActive = false
        locationTotalBottomConstraint.isActive = false
        middleTitleLabel.isHidden = false
        midTitleDescriptionLabel.isHidden = false
        middleLabelLine.isHidden = false
        openingTimeTitleLabel.isHidden = false
        openingTimeLine.isHidden = false
        sundayTimeLabel.isHidden = false
        fridayTimeLabel.isHidden = false
        contactTitleLabel.isHidden = false
        contactLine.isHidden = false
        contactLabel.isHidden = false
        locationFirstLabelHeight.constant = 0
        titleLabel.text = heritageDetail.name?.uppercased()
        
        titleDescriptionLabel.text = heritageDetail.shortdescription
        midTitleDescriptionLabel.text = heritageDetail.longdescription
        locationTitleLabel.text = NSLocalizedString("LOCATION_TITLE",
                                                    comment: "LOCATION_TITLE in the Heritage detail")
        openingTimeTitleLabel.text = NSLocalizedString("OPENING_TIME_TITLE",
                                                    comment: "OPENING_TIME_TITLE in the Heritage detail")
        contactTitleLabel.text = NSLocalizedString("CONTACT_TITLE",
                                                       comment: "CONTACT_TITLE in the Heritage detail")
        let mapRedirectionMessage = NSLocalizedString("MAP_REDIRECTION_MESSAGE",
                                                      comment: "MAP_REDIRECTION_MESSAGE in the Dining detail")
        locationButton.setTitle(mapRedirectionMessage, for: .normal)
        
        
        
    }
    func setPublicArtsDetailValues(publicArsDetail: PublicArtsDetail) {
        titleLabel.text = publicArsDetail.name?.uppercased()
        //subTitleLabel.text =
        middleTitleLabel.isHidden = true
        midTitleDescriptionLabel.isHidden = true
        middleLabelLine.isHidden = true
        openingTimeTitleLabel.isHidden = true
        openingTimeLine.isHidden = true
        sundayTimeLabel.isHidden = true
        fridayTimeLabel.isHidden = true
        contactTitleLabel.isHidden = true
        contactLine.isHidden = true
        contactLabel.isHidden = true

        titleBottomOnlyConstraint.isActive = true
        titleBottomOnlyConstraint.constant = 45
        locationTotalTopConstraint.isActive = true
        locationTotalTopConstraint.constant = 35
         locationTotalBottomConstraint.isActive = true
        locationTotalBottomConstraint.constant = 50
        titleDescriptionLabel.text = publicArsDetail.description
        midTitleDescriptionLabel.text = publicArsDetail.shortdescription
        locationTitleLabel.text = NSLocalizedString("LOCATION_TITLE",
                                                    comment: "LOCATION_TITLE in the Heritage detail")
        //fridayLabel.text = 
    }
    func setMuseumAboutCellData() {
        titleBottomOnlyConstraint.isActive = false
        locationTotalTopConstraint.isActive = false
        locationTotalBottomConstraint.isActive = false
        middleTitleLabel.isHidden = false
        midTitleDescriptionLabel.isHidden = false
        middleLabelLine.isHidden = false
        openingTimeTitleLabel.isHidden = false
        openingTimeLine.isHidden = false
        sundayTimeLabel.isHidden = false
        fridayTimeLabel.isHidden = false
        contactTitleLabel.isHidden = false
        contactLine.isHidden = false
        contactLabel.isHidden = false
        subTitleLabel.isHidden = true
        subTitleHeight.constant = 0
        titleLabel.text = "MUSEUM OF ISLAMIC ART"
        middleTitleLabel.text = "TRADITIONAL INSPIRATION"
        openingTimeTitleLabel.text = "MUSEUM TIMINGS"
        fridayLabel.isHidden = true
        locationFirstLabelHeight.constant = 0
        titleDescriptionLabel.text = "MIA's masterpieces come from diverse societies - both secular and spiritual. \n Pieces in the collection are all connected by Islam, but many are non-religious in nature. \n\nThey are drawn from the treasure-houses of princes and the personal homes of ordinary people. Each object tells a fascinating story about its origins, providing an experience that extends far beyond the physical gallery space. \n\n Discover the beauty of Islamic art and realise its international influence. Plan your visit to MIA."
        midTitleDescriptionLabel.text = "Designed by world-renowned architect I.M. Pei, the MIA building has become an icon. Standing apart on the waters of the Corniche, it draws influence from traditional Islamic architecture. the buildng is made from limestone, which captures hourly changes in light and shade. \n\n The geometric patterns of the Islamic world adorn the inside space, making for a grand interior. A variety of textures and materials, including wood and stone, have created a unique environment for the museum's stunning collections. With incredible views across the bay, It's the foundation for Doha's burgeoning cultural scene."
        sundayTimeLabel.text = "Saturday to Sunday: 9:00AM - 7:00PM"
        fridayTimeLabel.text = "Fridays:1:30PM to 7:00PM"
    }
    @IBAction func didTapFavouriteButton(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.3,
                         animations: {
                            self.favoriteButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.1, animations: {
                                self.favoriteButton.transform = CGAffineTransform.identity
                                
                            })
                            self.favBtnTapAction?()
        })
    }
    @IBAction func didTapShareButton(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.3,
                         animations: {
                            self.shareButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.1, animations: {
                                self.shareButton.transform = CGAffineTransform.identity
                                
                            })
                            self.shareBtnTapAction?()
        })
    }
   
    @IBAction func didTapLocationButton(_ sender: UIButton) {
        self.locationButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        locationButtonTapAction?()
    }
    @IBAction func locationButtonTouchDown(_ sender: UIButton) {
        self.locationButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

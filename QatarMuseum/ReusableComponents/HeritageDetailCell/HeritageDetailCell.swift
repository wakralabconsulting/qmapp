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
    
    @IBOutlet weak var titleDescriptionLabel: UILabel!
    @IBOutlet weak var midTitleDescriptionLabel: UILabel!
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
    @IBOutlet weak var locationsTopConstraint: UIView!

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
        
        
    }
    func setHeritageDetailCellData() {
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
       // titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
        titleDescriptionLabel.text = "For our ancestors, Al Zubarah was a thriving pearl fishing and trading port. Now it's Qatar's largest heritage site, with its impressive city wall, ancient residential places and houses, markets,industrial areas and mosques. \n It's one of the best-preserved examples of an 18th and 19th century gulf merchant town and in 2013 was named a UNESCO World Heritage site."
        midTitleDescriptionLabel.text = "Once thriving port bustling with fishermen and merchants, the town of AL Zubarah was designated a protected area in 2009. Since then, Qatar Museums has led teams of archaeologists and scientists to investigate the site. Through their research and engagement  with local communities, they are documenting and shedding light on the rise and fall of this unique are. \n\n In 2013 the World Heritage Committe inscribed Al Zubarah Archaeological Site into the UNESCO World Heritage List. The Site includes three major features, the largest of which are the archaeological remains of the town, dating back to the 1760s. Connected to it is the settlement of Qal'at Murair, which was fortified to protect the city's inland wells. Al Zubarah Fort was built in 1938 and is the youngest, most prominent feature at the site."
        locationTitleLabel.text = "LOCATION"
    }
    func setPublicArtsDetailCellData() {
        titleLabel.text = "GANDHI'S THREE MONKEYS \n BY SUBODH GUPTA"
        subTitleLabel.text = "AN ARRESTING INSTALLATION"
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
        titleDescriptionLabel.text = " This is a series of three sculptures showing heads wearing military gear. One wears a gas mask, another a soldier's helmet, and the third a terrorist's hood. \n\n Each piece is composed of cooking instruments, used pals, traditional Indian lunch boxes and glass bowls. \n\n Together, they recall Gandhi's famous visual metaphor - the three wise monkeys that represent the see no evil, hear no wvil, speak no evil proverb. \n Placed in the midst of Katara, Doha's bustling cultural village, this installation captures people's attention as they go about their days. By tackling the bold theme of war and peace in a domestic setting, they are all the more arresting. \n\n Gupta's practice shifts between different mediumsincluding painting, sculpure, photography, video and performance. Throughout his work, he uses objects that are recognizable icons of Indian life, such as domestic Kitchenware, bicycles, scooters and taxis. By relocating them from their original context, he elevates their status from common object to valued artwork"
        fridayLabel.text = "Katara Cultural Village"
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
        self.favoriteButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        favBtnTapAction?()
    }
    @IBAction func didTapShareButton(_ sender: UIButton) {
        self.shareButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        shareBtnTapAction?()
    }
    @IBAction func favouriteTouchDown(_ sender: UIButton) {
        self.favoriteButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    @IBAction func shareTouchDown(_ sender: UIButton) {
        self.shareButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
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

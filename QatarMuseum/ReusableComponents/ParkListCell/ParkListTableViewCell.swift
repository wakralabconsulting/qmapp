//
//  ParkListTableViewCell.swift
//  QatarMuseums
//
//  Created by Exalture on 19/03/19.
//  Copyright © 2019 Wakralab. All rights reserved.
//

import MapKit
import UIKit

class ParkListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var timimgTitle: UILabel!
    @IBOutlet weak var timimgTextLabel: UILabel!
    @IBOutlet weak var locationTitle: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func setParkListValues() {
        titleLabel.font = UIFont.invitationTextFont
        timimgTitle.font = UIFont.invitationTextFont
        locationTitle.font = UIFont.invitationTextFont
        descriptionLabel.font = UIFont.englishTitleFont
        timimgTextLabel.font = UIFont.englishTitleFont
        descriptionLabel.text = "adbj jdhd s kjsdskhksd  ksjdhkks d sjdksjdk sdksdhksjhdhs skdsd cskdcs sd shhsd ksdhk sdh sdhsd  sdj skd  dkhjshdk ksdjk sd skd ksdh skdjhshdk sd sdjshdhskd sd csdjh ksdhs dcksdhc sdkhkshd sdc sdhc sdc shuhriuerferjejke khgfrkgvk vjdfvhkdjhruhtrjlskjsdc ufhshfc sfch sfjcs fc scsfh sch fcisfhcsh  djsh dkfhvkfvndkjfvdk dkfvkdv dvdvd vdvdfv dfv dvhdvdbrfhriuriuerf d s csfhdfics cd"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

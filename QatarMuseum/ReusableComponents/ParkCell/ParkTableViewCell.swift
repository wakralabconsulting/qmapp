//
//  ParkTableViewCell.swift
//  QatarMuseums
//
//  Created by Exalture on 22/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class ParkTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var timeTitleLabel: UILabel!
    @IBOutlet weak var locationsTitleLabel: UILabel!
    @IBOutlet weak var titleDescriptionLabel: UILabel!
    @IBOutlet weak var titleSecondDescriptionLabel: UILabel!
    @IBOutlet weak var timeDescriptionLabel: UILabel!
    @IBOutlet weak var titleLineView: UIView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var timeLineViewHeight: NSLayoutConstraint!
    @IBOutlet weak var locationLineViewHeight: NSLayoutConstraint!
    @IBOutlet weak var locationFirstLabel: UILabel!
    
    @IBOutlet weak var locationButtonToBottomConstraint: NSLayoutConstraint!
    // @IBOutlet weak var imageAspect: NSLayoutConstraint!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var parkImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //MARK: Public Arts List Data
    func setParksCellValues(cellValues: NSDictionary,imageName: String) {
        
        
        titleLabel.text = (cellValues.value(forKey: "title") as? String)
        titleDescriptionLabel.text = (cellValues.value(forKey: "titleDescription") as? String)
        titleSecondDescriptionLabel.text = (cellValues.value(forKey: "secondDescription") as? String)
        if ((cellValues.value(forKey: "subTitle")  != nil) && (cellValues.value(forKey: "subTitle") as! String != "")) {
           // subLabelHeight.constant = 12
            
            subTitleLabel.text = (cellValues.value(forKey: "subTitle") as? String)?.uppercased()
        }
        else {
            
           // subLabelHeight.constant = 0
        }
        if ((cellValues.value(forKey: "openingTimeDes")  != nil) && (cellValues.value(forKey: "openingTimeDes") as! String != ""))  {
            timeTitleLabel.isHidden = false
            timeDescriptionLabel.text = (cellValues.value(forKey: "openingTimeDes") as? String)
            timeLineViewHeight.constant = 2
        }
        else {
            timeTitleLabel.isHidden = true
            timeDescriptionLabel.isHidden = true
            timeLineViewHeight.constant = 0
        }
        if ((cellValues.value(forKey: "locationDes")  != nil) && (cellValues.value(forKey: "locationDes") as! String != ""))  {
            locationsTitleLabel.isHidden = false
            locationButton.isHidden = false
            locationsTitleLabel.text = "LOCATION"
            locationButton.setTitle((cellValues.value(forKey: "locationDes") as? String), for: .normal)
            locationLineViewHeight.constant = 2
            locationButtonToBottomConstraint.constant = 29
        }
        else {
            locationsTitleLabel.isHidden = true
            locationButton.isHidden = true
            locationLineViewHeight.constant = 0
            locationButtonToBottomConstraint.constant = 0
        }
        
        parkImageView.image = UIImage(named: imageName)
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

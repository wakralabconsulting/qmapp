//
//  DiningDetailTableViewCell.swift
//  QatarMuseums
//
//  Created by Exalture on 29/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class DiningDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var timeTitleLabel: UILabel!
    @IBOutlet weak var locationsTitleLabel: UILabel!
    @IBOutlet weak var titleDescriptionLabel: UILabel!
    @IBOutlet weak var titleSecondDescriptionLabel: UILabel!
    @IBOutlet weak var timeDescriptionLabel: UILabel!
    @IBOutlet weak var titleLineView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
   // @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
   
   // @IBOutlet weak var locationLineViewHeight: NSLayoutConstraint!
    @IBOutlet weak var locationFirstLabel: UILabel!
    
  
    // @IBOutlet weak var imageAspect: NSLayoutConstraint!
    @IBOutlet weak var locationButton: UIButton!
   // @IBOutlet weak var diningImageView: UIImageView!
    var favBtnTapAction : (()->())?
    var shareBtnTapAction : (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    func setDiningCellValues() {
        
        
        titleLabel.text = "IDAM"
        titleDescriptionLabel.text = "Embark on refined, generous and enchanted culinary journey at IDAM, Alain Ducasse's first restaurant in the Middle east."
        titleSecondDescriptionLabel.text = "In the heart of the museum, with spectacular views of the Doha skyline, Idam offers an innovative and flavorsome selection of contemporary French Mediterranean cuisine designed with an Arabic twist. Timeless classics of local and regional cuisine, with most ingredients sourced locally in Qatar. \n Philippe Starck's unique and exquisite decor creates a sophisticated atmosphere. \n For more information and to make a reservation, visit MIA"
        
        
        timeTitleLabel.isHidden = false
        timeDescriptionLabel.text = "Everyday From 11 am to 11 pm"
        titleLineView.isHidden = false
        
        
        locationsTitleLabel.isHidden = false
        locationButton.isHidden = false
        locationsTitleLabel.text = "LOCATION"
        locationButton.setTitle("Click here to open in Google Maps", for: .normal)
        locationFirstLabel.text = "Museum of Islamic Art"

        
        
       // diningImageView.image = UIImage(named: "gold_and_class")
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
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  DiningDetailTableViewCell.swift
//  QatarMuseums
//
//  Created by Exalture on 29/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class DiningDetailTableViewCell: UITableViewCell,UITextViewDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeTitleLabel: UILabel!
    @IBOutlet weak var locationsTitleLabel: UILabel!
    @IBOutlet weak var titleDescriptionLabel: UITextView!
    @IBOutlet weak var timeDescriptionLabel: UILabel!
    @IBOutlet weak var titleLineView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var locationFirstLabel: UILabel!
    @IBOutlet weak var visitMIAText: UITextView!
    @IBOutlet weak var locationButton: UIButton!
 
    var favBtnTapAction : (()->())?
    var shareBtnTapAction : (()->())?
    var locationButtonAction: (() -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    func setDiningCellValues() {
        
        titleLabel.font = UIFont.diningHeaderFont
        titleDescriptionLabel.font = UIFont.englishTitleFont
        timeTitleLabel.font = UIFont.closeButtonFont
        timeDescriptionLabel.font = UIFont.sideMenuLabelFont
        locationsTitleLabel.font = UIFont.closeButtonFont
        locationFirstLabel.font = UIFont.sideMenuLabelFont
        locationButton.titleLabel?.font = UIFont.sideMenuLabelFont
        titleLabel.text = "IDAM"
     
        titleDescriptionLabel.text = "Embark on refined, generous and enchanted culinary journey at IDAM, Alain Ducasse's first restaurant in the Middle east. \n In the heart of the museum, with spectacular views of the Doha skyline, Idam offers an innovative and flavorsome selection of contemporary French Mediterranean cuisine designed with an Arabic twist. Timeless classics of local and regional cuisine, with most ingredients sourced locally in Qatar. \n Philippe Starck's unique and exquisite decor creates a sophisticated atmosphere. "
        
        timeTitleLabel.isHidden = false
        timeDescriptionLabel.text = "Everyday From 11 am to 11 pm"
        titleLineView.isHidden = false
        
        
        locationsTitleLabel.isHidden = false
        locationButton.isHidden = false
        locationsTitleLabel.text = "LOCATION"
        locationButton.setTitle("Click here to open in Google Maps", for: .normal)
        locationFirstLabel.text = "Museum of Islamic Art"
        //For HyperLink in textview
        let yourAttributes = [kCTForegroundColorAttributeName: UIColor.black, kCTFontAttributeName: UIFont.englishTitleFont]
        let partOne = NSMutableAttributedString(string: "For more information and to make a reservation, visit ", attributes: yourAttributes as [NSAttributedStringKey : Any])
        let yourAttributes2 = [kCTForegroundColorAttributeName: UIColor.viewMyFavDarkPink, kCTFontAttributeName: UIFont.englishTitleFont]
        let parttwo = NSMutableAttributedString(string: "MIA ", attributes: yourAttributes2 as [NSAttributedStringKey : Any])
        let combination = NSMutableAttributedString()
        combination.append(partOne)
        combination.append(parttwo)
        
         let linkAttributes: [NSAttributedStringKey: Any] = [
                    .link: NSURL(string: "https://www.apple.com")!,
                    NSAttributedStringKey.foregroundColor: UIColor.profilePink,
                    NSAttributedStringKey.underlineStyle: NSNumber.init(value: Int8(NSUnderlineStyle.styleSingle.rawValue)),
                    NSAttributedStringKey.font : UIFont.englishTitleFont
                ]
        
        combination.setAttributes(linkAttributes, range: NSMakeRange(53, 4))
        self.visitMIAText.delegate = self
        
        self.visitMIAText.attributedText = combination
        self.visitMIAText.isUserInteractionEnabled = true
        self.visitMIAText.isEditable = false
        visitMIAText.tintColor = UIColor.viewMyFavDarkPink
        self.visitMIAText.textAlignment = .center
        titleDescriptionLabel.textAlignment = .center
       

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
   
    @IBAction func didTapLocation(_ sender: UIButton) {

         self.locationButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        self.locationButtonAction?()
        
    }
    
    @IBAction func locationButtonTouchDown(_ sender: UIButton) {
        self.locationButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

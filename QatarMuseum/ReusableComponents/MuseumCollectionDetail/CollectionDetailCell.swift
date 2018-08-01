//
//  CollectionDetailCell.swift
//  QatarMuseums
//
//  Created by Exalture on 18/07/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class CollectionDetailCell: UITableViewCell {

    
    @IBOutlet weak var firstTitle: UILabel!
    @IBOutlet weak var firstDescription: UILabel!
    @IBOutlet weak var secondTitle: UILabel!
    @IBOutlet weak var secondSubTitle: UILabel!
    @IBOutlet weak var secondDescription: UILabel!
    @IBOutlet weak var thirdDescription: UILabel!
    @IBOutlet weak var fourthDescription: UILabel!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var firstImageHeight: NSLayoutConstraint!
    @IBOutlet weak var favouriteHeight: NSLayoutConstraint!
    @IBOutlet weak var favouriteView: UIView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var firstTitleLine: UIView!
    @IBOutlet weak var fistViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstTitleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    var favouriteButtonAction : (()->())?
    var shareButtonAction : (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func setCollectionCellValues(cellValues: NSDictionary,imageName: String,currentRow: Int) {
        firstTitle.font = UIFont.settingsUpdateLabelFont
        firstDescription.font = UIFont.collectionFirstDescriptionFont
        secondTitle.font = UIFont.closeButtonFont
        secondSubTitle.font = UIFont.collectionSubTitleFont
        secondDescription.font = UIFont.englishTitleFont
        thirdDescription.font = UIFont.englishTitleFont
        fourthDescription.font = UIFont.englishTitleFont
        firstTitle.text = "CERAMIC COLLECTION"
        firstDescription.text = "As well as being objects of great age and beauty, the ceramics in the museum were also meant to be used. \n\n From humble kitchen wares to elaborate tile panels, ceramics were a vital part of everyday life in the Islamic world. \n\n They exemplify the externam influences and internal creativity that inspired this flourishing of ceramic design over 2 centuries. "
        secondTitle.text = "LUSTERWARE APOTHECARY JAR"
        secondSubTitle.text = "Mamluk, Syria, 14th century"
        secondDescription.text = "This jar was probably produced for the celebrated Damascene hospital of Nural-Din Mahmud ibnZangi."
        thirdDescription.text = "The inscription around the neck says it was made for the hospital 'of Nuri' and the 'fleur de lis' design was the motif of Nur al-Din."
        fourthDescription.text = "The other inscriptions read 'water lily', suggesting what was contained within the jar, undoubtedly a pharmaceutical compound or preparation of the plant."
        firstImageView.image = UIImage(named: imageName)
        secondImageView.image = UIImage(named: imageName)
        
        if (currentRow == 0) {
            firstTitle.isHidden = false
            firstDescription.isHidden = false
            firstTitleLine.isHidden = false
            firstTitleTopConstraint.constant = 30
            fistViewTopConstraint.constant = 30
            
        }
        else {
            firstTitle.isHidden = true
            firstDescription.isHidden = true
            firstTitleLine.isHidden = true
            firstTitle.text = ""
            firstDescription.text = ""
            firstTitleTopConstraint.constant = 0
            fistViewTopConstraint.constant = 0
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func didTapFavourite(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.3,
                         animations: {
                            self.favouriteButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.1, animations: {
                                self.favouriteButton.transform = CGAffineTransform.identity
                                
                            })
                            self.favouriteButtonAction?()
        })
        
    }
    
    @IBAction func didTapShare(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.3,
                         animations: {
                            self.shareButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.1, animations: {
                                self.shareButton.transform = CGAffineTransform.identity
                                
                            })
                            self.shareButtonAction?()
        })
        
    }
    
}

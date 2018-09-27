//
//  ObjectDetailTableViewCell.swift
//  QatarMuseums
//
//  Created by Developer on 13/08/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class ObjectDetailTableViewCell: UITableViewCell,UITextViewDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailSecondLabel: UILabel!
    @IBOutlet weak var centerImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var imageDetailLabel: UILabel!
    @IBOutlet weak var shareBtnViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomPadding: NSLayoutConstraint!
    
    var favBtnTapAction : (()->())?
    var shareBtnTapAction : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupCellUI() {
        titleLabel.textAlignment = .left
        descriptionLabel.textAlignment = .left
        detailSecondLabel.textAlignment = .left
        imageDetailLabel.textAlignment = .left

        titleLabel.font = UIFont.diningHeaderFont
        descriptionLabel.font = UIFont.englishTitleFont
        detailSecondLabel.font = UIFont.englishTitleFont
        imageDetailLabel.font = UIFont.sideMenuLabelFont
    }
    
    func setObjectDetail(objectDetail:TourGuideFloorMap) {
        titleLabel.text = objectDetail.title
        descriptionLabel?.text = objectDetail.curatorialDescription
        detailSecondLabel.text = objectDetail.objectENGSummary
       // imageDetailLabel.text = "Saint Jerome in His Study \nDomenico Ghirlandaio (1449-1494) \nChurch of Ognissanti, Florence, 1480"
        imageDetailLabel.isHidden = true
       // centerImageView.image = UIImage(named: "lusterwar_apothecarry_jar_full")
        shareBtnViewHeight.constant = 0
        bottomPadding.constant = 0
    }
    
    func setObjectHistoryDetail(historyDetail:TourGuideFloorMap) {
        titleLabel.text = "Object History"
        descriptionLabel?.text = historyDetail.objectHistory
      //  detailSecondLabel.text = "Like his father before him, Piero continued the family's tradition of artistic patronage, extending the collection beyond Italian Renaissance works to include Dutch and Flemish paintings, as well as rare books. This particular vase most probably remained in royal or aristocratic families for generations, before being discovered - along with four other similar vases - in a private Italian collection in 2005. Before this re-discovery, only one other albarello of its kind was recorded in the Musee des arts Decoratifs, Paris."
        //imageDetailLabel.text = "Portrait of Piero di Cosimo de' Medici \nBronzino (Agnolo di Cosimo) (1503-1572) \nFlorence, 1550-1570 \nNational Gallery, London"
        imageDetailLabel.isHidden = true
        //centerImageView.image = UIImage(named: "science_tour")
        shareBtnViewHeight.constant = 0
        bottomPadding.constant = 0
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
}

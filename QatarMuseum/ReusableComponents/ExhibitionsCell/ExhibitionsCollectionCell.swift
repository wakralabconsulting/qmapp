//
//  ExhibitionsCollectionCell.swift
//  QatarMuseum
//
//  Created by Exalture on 10/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Kingfisher
import UIKit

class ExhibitionsCollectionCell: UICollectionViewCell {
    @IBOutlet weak var exhibitionImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var openCloseView: UIView!
    @IBOutlet weak var openCloseLabel: UILabel!
    var isFavourite : Bool = false
    var exhibitionCellItemBtnTapAction : (()->())?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setGradientLayer()
    }
    
    //MARK: HomeExhibitionList data
    func setExhibitionCellValues(exhibition: Exhibition) {
        titleLabel.text = exhibition.name?.uppercased()
        dateLabel.text = exhibition.date?.uppercased()
        addressLabel.text = exhibition.location?.uppercased()
        titleLabel.font = UIFont.heritageTitleFont
        dateLabel.font = UIFont.exhibitionDateLabelFont
        addressLabel.font = UIFont.exhibitionDateLabelFont
        if (exhibition.isFavourite == true) {
            favouriteButton.setImage(UIImage(named: "heart_fillX1"), for: .normal)
        } else {
            favouriteButton.setImage(UIImage(named: "heart_emptyX1"), for: .normal)
        }
        if (exhibition.isOpen == true) {
            openCloseView.backgroundColor = UIColor.yellow
            openCloseLabel.text = NSLocalizedString("NOW_OPEN_TITLE", comment: "NOW_OPEN_TITLE in the exhibition page")
            openCloseLabel.textColor = UIColor.black
        } else {
            openCloseView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.45)
            openCloseLabel.text = NSLocalizedString("CLOSED_TITLE", comment: "CLOSED_TITLE in the exhibition page")
            openCloseLabel.textColor = UIColor.white
        }
        if let imageUrl = exhibition.image {
           // exhibitionImageView.kf.indicatorType = .activity
            exhibitionImageView.kf.setImage(with: URL(string: imageUrl))
        }
    }
    
    //MARK: MuseumExhibitionList data
    func setMuseumExhibitionCellValues(cellValues: NSDictionary,imageName: String) {
        titleLabel.text = (cellValues.value(forKey: "title") as? String)?.uppercased()
        dateLabel.text = (cellValues.value(forKey: "dateTitle") as? String)?.uppercased()
        addressLabel.text = (cellValues.value(forKey: "addressTitle") as? String)?.uppercased()
        if ((cellValues.value(forKey: "favourite") as! Bool) == true) {
            favouriteButton.setImage(UIImage(named: "heart_fillX1"), for: .normal)
        } else {
            favouriteButton.setImage(UIImage(named: "heart_emptyX1"), for: .normal)
        }
        if ((cellValues.value(forKey: "open")as! Bool) == true) {
            openCloseView.backgroundColor = UIColor.yellow
            openCloseLabel.text = NSLocalizedString("NOW_OPEN_TITLE", comment: "NOW_OPEN_TITLE in the exhibition page")
            openCloseLabel.textColor = UIColor.black
        } else {
            openCloseView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.45)
            openCloseLabel.text = NSLocalizedString("CLOSED_TITLE", comment: "CLOSED_TITLE in the exhibition page")
            openCloseLabel.textColor = UIColor.white
        }
//        if let imageUrl = cellValues.value(forKey: "image") as? String{
//           // exhibitionImageView.kf.indicatorType = .activity
//            exhibitionImageView.kf.setImage(with: URL(string: imageUrl))
//
//        }
        exhibitionImageView.image = UIImage(named: imageName)
    }
    
    func setGradientLayer() {
        self.exhibitionImageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let width = self.bounds.width
        let height = self.bounds.height
        let sHeight:CGFloat = 70.0
        let shadow = UIColor.black.withAlphaComponent(0.7).cgColor
        
        let bottomImageGradient = CAGradientLayer()
        bottomImageGradient.frame = CGRect(x: 0, y: height - sHeight, width: width, height: sHeight)
        bottomImageGradient.colors = [UIColor.clear.cgColor, shadow]
        exhibitionImageView.layer.insertSublayer(bottomImageGradient, at: 0)
    }
    
    @IBAction func didTapExhibitionCellButton(_ sender: UIButton) {
        exhibitionCellItemBtnTapAction?()
        self.favouriteButton.transform = CGAffineTransform(scaleX:1, y: 1)
    }
    
    @IBAction func favoriteTouchDownPressed(_ sender: UIButton) {
        self.favouriteButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        if (isFavourite) {
            favouriteButton.setImage(UIImage(named: "heart_emptyX1"), for: .normal)
            isFavourite = false
        } else {
            favouriteButton.setImage(UIImage(named: "heart_fillX1"), for: .normal)
            isFavourite = true
        }
    }
    
}

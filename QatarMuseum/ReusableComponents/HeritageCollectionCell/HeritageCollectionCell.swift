//
//  HeritageCollectionCell.swift
//  QatarMuseums
//
//  Created by Exalture on 21/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class HeritageCollectionCell: UICollectionViewCell {
    @IBOutlet weak var heritageImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var lineLabelHeight: NSLayoutConstraint!
   // @IBOutlet weak var subLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var titleBottomConstraint: NSLayoutConstraint!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setGradientLayer()
    }
    //MARK: HeritageList data
    func setHeritageListCellValues(heritageList: HeritageList) {
        titleLabel.text = heritageList.name?.uppercased()
        //subTitle.text = heritageList..uppercased()
        lineLabel.isHidden = true
        //lineLabelHeight.constant = 2
        titleBottomConstraint.constant = 2
       
        if (heritageList.isFavourite == true)  {
            favouriteButton.setImage(UIImage(named: "heart_fillX1"), for: .normal)
        }
        else {
            favouriteButton.setImage(UIImage(named: "heart_emptyX1"), for: .normal)
        }
        
        if let imageUrl = heritageList.image{
            heritageImageView.kf.setImage(with: URL(string: imageUrl))
        }
        titleLabel.font = UIFont.heritageTitleFont
        subTitle.font = UIFont.heritageTitleFont
        
    }
    //MARK: Public Arts List Data
    func setPublicArtsListCellValues(cellValues: NSDictionary,imageName: String) {
        titleLabel.text = (cellValues.value(forKey: "title") as? String)?.uppercased()
        lineLabelHeight.constant = 0
        lineLabel.isHidden = true
        titleBottomConstraint.constant = 0
        if ((cellValues.value(forKey: "subTitle")  != nil) && (cellValues.value(forKey: "subTitle") as! String != "")) {
            subTitle.text = (cellValues.value(forKey: "subTitle") as? String)?.uppercased()
        }
        else {
            //subTitle.text = (cellValues.value(forKey: "title") as? String)?.uppercased()
            //titleLabel.isHidden = true
           // subLabelHeight.constant = 0
        }
        
        if ((cellValues.value(forKey: "favourite") as! Bool) == true) {
            favouriteButton.setImage(UIImage(named: "heart_fillX1"), for: .normal)
        }
        else {
            favouriteButton.setImage(UIImage(named: "heart_emptyX1"), for: .normal)
        }
        heritageImageView.image = UIImage(named: imageName)
        titleLabel.font = UIFont.heritageTitleFont
        subTitle.font = UIFont.heritageTitleFont
    }
    //MARK: Collections List Data
    func setCollectionsCellValues(cellValues: NSDictionary,imageName: String) {
        
        
        titleLabel.text = (cellValues.value(forKey: "title") as? String)?.uppercased()
        lineLabelHeight.constant = 0
        lineLabel.isHidden = true
        titleBottomConstraint.constant = 0
       // subLabelHeight.constant = 0
        
        
       favouriteButton.isHidden = true
        heritageImageView.image = UIImage(named: imageName)
    }
    func setGradientLayer() {
        self.heritageImageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let width = self.bounds.width
        let height = self.bounds.height
        let sHeight:CGFloat = 60.0
        let shadow = UIColor.black.withAlphaComponent(0.8).cgColor
        
        // Add gradient bar for image on top
        //        let topImageGradient = CAGradientLayer()
        //        topImageGradient.frame = CGRect(x: 0, y: 0, width: width, height: sHeight)
        //        topImageGradient.colors = [shadow, UIColor.clear.cgColor]
        //        exhibitionImageView.layer.insertSublayer(topImageGradient, at: 0)
        
        let bottomImageGradient = CAGradientLayer()
        bottomImageGradient.frame = CGRect(x: 0, y: height - sHeight, width: width, height: sHeight)
        bottomImageGradient.colors = [UIColor.clear.cgColor, shadow]
        heritageImageView.layer.insertSublayer(bottomImageGradient, at: 0)
    }
}

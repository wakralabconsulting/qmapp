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
    func setHeritageListCellValues(cellValues: NSDictionary,imageName: String) {
        
        titleLabel.text = (cellValues.value(forKey: "title") as? String)?.uppercased()
        
        subTitle.text = (cellValues.value(forKey: "subTitle") as? String)?.uppercased()
        lineLabelHeight.constant = 2
       // subLabelHeight.constant = 12
        titleBottomConstraint.constant = 7
        lineLabel.isHidden = false
        if ((cellValues.value(forKey: "favourite") as! Bool) == true) {
            favouriteButton.setImage(UIImage(named: "heart_fillX1"), for: .normal)
        }
        else {
            favouriteButton.setImage(UIImage(named: "heart_emptyX1"), for: .normal)
        }
        
        //        if let imageUrl = cellValues.value(forKey: "image") as? String{
        //           // exhibitionImageView.kf.indicatorType = .activity
        //            exhibitionImageView.kf.setImage(with: URL(string: imageUrl))
        //
        //        }
        heritageImageView.image = UIImage(named: imageName)
    }
    //MARK: Public Arts List Data
    func setPublicArtsListCellValues(cellValues: NSDictionary,imageName: String) {
        
        
        titleLabel.text = (cellValues.value(forKey: "title") as? String)?.uppercased()
        lineLabelHeight.constant = 0
        lineLabel.isHidden = true
        titleBottomConstraint.constant = 0
        if ((cellValues.value(forKey: "subTitle")  != nil) && (cellValues.value(forKey: "subTitle") as! String != "")) {
           // subLabelHeight.constant = 12
            
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

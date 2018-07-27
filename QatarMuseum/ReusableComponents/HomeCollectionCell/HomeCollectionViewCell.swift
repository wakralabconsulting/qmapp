//
//  HomeCollectionViewCell.swift
//  QatarMuseum
//
//  Created by Exalture on 06/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Kingfisher
import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var homeTitleLabel: UILabel!
    @IBOutlet weak var tourGuideButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setGradientLayer()
    }
    
    func setHomeCellData(home: Home) {
        homeTitleLabel.text = home.name
        if (home.isTourguideAvailable == true) {
            tourGuideButton.isHidden = false
        }
        if home.name == "Exhibitions" {
            homeImageView.image = UIImage(named: (home.image as! String))
        } else if let imageUrl = home.image {
            //homeImageView.kf.indicatorType = .activity
            homeImageView.kf.setImage(with: URL(string: imageUrl))
        }
    }
    
    func setTourGuideCellData(homeCellData: NSDictionary, imageName: String) {
        homeTitleLabel.text = homeCellData.value(forKey: "title") as? String
        if ((homeCellData.value(forKey: "tourguide") as! Bool) == true) {
            tourGuideButton.isHidden = false
        }
        
//        if let imageUrl = homeCellData.value(forKey: "image") as? String{
//            //homeImageView.kf.indicatorType = .activity
//            homeImageView.kf.setImage(with: URL(string: imageUrl))
//
//        }
        homeImageView.image = UIImage(named: imageName)
    }
    
    func setGradientLayer() {
        self.homeImageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        let width = self.bounds.width
        let height = self.bounds.height
        let sHeight:CGFloat = 60.0
        let shadow = UIColor.black.withAlphaComponent(0.6).cgColor
        
        // Add gradient bar for image on top
        //        let topImageGradient = CAGradientLayer()
        //        topImageGradient.frame = CGRect(x: 0, y: 0, width: width, height: sHeight)
        //        topImageGradient.colors = [shadow, UIColor.clear.cgColor]
        //        homeImageView.layer.insertSublayer(topImageGradient, at: 0)
        
        let bottomImageGradient = CAGradientLayer()
        bottomImageGradient.frame = CGRect(x: 0, y: height - sHeight, width: width, height: sHeight)
        bottomImageGradient.colors = [UIColor.clear.cgColor, shadow]
        homeImageView.layer.insertSublayer(bottomImageGradient, at: 0)
    }
}

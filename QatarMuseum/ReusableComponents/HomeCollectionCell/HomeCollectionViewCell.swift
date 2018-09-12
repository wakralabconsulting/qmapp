//
//  HomeCollectionViewCell.swift
//  QatarMuseum
//
//  Created by Exalture on 06/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Alamofire
import Kingfisher
import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var homeTitleLabel: UILabel!
    @IBOutlet weak var tourGuideImage: UIImageView!
    let networkReachability = NetworkReachabilityManager()
    override func layoutSubviews() {
        super.layoutSubviews()
        setGradientLayer()
    }
    
    func setHomeCellData(home: Home) {
        let titleString = home.name
        homeTitleLabel.text = titleString?.capitalized
        homeTitleLabel.font = UIFont.homeTitleFont
        //Added Tour guide icon for MIA in home page
        if (home.id == "63") {
            tourGuideImage.isHidden = false
        }
        else { //
            tourGuideImage.isHidden = true
        }
            if let imageUrl = home.image {
            homeImageView.kf.setImage(with: URL(string: imageUrl))
        }
        if (homeImageView.image == nil) {
            homeImageView.image = UIImage(named: "default_imageX2")
        }
    }
    
    func setTourGuideCellData(homeCellData: NSDictionary, imageName: String) {
        homeTitleLabel.text = homeCellData.value(forKey: "title") as? String
        //if ((homeCellData.value(forKey: "tourguide") as! Bool) == true) {
            tourGuideImage.isHidden = true
       // }
        
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
        let bottomImageGradient = CAGradientLayer()
        bottomImageGradient.frame = CGRect(x: 0, y: height - sHeight, width: width, height: sHeight)
        bottomImageGradient.colors = [UIColor.clear.cgColor, shadow]
        homeImageView.layer.insertSublayer(bottomImageGradient, at: 0)
    }
}

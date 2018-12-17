//
//  TravelCollectionViewCell.swift
//  QatarMuseums
//
//  Created by Exalture on 28/11/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import UIKit

class TravelCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        titleLabel.font = UIFont.oopsTitleFont
        self.awakeFromNib()
    }
    func setTravelListData(travelListData: HomeBanner) {
        titleLabel.text = travelListData.title
        if let imgUrl = travelListData.bannerLink {
            imageView.kf.setImage(with: URL(string: imgUrl))
        }
    }
    func setGradientLayer() {
        self.imageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        let width = self.bounds.width
        let height = self.bounds.height
        let sHeight:CGFloat = 60.0
        let shadow = UIColor.black.withAlphaComponent(0.6).cgColor
        let bottomImageGradient = CAGradientLayer()
        bottomImageGradient.frame = CGRect(x: 0, y: height - sHeight, width: width, height: sHeight)
        bottomImageGradient.colors = [UIColor.clear.cgColor, shadow]
        imageView.layer.insertSublayer(bottomImageGradient, at: 0)
    }
}

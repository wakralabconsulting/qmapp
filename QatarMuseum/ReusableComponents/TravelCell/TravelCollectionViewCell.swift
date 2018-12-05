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
    }
    func setTravelListData(travelListData: HomeBanner) {
        titleLabel.text = travelListData.title
        if let imgUrl = travelListData.bannerLink {
            imageView.kf.setImage(with: URL(string: imgUrl))
        }
    }
}

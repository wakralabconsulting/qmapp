//
//  PreviewCollectionViewCell.swift
//  QatarMuseums
//
//  Created by Exalture on 13/09/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import UIKit

class PreviewCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var previewContentView: UIView!
    override func awakeFromNib() {
        
        
        previewContentView.clipsToBounds = true
        previewContentView.layer.cornerRadius = 10
        if #available(iOS 11.0, *) {
            previewContentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            let rectShape = CAShapeLayer()
            rectShape.bounds = previewContentView.frame
            rectShape.position = previewContentView.center
            rectShape.path = UIBezierPath(roundedRect: previewContentView.bounds,    byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
            previewContentView.layer.mask = rectShape
        }
    }
}

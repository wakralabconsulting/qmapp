//
//  MiaCollectionReusableView.swift
//  QatarMuseums
//
//  Created by Exalture on 17/07/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit
protocol MiaTourProtocol {
    func exploreButtonTapAction( miaHeader: MiaCollectionReusableView)
}
class MiaCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var miaTourGuideText: UILabel!
    @IBOutlet weak var selfGuidedText: UILabel!
    
    @IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var audioCircleImage: UIImageView!
    var miaTourDelegate : MiaTourProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func didTapExplore(_ sender: UIButton) {
        miaTourDelegate?.exploreButtonTapAction(miaHeader: self)
        self.exploreButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        self.audioCircleImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    @IBAction func exploreButtonTouchDown(_ sender: UIButton) {
         self.exploreButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        self.audioCircleImage.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
}

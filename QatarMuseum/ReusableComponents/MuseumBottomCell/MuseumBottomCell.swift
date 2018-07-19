//
//  MuseumBottomCell.swift
//  QatarMuseums
//
//  Created by Exalture on 23/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class MuseumBottomCell: UICollectionViewCell {
    
    @IBOutlet weak var itemButton: UIButton!
    @IBOutlet weak var itemName: UILabel!
    var cellItemBtnTapAction : (()->())?
    
    @IBAction func didTapCellButton(_ sender: UIButton) {
        self.itemButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        cellItemBtnTapAction?()
    }
    
    @IBAction func cellButtonTouchDown(_ sender: UIButton) {
        self.itemButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
}

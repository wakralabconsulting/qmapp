//
//  ObjectPopupView.swift
//  QatarMuseums
//
//  Created by Developer on 13/08/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

protocol ObjectPopUpProtocol {
    func objectPopupCloseButtonPressed()
}

class ObjectPopupView: UIView {
    @IBOutlet var objectPopup: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var objectPopUpInnerView: UIView!
    @IBOutlet weak var viewDetailButton: UIButton!
    
    var objectPopupDelegate : ObjectPopUpProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("ObjectPopupXib", owner: self, options: nil)
        addSubview(objectPopup)
        objectPopup.frame = self.bounds
        objectPopup.autoresizingMask = [.flexibleHeight,.flexibleWidth]
//        setUpUI()
    }
    func setUpUI() {
        objectPopUpInnerView.layer.cornerRadius = 5.0
        self.backgroundColor = UIColor.popupBackgroundWhite
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        titleLabel.font = UIFont.eventPopupTitleFont
//        eventDescription.font = UIFont.settingsUpdateLabelFont
        viewDetailButton.titleLabel?.font = UIFont.englishTitleFont
    }
    
    @IBAction func didTapEventCloseButton(_ sender: UIButton) {
        objectPopupDelegate?.objectPopupCloseButtonPressed()
        self.closeButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    @IBAction func eventCloseTouchDown(_ sender: UIButton) {
        self.closeButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
}

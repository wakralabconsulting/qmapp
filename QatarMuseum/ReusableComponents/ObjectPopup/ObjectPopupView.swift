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
    func viewDetailButtonTapAction()
}

class ObjectPopupView: UIView {
    @IBOutlet var objectPopup: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var objectPopUpInnerView: UIView!
    @IBOutlet weak var viewDetailButton: UIButton!
    @IBOutlet weak var productionValue: UILabel!
    @IBOutlet weak var productionDatesValue: UILabel!
    @IBOutlet weak var periodAndStyleValue: UILabel!
    @IBOutlet weak var productionLabel: UILabel!
    @IBOutlet weak var productionDatesLabel: UILabel!
    @IBOutlet weak var periodAndStyleLabel: UILabel!
    
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
        setUpUI()
    }
    
    func setUpUI() {
        objectPopUpInnerView.layer.cornerRadius = 5.0
        self.backgroundColor = UIColor.popupBackgroundWhite
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        titleLabel.font = UIFont.eventPopupTitleFont
        productionValue.font = UIFont.collectionFirstDescriptionFont
        productionDatesValue.font = UIFont.collectionFirstDescriptionFont
        periodAndStyleValue.font = UIFont.collectionFirstDescriptionFont
        viewDetailButton.titleLabel?.font = UIFont.collectionFirstDescriptionFont
    }
    
    func loadPopup() {
        productionLabel.text = NSLocalizedString("PRODUCTION_LABEL", comment: "PRODUCTION_LABEL Label in the Popup")
        productionDatesLabel.text = NSLocalizedString("PRODUCTION_DATES_LABEL", comment: "PRODUCTION_DATES_LABEL Label in the Popup")
        periodAndStyleLabel.text = NSLocalizedString("PERIOD_STYLE_LABEL", comment: "PERIOD_STYLE_LABEL Label in the Popup")
        let buttonTitle = NSLocalizedString("VIEW_DETAIL_BUTTON_TITLE", comment: "VIEW_DETAIL_BUTTON_TITLE Label in the Popup")
        viewDetailButton.setTitle(buttonTitle, for: .normal)
    }
    
    @IBAction func didTapObjectCloseButton(_ sender: UIButton) {
        objectPopupDelegate?.objectPopupCloseButtonPressed()
        self.closeButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    @IBAction func objectCloseTouchDown(_ sender: UIButton) {
        self.closeButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
    @IBAction func didTapViewDetail(_ sender: UIButton) {
        objectPopupDelegate?.viewDetailButtonTapAction()
        self.viewDetailButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    @IBAction func viewDetailButtonTouchDown(_ sender: UIButton) {
        self.viewDetailButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
}

//
//  ComingSoonPopUp.swift
//  QatarMuseum
//
//  Created by Exalture on 06/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit
protocol comingSoonPopUpProtocol {
    func closeButtonPressed()
}

class ComingSoonPopUp: UIView {
    var comingSoonPopupDelegate : comingSoonPopUpProtocol?
    
    @IBOutlet var comingSoonPopup: UIView!
    @IBOutlet weak var popupInnerView: UIView!
    @IBOutlet weak var messageLabel: UITextView!
    @IBOutlet weak var stayTunedLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ComingSoonpopup", owner: self, options: nil)
        addSubview(comingSoonPopup)
        comingSoonPopup.frame = self.bounds
        comingSoonPopup.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        setUpUI()
    }
    
    func setUpUI() {
        popupInnerView.layer.cornerRadius = 20.0
        self.backgroundColor = UIColor.popupBackgroundWhite
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        titleLabel.font = UIFont.eventPopupTitleFont
        messageLabel.font = UIFont.sideMenuLabelFont
        stayTunedLabel.font = UIFont.sideMenuLabelFont
        closeButton.titleLabel?.font = UIFont.closeButtonFont
    }
    
    func loadPopup() {
        titleLabel.text = NSLocalizedString("COMINGSOON_TITLE", comment: "COMINGSOON_TITLE Label in the Popup")
        messageLabel.text = NSLocalizedString("COMINGSOON_MESSAGE", comment: "COMINGSOON_MESSAGE Label in the Popup")
        stayTunedLabel.text = NSLocalizedString("COMINGSOON_STAY_TUNED", comment: "COMINGSOON_STAY_TUNED Label in the Popup")
        let buttonTitle = NSLocalizedString("CLOSEBUTTON_TITLE", comment: "CLOSEBUTTON_TITLE Label in the Popup")
        closeButton.setTitle(buttonTitle, for: .normal)
    }
    
    func loadLogoutMessage(message: String) {
        titleLabel.text = ""
        messageLabel.text = message
        stayTunedLabel.text = ""
        messageLabel.font = UIFont.diningHeaderFont
        let buttonTitle = NSLocalizedString("OK", comment: "OK Label in the Popup")
        closeButton.setTitle(buttonTitle, for: .normal)
    }
    
    func loadLocationErrorPopup() {
        titleLabel.text = NSLocalizedString("SOMETHING_WENT_WRONG_TITLE", comment: "SOMETHING_WENT_WRONG_TITLE Label in the Popup")
        messageLabel.text = NSLocalizedString("LOCATION_ERROR_MESSAGE", comment: "LOCATION_ERROR_MESSAGE Label in the Popup")
        stayTunedLabel.text = ""
        let buttonTitle = NSLocalizedString("CLOSEBUTTON_TITLE", comment: "CLOSEBUTTON_TITLE Label in the Popup")
        
        closeButton.setTitle(buttonTitle, for: .normal)
    }
    func loadTourGuidePopup() {
        titleLabel.text = NSLocalizedString("COMINGSOON_TITLE", comment: "COMINGSOON_TITLE Label in the Popup")
        messageLabel.text = NSLocalizedString("COMINGSOON_MESSAGE", comment: "COMINGSOON_MESSAGE Label in the Popup") + "\n" + NSLocalizedString("TOUR_GUIDE_COMINGSOON", comment: "TOUR_GUIDE_COMINGSOON Label in the Popup")
        stayTunedLabel.text = NSLocalizedString("COMINGSOON_STAY_TUNED", comment: "COMINGSOON_STAY_TUNED Label in the Popup")
        let buttonTitle = NSLocalizedString("CLOSEBUTTON_TITLE", comment: "CLOSEBUTTON_TITLE Label in the Popup")
        closeButton.setTitle(buttonTitle, for: .normal)
    }
    
    @IBAction func closeButtonTouchDown(_ sender: UIButton) {
        
        self.closeButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
    @IBAction func didTapClose(_ sender: UIButton) {
        
        
        self.closeButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        comingSoonPopupDelegate?.closeButtonPressed()
    }
    
}

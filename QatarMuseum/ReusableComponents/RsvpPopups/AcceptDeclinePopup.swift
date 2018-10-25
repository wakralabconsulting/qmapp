//
//  LoginPopupPage.swift
//  QatarMuseums
//
//  Created by Exalture on 18/10/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import UIKit
protocol DeclinePopupProtocol
{
    func declinePopupCloseButtonPressed()
    func yesButtonPressed()
    func noButtonPressed()
}
class AcceptDeclinePopup: UIView {
    
    @IBOutlet var declinePopup: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var declinePopupInnerView: UIView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
//    @IBOutlet weak var declinePopupHeight: NSLayoutConstraint!
    @IBOutlet weak var popupViewHeight: NSLayoutConstraint!
    
    var declinePopupDelegate : DeclinePopupProtocol?
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit()
    {
        Bundle.main.loadNibNamed("AcceptDeclinePopup", owner: self, options: nil)
        addSubview(declinePopup)
        declinePopup.frame = self.bounds
        declinePopup.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        setUpUI()
    }
    func setUpUI() {
        declinePopupInnerView.layer.cornerRadius = 20.0
        self.backgroundColor = UIColor.popupBackgroundWhite
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        titleLabel.font = UIFont.headerFont
//        userNameText.font = UIFont.startTourFont
//        passwordText.font = UIFont.startTourFont
        yesButton.titleLabel?.font = UIFont.startTourFont
        noButton.titleLabel?.font = UIFont.discoverButtonFont
    }
    @IBAction func didTapNoButton(_ sender: UIButton) {
        self.noButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        declinePopupDelegate?.noButtonPressed()
    }
    @IBAction func didTapYesButton(_ sender: UIButton) {
        self.yesButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        declinePopupDelegate?.yesButtonPressed()
    }
    
    @IBAction func didTapClose(_ sender: UIButton) {
        self.closeButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        declinePopupDelegate?.declinePopupCloseButtonPressed()
    }
    @IBAction func popupCloseTouchDown(_ sender: UIButton) {
        self.closeButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    @IBAction func noButtonTouchDown(_ sender: UIButton) {
        self.noButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    @IBAction func yesButtonTouchDown(_ sender: UIButton) {
        self.noButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
}

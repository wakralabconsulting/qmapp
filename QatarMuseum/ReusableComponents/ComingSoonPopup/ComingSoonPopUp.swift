//
//  ComingSoonPopUp.swift
//  QatarMuseum
//
//  Created by Exalture on 06/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit
protocol comingSoonPopUpProtocol
{
    func closeButtonPressed()
}
class ComingSoonPopUp: UIView {
    
    
    var comingSoonPopupDelegate : comingSoonPopUpProtocol?
    @IBOutlet var comingSoonPopup: UIView!
    @IBOutlet weak var popupInnerView: UIView!
    //@IBOutlet weak var closeButton: UIView!
    
    @IBOutlet weak var closeButton: UIButton!
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
        Bundle.main.loadNibNamed("ComingSoonpopup", owner: self, options: nil)
        addSubview(comingSoonPopup)
        comingSoonPopup.frame = self.bounds
        comingSoonPopup.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        setUpUI()
    }
    func setUpUI() {
        
        popupInnerView.layer.cornerRadius = 20.0
        self.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        let screenTect = UIScreen.main.bounds
//        if(screenTect.size.height <= 568) {
//            self.closeButton.layer.cornerRadius = 16.0
//        }
//        else {
//            self.closeButton.layer.cornerRadius = 20.0
//        }
        layoutIfNeeded()
        
    }
    
    
    @IBAction func closeButtonTouchDown(_ sender: UIButton) {
        self.closeButton.backgroundColor = UIColor(red: 128/255, green: 166/255, blue: 215/255, alpha: 0.6)
        self.closeButton.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7), for: .normal)
        self.closeButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    @IBAction func didTapClose(_ sender: UIButton) {
        self.closeButton.backgroundColor = UIColor(red: 128/255, green: 166/255, blue: 215/255, alpha: 1)
        self.closeButton.setTitleColor(UIColor.black, for: .normal)
        self.closeButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        comingSoonPopupDelegate?.closeButtonPressed()
    }
    
}

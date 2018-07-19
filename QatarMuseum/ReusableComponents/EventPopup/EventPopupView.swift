//
//  EventPopupView.swift
//  QatarMuseum
//
//  Created by Exalture on 08/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit
protocol EventPopUpProtocol
{
    func eventCloseButtonPressed()
    func addToCalendarButtonPressed()
}
class EventPopupView: UIView {

    @IBOutlet var eventPopUp: UIView!
    
    @IBOutlet weak var eventPopupInnerView: UIView!
    @IBOutlet weak var addToCalendarButton: UIButton!
    var eventPopupDelegate : EventPopUpProtocol?
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
        Bundle.main.loadNibNamed("EventPopUp", owner: self, options: nil)
        addSubview(eventPopUp)
        eventPopUp.frame = self.bounds
        eventPopUp.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        setUpUI()
    }
    func setUpUI() {
        
        eventPopupInnerView.layer.cornerRadius = 20.0
        self.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
       
        
    }
    @IBAction func didTapEventCloseButton(_ sender: UIButton) {
        eventPopupDelegate?.eventCloseButtonPressed()
    }
    
    @IBAction func didTapAddToCalendar(_ sender: UIButton) {
        eventPopupDelegate?.addToCalendarButtonPressed()
    }
}

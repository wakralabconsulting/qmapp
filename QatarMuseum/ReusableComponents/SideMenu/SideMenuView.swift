//
//  SideMenuView.swift
//  QatarMuseum
//
//  Created by Exalture on 06/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit
protocol SideMenuProtocol
{
    func exhibitionButtonPressed()
    func eventbuttonPressed()
    func educationButtonPressed()
    func tourGuideButtonPressed()
    func heritageButtonPressed()
    func publicArtsButtonPressed()
    func parksButtonPressed()
    func diningButtonPressed()
    func giftShopButtonPressed()
    func settingsButtonPressed()
    
    func menuEventPressed()
    func menuNotificationPressed()
    func menuProfilePressed()
    func menuClosePressed()
    
}
class SideMenuView: UIView,TopBarProtocol {
    
   
    @IBOutlet weak var sideMenuContentView: UIView!
    @IBOutlet weak var topBarView: TopBarView!
    
    @IBOutlet weak var exhibitionButton: UIButton!
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var educationButton: UIButton!
    @IBOutlet weak var tourGuideButton: UIButton!
    @IBOutlet weak var heritageButton: UIButton!
    @IBOutlet weak var publicArtsButton: UIButton!
    @IBOutlet weak var parksButton: UIButton!
    @IBOutlet weak var diningButton: UIButton!
    @IBOutlet weak var giftShopButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet var sideMenuView: UIView!
    @IBOutlet weak var exhibitionsLabel: UILabel!
    @IBOutlet weak var eventsLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var tourGuideLabel: UILabel!
    @IBOutlet weak var heritageSitesLabel: UILabel!
    @IBOutlet weak var publicArtsLabel: UILabel!
    @IBOutlet weak var diningLabel: UILabel!
    @IBOutlet weak var giftShopLabel: UILabel!
    @IBOutlet weak var parksLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    var sideMenuDelegate : SideMenuProtocol?
    
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
        Bundle.main.loadNibNamed("SideMenu", owner: self, options: nil)
        addSubview(sideMenuView)
        sideMenuView.frame = self.bounds
        sideMenuView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
       topBarView.topbarDelegate = self
       topBarView.menuButton.setImage(UIImage(named: "closeX1"), for: .normal)
        topBarView.backgroundColor = UIColor.clear
        topBarView.backButton.isHidden = true
        
        exhibitionsLabel.text = NSLocalizedString("EXHIBITIONS_LABEL", comment: "EXHIBITIONS_LABEL Label in the SideMenu page")

         eventsLabel.text = NSLocalizedString("EVENTS_LABEL", comment: "EVENTS_LABEL Label in the SideMenu page")
         educationLabel.text = NSLocalizedString("EDUCATION_LABEL", comment: "EDUCATION_LABEL Label in the SideMenu page")
         tourGuideLabel.text = NSLocalizedString("TOURGUIDE_LABEL", comment: "TOURGUIDE_LABEL Label in the SideMenu page")
         heritageSitesLabel.text = NSLocalizedString("HERITAGESITES_LABEL", comment: "HERITAGESITES_LABEL Label in the SideMenu page")
         publicArtsLabel.text = NSLocalizedString("PUBLIC_ARTS_LABEL", comment: "PUBLIC_ARTS_LABEL Label in the SideMenu page")
         diningLabel.text = NSLocalizedString("DINING_LABEL", comment: "DINING_LABEL Label in the SideMenu page")
         giftShopLabel.text = NSLocalizedString("GIFTSHOP_LABEL", comment: "GIFTSHOP_LABEL Label in the SideMenu page")
         parksLabel.text = NSLocalizedString("PARKS_LABEL", comment: "PARKS_LABEL Label in the SideMenu page")
         settingsLabel.text = NSLocalizedString("SIDEMENU_SETTINGS_LABEL", comment: "SIDEMENU_SETTINGS_LABEL Label in the SideMenu page")
        
       
    }
     var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func didTapExhibition(_ sender: UIButton) {
        self.exhibitionButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        sideMenuDelegate?.exhibitionButtonPressed()
    }
    @IBAction func didTapEvent(_ sender: UIButton) {
        self.eventButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        sideMenuDelegate?.eventbuttonPressed()
    }
    @IBAction func didTapEducation(_ sender: UIButton) {
        self.educationButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        sideMenuDelegate?.educationButtonPressed()
    }
    @IBAction func didTapTourGuide(_ sender: UIButton) {
        self.tourGuideButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        sideMenuDelegate?.tourGuideButtonPressed()
    }
    @IBAction func didTapHeritageSites(_ sender: UIButton) {
        self.heritageButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        sideMenuDelegate?.heritageButtonPressed()
    }
    @IBAction func didTapPublicArts(_ sender: UIButton) {
        self.publicArtsButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        sideMenuDelegate?.publicArtsButtonPressed()
    }
    @IBAction func didTapParks(_ sender: UIButton) {
        self.parksButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        sideMenuDelegate?.parksButtonPressed()
    }
    @IBAction func didTapDining(_ sender: UIButton) {
        self.diningButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        sideMenuDelegate?.diningButtonPressed()
    }
    @IBAction func didTapGiftShop(_ sender: UIButton) {
        self.giftShopButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        sideMenuDelegate?.giftShopButtonPressed()
        
    }
    @IBAction func didTapSettings(_ sender: UIButton) {
        self.settingsButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        sideMenuDelegate?.settingsButtonPressed()
    }
    func eventButtonPressed() {
        sideMenuDelegate?.menuEventPressed()
    }
    
    func notificationbuttonPressed() {
        sideMenuDelegate?.menuNotificationPressed()
    }
    
    func profileButtonPressed() {
        sideMenuDelegate?.menuProfilePressed()
    }
    
    func menuButtonPressed() {
        sideMenuDelegate?.menuClosePressed()
    }
    
    func backButtonPressed() {
        
    }
    //MARK: Touchdown Actions
    @IBAction func exhibitionsTouchDown(_ sender: UIButton) {
       self.exhibitionButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    @IBAction func eventButtonTouchDown(_ sender: UIButton) {
        self.eventButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    @IBAction func educationButtonTouchDown(_ sender: UIButton) {
        self.educationButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    @IBAction func tourGuideButtonTouchDown(_ sender: UIButton) {
        self.tourGuideButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    @IBAction func heritageButtonTouchDown(_ sender: UIButton) {
        self.heritageButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    @IBAction func publicArtsButtonTouchDown(_ sender: UIButton) {
        self.publicArtsButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    @IBAction func parksButtonTouchDown(_ sender: UIButton) {
        self.parksButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    @IBAction func diningButtonTouchDown(_ sender: UIButton) {
        self.diningButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    @IBAction func giftShopButtonTouchDown(_ sender: UIButton) {
        self.giftShopButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    @IBAction func settingsButtonTouchDown(_ sender: UIButton) {
        self.settingsButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
}

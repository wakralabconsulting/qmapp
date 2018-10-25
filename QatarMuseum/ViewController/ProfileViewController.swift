//
//  ProfileViewController.swift
//  QatarMuseum
//
//  Created by Exalture on 10/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit
import Crashlytics
class ProfileViewController: UIViewController,HeaderViewProtocol,comingSoonPopUpProtocol, GreetingsPopUpProtocol, InvitationAcceptedPopupProtocol,DeclinePopupProtocol {
    
    @IBOutlet weak var headerView: CommonHeaderView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var dummyImg: UIImageView!
    @IBOutlet weak var viewmyCulturePassButton: UIButton!
    @IBOutlet weak var viewMyFavoriteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    //VIP Inviation controls
    
    @IBOutlet weak var invitationMessageLabel: UILabel!
    @IBOutlet weak var acceptLabel: UILabel!
    @IBOutlet weak var accepetDeclineSwitch: UISwitch!
    @IBOutlet weak var declineLabel: UILabel!
    
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
    
    
    //VVIP Invitation Scenes
    
    var greetingsPopUpView : GreetingsPopupPage = GreetingsPopupPage()
    var invitationAcceptedPopUpView : InvitationAcceptedPopup = InvitationAcceptedPopup()
    var acceptDeclinePopupView : AcceptDeclinePopup = AcceptDeclinePopup()
    
    var fromHome : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProfileUI()
        loadGreetingsPopup()
    }

    func setUpProfileUI() {
        headerView.headerViewDelegate = self
        headerView.headerTitle.text = NSLocalizedString("PROFILE_TITLE", comment: "PROFILE_TITLE Label in the PROFILE page")
        headerView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        profileImageView.image = UIImage(named: "profile_pic_round")
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            
            headerView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        } else {
            headerView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
        
        //Invitation Controls updation
        
        self.accepetDeclineSwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
//        acceptLabel.textAlignment = NSTextAlignment.right
//        declineLabel.textAlignment = NSTextAlignment.left
//        invitationMessageLabel.textAlignment = NSTextAlignment.center
        
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            accepetDeclineSwitch.isOn = true
            let offColor = UIColor.green
            accepetDeclineSwitch.tintColor = offColor
            accepetDeclineSwitch.layer.cornerRadius = 16
            accepetDeclineSwitch.backgroundColor = offColor
            headerView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        } else {
            accepetDeclineSwitch.isOn = false
            let offColor = UIColor.red
            accepetDeclineSwitch.tintColor = offColor
            accepetDeclineSwitch.layer.cornerRadius = 16
            accepetDeclineSwitch.backgroundColor = offColor
            headerView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
        
    }
    
    @IBAction func accepetDeclineSwitchClicked(sender: AnyObject) {
        
        //Change to Arabic
        if (accepetDeclineSwitch.isOn) {
            accepetDeclineSwitch.onTintColor = UIColor.red
            loadConfirmationPopup()
        }
        else {
//            accepetDeclineSwitch.tintColor = offColor
//            accepetDeclineSwitch.layer.cornerRadius = 16
//            accepetDeclineSwitch.backgroundColor = offColor
            acceptNowButtonPressed()
        }
        
    }
    
    
    func loadConfirmationPopup() {
        acceptDeclinePopupView  = AcceptDeclinePopup(frame: self.view.frame)
        acceptDeclinePopupView.popupViewHeight.constant = 250
        acceptDeclinePopupView.declinePopupDelegate = self
        self.view.addSubview(acceptDeclinePopupView)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func loadComingSoonPopup() {
        popupView  = ComingSoonPopUp(frame: self.view.frame)
        popupView.comingSoonPopupDelegate = self
        popupView.loadPopup()
        self.view.addSubview(popupView)
    }
    
    func loadGreetingsPopup() {
        greetingsPopUpView  = GreetingsPopupPage(frame: self.view.frame)
        greetingsPopUpView.greetingsPopupDelegate = self
        self.view.addSubview(greetingsPopUpView)
    }
    
    func closeButtonPressed() {
        self.popupView.removeFromSuperview()
    }
    @IBAction func didTapViewMyFavoriteButton(_ sender: UIButton) {
        loadComingSoonPopup()
        self.viewMyFavoriteButton.backgroundColor = UIColor.profilePink
        self.viewMyFavoriteButton.setTitleColor(UIColor.whiteColor, for: .normal)
        self.viewMyFavoriteButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        
    }
    @IBAction func viewMyFavoriteButtonTouchDown(_ sender: UIButton) {
        self.viewMyFavoriteButton.backgroundColor = UIColor.profileLightPink
        self.viewMyFavoriteButton.setTitleColor(UIColor.viewMyFavDarkPink, for: .normal)
         self.viewMyFavoriteButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    @IBAction func didTapViewMyCulturePassCard(_ sender: UIButton) {
        loadComingSoonPopup()
        self.viewmyCulturePassButton.backgroundColor = UIColor.viewMycultureBlue
        self.viewmyCulturePassButton.setTitleColor(UIColor.white, for: .normal)
        self.viewmyCulturePassButton.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    @IBAction func viewMyCulturePassButtonTouchDown(_ sender: UIButton) {
        self.viewmyCulturePassButton.backgroundColor = UIColor.viewMycultureLightBlue
        self.viewmyCulturePassButton.setTitleColor(UIColor.viewMyculTitleBlue, for: .normal)
        self.viewmyCulturePassButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    @IBAction func didTapProfileEditButton(_ sender: UIButton) {
        self.editButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        loadComingSoonPopup()
    }
    @IBAction func editButtonTouchDown(_ sender: UIButton) {
        self.editButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
    //MARK: headerView Protocol
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        if (fromHome) {
            let appDelegate = UIApplication.shared.delegate
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "homeId") as! HomeViewController
            appDelegate?.window??.rootViewController = homeViewController
        }
        else {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    //Methods for Invitation Greetings
    
    func greetingsPopupClose() {
        self.greetingsPopUpView.removeFromSuperview()
    }
    
    func greetingsPopupCloseButtonPressed() {
        self.greetingsPopUpView.removeFromSuperview()
    }
    
    func acceptNowButtonPressed() {
        greetingsPopupClose()
        invitationAcceptedPopUpView  = InvitationAcceptedPopup(frame: self.view.frame)
        invitationAcceptedPopUpView.inviteAcceptPopupHeight.constant = 250
        invitationAcceptedPopUpView.invitationAcceptedPopupDelegate = self
        self.view.addSubview(invitationAcceptedPopUpView)
    }
    
    func acceptLaterButtonPressed() {
        greetingsPopupClose()
        self.invitationAcceptedPopUpView.removeFromSuperview()

    }
    
    
    func invitationAcceptPopupClose() {
        self.invitationAcceptedPopUpView.removeFromSuperview()

    }
    
    func invitationAcceptClose() {
        self.invitationAcceptedPopUpView.removeFromSuperview()
        let offColor = UIColor.settingsSwitchOnTint
        accepetDeclineSwitch.tintColor = offColor
        accepetDeclineSwitch.layer.cornerRadius = 16
        accepetDeclineSwitch.backgroundColor = offColor
        accepetDeclineSwitch.isOn = false

    }
    func declinePopupCloseButtonPressed() {
        self.acceptDeclinePopupView.removeFromSuperview()
    }
    
    func yesButtonPressed() {
        self.acceptDeclinePopupView.removeFromSuperview()
        accepetDeclineSwitch.onTintColor = UIColor.red
        accepetDeclineSwitch.isOn = true
    }
    
    func noButtonPressed() {
        self.acceptDeclinePopupView.removeFromSuperview()
        let offColor = UIColor.settingsSwitchOnTint
        accepetDeclineSwitch.tintColor = offColor
        accepetDeclineSwitch.layer.cornerRadius = 16
        accepetDeclineSwitch.backgroundColor = offColor
        accepetDeclineSwitch.isOn = false

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}

//
//  CulturePassViewController.swift
//  QatarMuseums
//
//  Created by Developer on 21/08/18.
//  Copyright © 2018 Exalture. All rights reserved.
//
import Crashlytics
import UIKit

class CulturePassViewController: UIViewController, HeaderViewProtocol, comingSoonPopUpProtocol {
    @IBOutlet weak var headerView: CommonHeaderView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var secondIntroLabel: UILabel!
    @IBOutlet weak var benefitLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var notMemberLabel: UILabel!
    @IBOutlet weak var alreadyMemberLabel: UILabel!
    @IBOutlet weak var benefitsDiscountLabel: UILabel!
    var fromHome: Bool = false
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
    let benefitList = ["15% Discount at QM Cafe's across all venues",
                       "10% Discount on items in all QM Gift Shops (without minimum purchase)",
                       "10% Discount at Idam Restaurant at lunch time",
                       "Receive our monthly newsletter to stay up to date on QM and partner offerings",
                       "Get premier access to members only talks &workkshops",
                       "Get exclusive invitation to QM open house access to our world class call center 8AM to 8PM daily"]
    
    override func viewDidLoad() {
        super.viewDidLoad()   
        setupUI()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        //loadingView.isHidden = false
       // loadingView.showLoading()
        headerView.headerViewDelegate = self
        headerView.headerTitle.text = NSLocalizedString("CULTUREPASS_TITLE", comment: "CULTUREPASS_TITLE in the Culture Pass page")
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            headerView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        } else {
            headerView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
        
        introLabel.textAlignment = .left
        secondIntroLabel.textAlignment = .left
        benefitLabel.textAlignment = .center

        benefitLabel.font = UIFont.eventPopupTitleFont
        introLabel.font = UIFont.englishTitleFont
        secondIntroLabel.font = UIFont.englishTitleFont
        notMemberLabel.font = UIFont.englishTitleFont
        alreadyMemberLabel.font = UIFont.englishTitleFont
        
        benefitLabel.text = NSLocalizedString("BENEFIT_TITLE", comment: "BENEFIT_TITLE in the Culture Pass page")
        introLabel.text = NSLocalizedString("CULTURE_PASS_INTRO", comment: "CULTURE_PASS_INTRO in the Culture Pass page")
        secondIntroLabel.text = NSLocalizedString("CULTURE_PASS_SECONDDESC", comment: "CULTURE_PASS_SECONDDESC in the Culture Pass page")
        var benefitString = String()
        for i in 0 ... benefitList.count-1 {
            benefitString = benefitString + "\n\n" + "-" + benefitList[i]
            benefitsDiscountLabel.text = benefitString
            benefitsDiscountLabel.font = UIFont.settingsUpdateLabelFont
        }
        
    }
    
    

    func loadComingSoonPopup() {
        popupView  = ComingSoonPopUp(frame: self.view.frame)
        popupView.comingSoonPopupDelegate = self
        popupView.loadPopup()
        self.view.addSubview(popupView)
    }
    
    func closeButtonPressed() {
        self.popupView.removeFromSuperview()
    }
    
    @IBAction func didTapRegisterButton(_ sender: UIButton) {
        loadComingSoonPopup()
        self.registerButton.backgroundColor = UIColor.profilePink
        self.registerButton.setTitleColor(UIColor.whiteColor, for: .normal)
        self.registerButton.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
    @IBAction func registerButtonTouchDown(_ sender: UIButton) {
        self.registerButton.backgroundColor = UIColor.profileLightPink
        self.registerButton.setTitleColor(UIColor.viewMyFavDarkPink, for: .normal)
        self.registerButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }
    
    @IBAction func didTapLogInButton(_ sender: UIButton) {
        loadComingSoonPopup()
        self.logInButton.backgroundColor = UIColor.viewMycultureBlue
        self.logInButton.setTitleColor(UIColor.white, for: .normal)
        self.logInButton.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
    @IBAction func logInButtonTouchDown(_ sender: UIButton) {
        self.logInButton.backgroundColor = UIColor.viewMycultureLightBlue
        self.logInButton.setTitleColor(UIColor.viewMyculTitleBlue, for: .normal)
        self.logInButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }
    
    //MARK: Header delegates
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        if (fromHome == true) {
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "homeId") as! HomeViewController
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = homeViewController
        }
        else {
            self.dismiss(animated: false, completion: nil)
        }
        
    }
}

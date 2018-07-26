//
//  SettingsViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 23/07/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,HeaderViewProtocol {

    @IBOutlet weak var headerView: CommonHeaderView!
    @IBOutlet weak var selectLanguageLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var arabicLabel: UILabel!
    @IBOutlet weak var notificationTitleLabel: UILabel!
    @IBOutlet weak var eventUpdateLabel: UILabel!
    @IBOutlet weak var exhibitionLabel: UILabel!
    @IBOutlet weak var museumLabel: UILabel!
    @IBOutlet weak var culturePassLabel: UILabel!
    @IBOutlet weak var tourGuideLabel: UILabel!
    @IBOutlet weak var languageSwitch: UISwitch!
    @IBOutlet weak var eventSwitch: UISwitch!
    @IBOutlet weak var exhibitionSwitch: UISwitch!
    @IBOutlet weak var museumSwitch: UISwitch!
    @IBOutlet weak var culturePassSwitch: UISwitch!
    @IBOutlet weak var tourGuideSwitch: UISwitch!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
    }
    func setupUI() {
        headerView.headerViewDelegate = self
        headerView.headerTitle.text = NSLocalizedString("SETTINGS_LABEL", comment: "SETTINGS_LABEL in the Settings page")
        selectLanguageLabel.text = NSLocalizedString("SELECT_LANGUAGE_LABEL", comment: "SELECT_LANGUAGE_LABEL in the Settings page")
        notificationTitleLabel.text = NSLocalizedString("NOTIFICATION_SETTINGS", comment: "NOTIFICATION_SETTINGS in the Settings page")
        arabicLabel.text = NSLocalizedString("ARABIC", comment: "ARABIC in the Settings page")
        englishLabel.text = NSLocalizedString("ENGLISH", comment: "ENGLISH in the Settings page")
        eventUpdateLabel.text = NSLocalizedString("EVENT_UPDATE_LABEL", comment: "EVENT_UPDATE_LABEL in the Settings page")
        exhibitionLabel.text = NSLocalizedString("EXHIBITION_UPDATE_LABEL", comment: "EXHIBITION_UPDATE_LABEL in the Settings page")
        museumLabel.text = NSLocalizedString("MUSEUM_UPDATE_LABEL", comment: "MUSEUM_UPDATE_LABEL in the Settings page")
        culturePassLabel.text = NSLocalizedString("CULTUREPASS_UPDATE_LABEL", comment: "CULTUREPASS_UPDATE_LABEL in the Settings page")
        tourGuideLabel.text = NSLocalizedString("TOURGUIDE_UPDATE_LABEL", comment: "TOURGUIDE_UPDATE_LABEL in the Settings page")
        
       self.languageSwitch.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
       
        self.eventSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        self.exhibitionSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        self.museumSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        self.culturePassSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        self.tourGuideSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            languageSwitch.isOn = false
            let offColor = UIColor.red
            languageSwitch.tintColor = offColor
            languageSwitch.layer.cornerRadius = 16
            languageSwitch.backgroundColor = offColor
            headerView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        }
        else {
            languageSwitch.isOn = true
             headerView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func toggleLanguageSwitch(_ sender: UISwitch) {
        let offColor = UIColor.red
        //Change to Arabic
        if (languageSwitch.isOn) {
            languageSwitch.onTintColor = UIColor.settingsSwitchOnTint
            
            let refreshAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            let titleFont = [NSAttributedStringKey.font: UIFont(name: "DINNextLTPro-Bold", size: 17.0)!]
            let redirectionMessage = NSLocalizedString("SETTINGS_REDIRECTION_MSG", comment: "redirection message in settings page")
            let titleAttrString = NSMutableAttributedString(string: redirectionMessage, attributes: titleFont)
            let yesMessage = NSLocalizedString("YES", comment: "yes message")
            let noMessage = NSLocalizedString("NO", comment: "no message")
            
            refreshAlert.setValue(titleAttrString, forKey: "attributedTitle")
            let noMessageAction = UIAlertAction(title: noMessage, style: .default) { (action) in
                self.languageSwitch.isOn = false
                refreshAlert .dismiss(animated: true, completion: nil)
            }
            let yesAction = UIAlertAction(title: yesMessage, style: .default) { (action) in
                LocalizationLanguage.setAppleLAnguageTo(lang: "ar")
                languageKey = 2
                UserDefaults.standard.set(true, forKey: "Arabic")
                if #available(iOS 9.0, *) {
                    UIView.appearance().semanticContentAttribute = .forceRightToLeft
                    let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "homeId") as! HomeViewController
                    
                    let appDelegate = UIApplication.shared.delegate
                    appDelegate?.window??.rootViewController = homeViewController
                    
                } else {
                    // Fallback on earlier versions
                }
            }
            refreshAlert.addAction(noMessageAction)
            refreshAlert.addAction(yesAction)
            present(refreshAlert, animated: true, completion: nil)
        }
        else {
            languageSwitch.tintColor = offColor
            languageSwitch.layer.cornerRadius = 16
            languageSwitch.backgroundColor = offColor
            
            
            let refreshAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            let titleFont = [NSAttributedStringKey.font: UIFont(name: "DINNextLTArabic-Bold", size: 17.0)!]
            
            let redirectionMessage = NSLocalizedString("SETTINGS_REDIRECTION_MSG", comment: "redirection message in settings page")
            let titleAttrString = NSMutableAttributedString(string: redirectionMessage, attributes: titleFont)
            let yesMessage = NSLocalizedString("YES", comment: "yes message")
            let noMessage = NSLocalizedString("NO", comment: "no message")
            refreshAlert.setValue(titleAttrString, forKey: "attributedTitle")
            let noMessageAction = UIAlertAction(title: noMessage, style: .default) { (action) in
                self.languageSwitch.isOn = true
                refreshAlert .dismiss(animated: true, completion: nil)
            }
            let yesAction = UIAlertAction(title: yesMessage, style: .default) { (action) in
                LocalizationLanguage.setAppleLAnguageTo(lang: "en")
                languageKey = 1
                UserDefaults.standard.set(false, forKey: "Arabic")
                if #available(iOS 9.0, *) {
                    UIView.appearance().semanticContentAttribute = .forceLeftToRight
                    let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "homeId") as! HomeViewController
                    
                    let appDelegate = UIApplication.shared.delegate
                    appDelegate?.window??.rootViewController = homeViewController
                    
                } else {
                    // Fallback on earlier versions
                    
                }
            }
            refreshAlert.addAction(noMessageAction)
            refreshAlert.addAction(yesAction)
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    @IBAction func toggleEventSwitch(_ sender: UISwitch) {
        let offColor = UIColor.red
        if (eventSwitch.isOn) {
            eventSwitch.onTintColor = UIColor.settingsSwitchOnTint
        }
        else {
            eventSwitch.tintColor = offColor
            eventSwitch.layer.cornerRadius = 16
            eventSwitch.backgroundColor = offColor
        }
    }
    @IBAction func toggleExhibitionSwitch(_ sender: UISwitch) {
        let offColor = UIColor.red
        if (exhibitionSwitch.isOn) {
            exhibitionSwitch.onTintColor = UIColor.settingsSwitchOnTint
        }
        else {
            exhibitionSwitch.tintColor = offColor
            exhibitionSwitch.layer.cornerRadius = 16
            exhibitionSwitch.backgroundColor = offColor
        }
    }
    @IBAction func toggleMuseumSwitch(_ sender: UISwitch) {
        let offColor = UIColor.red
        if (museumSwitch.isOn) {
            museumSwitch.onTintColor = UIColor.settingsSwitchOnTint
        }
        else {
            museumSwitch.tintColor = offColor
            museumSwitch.layer.cornerRadius = 16
            museumSwitch.backgroundColor = offColor
        }
    }
    @IBAction func toggleCulturePassSwitch(_ sender: UISwitch) {
        let offColor = UIColor.red
        if (culturePassSwitch.isOn) {
            culturePassSwitch.onTintColor = UIColor.settingsSwitchOnTint
        }
        else {
            culturePassSwitch.tintColor = offColor
            culturePassSwitch.layer.cornerRadius = 16
            culturePassSwitch.backgroundColor = offColor
        }
    }
    @IBAction func toggleTourGuideSwitch(_ sender: UISwitch) {
        let offColor = UIColor.red
        if (tourGuideSwitch.isOn) {
            tourGuideSwitch.onTintColor = UIColor.settingsSwitchOnTint
        }
        else {
            tourGuideSwitch.tintColor = offColor
            tourGuideSwitch.layer.cornerRadius = 16
            tourGuideSwitch.backgroundColor = offColor
        }
    }
    
    @IBAction func didTapResetButton(_ sender: UIButton) {
        self.resetButton.backgroundColor = UIColor.profilePink
        self.resetButton.setTitleColor(UIColor.whiteColor, for: .normal)
        self.resetButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    @IBAction func didTapApplyButton(_ sender: UIButton) {
        self.applyButton.backgroundColor = UIColor.viewMycultureBlue
        self.applyButton.setTitleColor(UIColor.white, for: .normal)
        self.applyButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    @IBAction func resetButtonTouchDown(_ sender: UIButton) {
        self.resetButton.backgroundColor = UIColor.profileLightPink
        self.resetButton.setTitleColor(UIColor.viewMyFavDarkPink, for: .normal)
        self.resetButton.transform = CGAffineTransform(scaleX: 0.7, y:0.7)
    }
    @IBAction func applyButtonTouchDown(_ sender: UIButton) {
        self.applyButton.backgroundColor = UIColor.viewMycultureLightBlue
        self.applyButton.setTitleColor(UIColor.viewMyculTitleBlue, for: .normal)
        self.applyButton.transform = CGAffineTransform(scaleX: 0.7, y:0.7)
    }
    //MARK: header delegate
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    


}

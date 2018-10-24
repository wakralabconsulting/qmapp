//
//  ProfileViewController.swift
//  QatarMuseum
//
//  Created by Exalture on 10/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit
import Crashlytics
class ProfileViewController: UIViewController,HeaderViewProtocol,comingSoonPopUpProtocol {
    @IBOutlet weak var headerView: CommonHeaderView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var dummyImg: UIImageView!
    @IBOutlet weak var viewmyCulturePassButton: UIButton!
    @IBOutlet weak var viewMyFavoriteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var membershipNumText: UILabel!
    @IBOutlet weak var emailText: UILabel!
    
    @IBOutlet weak var dateOfBirthText: UILabel!
    @IBOutlet weak var countryText: UILabel!
    @IBOutlet weak var nationalityText: UILabel!
    
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
    var fromHome : Bool = false
    var loginInfo : LoginData?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProfileUI()
        
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
        if (loginInfo != nil) {
            let userData = loginInfo?.user
            membershipNumText.text = userData?.uid
            emailText.text = userData?.mail
            
            if(userData?.fieldDateOfBirth != nil) {
                if((userData?.fieldDateOfBirth?.count)! > 0) {
                    dateOfBirthText.text = userData?.fieldDateOfBirth![0]
                }
            }
            let locationData = userData?.fieldLocation["und"] as! NSArray
            if(locationData.count > 0) {
                let iso = locationData[0] as! NSDictionary
                if(iso["iso2"] != nil) {
                    countryText.text = iso["iso2"] as! String
                }
                
            }
            
            let nationalityData = userData?.fieldNationality["und"] as! NSArray
            if(nationalityData.count > 0) {
                let nation = nationalityData[0] as! NSDictionary
                if(nation["iso2"] != nil) {
                    nationalityText.text = nation["iso2"] as! String
                }
                
            }
            
        }
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
    func closeButtonPressed() {
        self.popupView.removeFromSuperview()
    }
    @IBAction func didTapViewMyFavoriteButton(_ sender: UIButton) {
        loadComingSoonPopup()
        self.viewMyFavoriteButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        
    }
    @IBAction func viewMyFavoriteButtonTouchDown(_ sender: UIButton) {
         self.viewMyFavoriteButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    @IBAction func didTapViewMyCulturePassCard(_ sender: UIButton) {
        let cardView =  self.storyboard?.instantiateViewController(withIdentifier: "cardViewId") as! CulturePassCardViewController
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(cardView, animated: false, completion: nil)
        self.viewmyCulturePassButton.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    @IBAction func viewMyCulturePassButtonTouchDown(_ sender: UIButton) {
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
    func logOutButtonPressed() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}

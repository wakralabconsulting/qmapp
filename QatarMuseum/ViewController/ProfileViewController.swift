//
//  ProfileViewController.swift
//  QatarMuseum
//
//  Created by Exalture on 10/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Alamofire
import Crashlytics
import Kingfisher
import UIKit

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
    @IBOutlet weak var userNameText: UITextView!
    
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
    var fromHome : Bool = false
    var loginInfo : LoginData?
    var logoutToken : String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        getCulturePassTokenFromServer()
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
            
            if(loginInfo?.user != nil) {
                let userData = loginInfo?.user
                
                if(userData?.uid != nil) {
                    membershipNumText.text = userData?.uid
                }
                if(userData?.mail != nil) {
                    emailText.text = userData?.mail
                }
                if(userData?.name != nil) {
                    userNameText.text = userData?.name?.uppercased()
                }
                if let imageUrl = userData?.picture {
                    profileImageView.kf.setImage(with: URL(string: imageUrl))
                }
                
                if(userData?.fieldDateOfBirth != nil) {
                    if((userData?.fieldDateOfBirth?.count)! > 0) {
                        dateOfBirthText.text = userData?.fieldDateOfBirth![0]
                    }
                }
                let locationData = userData?.fieldLocation["und"] as! NSArray
                if(locationData.count > 0) {
                    let iso = locationData[0] as! NSDictionary
                    if(iso["iso2"] != nil) {
                        countryText.text = iso["iso2"] as? String
                    }
                    
                }
                
                let nationalityData = userData?.fieldNationality["und"] as! NSArray
                if(nationalityData.count > 0) {
                    let nation = nationalityData[0] as! NSDictionary
                    if(nation["iso2"] != nil) {
                        nationalityText.text = nation["iso2"] as? String
                    }
                    
                }
        }
        } else {
            
            if((UserDefaults.standard.value(forKey: "displayName") as? String != nil) && (UserDefaults.standard.value(forKey: "displayName") as? String != "")) {
                userNameText.text = (UserDefaults.standard.value(forKey: "displayName") as? String)?.uppercased()
            }
            if((UserDefaults.standard.value(forKey: "profilePic") as? String != nil) && (UserDefaults.standard.value(forKey: "profilePic") as? String != "")) {
                if let imageUrl = (UserDefaults.standard.value(forKey: "profilePic") as? String) {
                    profileImageView.kf.setImage(with: URL(string: imageUrl))
                }
            }
            
            if((UserDefaults.standard.value(forKey: "uid") as? String != nil) && (UserDefaults.standard.value(forKey: "uid") as? String != "")) {
                membershipNumText.text = UserDefaults.standard.value(forKey: "uid") as? String
            }
            if((UserDefaults.standard.value(forKey: "mail") as? String != nil) && (UserDefaults.standard.value(forKey: "mail") as? String != "")) {
                emailText.text = UserDefaults.standard.value(forKey: "mail") as? String
            }
            if((UserDefaults.standard.value(forKey: "fieldDateOfBirth") as? String != nil) && (UserDefaults.standard.value(forKey: "fieldDateOfBirth") as? String != "")) {
                dateOfBirthText.text = UserDefaults.standard.value(forKey: "fieldDateOfBirth") as? String
            }
            if((UserDefaults.standard.value(forKey: "country") as? String != nil) && (UserDefaults.standard.value(forKey: "country") as? String != "")) {
                countryText.text = UserDefaults.standard.value(forKey: "country") as? String
            }
            if((UserDefaults.standard.value(forKey: "nationality") as? String != nil) && (UserDefaults.standard.value(forKey: "nationality") as? String != "")) {
                nationalityText.text = UserDefaults.standard.value(forKey: "nationality") as? String
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
        if (loginInfo != nil) {
            if(loginInfo?.user != nil) {
                let userData = loginInfo?.user
                if(userData?.uid != nil) {
                    cardView.membershipNumber = "006000"+(userData?.uid)!
                }
            }
        } else {
            if((UserDefaults.standard.value(forKey: "uid") as? String != nil) && (UserDefaults.standard.value(forKey: "uid") as? String != "")) {
                cardView.membershipNumber = "006000" + (UserDefaults.standard.value(forKey: "uid") as? String)!
            }
        }
        
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
    
    //MARK: WebServiceCall
    func getCulturePassTokenFromServer()
    {
        _ = Alamofire.request(QatarMuseumRouter.GetToken(String: "application/json",["name": "haithembahri","pass":"saliha"])).responseObject { (response: DataResponse<TokenData>) -> Void in
            switch response.result {
            case .success(let data):
                self.logoutToken = data.accessToken
                self.headerView.settingsButton.isHidden = false
                self.headerView.settingsButton.setImage(UIImage(named: "logoutX1"), for: .normal)

            case .failure(let error):
                print(error)
            }
        }
    }
    /* logout when click on the logout button */
    func filterButtonPressed() {
        
        if((logoutToken != nil) && (logoutToken != "") && (UserDefaults.standard.value(forKey: "name") as? String != nil) && (UserDefaults.standard.value(forKey: "name") as! String != "") && (UserDefaults.standard.value(forKey: "password") as? String != nil) && (UserDefaults.standard.value(forKey: "password") as! String != "")) {
            let userName = UserDefaults.standard.value(forKey: "name") as! String
            let pwd = UserDefaults.standard.value(forKey: "password") as! String
                _ = Alamofire.request(QatarMuseumRouter.Logout(String: logoutToken!, String: "application/json",["name" : userName,"pass": pwd])).responseObject { (response: DataResponse<LogoutData>) -> Void in
                    switch response.result {
                    case .success(let data):
                        print(data)
                        if(response.response?.statusCode == 200) {
                            UserDefaults.standard.setValue("", forKey: "name")
                            UserDefaults.standard.setValue("", forKey: "password")
                            UserDefaults.standard.setValue("", forKey: "uid")
                            UserDefaults.standard.setValue("", forKey: "mail")
                            UserDefaults.standard.setValue("", forKey: "displayName")
                            UserDefaults.standard.setValue("", forKey: "fieldDateOfBirth")
                            UserDefaults.standard.setValue("", forKey: "country")
                            UserDefaults.standard.setValue("" , forKey: "nationality")
                            UserDefaults.standard.setValue("" , forKey: "profilePic")
                            if let presenter = self.presentingViewController as? CulturePassViewController {
                                presenter.fromHome = true
                                self.dismiss(animated: false, completion: nil)
                            } else {
                                let culturePassView =  self.storyboard?.instantiateViewController(withIdentifier: "culturePassViewId") as! CulturePassViewController
                                culturePassView.fromHome = true
                                self.present(culturePassView, animated: false, completion: nil)
                            }
                            
                        } else {
                            showAlertView(title: "Qatar Museums", message: "Can not log out", viewController: self)
                        }
                    case .failure(let error):
                        print(error)
                        
                    }
                }
        } else {
            showAlertView(title: "Qatar Museums", message: "Can not log out", viewController: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}

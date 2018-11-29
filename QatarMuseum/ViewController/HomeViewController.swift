//
//  HomeViewController.swift
//  QatarMuseum
//
//  Created by Exalture on 06/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Alamofire
import CoreData
import UIKit
import Firebase

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TopBarProtocol,comingSoonPopUpProtocol,SideMenuProtocol,UIViewControllerTransitioningDelegate,LoadingViewProtocol,LoginPopUpProtocol,UITextFieldDelegate {

    @IBOutlet weak var restaurantButton: UIButton!
    @IBOutlet weak var giftShopButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var culturePassButton: UIButton!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var topbarView: TopBarView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var giftShopLabel: UILabel!
    @IBOutlet weak var culturePassLabel: UILabel!
    @IBOutlet weak var diningLabel: UILabel!
    
    
    var homeDataFullArray : NSArray!
    var effect:UIVisualEffect!
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
    var sideView : SideMenuView = SideMenuView()
    var isSideMenuLoaded : Bool = false
    var homeList: [Home]! = []
    var homeEntity: HomeEntity?
    var homeEntityArabic: HomeEntityArabic?
    let networkReachability = NetworkReachabilityManager()
    var homeDBArray:[HomeEntity]?
    var homeDBArrayArabic:[HomeEntityArabic]?
    var apnDelegate : APNProtocol?
    let imageView = UIImageView()
    //let closeButton = UIButton()
    var blurView = UIVisualEffectView()
    var imgButton = UIButton()
    var imgLabel = UITextView()
    var homeBannerList: [HomeBanner]! = []
    var loginPopUpView : LoginPopupPage = LoginPopupPage()
    var accessToken : String? = nil
    var loginArray : LoginData?
    var userInfoArray : UserInfoData?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNib()
        
        
        if (networkReachability?.isReachable)! {
            getHomeList()
        } else {
            self.fetchHomeInfoFromCoredata()
        }
        setUpUI()
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedNotification(notification:)), name: NSNotification.Name("NotificationIdentifier"), object: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setTopImageUI() {
       
        homeCollectionView.contentInset = UIEdgeInsetsMake(120, 0, 0, 0)
        if(UIScreen.main.bounds.height == 812) {
            imageView.frame = CGRect(x: 0, y: 108, width: UIScreen.main.bounds.size.width, height: 120)
        } else {
            imageView.frame = CGRect(x: 0, y: 85, width: UIScreen.main.bounds.size.width, height: 120)
        }
        
        imageView.backgroundColor = UIColor.white
            if homeBannerList.count > 0 {

                if let imageUrl = homeBannerList[0].bannerLink {
                    if(imageUrl != "") {
                        imageView.kf.setImage(with: URL(string: imageUrl))
                    }else {
                        imageView.image = UIImage(named: "default_imageX2")
                    }

                }
                else {
                    imageView.image = UIImage(named: "default_imageX2")
                }
            }
            else {
                imageView.image = nil
            }
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
        
        if(homeBannerList[0].bannerTitle != nil) {
            imgLabel.text = homeBannerList[0].bannerTitle
        }
        imgLabel.textAlignment = .center
        imgLabel.scrollsToTop = false
        imgLabel.isEditable = false
        imgLabel.isScrollEnabled = false
        imgLabel.isSelectable = false
        imgLabel.backgroundColor = UIColor.clear
        imgLabel.font = UIFont.eventPopupTitleFont
        if(UIScreen.main.bounds.height == 812) {
            imgLabel.frame = CGRect(x: 0, y: 130, width: UIScreen.main.bounds.size.width, height: 90)
        } else {
            imgLabel.frame = CGRect(x: 0, y: 95, width: UIScreen.main.bounds.size.width, height: 90)
        }
        
        self.view.addSubview(imgLabel)
        
        imgButton.setTitle("", for: .normal)
        imgButton.setTitleColor(UIColor.blue, for: .normal)
        imgButton.frame = imageView.frame
        imgButton.addTarget(self, action: #selector(self.imgButtonPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(imgButton)
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.light)
        blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = imageView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0
        imageView.addSubview(blurView)
        self.view.layoutIfNeeded()
        
        
    }
   
    @objc func imgButtonPressed(sender: UIButton!) {
      //  if((imageView.image != nil) && (imageView.image != UIImage(named: "default_imageX2"))) {
            //loadMuseumsPage()
        let museumsView =  self.storyboard?.instantiateViewController(withIdentifier: "museumViewId") as! MuseumsViewController
        museumsView.fromHomeBanner = true
        museumsView.museumTitleString = homeBannerList[0].bannerTitle
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(museumsView, animated: false, completion: nil)
        
        //}
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 120 - (scrollView.contentOffset.y + 120)
        let height = min(max(y, 0), 120)
        if(UIScreen.main.bounds.height == 812) {
            imageView.frame = CGRect(x: 0, y: 108, width: UIScreen.main.bounds.size.width, height: height)
            imgButton.frame = imageView.frame
            imgLabel.frame = CGRect(x: 0, y: 130, width: UIScreen.main.bounds.size.width, height: height-10)
        }else {
            imageView.frame = CGRect(x: 0, y: 85, width: UIScreen.main.bounds.size.width, height: height)
            imgButton.frame = imageView.frame
            imgLabel.frame = CGRect(x: 0, y: 95, width: UIScreen.main.bounds.size.width, height: height-10)
        }

        if (imageView.frame.height >= 120 ){
            blurView.alpha  = 0.0
        } else if (imageView.frame.height >= 100 ){
            blurView.alpha  = 0.2
        } else if (imageView.frame.height >= 80 ){
            blurView.alpha  = 0.4
        } else if (imageView.frame.height >= 60 ){
            blurView.alpha  = 0.6
        } else if (imageView.frame.height >= 40 ){
            blurView.alpha  = 0.8
        } else if (imageView.frame.height >= 20 ){
            blurView.alpha  = 0.9
        }
    }
    @objc func receivedNotification(notification: Notification) {
        let notificationsView =  self.storyboard?.instantiateViewController(withIdentifier: "notificationId") as! NotificationsViewController
        notificationsView.fromHome = true
        self.present(notificationsView, animated: false, completion: nil)
    }

    func setUpUI() {
        topbarView.topbarDelegate = self
        topbarView.backButton.isHidden = true
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        visualEffectView.isHidden = true
        loadingView.isHidden = false
        loadingView.loadingViewDelegate = self
        loadingView.showLoading()
        moreLabel.text = NSLocalizedString("MORE",comment: "MORE in Home Page")
        culturePassLabel.text = NSLocalizedString("CULTUREPASS_TITLE",comment: "CULTUREPASS_TITLE in Home Page")
        giftShopLabel.text = NSLocalizedString("GIFT_SHOP",comment: "GIFT_SHOP in Home Page")
        diningLabel.text = NSLocalizedString("DINING_LABEL",comment: "DINING_LABEL in Home Page")
        
        moreLabel.font = UIFont.exhibitionDateLabelFont
        culturePassLabel.font = UIFont.exhibitionDateLabelFont
        giftShopLabel.font = UIFont.exhibitionDateLabelFont
        diningLabel.font = UIFont.exhibitionDateLabelFont
        if(UserDefaults.standard.value(forKey: "firstTimeLaunch") as? String == nil) {
           loadLoginPopup()
            UserDefaults.standard.set("false", forKey: "firstTimeLaunch")
        } else {
            getHomeBanner()
        }
    }
    
    func registerNib() {
        let nib = UINib(nibName: "HomeCollectionCell", bundle: nil)
        homeCollectionView?.register(nib, forCellWithReuseIdentifier: "homeCellId")
        let nib2 = UINib(nibName: "NMoHeaderView", bundle: nil)
        homeCollectionView?.register(nib2, forCellWithReuseIdentifier: "bannerCellId")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return homeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        loadingView.stopLoading()
        loadingView.isHidden = true
        if((UserDefaults.standard.value(forKey: "acceptOrDecline") as? String != nil) && (UserDefaults.standard.value(forKey: "acceptOrDecline") as? String != "")  && (self.homeBannerList.count > 0)) {
            if(indexPath.row == 0) {
                let cell1 : NMoQHeaderCell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "bannerCellId", for: indexPath) as! NMoQHeaderCell
                cell1.setBannerData(bannerData: homeBannerList[0])
                return cell1
            } else {
                let cell : HomeCollectionViewCell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "homeCellId", for: indexPath) as! HomeCollectionViewCell
                
                cell.setHomeCellData(home: homeList[indexPath.row])
                
                loadingView.stopLoading()
                loadingView.isHidden = true
                return cell
            }
        }else {
            let cell : HomeCollectionViewCell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "homeCellId", for: indexPath) as! HomeCollectionViewCell
            
            cell.setHomeCellData(home: homeList[indexPath.row])
            
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(homeCollectionView.frame)
        if((UserDefaults.standard.value(forKey: "acceptOrDecline") as? String != nil) && (UserDefaults.standard.value(forKey: "acceptOrDecline") as? String != "")  && (self.homeBannerList.count > 0)) {
            if(indexPath.row == 0) {
                let museumsView =  self.storyboard?.instantiateViewController(withIdentifier: "museumViewId") as! MuseumsViewController
                museumsView.fromHomeBanner = true
                museumsView.museumTitleString = homeBannerList[0].bannerTitle
                let transition = CATransition()
                transition.duration = 0.25
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromRight
                view.window!.layer.add(transition, forKey: kCATransition)
                self.present(museumsView, animated: false, completion: nil)
            } else {
                if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                    if (homeList[indexPath.row].id == "12181") {
                        loadExhibitionPage()
                    }
                    else {
                        loadMuseumsPage(curretRow: indexPath.row)
                    }
                }
                else {
                    if (homeList[indexPath.row].id == "12186") {
                        loadExhibitionPage()
                    }
                    else {
                        loadMuseumsPage(curretRow: indexPath.row)
                    }
                }
            }
        } else {
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                if (homeList[indexPath.row].id == "12181") {
                    loadExhibitionPage()
                }
                else {
                    loadMuseumsPage(curretRow: indexPath.row)
                }
            }
            else {
                if (homeList[indexPath.row].id == "12186") {
                    loadExhibitionPage()
                }
                else {
                    loadMuseumsPage(curretRow: indexPath.row)
                }
            }
        }
        

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightValue = UIScreen.main.bounds.height/100
        if((UserDefaults.standard.value(forKey: "acceptOrDecline") as? String != nil) && (UserDefaults.standard.value(forKey: "acceptOrDecline") as? String != "")  && (self.homeBannerList.count > 0)) {
            if(indexPath.row == 0) {
                return CGSize(width: homeCollectionView.frame.width, height: 120)

            } else {
                return CGSize(width: homeCollectionView.frame.width, height: heightValue*27)

            }

        }
        else {
            return CGSize(width: homeCollectionView.frame.width, height: heightValue*27)

        }
    }
    
    func loadMuseumsPage(curretRow:Int? = 0) {
        let museumsView =  self.storyboard?.instantiateViewController(withIdentifier: "museumViewId") as! MuseumsViewController
//        if (homeBannerList.count > 0) {
//            museumsView.fromHomeBanner = true
//            museumsView.museumTitleString = homeBannerList[0].bannerTitle
//        } else {
        museumsView.museumId = homeList[curretRow!].id
        museumsView.museumTitleString = homeList[curretRow!].name
        museumsView.fromHomeBanner = false
        //}
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(museumsView, animated: false, completion: nil)
        
    }
    
    func loadExhibitionPage() {
        let exhibitionView =  self.storyboard?.instantiateViewController(withIdentifier: "exhibitionViewId") as! ExhibitionsViewController
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        //transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        exhibitionView.exhibitionsPageNameString = ExhbitionPageName.homeExhibition
        self.present(exhibitionView, animated: false, completion: nil)
    }
    
    func loadComingSoonPopup() {
        popupView  = ComingSoonPopUp(frame: self.view.frame)
        popupView.comingSoonPopupDelegate = self
        popupView.loadPopup()
        self.view.addSubview(popupView)
    }
    
    func updateNotificationBadge() {
        topbarView.updateNotificationBadgeCount()
    }
    
    //MARK: Service call
    func getHomeList() {
        _ = Alamofire.request(QatarMuseumRouter.HomeList()).responseObject { (response: DataResponse<HomeList>) -> Void in
            switch response.result {
            case .success(let data):
                self.homeList = data.homeList
                
                if((UserDefaults.standard.value(forKey: "acceptOrDecline") as? String != nil) && (UserDefaults.standard.value(forKey: "acceptOrDecline") as? String != "")  && (self.homeBannerList.count > 0)) {
                    self.homeList.insert(Home(id:nil , name: self.homeBannerList[0].bannerTitle,image: self.homeBannerList[0].bannerLink,
                                              tourguide_available: "false", sort_id: nil),
                                         at: 0)
                }
                self.saveOrUpdateHomeCoredata()
                self.homeCollectionView.reloadData()
            case .failure(let error):
                var errorMessage: String
                errorMessage = String(format: NSLocalizedString("NO_RESULT_MESSAGE",
                                                                comment: "Setting the content of the alert"))
                self.loadingView.stopLoading()
                self.loadingView.noDataView.isHidden = false
                self.loadingView.isHidden = false
                self.loadingView.showNoDataView()
                self.loadingView.noDataLabel.text = errorMessage
            }
        }
    }
    func getHomeBanner() {
        _ = Alamofire.request(QatarMuseumRouter.GetHomeBanner()).responseObject { (response: DataResponse<HomeBannerList>) -> Void in
            switch response.result {
            case .success(let data):
                
                self.homeBannerList = data.homeBannerList
                if((UserDefaults.standard.value(forKey: "acceptOrDecline") as? String != nil) && (UserDefaults.standard.value(forKey: "acceptOrDecline") as? String != "")  && (self.homeBannerList.count > 0)) {
                    //self.setTopImageUI()
                }
                self.homeCollectionView.reloadData()
                print(self.homeBannerList)
            case .failure(let error):
                var errorMessage: String
                errorMessage = String(format: NSLocalizedString("NO_RESULT_MESSAGE",
                                                                comment: "Setting the content of the alert"))
                self.loadingView.stopLoading()
                self.loadingView.noDataView.isHidden = false
                self.loadingView.isHidden = false
                self.loadingView.showNoDataView()
                self.loadingView.noDataLabel.text = errorMessage
            }
        }
    }
    //MARK: Topbar Delegate
    func backButtonPressed() {
    
    }
    
    func eventButtonPressed() {
        topBarEventButtonPressed()
    }
    
    func notificationbuttonPressed() {
        let notificationsView =  self.storyboard?.instantiateViewController(withIdentifier: "notificationId") as! NotificationsViewController
        notificationsView.fromHome = true
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(notificationsView, animated: false, completion: nil)
    }
    
    func profileButtonPressed() {
       //topBarProfileButtonPressed()
        culturePassButtonPressed()
    }
    
    func menuButtonPressed() {
        topbarMenuPressed()
    }
    
    //MARK: Poup Delegate
    func closeButtonPressed() {
        self.popupView.removeFromSuperview()
    }
    
    //MARK: SideMenu Delegates
    func exhibitionButtonPressed() {
        let exhibitionView =  self.storyboard?.instantiateViewController(withIdentifier: "exhibitionViewId") as! ExhibitionsViewController
        exhibitionView.fromSideMenu = true
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
         exhibitionView.exhibitionsPageNameString = ExhbitionPageName.homeExhibition
        self.present(exhibitionView, animated: false, completion: nil)
    }
    
    func eventbuttonPressed() {
        let eventView =  self.storyboard?.instantiateViewController(withIdentifier: "eventPageID") as! EventViewController
        eventView.fromHome = true
        eventView.isLoadEventPage = true
        eventView.fromSideMenu = true
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(eventView, animated: false, completion: nil)
    }
    
    func educationButtonPressed() {
        let educationView =  self.storyboard?.instantiateViewController(withIdentifier: "educationPageID") as! EducationViewController
        educationView.fromSideMenu = true
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(educationView, animated: false, completion: nil)
    }
    
    func tourGuideButtonPressed() {
        let tourGuideView =  self.storyboard?.instantiateViewController(withIdentifier: "tourGuidId") as! TourGuideViewController
        //tourGuideView.fromHome = true
        tourGuideView.fromSideMenu = true
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(tourGuideView, animated: false, completion: nil)
    }
    
    func heritageButtonPressed() {
        let heritageView =  self.storyboard?.instantiateViewController(withIdentifier: "heritageViewId") as! HeritageListViewController
        heritageView.fromSideMenu = true
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(heritageView, animated: false, completion: nil)
    }
    
    func publicArtsButtonPressed() {
        let publicArtsView =  self.storyboard?.instantiateViewController(withIdentifier: "publicArtsViewId") as! PublicArtsViewController
        publicArtsView.fromSideMenu = true
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(publicArtsView, animated: false, completion: nil)
    }
    
    func parksButtonPressed() {
        let parksView =  self.storyboard?.instantiateViewController(withIdentifier: "parkViewId") as! ParksViewController
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(parksView, animated: false, completion: nil)
    }
    
    func diningButtonPressed() {
        let diningView =  self.storyboard?.instantiateViewController(withIdentifier: "diningViewId") as! DiningViewController
        diningView.fromHome = true
        diningView.fromSideMenu = true
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(diningView, animated: false, completion: nil)
    }
    
    func culturePassButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
        if (UserDefaults.standard.value(forKey: "accessToken") as? String != nil) {
            let profileView =  self.storyboard?.instantiateViewController(withIdentifier: "profileViewId") as! ProfileViewController
            self.present(profileView, animated: false, completion: nil)
        } else {
            let culturePassView =  self.storyboard?.instantiateViewController(withIdentifier: "culturePassViewId") as! CulturePassViewController
            culturePassView.fromHome = true
            self.present(culturePassView, animated: false, completion: nil)
        }
    }
    
    func giftShopButtonPressed() {
        let aboutUrlString = "https://inq-online.com/"
        //"https://inq-online.com/?SID=k36n3od6ovtc5jn5hlf8o54g64"
        if let aboutUrl = URL(string: aboutUrlString) {
            // show alert to choose app
            if UIApplication.shared.canOpenURL(aboutUrl as URL) {
                let webViewVc:WebViewController = self.storyboard?.instantiateViewController(withIdentifier: "webViewId") as! WebViewController
                webViewVc.webViewUrl = aboutUrl
                webViewVc.titleString = NSLocalizedString("WEBVIEW_TITLE", comment: "WEBVIEW_TITLE  in the Webview")
                self.present(webViewVc, animated: false, completion: nil)
            }
        }
    }
    
    func settingsButtonPressed() {
        let settingsView =  self.storyboard?.instantiateViewController(withIdentifier: "settingsId") as! SettingsViewController
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(settingsView, animated: false, completion: nil)
    }
    
    func menuEventPressed() {
        topBarEventButtonPressed()
    }
    
    func menuNotificationPressed() {
        let notificationsView =  self.storyboard?.instantiateViewController(withIdentifier: "notificationId") as! NotificationsViewController
        notificationsView.fromHome = true
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(notificationsView, animated: false, completion: nil)
    }
    
    func menuProfilePressed() {
        topBarProfileButtonPressed()
    }
    
    func menuClosePressed() {
        UIView.animate(withDuration: 0.4, animations: {
            self.sideView.transform = CGAffineTransform.init(scaleX:1 , y: 1)
            self.sideView.alpha = 0
        }) { (success:Bool) in
            self.visualEffectView.effect = nil
            self.visualEffectView.isHidden = true
            self.sideView.removeFromSuperview()
        }
        self.topbarView.menuButton.setImage(UIImage(named: "side_menu_iconX1"), for: .normal)
        self.topbarView.menuButton.contentEdgeInsets = UIEdgeInsets(top: 14, left: 18, bottom: 14, right: 18)
        sideView.sideMenuDelegate = self
    }
    
    //MARK: Bottombar Delegate
    @IBAction func didTapMoreButton(_ sender: UIButton) {
        self.moreButton.transform = CGAffineTransform(scaleX: 1, y: 1)
         topbarMenuPressed()
    }
    
    @IBAction func moreButtonTouchDown(_ sender: UIButton) {
        self.moreButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
    @IBAction func didTaprestaurantButton(_ sender: UIButton) {
        self.culturePassButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        let diningView =  self.storyboard?.instantiateViewController(withIdentifier: "diningViewId") as! DiningViewController
         diningView.fromHome = true
         diningView.fromSideMenu = false
         let transition = CATransition()
         transition.duration = 0.25
         transition.type = kCATransitionPush
         transition.subtype = kCATransitionFromRight
         view.window!.layer.add(transition, forKey: kCATransition)
         self.present(diningView, animated: false, completion: nil)
    }
    
    @IBAction func restaurantButtonTouchDown(_ sender: UIButton) {
        self.restaurantButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
    @IBAction func didTapCulturePass(_ sender: UIButton) {
        culturePassButtonPressed()
        self.culturePassButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    @IBAction func culturePassTouchDown(_ sender: UIButton) {
        self.culturePassButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
    @IBAction func didTapGiftShopButton(_ sender: UIButton) {
        giftShopButtonPressed()
        self.giftShopButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    @IBAction func giftShopButtonTouchDown(_ sender: UIButton) {
        self.giftShopButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
    func topbarMenuPressed() {
        self.topbarView.menuButton.contentEdgeInsets = UIEdgeInsets(top: 14, left: 20, bottom: 14, right: 18)
        var sideViewFrame = CGRect()
        if (UIScreen.main.bounds.height >= 812) {
            sideViewFrame = CGRect(x: 0, y: 40, width: self.view.frame.width, height: self.view.bounds.height)
        } else {
            sideViewFrame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.bounds.height)
        }
        sideView  = SideMenuView(frame: sideViewFrame)
        self.view.addSubview(sideView)
        
        sideView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        sideView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.visualEffectView.isHidden = false
            self.visualEffectView.effect = self.effect
            self.sideView.alpha = 1
            self.sideView.transform = CGAffineTransform.identity
            self.sideView.topBarView.menuButton.contentEdgeInsets = UIEdgeInsets(top: 14, left: 18, bottom: 14, right: 20)
        }
        sideView.sideMenuDelegate = self
        
    }
    
    func topBarEventButtonPressed() {
        let eventView =  self.storyboard?.instantiateViewController(withIdentifier: "eventPageID") as! EventViewController
        eventView.fromHome = true
        eventView.isLoadEventPage = true
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(eventView, animated: false, completion: nil)
    }
    
    func topBarProfileButtonPressed() {
        let profileView =  self.storyboard?.instantiateViewController(withIdentifier: "profileViewId") as! ProfileViewController
        profileView.fromHome = true
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(profileView, animated: false, completion: nil)
        
    }
    
    //MARK: Coredata Method
    func saveOrUpdateHomeCoredata() {
        if (homeList.count > 0) {
            let appDelegate =  UIApplication.shared.delegate as? AppDelegate
            if #available(iOS 10.0, *) {
                let container = appDelegate!.persistentContainer
                container.performBackgroundTask() {(managedContext) in
                    self.coreDataInBackgroundThread(managedContext: managedContext)
                }
            } else {
                let managedContext = appDelegate!.managedObjectContext
                managedContext.perform {
                    self.coreDataInBackgroundThread(managedContext : managedContext)
                }
            }
        }
    }
    
    func coreDataInBackgroundThread(managedContext: NSManagedObjectContext) {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            let fetchData = checkAddedToCoredata(entityName: "HomeEntity", homeId: nil, managedContext: managedContext) as! [HomeEntity]
            if (fetchData.count > 0) {
                for i in 0 ... homeList.count-1 {
                    let homeListDict = homeList[i]
                    let fetchResult = checkAddedToCoredata(entityName: "HomeEntity", homeId: homeList[i].id, managedContext: managedContext)
                    //update
                    if(fetchResult.count != 0) {
                        let homedbDict = fetchResult[0] as! HomeEntity
                        homedbDict.name = homeListDict.name
                        homedbDict.image = homeListDict.image
                        homedbDict.sortid =  homeListDict.sortId
                        homedbDict.tourguideavailable = homeListDict.isTourguideAvailable
                        
                        do{
                            try managedContext.save()
                        }
                        catch{
                            print(error)
                        }
                    } else {
                        //save
                        self.saveToCoreData(homeListDict: homeListDict, managedObjContext: managedContext)
                    }
                }
            } else {
                for i in 0 ... homeList.count-1 {
                    let homeListDict : Home?
                    homeListDict = homeList[i]
                    self.saveToCoreData(homeListDict: homeListDict!, managedObjContext: managedContext)
                }
            }
        } else {
            let fetchData = checkAddedToCoredata(entityName: "HomeEntityArabic", homeId: nil, managedContext: managedContext) as! [HomeEntityArabic]
            if (fetchData.count > 0) {
                for i in 0 ... homeList.count-1 {
                    let homeListDict = homeList[i]
                    
                    let fetchResult = checkAddedToCoredata(entityName: "HomeEntityArabic", homeId: homeList[i].id, managedContext: managedContext)
                    //update
                    if(fetchResult.count != 0) {
                        let homedbDict = fetchResult[0] as! HomeEntityArabic
                        homedbDict.arabicname = homeListDict.name
                        homedbDict.arabicimage = homeListDict.image
                        homedbDict.arabicsortid =  homeListDict.sortId
                        homedbDict.arabictourguideavailable = homeListDict.isTourguideAvailable
                        do{
                            try managedContext.save()
                        }
                        catch{
                            print(error)
                        }
                    } else {
                        //save
                        self.saveToCoreData(homeListDict: homeListDict, managedObjContext: managedContext)
                        
                    }
                }
            } else {
                for i in 0 ... homeList.count-1 {
                    let homeListDict : Home?
                    homeListDict = homeList[i]
                    self.saveToCoreData(homeListDict: homeListDict!, managedObjContext: managedContext)
                    
                }
            }
        }
    }
    
    func saveToCoreData(homeListDict: Home, managedObjContext: NSManagedObjectContext) {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
             let homeInfo: HomeEntity = NSEntityDescription.insertNewObject(forEntityName: "HomeEntity", into: managedObjContext) as! HomeEntity
            homeInfo.id = homeListDict.id
            homeInfo.name = homeListDict.name
            homeInfo.image = homeListDict.image
            homeInfo.tourguideavailable = homeListDict.isTourguideAvailable
            homeInfo.image = homeListDict.image
            homeInfo.sortid = homeListDict.sortId
        } else{
            let homeInfo: HomeEntityArabic = NSEntityDescription.insertNewObject(forEntityName: "HomeEntityArabic", into: managedObjContext) as! HomeEntityArabic
            homeInfo.id = homeListDict.id
            homeInfo.arabicname = homeListDict.name
            homeInfo.arabicimage = homeListDict.image
            homeInfo.arabictourguideavailable = homeListDict.isTourguideAvailable
            homeInfo.arabicsortid = homeListDict.sortId
        }
        do {
            try managedObjContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchHomeInfoFromCoredata() {
        let managedContext = getContext()
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                var homeArray = [HomeEntity]()
                let homeFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "HomeEntity")
            homeArray = (try managedContext.fetch(homeFetchRequest) as? [HomeEntity])!
            if (homeArray.count > 0) {
                for i in 0 ... homeArray.count-1 {
                    
                        self.homeList.insert(Home(id:homeArray[i].id , name: homeArray[i].name,image: homeArray[i].image,
                                                  tourguide_available: homeArray[i].tourguideavailable, sort_id: homeArray[i].sortid),
                                             at: i)
                }
                if(homeList.count == 0){
                    self.showNoNetwork()
                }
                homeCollectionView.reloadData()
            } else{
                self.showNoNetwork()
            }
        } else {
                var homeArray = [HomeEntityArabic]()
                let homeFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "HomeEntityArabic")
                homeArray = (try managedContext.fetch(homeFetchRequest) as? [HomeEntityArabic])!
                if (homeArray.count > 0) {
                    for i in 0 ... homeArray.count-1 {
                        self.homeList.insert(Home(id:homeArray[i].id , name: homeArray[i].arabicname,image: homeArray[i].arabicimage,
                                                  tourguide_available: homeArray[i].arabictourguideavailable, sort_id: homeArray[i].arabicsortid),
                                             at: i)
                    }
                    if(homeList.count == 0){
                        self.showNoNetwork()
                    }
                    homeCollectionView.reloadData()
                } else{
                    self.showNoNetwork()
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func checkAddedToCoredata(entityName: String?, homeId: String?, managedContext: NSManagedObjectContext) -> [NSManagedObject] {
        var fetchResults : [NSManagedObject] = []
        let homeFetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName!)
        if (homeId != nil) {
            homeFetchRequest.predicate = NSPredicate.init(format: "id == \(homeId!)")
        }
        fetchResults = try! managedContext.fetch(homeFetchRequest)
        return fetchResults
    }
    
    func showNodata() {
        var errorMessage: String
        errorMessage = String(format: NSLocalizedString("NO_RESULT_MESSAGE",
                                                        comment: "Setting the content of the alert"))
        self.loadingView.stopLoading()
        self.loadingView.noDataView.isHidden = false
        self.loadingView.isHidden = false
        self.loadingView.showNoDataView()
        self.loadingView.noDataLabel.text = errorMessage
    }
    func showNoNetwork() {
        self.loadingView.stopLoading()
        self.loadingView.noDataView.isHidden = false
        self.loadingView.isHidden = false
        self.loadingView.showNoNetworkView()
    }
    //MARK: LoadingView Delegate
    func tryAgainButtonPressed() {
        if  (networkReachability?.isReachable)! {
            self.getHomeList()
        }
    }
    //MARK: Login Details
    func loadLoginPopup() {
        loginPopUpView  = LoginPopupPage(frame: self.view.frame)
        loginPopUpView.loginPopupDelegate = self
        loginPopUpView.userNameText.delegate = self
        loginPopUpView.passwordText.delegate = self
        self.view.addSubview(loginPopUpView)
    }
    func popupCloseButtonPressed() {
        self.loginPopUpView.removeFromSuperview()
    }
    func loginButtonPressed() {
        loginPopUpView.userNameText.resignFirstResponder()
        loginPopUpView.passwordText.resignFirstResponder()
        self.loginPopUpView.loadingView.isHidden = false
        self.loginPopUpView.loadingView.showLoading()
        
        let titleString = NSLocalizedString("WEBVIEW_TITLE",comment: "Set the title for Alert")
        if  (networkReachability?.isReachable)! {
            if ((loginPopUpView.userNameText.text != "") && (loginPopUpView.passwordText.text != "")) {
                self.getCulturePassTokenFromServer(login: true)
            }  else {
                self.loginPopUpView.loadingView.stopLoading()
                self.loginPopUpView.loadingView.isHidden = true
                if ((loginPopUpView.userNameText.text == "") && (loginPopUpView.passwordText.text == "")) {
                    showAlertView(title: titleString, message: NSLocalizedString("USERNAME_REQUIRED",comment: "Set the message for user name required")+"\n"+NSLocalizedString("PASSWORD_REQUIRED",comment: "Set the message for password required"), viewController: self)
                    
                } else if ((loginPopUpView.userNameText.text == "") && (loginPopUpView.passwordText.text != "")) {
                    showAlertView(title: titleString, message: NSLocalizedString("USERNAME_REQUIRED",comment: "Set the message for user name required"), viewController: self)
                } else if ((loginPopUpView.userNameText.text != "") && (loginPopUpView.passwordText.text == "")) {
                    showAlertView(title: titleString, message: NSLocalizedString("PASSWORD_REQUIRED",comment: "Set the message for password required"), viewController: self)
                }
            }
        } else {
            self.loginPopUpView.loadingView.stopLoading()
            self.loginPopUpView.loadingView.isHidden = true
            self.view.hideAllToasts()
            let eventAddedMessage =  NSLocalizedString("CHECK_NETWORK", comment: "CHECK_NETWORK")
            self.view.makeToast(eventAddedMessage)
        }
    }
    //MARK: WebServiceCall
    func getCulturePassTokenFromServer(login: Bool? = false) {
        _ = Alamofire.request(QatarMuseumRouter.GetToken(["name": loginPopUpView.userNameText.text!,"pass":loginPopUpView.passwordText.text!])).responseObject { (response: DataResponse<TokenData>) -> Void in
            switch response.result {
            case .success(let data):
                self.accessToken = data.accessToken
                if(login == true) {
                    self.getCulturePassLoginFromServer()
                } else {
                    //self.setNewPassword()
                }
                
            case .failure( _):
                self.loginPopUpView.loadingView.stopLoading()
                self.loginPopUpView.loadingView.isHidden = true
            }
        }
    }
    func getCulturePassLoginFromServer() {
        let titleString = NSLocalizedString("WEBVIEW_TITLE",comment: "Set the title for Alert")
        if(accessToken != nil) {
            _ = Alamofire.request(QatarMuseumRouter.Login(["name" : loginPopUpView.userNameText.text!,"pass": loginPopUpView.passwordText.text!])).responseObject { (response: DataResponse<LoginData>) -> Void in
                switch response.result {
                case .success(let data):
                    self.loginPopUpView.loadingView.stopLoading()
                    self.loginPopUpView.loadingView.isHidden = true
                    self.loginPopUpView.removeFromSuperview()
                    if(response.response?.statusCode == 200) {
                        self.loginArray = data
                        UserDefaults.standard.setValue(self.loginArray?.token, forKey: "accessToken")
                        if(self.loginArray != nil) {
                            if(self.loginArray?.user != nil) {
                                if(self.loginArray?.user?.uid != nil) {
                                    self.checkRSVPUserFromServer(userId: self.loginArray?.user?.uid )
                                }
                            }
                        }
                    } else if(response.response?.statusCode == 401) {
                        showAlertView(title: titleString, message: NSLocalizedString("WRONG_USERNAME_OR_PWD",comment: "Set the message for wrong username or password"), viewController: self)
                    } else if(response.response?.statusCode == 406) {
                        showAlertView(title: titleString, message: NSLocalizedString("ALREADY_LOGGEDIN",comment: "Set the message for Already Logged in"), viewController: self)
                    }
                    
                case .failure( _):
                    self.loginPopUpView.removeFromSuperview()
                    self.loginPopUpView.loadingView.stopLoading()
                    self.loginPopUpView.loadingView.isHidden = true
                    
                }
            }
            
        }
    }
    //RSVP Service call
    func checkRSVPUserFromServer(userId: String?) {
        _ = Alamofire.request(QatarMuseumRouter.GetUser(userId!)).responseObject { (response: DataResponse<UserInfoData>) -> Void in
            switch response.result {
            case .success(let data):
                self.loginPopUpView.loadingView.stopLoading()
                self.loginPopUpView.loadingView.isHidden = true
                if(response.response?.statusCode == 200) {
                    self.userInfoArray = data
                    
                    if(self.userInfoArray != nil) {
                        if(self.userInfoArray?.fieldRsvpAttendance != nil) {
                            let undData = self.userInfoArray?.fieldRsvpAttendance!["und"] as! NSArray
                            if(undData != nil) {
                                if(undData.count > 0) {
                                    let value = undData[0] as! NSDictionary
                                    if(value["value"] != nil) {
                                        UserDefaults.standard.setValue(value["value"], forKey: "acceptOrDecline")
                                        self.getHomeBanner()
//                                        if(self.homeBannerList.count > 0) {
//                                            self.setTopImageUI()
//                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    self.setProfileDetails(loginInfo: self.loginArray)
                }
            case .failure( _):
                self.loginPopUpView.loadingView.stopLoading()
                self.loginPopUpView.loadingView.isHidden = true
                
            }
        }
    }
    func setProfileDetails(loginInfo : LoginData?) {
        if (loginInfo != nil) {
            let userData = loginInfo?.user
            UserDefaults.standard.setValue(userData?.uid, forKey: "uid")
            UserDefaults.standard.setValue(userData?.mail, forKey: "mail")
            UserDefaults.standard.setValue(userData?.name, forKey: "displayName")
            UserDefaults.standard.setValue(userData?.picture, forKey: "profilePic")
            if(userData?.fieldDateOfBirth != nil) {
                if((userData?.fieldDateOfBirth?.count)! > 0) {
                    UserDefaults.standard.setValue(userData?.fieldDateOfBirth![0], forKey: "fieldDateOfBirth")
                }
            }
            let firstNameData = userData?.fieldFirstName["und"] as! NSArray
            if(firstNameData != nil && firstNameData.count > 0) {
                let name = firstNameData[0] as! NSDictionary
                if(name["value"] != nil) {
                    UserDefaults.standard.setValue(name["value"] as! String, forKey: "fieldFirstName")
                }
            }
            let lastNameData = userData?.fieldLastName["und"] as! NSArray
            if(lastNameData != nil && lastNameData.count > 0) {
                let name = lastNameData[0] as! NSDictionary
                if(name["value"] != nil) {
                    UserDefaults.standard.setValue(name["value"] as! String, forKey: "fieldLastName")
                }
            }
            let locationData = userData?.fieldLocation["und"] as! NSArray
            if(locationData.count > 0) {
                let iso = locationData[0] as! NSDictionary
                if(iso["iso2"] != nil) {
                    UserDefaults.standard.setValue(iso["iso2"] as! String, forKey: "country")
                }
                
            }
            
            let nationalityData = userData?.fieldNationality["und"] as! NSArray
            if(nationalityData.count > 0) {
                let nation = nationalityData[0] as! NSDictionary
                if(nation["iso2"] != nil) {
                    UserDefaults.standard.setValue(nation["iso2"] as! String , forKey: "nationality")
                }
                
            }
            
        }
        self.loginPopUpView.removeFromSuperview()
    }
    //MARK:TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == loginPopUpView.userNameText) {
            loginPopUpView.passwordText.becomeFirstResponder()
        } else {
            loginPopUpView.userNameText.resignFirstResponder()
            loginPopUpView.passwordText.resignFirstResponder()
        }
        return true
    }

}

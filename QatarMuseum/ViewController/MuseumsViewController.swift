//
//  MuseumsViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 23/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Alamofire
import Crashlytics
import Kingfisher
import UIKit

class MuseumsViewController: UIViewController,KASlideShowDelegate,TopBarProtocol,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,comingSoonPopUpProtocol {
    
    @IBOutlet weak var museumsTopbar: TopBarView!
    @IBOutlet weak var museumsSlideView: KASlideShow!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var museumsBottomCollectionView: UICollectionView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var museumTitle: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    
    var collectionViewImages : NSArray!
    var collectionViewNames : NSArray!
    var popUpView : ComingSoonPopUp = ComingSoonPopUp()
    var museumArray: [Museum] = []
    var museumId:String? = nil
    var museumTitleString:String? = nil
    var totalImgCount = Int()
    var sliderImgCount : Int? = 0
    var sliderImgArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
     
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupUI() {
        
        getMuseumDataFromServer()
        museumsSlideView.imagesContentMode = .scaleAspectFill
        self.museumsSlideView.addImage(UIImage(named: "sliderPlaceholder"))
        let aboutName = NSLocalizedString("ABOUT", comment: "ABOUT  in the Museum")
        let tourGuideName = NSLocalizedString("TOURGUIDE_LABEL", comment: "TOURGUIDE_LABEL  in the Museum page")
        let exhibitionsName = NSLocalizedString("EXHIBITIONS_LABEL", comment: "EXHIBITIONS_LABEL  in the Museum page")
        let collectionsName = NSLocalizedString("COLLECTIONS_TITLE", comment: "COLLECTIONS_TITLE  in the Museum page")
        let parkName = NSLocalizedString("PARKS_LABEL", comment: "PARKS_LABEL  in the Museum page")
        let diningName = NSLocalizedString("DINING_LABEL", comment: "DINING_LABEL  in the Museum page")
        
        museumsTopbar.topbarDelegate = self
        museumsTopbar.menuButton.isHidden = true
        museumsTopbar.backButton.isHidden = false
        museumTitle.text = museumTitleString
        museumTitle.font = UIFont.museumTitleFont
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            museumsTopbar.backButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
            previousButton.isHidden = true
            nextButton.isHidden = false
        } else {
            museumsTopbar.backButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
            previousButton.isHidden = false
            nextButton.isHidden = true
            previousButton.setImage(UIImage(named: "nextImg"), for: .normal)
        }
        if ((museumId != nil) && ((museumId == "63") || (museumId == "96"))) {
            collectionViewImages = ["MIA_AboutX1","Audio CircleX1","exhibition_blackX1","collectionsX1","park_blackX1","diningX1",]
            collectionViewNames = [aboutName,tourGuideName,exhibitionsName,collectionsName,parkName,diningName]
        } else {
            collectionViewImages = ["MIA_AboutX1","exhibition_blackX1","collectionsX1","diningX1",]
            collectionViewNames = [aboutName,exhibitionsName,collectionsName,diningName]
            previousButton.isHidden = true
            nextButton.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //museumsSlideView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    func setSlideShow(imgArray: NSArray) {
        //KASlideshow
        museumsSlideView.delegate = self
        museumsSlideView.delay = 1
        museumsSlideView.transitionDuration = 2.7
        museumsSlideView.transitionType = KASlideShowTransitionType.fade
        museumsSlideView.imagesContentMode = .scaleAspectFill
        museumsSlideView.images = imgArray as! NSMutableArray
        museumsSlideView.add(KASlideShowGestureType.swipe)
        museumsSlideView.imagesContentMode = .scaleAspectFill
        museumsSlideView.start()
        pageControl.numberOfPages = imgArray.count
        if museumsSlideView.images.count > 0 {
            let dot = pageControl.subviews[0]
            dot.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        }
        
        pageControl.currentPage = Int(museumsSlideView.currentIndex)
        pageControl.addTarget(self, action: #selector(MuseumsViewController.pageChanged), for: .valueChanged)
    }
    
    func setImageArray() {
        self.sliderImgArray[0] = UIImage(named: "sliderPlaceholder")!
        self.sliderImgArray[1] = UIImage(named: "sliderPlaceholder")!
        self.sliderImgArray[2] = UIImage(named: "sliderPlaceholder")!
    
        if ((museumArray[0].multimediaFile?.count)! >= 4) {
            totalImgCount = 3
        } else if ((museumArray[0].multimediaFile?.count)! > 1){
            totalImgCount = (museumArray[0].multimediaFile?.count)!-1
        } else {
            totalImgCount = 0
        }
        if (totalImgCount > 0) {
            for  var i in 1 ... totalImgCount {
                let imageUrlString = museumArray[0].multimediaFile![i]
                downloadImage(imageUrlString: imageUrlString)
            }
        }
    }
    
    func downloadImage(imageUrlString : String?)  {
            if (imageUrlString != nil) {
                let imageUrl = URL(string: imageUrlString!)
                ImageDownloader.default.downloadImage(with: imageUrl!, options: [], progressBlock: nil) {
                    (image, error, url, data) in
                    if let image = image {
                        self.sliderImgCount = self.sliderImgCount!+1
                        self.sliderImgArray[self.sliderImgCount!-1] = image
                        self.setSlideShow(imgArray: self.sliderImgArray)
                        self.museumsSlideView.start()
                    } else {
                        if(self.sliderImgCount == 0) {
                           self.sliderImgArray[0] = UIImage(named: "sliderPlaceholder")!
                        } else {
                            self.sliderImgArray[self.sliderImgCount!-1] = UIImage(named: "sliderPlaceholder")!
                        }
                        self.sliderImgCount = self.sliderImgCount!+1
                        self.setSlideShow(imgArray: self.sliderImgArray)
                        self.museumsSlideView.start()
                    }
                }
            }
    }

    //KASlideShow delegate
    func kaSlideShowWillShowNext(_ slideshow: KASlideShow) {
        
    }
    
    func kaSlideShowWillShowPrevious(_ slideshow: KASlideShow) {
        
    }
    
    func kaSlideShowDidShowNext(_ slideshow: KASlideShow) {
        let currentIndex = Int(museumsSlideView.currentIndex)
        pageControl.currentPage = Int(museumsSlideView.currentIndex)
        customizePageControlDot(currentIndex: currentIndex)
        
    }
    
    func kaSlideShowDidShowPrevious(_ slideshow: KASlideShow) {
        let currentIndex = Int(museumsSlideView.currentIndex)
        pageControl.currentPage = Int(museumsSlideView.currentIndex)
        customizePageControlDot(currentIndex: currentIndex)
    }
    
    func customizePageControlDot(currentIndex: Int) {
        for i in 0...2 {
            if (i == currentIndex) {
                let dot = pageControl.subviews[i]
                for j in 0...2 {
                    let dot1 = pageControl.subviews[j]
                    dot1.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                dot.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
                break
            }
        }
      
       
    }
    @objc func pageChanged() {
        
    }
    //MARK: Topbar delegate
    func backButtonPressed() {
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "homeId") as! HomeViewController
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = homeViewController
    }
    //MARK: CollectionView Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let museumsCell : MuseumBottomCell = museumsBottomCollectionView.dequeueReusableCell(withReuseIdentifier: "museumCellId", for: indexPath) as! MuseumBottomCell
        museumsCell.itemButton.setImage(UIImage(named: collectionViewImages.object(at: indexPath.row) as! String), for: .normal)
        let itemName = collectionViewNames.object(at: indexPath.row) as? String
        museumsCell.itemName.text = collectionViewNames.object(at: indexPath.row) as? String
        if((itemName == "Tour Guide") || (itemName == "الدليل السياحي")) {
             museumsCell.itemButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 9, bottom: 10, right: 9)
        }
        else if((itemName == "Exhibitions") || (itemName == "المعارض")) {
            museumsCell.itemButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 14, bottom: 13, right: 14)
        }
        else if((itemName == "Collections") || (itemName == "المجموعات")) {
           
            museumsCell.itemButton.contentEdgeInsets = UIEdgeInsets(top: 19, left: 15, bottom: 19, right: 15)
            
        }
        else if ((itemName == "Parks") || (itemName == "الحدائق"))  {
            museumsCell.itemButton.contentEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        }
        else if  ((itemName == "Dining") || (itemName == "العشاء")) {
            museumsCell.itemButton.contentEdgeInsets = UIEdgeInsets(top: 18, left: 15, bottom: 18, right: 15)
        }
        if((museumId != nil) && ((museumId == "63") || (museumId == "96"))) {
            if (museumsBottomCollectionView.contentOffset.x <= 0.0) {
                if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                    previousButton.isHidden = true
                    nextButton.isHidden = false
                }
                else{
                    previousButton.isHidden = false
                    nextButton.isHidden = true
                    previousButton.setImage(UIImage(named: "nextImg"), for: .normal)
                    
                }
            }
            else {
                if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                    previousButton.isHidden = false
                    nextButton.isHidden = true
                    
                }
                else {
                    previousButton.isHidden = true
                    nextButton.isHidden = false
                    nextButton.setImage(UIImage(named: "previousImg"), for: .normal)
                }
            }
        }
        
        museumsCell.cellItemBtnTapAction = {
            () in
            self.loadBottomCellPages(cellObj: museumsCell, selectedItem: itemName )
        }
        return museumsCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let heightValue = UIScreen.main.bounds.height/100
        return CGSize(width: museumsBottomCollectionView.frame.width/4, height: 110)
    }
    func loadBottomCellPages(cellObj: MuseumBottomCell, selectedItem: String?) {
       if ((selectedItem == "About") || (selectedItem == "عن")) {
//            let heritageDtlView = self.storyboard?.instantiateViewController(withIdentifier: "heritageDetailViewId") as! HeritageDetailViewController
//            heritageDtlView.pageNameString = PageName.museumAbout
//            heritageDtlView.museumId = museumId
        
        let detailStoryboard: UIStoryboard = UIStoryboard(name: "DetailPageStoryboard", bundle: nil)
        
        let heritageDtlView = detailStoryboard.instantiateViewController(withIdentifier: "heritageDetailViewId2") as! MuseumAboutViewController
        heritageDtlView.pageNameString = PageName2.museumAbout
        heritageDtlView.museumId = museumId

        
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = kCATransitionFade
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            self.present(heritageDtlView, animated: false, completion: nil)
       } else if ((selectedItem == "Tour Guide") || (selectedItem == "الدليل السياحي")){
            let tourGuideView =  self.storyboard?.instantiateViewController(withIdentifier: "miaTourGuideId") as! MiaTourGuideViewController
           // tourGuideView.fromHome = false
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            view.window!.layer.add(transition, forKey: kCATransition)
            self.present(tourGuideView, animated: false, completion: nil)
       } else if ((selectedItem == "Exhibitions") || (selectedItem == "المعارض")){
            let exhibitionView = self.storyboard?.instantiateViewController(withIdentifier: "exhibitionViewId") as! ExhibitionsViewController
            exhibitionView.museumId = museumId
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            view.window!.layer.add(transition, forKey: kCATransition)
            exhibitionView.exhibitionsPageNameString = ExhbitionPageName.museumExhibition
            //exhibitionView.exhibitionsPageNameString = ExhbitionPageName.homeExhibition // For now changing to homeExhibition
            self.present(exhibitionView, animated: false, completion: nil)
       } else if ((selectedItem == "Collections") || (selectedItem == "المجموعات")){
            let musmCollectionnView = self.storyboard?.instantiateViewController(withIdentifier: "musmCollectionViewId") as! MuseumCollectionsViewController
            musmCollectionnView.museumId = museumId
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            view.window!.layer.add(transition, forKey: kCATransition)
            self.present(musmCollectionnView, animated: false, completion: nil)
       } else if ((selectedItem == "Parks") || (selectedItem == "الحدائق")){
            let parkView = self.storyboard?.instantiateViewController(withIdentifier: "parkViewId") as! ParksViewController
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = kCATransitionFade
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            self.present(parkView, animated: false, completion: nil)
       } else if((selectedItem == "Dining") || (selectedItem == "العشاء")) {
            let diningView =  self.storyboard?.instantiateViewController(withIdentifier: "diningViewId") as! DiningViewController
            diningView.museumId = museumId
            diningView.fromHome = false
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            view.window!.layer.add(transition, forKey: kCATransition)
            self.present(diningView, animated: false, completion: nil)
       } else {
            loadComingSoonPopup()
       }
    }
    
    @IBAction func didTapPrevious(_ sender: UIButton) {
        
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            let collectionBounds = self.museumsBottomCollectionView.bounds
            let contentOffset = CGFloat(floor(self.museumsBottomCollectionView.contentOffset.x - collectionBounds.size.width))
            self.moveCollectionToFrame(contentOffset: contentOffset)
            
            nextButton.isHidden = false
            previousButton.isHidden = true
            
            
        }
        else {
            self.museumsBottomCollectionView.isScrollEnabled = true
            let collectionBounds = self.museumsBottomCollectionView.bounds
            let contentOffset = CGFloat(floor(self.museumsBottomCollectionView.contentOffset.x + collectionBounds.size.width))
            self.moveCollectionToFrame(contentOffset: contentOffset)
            nextButton.isHidden = false
            previousButton.isHidden = true
          //  nextButton.setImage(UIImage(named: "nextImg"), for: .normal)
        }
    }
    
    @IBAction func didTapNext(_ sender: UIButton) {
       
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            self.museumsBottomCollectionView.isScrollEnabled = true
            let collectionBounds = self.museumsBottomCollectionView.bounds
            let contentOffset = CGFloat(floor(self.museumsBottomCollectionView.contentOffset.x + collectionBounds.size.width))
            self.moveCollectionToFrame(contentOffset: contentOffset)
            
            nextButton.isHidden = true
            previousButton.isHidden = false
            
        }
        else {
            let collectionBounds = self.museumsBottomCollectionView.bounds
            let contentOffset = CGFloat(floor(self.museumsBottomCollectionView.contentOffset.x - collectionBounds.size.width))
            self.moveCollectionToFrame(contentOffset: contentOffset)
            nextButton.isHidden = true
            previousButton.isHidden = false
            previousButton.setImage(UIImage(named: "nextImg"), for: .normal)
        }
    }
    func moveCollectionToFrame(contentOffset : CGFloat) {
        
        let frame: CGRect = CGRect(x : contentOffset ,y : self.museumsBottomCollectionView.contentOffset.y ,width : self.museumsBottomCollectionView.frame.width,height : self.museumsBottomCollectionView.frame.height)
        self.museumsBottomCollectionView.scrollRectToVisible(frame, animated: false)
        
    }
    func loadComingSoonPopup() {
        popUpView  = ComingSoonPopUp(frame: self.view.frame)
        popUpView.comingSoonPopupDelegate = self
        popUpView.loadPopup()
        self.view.addSubview(popUpView)
        
    }
    //MARk: ComingSoonPopUp Delegates
    func closeButtonPressed() {
        self.popUpView.removeFromSuperview()
    }
    //MARK: Header Deleagate
    func eventButtonPressed() {
        let eventView =  self.storyboard?.instantiateViewController(withIdentifier: "eventPageID") as! EventViewController
        eventView.fromHome = false
        eventView.isLoadEventPage = true
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
         transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(eventView, animated: false, completion: nil)
    }
    
    func notificationbuttonPressed() {
        let notificationsView =  self.storyboard?.instantiateViewController(withIdentifier: "notificationId") as! NotificationsViewController
        notificationsView.fromHome = false
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(notificationsView, animated: false, completion: nil)
    }
    
    func profileButtonPressed() {
        //commented bcz now its not needed
//        let profileView =  self.storyboard?.instantiateViewController(withIdentifier: "profileViewId") as! ProfileViewController
//        profileView.fromHome = false
//        let transition = CATransition()
//        transition.duration = 0.3
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromRight
//        view.window!.layer.add(transition, forKey: kCATransition)
//        self.present(profileView, animated: false, completion: nil)

            let culturePassView =  self.storyboard?.instantiateViewController(withIdentifier: "culturePassViewId") as! CulturePassViewController
            culturePassView.fromHome = false
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = kCATransitionFade
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            self.present(culturePassView, animated: false, completion: nil)
    }
    
    func menuButtonPressed() {
        
    }
    
    //MARK: WebServiceCall
    func getMuseumDataFromServer() {
        _ = Alamofire.request(QatarMuseumRouter.LandingPageMuseums(["nid": museumId ?? 0])).responseObject { (response: DataResponse<Museums>) -> Void in
            switch response.result {
            case .success(let data):
                self.museumArray = data.museum!
                if(self.museumArray.count > 0) {
                    self.setImageArray()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

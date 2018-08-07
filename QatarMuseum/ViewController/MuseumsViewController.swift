//
//  MuseumsViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 23/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class MuseumsViewController: UIViewController,KASlideShowDelegate,TopBarProtocol,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,comingSoonPopUpProtocol {
    
    @IBOutlet weak var museumsTopbar: TopBarView!
    @IBOutlet weak var museumsSlideView: KASlideShow!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var museumsBottomCollectionView: UICollectionView!
 
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var museumTitle: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    var slideshowImages : NSArray!
    var collectionViewImages : NSArray!
    var collectionViewNames : NSArray!
    var popUpView : ComingSoonPopUp = ComingSoonPopUp()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func setupUI() {
        slideshowImages = ["museum_of_islamic","second_slider_image","third_slider_image"]
        collectionViewImages = ["MIA_AboutX1","Audio CircleX1","exhibition_blackX1","collectionsX1","park_blackX1","diningX1",]
        collectionViewNames = ["About","Tour Guide","Exhibitions","Collections","Park","Dining"]
       
        museumsTopbar.topbarDelegate = self
        museumsTopbar.menuButton.isHidden = true
        museumsTopbar.backButton.isHidden = false
        museumTitle.text =  NSLocalizedString("MUSEUM_TITLE", comment: "MUSEUM_TITLE  in the Heritage page")
        museumTitle.font = UIFont.museumTitleFont
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            
            museumsTopbar.backButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
            previousButton.isHidden = true
            nextButton.isHidden = false
        }
        else {
            
            museumsTopbar.backButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
            previousButton.isHidden = false
            nextButton.isHidden = true
            previousButton.setImage(UIImage(named: "nextImg"), for: .normal)
        }

    }
    override func viewDidAppear(_ animated: Bool) {
         setSlideShow(imgArray: slideshowImages)
        museumsSlideView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let dot = pageControl.subviews[0]
        dot.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        
    }
    
    func setSlideShow(imgArray : NSArray) {
        
        //sliderLoading.stopAnimating()
       // sliderLoading.isHidden = true
        
        //KASlideshow
        museumsSlideView.delegate = self
        museumsSlideView.delay = 1
        museumsSlideView.transitionDuration = 2.7
        museumsSlideView.transitionType = KASlideShowTransitionType.fade
        museumsSlideView.imagesContentMode = .scaleAspectFill
        museumsSlideView.addImages(fromResources: imgArray as! [Any])
    
        museumsSlideView.add(KASlideShowGestureType.swipe)
        museumsSlideView.start()
        pageControl.numberOfPages = imgArray.count
        pageControl.currentPage = Int(museumsSlideView.currentIndex)
        pageControl.addTarget(self, action: #selector(MuseumsViewController.pageChanged), for: .valueChanged)
        
       
        
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
        museumsCell.itemName.text = collectionViewNames.object(at: indexPath.row) as? String
        if(indexPath.row == 1) {
             museumsCell.itemButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 9, bottom: 10, right: 9)
            
        }
        else if(indexPath.row == 2) {
            
            museumsCell.itemButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 14, bottom: 13, right: 14)
            
        }
        else if(indexPath.row == 3) {
           
            museumsCell.itemButton.contentEdgeInsets = UIEdgeInsets(top: 19, left: 15, bottom: 19, right: 15)
            
        }
        else if (indexPath.row == 4)  {
            museumsCell.itemButton.contentEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        }
        else if  (indexPath.row == 5) {
            museumsCell.itemButton.contentEdgeInsets = UIEdgeInsets(top: 18, left: 15, bottom: 18, right: 15)
        }
        else if(indexPath.row == 6) {
            
            museumsCell.itemButton.contentEdgeInsets = UIEdgeInsets(top: 18, left: 14, bottom: 18, right: 14)
            
        }
        
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
        
        
        museumsCell.cellItemBtnTapAction = {
            () in
            self.loadBottomCellPages(cellObj: museumsCell, selectedIndex: indexPath.row)
        }
        return museumsCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let heightValue = UIScreen.main.bounds.height/100
        return CGSize(width: museumsBottomCollectionView.frame.width/4, height: 110)
    }
    func loadBottomCellPages(cellObj: MuseumBottomCell, selectedIndex: Int) {
       if (selectedIndex == 0) {
            let heritageDtlView = self.storyboard?.instantiateViewController(withIdentifier: "heritageDetailViewId") as! HeritageDetailViewController
            heritageDtlView.pageNameString = PageName.museumAbout
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = kCATransitionFade
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            self.present(heritageDtlView, animated: false, completion: nil)
        }
        else if (selectedIndex == 1) {
            let tourGuideView =  self.storyboard?.instantiateViewController(withIdentifier: "miaTourGuideId") as! MiaTourGuideViewController
           // tourGuideView.fromHome = false
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            view.window!.layer.add(transition, forKey: kCATransition)
            self.present(tourGuideView, animated: false, completion: nil)
        }
        else if (selectedIndex == 2){
            let exhibitionView = self.storyboard?.instantiateViewController(withIdentifier: "exhibitionViewId") as! ExhibitionsViewController
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            view.window!.layer.add(transition, forKey: kCATransition)
            exhibitionView.exhibitionsPageNameString = ExhbitionPageName.museumExhibition
            self.present(exhibitionView, animated: false, completion: nil)
        }
        else if (selectedIndex == 3){
            let musmCollectionnView = self.storyboard?.instantiateViewController(withIdentifier: "musmCollectionViewId") as! MuseumCollectionsViewController
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            view.window!.layer.add(transition, forKey: kCATransition)
            self.present(musmCollectionnView, animated: false, completion: nil)
        }
        else if (selectedIndex == 4){
            let parkView = self.storyboard?.instantiateViewController(withIdentifier: "parkViewId") as! ParksViewController
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = kCATransitionFade
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            self.present(parkView, animated: false, completion: nil)
        }
       else if(selectedIndex == 5) {
        let diningView =  self.storyboard?.instantiateViewController(withIdentifier: "diningViewId") as! DiningViewController
        diningView.fromHome = false
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(diningView, animated: false, completion: nil)
       }
        else {
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
        let profileView =  self.storyboard?.instantiateViewController(withIdentifier: "profileViewId") as! ProfileViewController
        profileView.fromHome = false
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(profileView, animated: false, completion: nil)
    }
    
    func menuButtonPressed() {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}

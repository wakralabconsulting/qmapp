//
//  MiaTourDetailViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 17/07/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class MiaTourDetailViewController: UIViewController,HeaderViewProtocol,comingSoonPopUpProtocol,KASlideShowDelegate {

    @IBOutlet weak var tourGuideDescription: UILabel!
    
    @IBOutlet weak var startTourButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var headerView: CommonHeaderView!
    @IBOutlet weak var slideshowView: KASlideShow!
    var slideshowImages : NSArray!
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
    @IBOutlet weak var pageControl: UIPageControl!
    var i = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }

    func setupUI() {
        tourGuideDescription.text = "In this tour, you will see and learn about the achievements and contributions of Muslim scientists through history. The eight objects have an obvious scientific purpose or show how science has influenced artistic methods."
        headerView.headerViewDelegate = self
         slideshowImages = ["science_tour_object"]
        headerView.headerTitle.text = NSLocalizedString("MIA_TOUR_GUIDES_TITLE", comment: "MIA_TOUR_GUIDES_TITLE in the Mia tour guide page")

        setSlideShow(imgArray: slideshowImages)
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            
            headerView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        }
        else {
            headerView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func setSlideShow(imgArray : NSArray) {
        
        //sliderLoading.stopAnimating()
        // sliderLoading.isHidden = true
        
        //KASlideshow
        slideshowView.delegate = self
        slideshowView.delay = 0.5
        slideshowView.transitionDuration = 2.7
        slideshowView.transitionType = KASlideShowTransitionType.fade
        slideshowView.imagesContentMode = .scaleAspectFit
        slideshowView.addImages(fromResources: imgArray as! [Any])
        
        slideshowView.add(KASlideShowGestureType.swipe)
        slideshowView.start()
        pageControl.numberOfPages = imgArray.count
        pageControl.currentPage = Int(slideshowView.currentIndex)
        pageControl.addTarget(self, action: #selector(MuseumsViewController.pageChanged), for: .valueChanged)
        
        
        
    }
    //KASlideShow delegate
    
    func kaSlideShowWillShowNext(_ slideshow: KASlideShow) {
        
    }
    
    func kaSlideShowWillShowPrevious(_ slideshow: KASlideShow) {
        
    }
    
    func kaSlideShowDidShowNext(_ slideshow: KASlideShow) {

        
        pageControl.subviews.forEach {
            if (i == slideshow.currentIndex) {
                $0.transform = CGAffineTransform(scaleX: 2, y: 2);
                
            }
            else{
                $0.transform = CGAffineTransform(scaleX: 1, y: 1);
            }
            if(i == slideshowImages.count-1) {
                i = 0
            }
            else {
                i = i+1
            }
            
        }
        
       
    }
    func kaSlideShowDidShowPrevious(_ slideshow: KASlideShow) {
        
        //pageControl.currentPage = Int(slideshowView.currentIndex)
    }
    @IBAction func didTapPlayButton(_ sender: UIButton) {
        self.playButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        loadComingSoonPopup()
    }
    
    @IBAction func playButtonTouchDown(_ sender: UIButton) {
        self.playButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    @IBAction func didTapStartTour(_ sender: UIButton) {
        self.startTourButton.backgroundColor = UIColor.viewMycultureBlue
        //self.startTourButton.setTitleColor(UIColor.white, for: .normal)
        self.startTourButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        loadComingSoonPopup()
    }
    @IBAction func startTourButtonTouchDown(_ sender: UIButton) {
        self.startTourButton.backgroundColor = UIColor.startTourLightBlue
        self.startTourButton.setTitleColor(UIColor.viewMyculTitleBlue, for: .normal)
        
        self.startTourButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    func loadComingSoonPopup() {
        popupView  = ComingSoonPopUp(frame: self.view.frame)
        popupView.comingSoonPopupDelegate = self
        popupView.loadPopup()
        self.view.addSubview(popupView)
        
    }
    @objc func pageChanged() {
        
    }
    //MARK: Poup Delegate
    func closeButtonPressed() {
        
        self.popupView.removeFromSuperview()
    }
    //MARK: Header delegate
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 

}

//
//  MiaTourDetailViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 17/07/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Crashlytics
import UIKit
import Alamofire
import Kingfisher

class MiaTourDetailViewController: UIViewController, HeaderViewProtocol, comingSoonPopUpProtocol, KASlideShowDelegate {
    @IBOutlet weak var tourGuideDescription: UITextView!
    @IBOutlet weak var startTourButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var headerView: CommonHeaderView!
    @IBOutlet weak var slideshowView: KASlideShow!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scienceTourTitle: UILabel!
    
    @IBOutlet weak var overlayView: UIView!
    var slideshowImages : NSArray!
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
    var i = 0
    var museumId :String = "63"
    var tourGuide: [TourGuide] = []
    var totalImgCount = Int()
    var sliderImgCount : Int? = 0
    var sliderImgArray = NSMutableArray()
    var titleString : String? = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        getTourGuideDataFromServer()
        setupUI()
        setGradientLayer()
    }

    func setupUI() {
        scienceTourTitle.font = UIFont.miatourGuideFont
        tourGuideDescription.font = UIFont.englishTitleFont
        startTourButton.titleLabel?.font = UIFont.startTourFont
        startTourButton.setTitle(NSLocalizedString("START_TOUR", comment: "START_TOUR in science tour page"), for: .normal)
        headerView.headerViewDelegate = self
        headerView.headerTitle.text = NSLocalizedString("MIA_TOUR_GUIDES_TITLE", comment: "MIA_TOUR_GUIDES_TITLE in the Mia tour guide page")

       // slideshowView.imagesContentMode = .scaleAspectFill
        self.slideshowView.addImage(UIImage(named: "sliderPlaceholder"))
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            headerView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        } else {
            headerView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
        self.scienceTourTitle.text = titleString?.uppercased()
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
        slideshowView.images = imgArray as! NSMutableArray
        slideshowView.add(KASlideShowGestureType.swipe)
        slideshowView.imagesContentMode = .scaleAspectFill
        slideshowView.start()
        if slideshowView.images.count > 0 {
            let dot = pageControl.subviews[0]
            dot.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        }
    
        pageControl.numberOfPages = imgArray.count
        pageControl.currentPage = Int(slideshowView.currentIndex)
        pageControl.addTarget(self, action: #selector(MiaTourDetailViewController.pageChanged), for: .valueChanged)
    }
    
    //KASlideShow delegate
    func kaSlideShowWillShowNext(_ slideshow: KASlideShow) {
        
    }
    
    func kaSlideShowWillShowPrevious(_ slideshow: KASlideShow) {
        
    }
    
    func kaSlideShowDidShowNext(_ slideshow: KASlideShow) {
        let currentIndex = Int(slideshowView.currentIndex)
        pageControl.currentPage = Int(slideshowView.currentIndex)
        customizePageControlDot(currentIndex: currentIndex)
    }
    
    func kaSlideShowDidShowPrevious(_ slideshow: KASlideShow) {
        let currentIndex = Int(slideshowView.currentIndex)
        pageControl.currentPage = Int(slideshowView.currentIndex)
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
    
    @IBAction func didTapPlayButton(_ sender: UIButton) {
        self.playButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        loadComingSoonPopup()
    }
    
    @IBAction func playButtonTouchDown(_ sender: UIButton) {
        self.playButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
    @IBAction func didTapStartTour(_ sender: UIButton) {
        self.startTourButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)

        
        //Open PageViewcontroller with short details
//        let shortDetailsView =  self.storyboard?.instantiateViewController(withIdentifier: "previewPageId") as! PreviewPageViewController
//
//        self.present(shortDetailsView, animated: false, completion: nil)
        let shortDetailsView =  self.storyboard?.instantiateViewController(withIdentifier: "previewContainerId") as! PreviewContainerViewController
        self.present(shortDetailsView, animated: false, completion: nil)

    }
    
    @IBAction func startTourButtonTouchDown(_ sender: UIButton) {
       
       // self.startTourButton.setTitleColor(UIColor.viewMyculTitleBlue, for: .normal)
        
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
    
    //MARK: WebServiceCall
    func getTourGuideDataFromServer() {
        _ = Alamofire.request(QatarMuseumRouter.MuseumTourGuide(["museum_id": museumId])).responseObject { (response: DataResponse<TourGuides>) -> Void in
            switch response.result {
            case .success(let data):
                self.tourGuide = data.tourGuide!
                if(self.tourGuide.count > 0) {
                    
                    if let searchDict = self.tourGuide.first(where: {$0.nid == "12216"}) {
                        self.tourGuideDescription.text = searchDict.tourGuideDescription
                        self.setImageArray(tourGuideImgDict: searchDict)
                    } else {
                        // item could not be found
                    }

                   // self.scienceTourTitle.text = self.tourGuide[0].title?.uppercased()
                   // self.tourGuideDescription.text = self.tourGuide[0].tourGuideDescription
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setImageArray(tourGuideImgDict : TourGuide?) {
        self.sliderImgArray[0] = UIImage(named: "sliderPlaceholder")!
        self.sliderImgArray[1] = UIImage(named: "sliderPlaceholder")!
        self.sliderImgArray[2] = UIImage(named: "sliderPlaceholder")!
        
//        if ((tourGuideImgDict?.multimediaFile?.count)! >= 3) {
//            totalImgCount = 3
//        } else if ((tourGuideImgDict?.multimediaFile?.count)! > 1){
//            totalImgCount = (tourGuideImgDict?.multimediaFile?.count)!-1
//        } else {
//            totalImgCount = 0
//        }
        if ((tourGuideImgDict?.multimediaFile?.count)! > 0) {
            for  var i in 0 ... (tourGuideImgDict?.multimediaFile?.count)!-1 {
                let imageUrlString = tourGuideImgDict?.multimediaFile![i]
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
                    self.slideshowView.start()
                } else {
                    if(self.sliderImgCount == 0) {
                        self.sliderImgArray[0] = UIImage(named: "sliderPlaceholder")!
                    } else {
                        self.sliderImgArray[self.sliderImgCount!-1] = UIImage(named: "sliderPlaceholder")!
                    }
                    self.sliderImgCount = self.sliderImgCount!+1
                    self.setSlideShow(imgArray: self.sliderImgArray)
                    self.slideshowView.start()
                }
            }
        }
    }
    func setGradientLayer() {

        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0 , 1.3]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.overlayView.layer.insertSublayer(gradient, at: 0)
        
    }
}

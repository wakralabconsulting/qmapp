//
//  PreviewContainerViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 03/10/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import Alamofire
import UIKit

class PreviewContainerViewController: UIViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource,HeaderViewProtocol,UIGestureRecognizerDelegate {
    
    

    var pageViewController = UIPageViewController()
    @IBOutlet weak var headerView: CommonHeaderView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var pageViewOne: UIView!
    @IBOutlet weak var pageViewTwo: UIView!
    @IBOutlet weak var pageViewThree: UIView!
    @IBOutlet weak var pageViewFour: UIView!
    @IBOutlet weak var pageViewFive: UIView!
    @IBOutlet weak var pageImageViewOne: UIImageView!
    @IBOutlet weak var pageImageViewTwo: UIImageView!
    @IBOutlet weak var pageImageViewThree: UIImageView!
    @IBOutlet weak var pageImageViewFour: UIImageView!
    @IBOutlet weak var pageImageViewFive: UIImageView!
    @IBOutlet weak var viewOneLineOne: UIView!
    @IBOutlet weak var viewOneLineTwo: UIView!
    @IBOutlet weak var viewTwoLineOne: UIView!
    @IBOutlet weak var viewTwoLineTwo: UIView!
    @IBOutlet weak var viewThreeLineOne: UIView!
    @IBOutlet weak var viewThreeLineTwo: UIView!
    @IBOutlet weak var viewFourLineOne: UIView!
    @IBOutlet weak var viewFourLineTwo: UIView!
    @IBOutlet weak var viewFiveLineOne: UIView!
    @IBOutlet weak var viewFiveLineTwo: UIView!
    
    @IBOutlet weak var pageImageOneHeight: NSLayoutConstraint!
    @IBOutlet weak var pageImageOneWidth: NSLayoutConstraint!
    @IBOutlet weak var pageImageTwoHeight: NSLayoutConstraint!
    @IBOutlet weak var pageImageTwoWidth: NSLayoutConstraint!
    @IBOutlet weak var pageImageThreeHeight: NSLayoutConstraint!
    @IBOutlet weak var pageImageThreeWidth: NSLayoutConstraint!
    @IBOutlet weak var pageImageFourHeight: NSLayoutConstraint!
    @IBOutlet weak var pageImageFourWidth: NSLayoutConstraint!
    @IBOutlet weak var pageImageFiveHeight: NSLayoutConstraint!
    @IBOutlet weak var pageImageFiveWidth: NSLayoutConstraint!
    var pageImages = NSArray()
    var currentPreviewItem = Int()
    let pageCount: Int? = 4
    var reloaded: Bool = false
    var tourGuideArray: [TourGuideFloorMap]! = []
    var countValue : Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUI()
        getTourGuideDataFromServer()
        
    }
    func loadUI() {
        //loadingView.isHidden = false
        //loadingView.showLoading()
        
        
        
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            headerView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        } else {
            headerView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
        headerView.headerViewDelegate = self
        headerView.settingsButton.isHidden = false
        headerView.settingsButton.setImage(UIImage(named: "locationImg"), for: .normal)
        headerView.settingsButton.contentEdgeInsets = UIEdgeInsets(top: 9, left: 10, bottom:9, right: 10)
    }
    func setUpPageControl() {
       
        pageViewController = storyboard?.instantiateViewController(withIdentifier: "PageViewControllerId") as! UIPageViewController
        self.pageViewController.delegate = self;
         self.pageViewController.dataSource = self;
        let startingViewController: PreviewContentViewController = self.viewControllerAtIndex(index: 0)!
        let viewControllers = [startingViewController]
        
        self.pageViewController.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
        
        
        self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
        //self.addChildViewController(pageViewController)
        self.contentView.addSubview((pageViewController.view)!)
        //self.pageViewController.didMove(toParentViewController: self)
        
        pageImageViewOne.image = UIImage(named: "selectedControl")
        showOrHidePageControlView(countValue: pageCount, scrolling: false)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.loadDetailPage))
        tap.delegate = self // This is not required
        self.view.addGestureRecognizer(tap)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func showOrHidePageControlView(countValue: Int?,scrolling:Bool?) {
        if countValue == 0 {
            pageViewOne.isHidden = true
            pageViewTwo.isHidden = true
            pageViewThree.isHidden = true
            pageViewFour.isHidden = true
            pageViewFive.isHidden = true
            
            pageImageViewOne.isHidden = true
            pageImageViewTwo.isHidden = true
            pageImageViewThree.isHidden = true
            pageImageViewFour.isHidden = true
            pageImageViewFive.isHidden = true
            
            viewOneLineOne.isHidden = true
            viewOneLineTwo.isHidden = true
            viewTwoLineOne.isHidden = true
            viewTwoLineTwo.isHidden = true
            viewThreeLineOne.isHidden = true
            viewThreeLineTwo.isHidden = true
            viewFourLineOne.isHidden = true
            viewFourLineTwo.isHidden = true
            viewFiveLineOne.isHidden = true
            viewFiveLineTwo.isHidden = true
        } else if countValue == 1 {
            pageViewOne.isHidden = false
            pageViewTwo.isHidden = true
            pageViewThree.isHidden = true
            pageViewFour.isHidden = true
            pageViewFive.isHidden = true
            
            pageImageViewOne.isHidden = false
            pageImageViewTwo.isHidden = true
            pageImageViewThree.isHidden = true
            pageImageViewFour.isHidden = true
            pageImageViewFive.isHidden = true
            
            
            viewOneLineOne.isHidden = false
            if(scrolling)! {
                viewOneLineTwo.isHidden = true
                pageImageOneWidth.constant = 15
                pageImageOneHeight.constant = 15
                pageImageViewOne.image = UIImage(named: "stripper_inactive_end")
            } else {
                viewOneLineTwo.isHidden = false
            }
            
            viewTwoLineOne.isHidden = true
            //viewTwoLineTwo.isHidden = true
            viewThreeLineOne.isHidden = true
            viewThreeLineTwo.isHidden = true
            viewFourLineOne.isHidden = true
            viewFourLineTwo.isHidden = true
            viewFiveLineOne.isHidden = true
            viewFiveLineTwo.isHidden = true
        } else if countValue == 2 {
            pageViewOne.isHidden = false
            pageViewTwo.isHidden = false
            pageViewThree.isHidden = true
            pageViewFour.isHidden = true
            pageViewFive.isHidden = true
            
            pageImageViewOne.isHidden = false
            pageImageViewTwo.isHidden = false
            pageImageViewThree.isHidden = true
            pageImageViewFour.isHidden = true
            pageImageViewFive.isHidden = true
            
            if(scrolling)! {
                viewTwoLineTwo.isHidden = true
                pageImageTwoWidth.constant = 15
                pageImageTwoHeight.constant = 15
                pageImageViewTwo.image = UIImage(named: "stripper_inactive_end")
            } else {
                viewTwoLineTwo.isHidden = false
            }
            viewOneLineOne.isHidden = false
            viewOneLineTwo.isHidden = false
            viewTwoLineOne.isHidden = false
            //viewTwoLineTwo.isHidden = false
            viewThreeLineOne.isHidden = true
            viewThreeLineTwo.isHidden = true
            viewFourLineOne.isHidden = true
            viewFourLineTwo.isHidden = true
            viewFiveLineOne.isHidden = true
            viewFiveLineTwo.isHidden = true
            
        }
        else if countValue == 3 {
            pageViewOne.isHidden = false
            pageViewTwo.isHidden = false
            pageViewThree.isHidden = false
            pageViewFour.isHidden = true
            pageViewFive.isHidden = true
            
            pageImageViewOne.isHidden = false
            pageImageViewTwo.isHidden = false
            pageImageViewThree.isHidden = false
            pageImageViewFour.isHidden = true
            pageImageViewFive.isHidden = true
            
            if(scrolling)! {
                viewThreeLineTwo.isHidden = true
                pageImageThreeWidth.constant = 15
                pageImageThreeHeight.constant = 15
                pageImageViewThree.image = UIImage(named: "stripper_inactive_end")
            } else {
                viewThreeLineTwo.isHidden = false
            }
            viewOneLineOne.isHidden = false
            viewOneLineTwo.isHidden = false
            viewTwoLineOne.isHidden = false
            viewTwoLineTwo.isHidden = false
            viewThreeLineOne.isHidden = false
            // viewThreeLineTwo.isHidden = false
            viewFourLineOne.isHidden = true
            viewFourLineTwo.isHidden = true
            viewFiveLineOne.isHidden = true
            viewFiveLineTwo.isHidden = true
        }
        else if countValue == 4{
            pageViewOne.isHidden = false
            pageViewTwo.isHidden = false
            pageViewThree.isHidden = false
            pageViewFour.isHidden = false
            pageViewFive.isHidden = true
            
            pageImageViewOne.isHidden = false
            pageImageViewTwo.isHidden = false
            pageImageViewThree.isHidden = false
            pageImageViewFour.isHidden = false
            pageImageViewFive.isHidden = true
            
            if(scrolling)! {
                viewFourLineTwo.isHidden = true
                pageImageFourWidth.constant = 15
                pageImageFourHeight.constant = 15
                pageImageViewFour.image = UIImage(named: "stripper_inactive_end")
            } else {
                viewFourLineTwo.isHidden = false
            }
            viewOneLineOne.isHidden = false
            viewOneLineTwo.isHidden = false
            viewTwoLineOne.isHidden = false
            viewTwoLineTwo.isHidden = false
            viewThreeLineOne.isHidden = false
            viewThreeLineTwo.isHidden = false
            viewFourLineOne.isHidden = false
            //viewFourLineTwo.isHidden = false
            viewFiveLineOne.isHidden = true
            viewFiveLineTwo.isHidden = true
        }else{
            pageViewOne.isHidden = false
            pageViewTwo.isHidden = false
            pageViewThree.isHidden = false
            pageViewFour.isHidden = false
            pageViewFive.isHidden = false
            
            pageImageViewOne.isHidden = false
            pageImageViewTwo.isHidden = false
            pageImageViewThree.isHidden = false
            pageImageViewFour.isHidden = false
            pageImageViewFive.isHidden = false
            
            if(scrolling)! {
                viewFiveLineTwo.isHidden = true
                pageImageFiveWidth.constant = 15
                pageImageFiveHeight.constant = 15
                pageImageViewFive.image = UIImage(named: "stripper_inactive_end")
            } else {
                viewFiveLineTwo.isHidden = false
            }
            viewOneLineOne.isHidden = false
            viewOneLineTwo.isHidden = false
            viewTwoLineOne.isHidden = false
            viewTwoLineTwo.isHidden = false
            viewThreeLineOne.isHidden = false
            viewThreeLineTwo.isHidden = false
            viewFourLineOne.isHidden = false
            viewFourLineTwo.isHidden = false
            viewFiveLineOne.isHidden = false
            // viewFiveLineTwo.isHidden = false
        }
    }
    func showPageControlAtFirstTime() {
        if (pageCount! <= 5) {
            if(pageCount! == 4) {
                viewFourLineTwo.isHidden = true
            } else if (pageCount! == 3) {
                viewThreeLineTwo.isHidden = true
            } else if(pageCount! == 2) {
                viewTwoLineTwo.isHidden = true
            }
            else if(pageCount! == 1) {
                viewOneLineTwo.isHidden = true
                pageViewOne.isHidden = true
            }
            if(pageCount! == 5) {
                pageImageViewFive.image = UIImage(named: "stripper_inactive_end")
                pageImageFiveHeight.constant = 15
                pageImageFiveWidth.constant = 15
            }
            viewFiveLineTwo.isHidden = true
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        
        var index: Int? = (viewController as? PreviewContentViewController)?.pageIndex
        if ((index == 0) || (index == NSNotFound)) {
            return nil
        }
        index = index! - 1
      
        
        
        
        return self.viewControllerAtIndex(index: index!)
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        
        
        var index: Int? = (viewController as? PreviewContentViewController)?.pageIndex
        if (index == NSNotFound) {
            return nil
        }
        index = index! + 1
        
        if (index == self.pageCount) {
            return nil
        }
        
        
        
        
        
        return self.viewControllerAtIndex(index: index!)
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if (!completed)
        {
            return
        }
        
        if let currentViewController = pageViewController.viewControllers![0] as? PreviewContentViewController {
             let currentPageIndex = currentViewController.pageIndex
            reloaded = true
            var remainingCount = Int()
            if(currentPageIndex % 5 == 0) {
                //setPageViewVisible()
                
                pageImageViewOne.image = UIImage(named: "selectedControl")
                pageImageViewTwo.image = UIImage(named: "unselected")
                pageImageViewThree.image = UIImage(named: "unselected")
                pageImageViewFour.image = UIImage(named: "unselected")
                pageImageViewFive.image = UIImage(named: "unselected")
                remainingCount = pageCount! - ( currentPageIndex+1)
                if(currentPageIndex > currentPreviewItem) {
                    
                    if (remainingCount < 5) {
                        showOrHidePageControlView(countValue: remainingCount+1, scrolling: true)
                        if(remainingCount+1 == 2) {
                            pageImageViewTwo.image = UIImage(named: "stripper_inactive_end")
                        } else if(remainingCount+1 == 3) {
                            pageImageViewThree.image = UIImage(named: "stripper_inactive_end")
                        } else if(remainingCount+1 == 4) {
                            pageImageViewFour.image = UIImage(named: "stripper_inactive_end")
                        } else if(remainingCount+1 == 5) {
                            pageImageViewFive.image = UIImage(named: "stripper_inactive_end")
                        }
                    }
                    
                }
                else  {
                    //remainingCount = pageCount! - ( indexPath.row+1)
                    if(remainingCount+1 == 2) {
                        pageImageViewTwo.image = UIImage(named: "stripper_inactive_end")
                        pageImageTwoHeight.constant = 15
                        pageImageTwoWidth.constant = 15
                    } else if(remainingCount+1 == 3) {
                        pageImageViewThree.image = UIImage(named: "stripper_inactive_end")
                        pageImageThreeHeight.constant = 15
                        pageImageThreeWidth.constant = 15
                    } else if(remainingCount+1 == 4) {
                        pageImageViewFour.image = UIImage(named: "stripper_inactive_end")
                        pageImageFourHeight.constant = 15
                        pageImageFourWidth.constant = 15
                    } else if(remainingCount+1 == 5) {
                        pageImageViewFive.image = UIImage(named: "stripper_inactive_end")
                        pageImageFiveHeight.constant = 15
                        pageImageFiveWidth.constant = 15
                    }
                    
                }
                if(currentPageIndex == 0) {
                    viewOneLineOne.isHidden = true
                } else {
                    viewOneLineOne.isHidden = false
                    pageImageOneHeight.constant = 20
                    pageImageOneWidth.constant = 20
                    
                }
                
                
            } else if(currentPageIndex%5 == 1) {
                
                if(currentPageIndex == 1) {
                    pageImageOneHeight.constant = 15
                    pageImageOneWidth.constant = 15
                    pageImageViewOne.image = UIImage(named: "stripper_inactive_end")
                } else {
                    pageImageOneHeight.constant = 20
                    pageImageOneWidth.constant = 20
                    pageImageViewOne.image = UIImage(named: "unselected")
                }
                pageImageTwoHeight.constant = 20
                pageImageTwoWidth.constant = 20
                pageImageViewTwo.image = UIImage(named: "selectedControl")
                pageImageViewThree.image = UIImage(named: "unselected")
                pageImageViewFour.image = UIImage(named: "unselected")
                pageImageViewFive.image = UIImage(named: "unselected")
            } else if(currentPageIndex%5 == 2) {
                pageImageThreeHeight.constant = 20
                pageImageThreeWidth.constant = 20
                //pageImageViewOne.image = UIImage(named: "stripper_inactive_end")
                pageImageViewTwo.image = UIImage(named: "unselected")
                pageImageViewThree.image = UIImage(named: "selectedControl")
                pageImageViewFour.image = UIImage(named: "unselected")
                pageImageViewFive.image = UIImage(named: "unselected")
            } else if(currentPageIndex%5 == 3) {
                pageImageFourHeight.constant = 20
                pageImageFourWidth.constant = 20
                //setPageViewVisible()
                // pageImageViewOne.image = UIImage(named: "stripper_inactive_end")
                pageImageViewTwo.image = UIImage(named: "unselected")
                pageImageViewThree.image = UIImage(named: "unselected")
                pageImageViewFour.image = UIImage(named: "selectedControl")
                pageImageViewFive.image = UIImage(named: "unselected")
            }
            else if(currentPageIndex%5 == 4) {
                if(currentPageIndex > currentPreviewItem) {
                    let remnCount = pageCount! - ( currentPageIndex+1)
                    if(remnCount <= 0) {
                        viewFiveLineTwo.isHidden = true
                    }
                }
                else {
                    setPageViewVisible()
                    if(currentPageIndex == 4) {
                        viewOneLineOne.isHidden = true
                        pageImageOneHeight.constant = 15
                        pageImageOneWidth.constant = 15
                        pageImageViewOne.image = UIImage(named: "stripper_inactive_end")
                        
                        pageImageTwoHeight.constant = 20
                        pageImageTwoWidth.constant = 20
                        pageImageThreeHeight.constant = 20
                        pageImageThreeWidth.constant = 20
                        pageImageFourHeight.constant = 20
                        pageImageFourWidth.constant = 20
                        pageImageFiveHeight.constant = 20
                        pageImageFiveWidth.constant = 20
                    }
                }
                
                pageImageViewTwo.image = UIImage(named: "unselected")
                pageImageViewThree.image = UIImage(named: "unselected")
                pageImageViewFour.image = UIImage(named: "unselected")
                pageImageViewFive.image = UIImage(named: "selectedControl")
            }
            
            if(currentPageIndex == 0) {
                viewOneLineOne.isHidden = true
                pageImageOneHeight.constant = 20
                pageImageOneWidth.constant = 20
            }
            currentPreviewItem = currentPageIndex
            print(currentViewController.pageIndex)
        }
       
    }
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let currentPageIndex = (pendingViewControllers.last! as! PreviewContentViewController).pageIndex
       // print(currentPageIndex)
        
        
       
        
    }
    
    func viewControllerAtIndex(index : Int) -> PreviewContentViewController? {
        
        if ((self.pageCount! == 0) || (index > self.pageCount!)){
            return nil
        }
        
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewControllerId") as! PreviewContentViewController
        pageContentViewController.pageIndex = index
        pageContentViewController.tourGuideDict = tourGuideArray[index]
        //print(index)
        
        return pageContentViewController
    }
    func setPageViewVisible() {
        pageViewOne.isHidden = false
        pageViewTwo.isHidden = false
        pageViewThree.isHidden = false
        pageViewFour.isHidden = false
        pageViewFive.isHidden = false
        
        pageImageViewOne.isHidden = false
        pageImageViewTwo.isHidden = false
        pageImageViewThree.isHidden = false
        pageImageViewFour.isHidden = false
        pageImageViewFive.isHidden = false
        
        viewOneLineOne.isHidden = false
        viewOneLineTwo.isHidden = false
        viewTwoLineOne.isHidden = false
        viewTwoLineTwo.isHidden = false
        viewThreeLineOne.isHidden = false
        viewThreeLineTwo.isHidden = false
        viewFourLineOne.isHidden = false
        viewFourLineTwo.isHidden = false
        viewFiveLineOne.isHidden = false
        viewFiveLineTwo.isHidden = false
    }
    //MARK: Header Delegate
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    //MARK: WebServiceCall
    func getTourGuideDataFromServer()
    {
        
        _ = Alamofire.request(QatarMuseumRouter.CollectionByTourGuide(["tour_guide_id": "12216"])).responseObject { (response: DataResponse<TourGuideFloorMaps>) -> Void in
            switch response.result {
            case .success(let data):
                self.tourGuideArray = data.tourGuideFloorMap
                //self.saveOrUpdateHeritageCoredata()
                self.countValue = self.pageCount
                if(self.tourGuideArray.count != 0) {
                    self.setUpPageControl()
                    self.showPageControlAtFirstTime()
                }
                //self.previewCllectionView.reloadData()
               
                //self.loadingView.stopLoading()
                //self.loadingView.isHidden = true
                self.showOrHidePageControlView(countValue: self.pageCount, scrolling: false)
                if (self.tourGuideArray.count == 0) {
                   // self.loadingView.stopLoading()
                   // self.loadingView.noDataView.isHidden = false
                    //self.loadingView.isHidden = false
                   // self.loadingView.showNoDataView()
                }
            case .failure(let error):
                print(("error"))
                
//                self.loadingView.stopLoading()
//                self.loadingView.noDataView.isHidden = false
//                self.loadingView.isHidden = false
//                self.loadingView.showNoDataView()
//
                
            }
        }
    }
    func filterButtonPressed() {
        
        //        let transition = CATransition()
        //        transition.duration = 0.3
        //        transition.type = kCATransitionMoveIn
        //        //transition.subtype = kCATransitionFromRight
        //
        //
        //        view.window!.layer.add(transition, forKey: kCATransition)
        let floorMapView =  self.storyboard?.instantiateViewController(withIdentifier: "floorMapId") as! FloorMapViewController
        
        let selectedItem = tourGuideArray[currentPreviewItem]
        floorMapView.selectedScienceTour = selectedItem.artifactPosition
        floorMapView.selectedScienceTourLevel = selectedItem.floorLevel
        floorMapView.selectedTourdGuidIndex = currentPreviewItem
        floorMapView.fromScienceTour = true
        floorMapView.modalTransitionStyle = .flipHorizontal
        self.present(floorMapView, animated: true, completion: nil)
    }
    @objc func loadDetailPage(sender: UITapGestureRecognizer? = nil) {
        let objectDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "objectDetailId") as! ObjectDetailViewController
        objectDetailView.detailArray.append(tourGuideArray[currentPreviewItem])
                let transition = CATransition()
                transition.duration = 0.3
                transition.type = kCATransitionFade
                transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
                view.window!.layer.add(transition, forKey: kCATransition)
        self.present(objectDetailView, animated: false, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}

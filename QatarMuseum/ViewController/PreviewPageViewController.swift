//
//  PreviewPageViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 13/09/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import Alamofire
import UIKit
import Crashlytics
class PreviewPageViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HeaderViewProtocol {
   
    
    var pageIndex: Int = 0
    var strTitle: String!
    var strPhotoName: String!
    
    @IBOutlet weak var headerView: CommonHeaderView!
    @IBOutlet weak var previewCllectionView: UICollectionView!
    @IBOutlet weak var pageControlCollectionView: UICollectionView!
    @IBOutlet weak var loadingView: LoadingView!
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
 
    var currentPreviewItem = IndexPath()
    let pageCount: Int? = 14
    var reloaded: Bool = false
    var tourGuideArray: [TourGuideFloorMap]! = []
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        registerNib()
        getTourGuideDataFromServer()
     
    }
    
    func loadUI() {
        loadingView.isHidden = false
        loadingView.showLoading()
        headerView.headerViewDelegate = self
        headerView.settingsButton.isHidden = false
        headerView.settingsButton.setImage(UIImage(named: "locationImg"), for: .normal)
        headerView.settingsButton.contentEdgeInsets = UIEdgeInsets(top: 9, left: 10, bottom:9, right: 10)
        
        pageImageViewOne.image = UIImage(named: "selectedControl")
        //For TimelineView
//        if (pageCount! >= 5) {
//            showOrHidePageControlView(countValue: 5, scrolling: true)
//        } else {
            showOrHidePageControlView(countValue: tourGuideArray.count, scrolling: false)
        //}
        
        
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
 
    func registerNib() {
        let nib = UINib(nibName: "PreviewCellXib", bundle: nil)
        previewCllectionView?.register(nib, forCellWithReuseIdentifier: "previewCellId")
        let nib2 = UINib(nibName: "PageControlCellXib", bundle: nil)
        pageControlCollectionView?.register(nib2, forCellWithReuseIdentifier: "pageControlCellId")
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == previewCllectionView) {
            //return tourGuideArray.count
            return tourGuideArray.count
        } else {
            return tourGuideArray.count
            //return tourGuideArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == previewCllectionView) {
            let cell : PreviewCollectionViewCell = previewCllectionView.dequeueReusableCell(withReuseIdentifier: "previewCellId", for: indexPath) as! PreviewCollectionViewCell
            cell.setPreviewData(tourGuideData: tourGuideArray[indexPath.row])
           pageControlCollectionView.scrollToItem(at: indexPath, at: .right, animated: false)
           currentPreviewItem = indexPath
            if(indexPath.row == 0) {
                viewOneLineOne.isHidden = true
                if (tourGuideArray.count <= 5) {
                    if(tourGuideArray.count == 4) {
                        viewFourLineTwo.isHidden = true
                    } else if (tourGuideArray.count == 3) {
                        viewThreeLineTwo.isHidden = true
                    } else if(tourGuideArray.count == 2) {
                        viewTwoLineTwo.isHidden = true
                    }
                    else if(tourGuideArray.count == 1) {
                        viewOneLineTwo.isHidden = true
                        pageViewOne.isHidden = true
                    }
                    if(tourGuideArray.count == 5) {
                        pageImageViewFive.image = UIImage(named: "stripper_inactive_end")
                        pageImageFiveHeight.constant = 15
                        pageImageFiveWidth.constant = 15
                    }
                    viewFiveLineTwo.isHidden = true
                }
            }
            
            return cell
        } else {
            let cell : PageControlCell = pageControlCollectionView.dequeueReusableCell(withReuseIdentifier: "pageControlCellId", for: indexPath) as! PageControlCell
            if(indexPath.row == 0) {
                cell.dotImageView.image = UIImage(named: "selectedControl")
                
            }
            if(reloaded) {
                if((currentPreviewItem != nil) && (currentPreviewItem.row == indexPath.row)) {
                    pageControlCollectionView.scrollToItem(at: currentPreviewItem, at: .right, animated: false)
                    let cell : PageControlCell = pageControlCollectionView.dequeueReusableCell(withReuseIdentifier: "pageControlCellId", for: currentPreviewItem) as! PageControlCell
                    cell.dotImageView.image = UIImage(named: "selectedControl")
                    return cell
                } else {
                    let cell : PageControlCell = pageControlCollectionView.dequeueReusableCell(withReuseIdentifier: "pageControlCellId", for: currentPreviewItem) as! PageControlCell
                    cell.dotImageView.image = UIImage(named: "unselected")
                    return cell
                }
            }
            
            
            return cell
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let objectDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "objectDetailId") as! ObjectDetailViewController
        objectDetailView.detailArray.append(tourGuideArray[indexPath.row])
//        let transition = CATransition()
//        transition.duration = 0.3
//        transition.type = kCATransitionFade
//        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
//        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(objectDetailView, animated: false, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightValue = UIScreen.main.bounds.height/100
        if (collectionView == previewCllectionView) {
            return CGSize(width: previewCllectionView.frame.width, height: previewCllectionView.frame.height)
        } else {
            return CGSize(width: pageControlCollectionView.frame.width/CGFloat(5), height: 60
                
            )
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        
       // let pageWidth1 = scrollView.frame.size.width;
       // let page = floor((scrollView.contentOffset.x - pageWidth1 / 2) / pageWidth1) + 1;
        
    
       
        
        
        
        print(scrollView.contentOffset)
        
        targetContentOffset.pointee = scrollView.contentOffset
        let pageWidth:Float = Float(self.view.bounds.width)
        let minSpace:Float = 10.0
        var cellToSwipe:Double = Double(Float((scrollView.contentOffset.x))/Float((pageWidth+minSpace))) + Double(0.5)
        
       // var cellToSwipe:Double = Double(Float((scrollView.contentOffset.x))/(Float((pageWidth+minSpace)) * tourGuideArray.count))  + Double(0.5)

        if cellToSwipe < 0 {
            cellToSwipe = 0
        } else if cellToSwipe >= Double(tourGuideArray.count) {
            cellToSwipe = Double(tourGuideArray.count) - Double(1)
        }
        let indexPath:IndexPath = IndexPath(row: Int(cellToSwipe), section:0)
        self.previewCllectionView.scrollToItem(at:indexPath, at: UICollectionViewScrollPosition.left, animated: true)
       // self.previewCllectionView.scrollToItem(at:indexPath, at: UICollectionViewScrollPosition.right, animated: true)
        currentPreviewItem = indexPath
        pageControlCollectionView.reloadData()
        reloaded = true
       var remainingCount = Int()
        if(indexPath.row%5 == 0) {
            //setPageViewVisible()
            
            pageImageViewOne.image = UIImage(named: "selectedControl")
            pageImageViewTwo.image = UIImage(named: "unselected")
            pageImageViewThree.image = UIImage(named: "unselected")
            pageImageViewFour.image = UIImage(named: "unselected")
            pageImageViewFive.image = UIImage(named: "unselected")
            remainingCount = tourGuideArray.count - ( indexPath.row+1)
            if(velocity.x >= 0) {
                
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
                
            }else  {
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
            if(indexPath.row == 0) {
                viewOneLineOne.isHidden = true
            } else {
                viewOneLineOne.isHidden = false
                pageImageOneHeight.constant = 20
                pageImageOneWidth.constant = 20
                
            }
            
            
        } else if(indexPath.row%5 == 1) {
        
            if(indexPath.row == 1) {
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
        } else if(indexPath.row%5 == 2) {
            pageImageThreeHeight.constant = 20
            pageImageThreeWidth.constant = 20
            //pageImageViewOne.image = UIImage(named: "stripper_inactive_end")
            pageImageViewTwo.image = UIImage(named: "unselected")
            pageImageViewThree.image = UIImage(named: "selectedControl")
            pageImageViewFour.image = UIImage(named: "unselected")
            pageImageViewFive.image = UIImage(named: "unselected")
        } else if(indexPath.row%5 == 3) {
            pageImageFourHeight.constant = 20
            pageImageFourWidth.constant = 20
            //setPageViewVisible()
           // pageImageViewOne.image = UIImage(named: "stripper_inactive_end")
            pageImageViewTwo.image = UIImage(named: "unselected")
            pageImageViewThree.image = UIImage(named: "unselected")
            pageImageViewFour.image = UIImage(named: "selectedControl")
            pageImageViewFive.image = UIImage(named: "unselected")
        }
        else if(indexPath.row%5 == 4) {
            if(velocity.x >= 0) {
               let remnCount = tourGuideArray.count - ( indexPath.row+1)
                if(remnCount <= 0) {
                    viewFiveLineTwo.isHidden = true
                }
            } else {
                setPageViewVisible()
                if(indexPath.row == 4) {
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
            //setPageViewVisible()
           // pageImageViewOne.image = UIImage(named: "stripper_inactive_end")
            pageImageViewTwo.image = UIImage(named: "unselected")
            pageImageViewThree.image = UIImage(named: "unselected")
            pageImageViewFour.image = UIImage(named: "unselected")
            pageImageViewFive.image = UIImage(named: "selectedControl")
        }
 
        if(indexPath.row == 0) {
            viewOneLineOne.isHidden = true
            pageImageOneHeight.constant = 20
            pageImageOneWidth.constant = 20
        }
        
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
 
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    func filterButtonPressed() {
       
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        let floorMapView =  self.storyboard?.instantiateViewController(withIdentifier: "floorMapId") as! FloorMapViewController
        floorMapView.fromScienceTour = true
        self.present(floorMapView, animated: false, completion: nil)
    }
    //MARK: WebServiceCall
    func getTourGuideDataFromServer()
    {
        
        _ = Alamofire.request(QatarMuseumRouter.CollectionByTourGuide(["tour_guide_id": "12216"])).responseObject { (response: DataResponse<TourGuideFloorMaps>) -> Void in
            switch response.result {
            case .success(let data):
                self.tourGuideArray = data.tourGuideFloorMap
                //self.saveOrUpdateHeritageCoredata()
                self.previewCllectionView.reloadData()
                self.pageControlCollectionView.reloadData()
                self.loadingView.stopLoading()
                self.loadingView.isHidden = true
                self.showOrHidePageControlView(countValue: self.tourGuideArray.count, scrolling: false)
                if (self.tourGuideArray.count == 0) {
                    self.loadingView.stopLoading()
                    self.loadingView.noDataView.isHidden = false
                    self.loadingView.isHidden = false
                    self.loadingView.showNoDataView()
                }
            case .failure(let error):
                
                
                    self.loadingView.stopLoading()
                    self.loadingView.noDataView.isHidden = false
                    self.loadingView.isHidden = false
                    self.loadingView.showNoDataView()
                

            }
        }
    }
    

}

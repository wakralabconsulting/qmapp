//
//  PreviewPageViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 13/09/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import Alamofire
import UIKit

class PreviewPageViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HeaderViewProtocol {
   
    
    var pageIndex: Int = 0
    var strTitle: String!
    var strPhotoName: String!
    
    @IBOutlet weak var headerView: CommonHeaderView!
    @IBOutlet weak var previewCllectionView: UICollectionView!
    @IBOutlet weak var pageControlCollectionView: UICollectionView!


    var currentPreviewItem = IndexPath()
    let pageCount: Int? = 6
    var reloaded: Bool = false
    var tourGuideArray: [TourGuideFloorMap]! = []
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        registerNib()
        getTourGuideDataFromServer()
        
    }
    func loadUI() {
        headerView.headerViewDelegate = self
        headerView.settingsButton.isHidden = false
        headerView.settingsButton.setImage(UIImage(named: "locationImg"), for: .normal)
        headerView.settingsButton.contentEdgeInsets = UIEdgeInsets(top: 9, left: 10, bottom:9, right: 10)
        
        //pageImageViewOne.image = UIImage(named: "selectedControl")
        //For TimelineView
       // showOrHidePageControlView(countValue: pageCount)
        
    }
    /*
    func showOrHidePageControlView(countValue: Int?) {
        if countValue == 0 {
            pageViewOne.isHidden = true
            pageViewTwo.isHidden = true
            pageViewThree.isHidden = true
            pageViewFour.isHidden = true
            
            pageImageViewOne.isHidden = true
            pageImageViewTwo.isHidden = true
            pageImageViewThree.isHidden = true
            pageImageViewFour.isHidden = true
            
            lineViewOne.isHidden = true
            lineViewTwo.isHidden = true
            lineViewThree.isHidden = true
            lineViewFour.isHidden = true
        } else if countValue == 1 {
            pageViewOne.isHidden = false
            pageViewTwo.isHidden = true
            pageViewThree.isHidden = true
            pageViewFour.isHidden = true
            
            pageImageViewOne.isHidden = false
            pageImageViewTwo.isHidden = true
            pageImageViewThree.isHidden = true
            pageImageViewFour.isHidden = true
            
            lineViewOne.isHidden = false
            lineViewTwo.isHidden = true
            lineViewThree.isHidden = true
            lineViewFour.isHidden = true
        } else if countValue == 2 {
            pageViewOne.isHidden = false
            pageViewTwo.isHidden = false
            pageViewThree.isHidden = true
            pageViewFour.isHidden = true
            
            pageImageViewOne.isHidden = false
            pageImageViewTwo.isHidden = false
            pageImageViewThree.isHidden = true
            pageImageViewFour.isHidden = true
            
            lineViewOne.isHidden = false
            lineViewTwo.isHidden = false
            lineViewThree.isHidden = true
            lineViewFour.isHidden = true
        }
        else if countValue == 3 {
            pageViewOne.isHidden = false
            pageViewTwo.isHidden = false
            pageViewThree.isHidden = false
            pageViewFour.isHidden = true
            
            pageImageViewOne.isHidden = false
            pageImageViewTwo.isHidden = false
            pageImageViewThree.isHidden = false
            pageImageViewFour.isHidden = true
            
            lineViewOne.isHidden = false
            lineViewTwo.isHidden = false
            lineViewThree.isHidden = false
            lineViewFour.isHidden = true
        }
        else {
            pageViewOne.isHidden = false
            pageViewTwo.isHidden = false
            pageViewThree.isHidden = false
            pageViewFour.isHidden = false
            
            pageImageViewOne.isHidden = false
            pageImageViewTwo.isHidden = false
            pageImageViewThree.isHidden = false
            pageImageViewFour.isHidden = false
            
            lineViewOne.isHidden = false
            lineViewTwo.isHidden = false
            lineViewThree.isHidden = false
            lineViewFour.isHidden = false
        }
    }
 */
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
            return tourGuideArray.count
        } else {
            return tourGuideArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == previewCllectionView) {
            let cell : PreviewCollectionViewCell = previewCllectionView.dequeueReusableCell(withReuseIdentifier: "previewCellId", for: indexPath) as! PreviewCollectionViewCell
            cell.setPreviewData(tourGuideData: tourGuideArray[indexPath.row])
           pageControlCollectionView.scrollToItem(at: indexPath, at: .right, animated: false)
           currentPreviewItem = indexPath
            
            
            return cell
        } else {
            let cell : PageControlCell = pageControlCollectionView.dequeueReusableCell(withReuseIdentifier: "pageControlCellId", for: indexPath) as! PageControlCell
            if(indexPath.row == 0) {
                cell.dotImageView.image = UIImage(named: "selectedControl")
            }
            if(reloaded) {
                if((currentPreviewItem != nil) && (currentPreviewItem.row == indexPath.row)) {
                    
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
            return CGSize(width: pageControlCollectionView.frame.width/CGFloat(tourGuideArray.count), height: 60
                
            )
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        let pageWidth:Float = Float(self.view.bounds.width)
        let minSpace:Float = 10.0
        var cellToSwipe:Double = Double(Float((scrollView.contentOffset.x))/Float((pageWidth+minSpace))) + Double(0.5)
        if cellToSwipe < 0 {
            cellToSwipe = 0
        } else if cellToSwipe >= Double(tourGuideArray.count) {
            cellToSwipe = Double(tourGuideArray.count) - Double(1)
        }
        let indexPath:IndexPath = IndexPath(row: Int(cellToSwipe), section:0)
        self.previewCllectionView.scrollToItem(at:indexPath, at: UICollectionViewScrollPosition.left, animated: true)
        currentPreviewItem = indexPath
        pageControlCollectionView.reloadData()
        reloaded = true
       /*
        if(indexPath.row%4 == 0) {
            //setPageViewVisible()
            let remainingCount = pageCount! - ( indexPath.row+1)
            if (remainingCount < 3) {
                //showOrHidePageControlView(countValue: remainingCount+1)
            }
            
            pageImageViewOne.image = UIImage(named: "selectedControl")
            pageImageViewTwo.image = UIImage(named: "unselected")
            pageImageViewThree.image = UIImage(named: "unselected")
            pageImageViewFour.image = UIImage(named: "unselected")
        } else if(indexPath.row%4 == 1) {
            //setPageViewVisible()
            pageImageViewOne.image = UIImage(named: "selectedControl")
            pageImageViewTwo.image = UIImage(named: "selectedControl")
            pageImageViewThree.image = UIImage(named: "unselected")
            pageImageViewFour.image = UIImage(named: "unselected")
        } else if(indexPath.row%4 == 2) {
            setPageViewVisible()
            pageImageViewOne.image = UIImage(named: "selectedControl")
            pageImageViewTwo.image = UIImage(named: "selectedControl")
            pageImageViewThree.image = UIImage(named: "selectedControl")
            pageImageViewFour.image = UIImage(named: "unselected")
        } else if(indexPath.row%4 == 3) {
            setPageViewVisible()
            pageImageViewOne.image = UIImage(named: "selectedControl")
            pageImageViewTwo.image = UIImage(named: "selectedControl")
            pageImageViewThree.image = UIImage(named: "selectedControl")
            pageImageViewFour.image = UIImage(named: "selectedControl")
        }
        if (indexPath.row == pageCount!-1) {

           // showOrHidePageControlView(countValue: (indexPath.row%4)+1)
        }
 */
        
    }
    /*
    func setPageViewVisible() {
        pageViewOne.isHidden = false
        pageViewTwo.isHidden = false
        pageViewThree.isHidden = false
        pageViewFour.isHidden = false
        
        pageImageViewOne.isHidden = false
        pageImageViewTwo.isHidden = false
        pageImageViewThree.isHidden = false
        pageImageViewFour.isHidden = false
        
        lineViewOne.isHidden = false
        lineViewTwo.isHidden = false
        lineViewThree.isHidden = false
        lineViewFour.isHidden = false
    }
 */
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
                //self.loadingView.stopLoading()
                //self.loadingView.isHidden = true
                if (self.tourGuideArray.count == 0) {
                    //self.loadingView.stopLoading()
                    //self.loadingView.noDataView.isHidden = false
                    //self.loadingView.isHidden = false
                    //self.loadingView.showNoDataView()
                }
            case .failure(let error):
                if let unhandledError = handleError(viewController: self, errorType: error as! BackendError) {
                    var errorMessage: String
                    var errorTitle: String
                    switch unhandledError.code {
                    default: print(unhandledError.code)
                    errorTitle = String(format: NSLocalizedString("UNKNOWN_ERROR_ALERT_TITLE",
                                                                  comment: "Setting the title of the alert"))
                    errorMessage = String(format: NSLocalizedString("ERROR_MESSAGE",
                                                                    comment: "Setting the content of the alert"))
                    }
                    presentAlert(self, title: errorTitle, message: errorMessage)
                }
            }
        }
    }
    

}

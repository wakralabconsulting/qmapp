//
//  MiaTourGuideViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 17/07/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Alamofire
import Crashlytics
import UIKit

class MiaTourGuideViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,HeaderViewProtocol,comingSoonPopUpProtocol,UICollectionViewDelegateFlowLayout,MiaTourProtocol {
    @IBOutlet weak var miaTourCollectionView: UICollectionView!
    @IBOutlet weak var topbarView: CommonHeaderView!
    
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
 
    let networkReachability = NetworkReachabilityManager()
    var museumId :String = "63"
    var miaTourDataFullArray: [TourGuide] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        registerNib()
    }

    func setUpUI() {
//        loadingView.isHidden = false
//        loadingView.loadingViewDelegate = self
//        loadingView.showLoading()
        if  (networkReachability?.isReachable)! {
            getTourGuideDataFromServer()
        } else {
            
        }
        
        topbarView.headerViewDelegate = self
        topbarView.headerTitle.isHidden = true
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            topbarView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        } else {
            topbarView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func registerNib() {
        let nib = UINib(nibName: "HomeCollectionCell", bundle: nil)
        miaTourCollectionView?.register(nib, forCellWithReuseIdentifier: "homeCellId")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return miaTourDataFullArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : HomeCollectionViewCell = miaTourCollectionView.dequeueReusableCell(withReuseIdentifier: "homeCellId", for: indexPath) as! HomeCollectionViewCell
        cell.setScienceTourGuideCellData(homeCellData: miaTourDataFullArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        loadMiaTourDetail(currentRow: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightValue = UIScreen.main.bounds.height/100
        return CGSize(width: miaTourCollectionView.frame.width, height: heightValue*27)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let miaTourHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "miaTourHeader", for: indexPath) as! MiaCollectionReusableView
        miaTourHeaderView.miaTourDelegate = self
        return miaTourHeaderView
    }

    func loadMiaTourDetail(currentRow: Int?) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        
        let miaView =  self.storyboard?.instantiateViewController(withIdentifier: "miaDetailId") as! MiaTourDetailViewController
        if (miaTourDataFullArray != nil) {
            miaView.tourGuideDetail = miaTourDataFullArray[currentRow!]
        }
        self.present(miaView, animated: false, completion: nil)
    }
    func loadComingSoonPopup() {
        popupView  = ComingSoonPopUp(frame: self.view.frame)
        popupView.comingSoonPopupDelegate = self
        popupView.loadTourGuidePopup()
        self.view.addSubview(popupView)
        
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
    
    //MARK: Mia Tour Guide Delegate
    func exploreButtonTapAction(miaHeader: MiaCollectionReusableView) {
        var searchstring = String()
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            searchstring = "12476"
        } else {
            searchstring = "12476"
        }
        let miaView =  self.storyboard?.instantiateViewController(withIdentifier: "miaDetailId") as! MiaTourDetailViewController
        
        if (miaTourDataFullArray != nil) {
            if let arrayOffset = miaTourDataFullArray.index(where: {$0.nid == searchstring}) {
                miaView.tourGuideDetail = miaTourDataFullArray[arrayOffset]
                let transition = CATransition()
                transition.duration = 0.3
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromRight
                view.window!.layer.add(transition, forKey: kCATransition)
                self.present(miaView, animated: false, completion: nil)
            }
            
        }
        
    }
    //MARK: WebServiceCall
    func getTourGuideDataFromServer() {
        _ = Alamofire.request(QatarMuseumRouter.MuseumTourGuide(["museum_id": museumId])).responseObject { (response: DataResponse<TourGuides>) -> Void in
            switch response.result {
            case .success(let data):
                self.miaTourDataFullArray = data.tourGuide!
                //self.loadingView.stopLoading()
                //self.loadingView.isHidden = true
                self.miaTourCollectionView.reloadData()
            case .failure(let error):
                var errorMessage: String
                errorMessage = String(format: NSLocalizedString("NO_RESULT_MESSAGE",
                                                                comment: "Setting the content of the alert"))
                print(error)
//                self.loadingView.stopLoading()
//                self.loadingView.noDataView.isHidden = false
//                self.loadingView.isHidden = false
//                self.loadingView.showNoDataView()
//                self.loadingView.noDataLabel.text = errorMessage
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

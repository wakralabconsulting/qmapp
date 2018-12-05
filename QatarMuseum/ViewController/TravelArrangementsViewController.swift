//
//  TravelArrangementsViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 28/11/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import Alamofire
import UIKit

class TravelArrangementsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HeaderViewProtocol {
    
    

    @IBOutlet weak var travelHeaderView: CommonHeaderView!
    @IBOutlet weak var travelCollectionView: UICollectionView!
    @IBOutlet weak var loadingView: LoadingView!
    var travelList: [HomeBanner]! = []
    let networkReachability = NetworkReachabilityManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
    func setUI() {
        loadingView.isHidden = false
        loadingView.showLoading()
        
         travelHeaderView.headerViewDelegate = self
        
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            travelHeaderView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        } else {
            travelHeaderView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
            travelHeaderView.headerTitle.text = NSLocalizedString("TRAVEL_ARRANGEMENTS", comment: "TRAVEL_ARRANGEMENTS Label in the Travel page page").uppercased()
        registerNib()
        if (networkReachability?.isReachable)! {
            getTravelList()
        } else {
            
        }
    }
    func registerNib() {
            let nib = UINib(nibName: "TravelCell", bundle: nil)
            travelCollectionView?.register(nib, forCellWithReuseIdentifier: "travelCellId")
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return travelList.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        loadingView.stopLoading()
        loadingView.isHidden = true
        let travelCell : TravelCollectionViewCell = travelCollectionView.dequeueReusableCell(withReuseIdentifier: "travelCellId", for: indexPath) as! TravelCollectionViewCell
        travelCell.setTravelListData(travelListData: travelList[indexPath.row])
            return travelCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: travelCollectionView.frame.width, height: self.travelCollectionView.frame.height/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        loadDetailPage(selectedIndex: indexPath.row)
    }

    func loadDetailPage(selectedIndex: Int) {
        let detailStoryboard: UIStoryboard = UIStoryboard(name: "DetailPageStoryboard", bundle: nil)
        
        let museumAboutView = detailStoryboard.instantiateViewController(withIdentifier: "heritageDetailViewId2") as! MuseumAboutViewController
        museumAboutView.pageNameString = PageName2.museumTravel
        museumAboutView.travelImage = travelList[selectedIndex].bannerLink
        museumAboutView.travelTitle = travelList[selectedIndex].title
        museumAboutView.travelDetail = travelList[selectedIndex]
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(museumAboutView, animated: false, completion: nil)
    }
    
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    //MARK: Service Call
    func getTravelList() {
        _ = Alamofire.request(QatarMuseumRouter.GetNMoQTravelList()).responseObject { (response: DataResponse<HomeBannerList>) -> Void in
            switch response.result {
            case .success(let data):
                self.travelList = data.homeBannerList
                self.travelCollectionView.reloadData()
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 

}

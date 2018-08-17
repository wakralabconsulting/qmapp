//
//  MuseumCollectionsViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 22/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit
import Alamofire

class MuseumCollectionsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HeaderViewProtocol,comingSoonPopUpProtocol {
    @IBOutlet weak var museumCollectionView: UICollectionView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var collectionsHeader: CommonHeaderView!

    var popupView : ComingSoonPopUp = ComingSoonPopUp()
    var collection: [Collection] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        registerNib()
        getCollectionList()
    }
    
    func setUpUI() {
        loadingView.isHidden = false
        loadingView.showLoading()
        
        collectionsHeader.headerViewDelegate = self
        collectionsHeader.headerTitle.text = NSLocalizedString("COLLECTIONS_TITLE", comment: "COLLECTIONS_TITLE Label in the collections page")

        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            collectionsHeader.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        } else {
            collectionsHeader.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Webservice call
    func getCollectionList() {
        _ = Alamofire.request(QatarMuseumRouter.CollectionList(["museum_id": 63])).responseObject { (response: DataResponse<Collections>) -> Void in
            switch response.result {
            case .success(let data):
                self.collection = data.collections!
                self.museumCollectionView.reloadData()
                self.loadingView.stopLoading()
                self.loadingView.isHidden = true
                if (self.collection.count == 0) {
                    self.loadingView.stopLoading()
                    self.loadingView.noDataView.isHidden = false
                    self.loadingView.isHidden = false
                    self.loadingView.showNoDataView()
                }
            case .failure( _):
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
    
    func registerNib() {
        let nib = UINib(nibName: "HeritageCell", bundle: nil)
        museumCollectionView?.register(nib, forCellWithReuseIdentifier: "heritageCellId")
    }
    
    //MARK: CollectionView Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return collection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionsCell : HeritageCollectionCell = museumCollectionView.dequeueReusableCell(withReuseIdentifier: "heritageCellId", for: indexPath) as! HeritageCollectionCell
        collectionsCell.setCollectionsCellValues(collectionList: collection[indexPath.row])
        loadingView.stopLoading()
        loadingView.isHidden = true
        return collectionsCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightValue = UIScreen.main.bounds.height/100
        return CGSize(width: museumCollectionView.frame.width, height: heightValue*27)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            loadCollectionDetail()
        } else {
            addComingSoonPopup()
        }
    }
    
    func loadCollectionDetail() {
        let collectionDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "collectionDetailId") as! CollectionDetailViewController
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(collectionDetailView, animated: false, completion: nil)
    }
    
    func addComingSoonPopup() {
        let viewFrame : CGRect = self.view.frame
         popupView.comingSoonPopupDelegate = self
        popupView.frame = viewFrame
        popupView.loadPopup()
        self.view.addSubview(popupView)
    }
 
    //MARK: HeaderView Delegates
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK: ComingSoon Delegate
    func closeButtonPressed() {
        self.popupView.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

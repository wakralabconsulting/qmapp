//
//  MuseumCollectionsViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 22/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class MuseumCollectionsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HeaderViewProtocol,comingSoonPopUpProtocol {
    
    
    
    
    

    @IBOutlet weak var museumCollectionView: UICollectionView!
    
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var collectionsHeader: CommonHeaderView!
    var collectionsArray : NSArray!
    var collectionsImgArray = NSArray()
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        getCollectionsDataFromJson()
        registerNib()
        
    }
    func setUpUI() {
        loadingView.isHidden = false
        loadingView.showLoading()
        collectionsHeader.headerViewDelegate = self
        collectionsHeader.headerTitle.text = NSLocalizedString("COLLECTIONS_TITLE", comment: "COLLECTIONS_TITLE Label in the collections page")

        collectionsImgArray = ["ceramic_collection","glass_collection","the_cavour_case","gold_and_class","mosque_lamp"]
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            
            collectionsHeader.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        }
        else {
            collectionsHeader.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK: Service call
    func getCollectionsDataFromJson(){
        let url = Bundle.main.url(forResource: "CollectionsJson", withExtension: "json")
        
        let dataObject = NSData(contentsOf: url!)
        if let jsonObj = try? JSONSerialization.jsonObject(with: dataObject! as Data, options: .allowFragments) as? NSDictionary {
            
            collectionsArray = jsonObj!.value(forKey: "items")
                as! NSArray
        }
    }
    func registerNib() {
        let nib = UINib(nibName: "HeritageCell", bundle: nil)
        museumCollectionView?.register(nib, forCellWithReuseIdentifier: "heritageCellId")
    }
    //MARK: CollectionView Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return collectionsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionsCell : HeritageCollectionCell = museumCollectionView.dequeueReusableCell(withReuseIdentifier: "heritageCellId", for: indexPath) as! HeritageCollectionCell
        let publicArtsDataDict = collectionsArray.object(at: indexPath.row) as! NSDictionary
        collectionsCell.setCollectionsCellValues(cellValues: publicArtsDataDict, imageName: collectionsImgArray.object(at: indexPath.row) as! String)
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
        }
        else {
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

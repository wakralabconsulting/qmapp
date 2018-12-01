//
//  TravelArrangementsViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 28/11/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import UIKit

class TravelArrangementsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HeaderViewProtocol {
    
    

    @IBOutlet weak var travelHeaderView: CommonHeaderView!
    @IBOutlet weak var travelCollectionView: UICollectionView!
    @IBOutlet weak var loadingView: LoadingView!
    var panelDiscussionTitle = String()
    var travelImgArray = NSArray()
    var travelTitleArray = NSArray()
    
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
            travelImgArray = ["qatar_airways_bg","katara_bg"]
            travelTitleArray = ["Qatar Airways","Katara Hospitality"]
        
        registerNib()
    }
    func registerNib() {
            let nib = UINib(nibName: "TravelCell", bundle: nil)
            travelCollectionView?.register(nib, forCellWithReuseIdentifier: "travelCellId")
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        loadingView.stopLoading()
        loadingView.isHidden = true
            let travelCell : TravelCollectionViewCell = travelCollectionView.dequeueReusableCell(withReuseIdentifier: "travelCellId", for: indexPath) as! TravelCollectionViewCell
            travelCell.titleLabel.text = travelTitleArray[indexPath.row] as! String
            travelCell.imageView.image = UIImage(named: travelImgArray[indexPath.row] as! String)
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
        
        let heritageDtlView = detailStoryboard.instantiateViewController(withIdentifier: "heritageDetailViewId2") as! MuseumAboutViewController
        heritageDtlView.pageNameString = PageName2.museumTravel
        heritageDtlView.travelImage = travelImgArray[selectedIndex] as! String
        heritageDtlView.travelTitle = travelTitleArray[selectedIndex] as! String
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(heritageDtlView, animated: false, completion: nil)
    }
    
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 

}

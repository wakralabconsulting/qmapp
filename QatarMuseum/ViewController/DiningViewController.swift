//
//  DiningViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 29/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class DiningViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, HeaderViewProtocol,comingSoonPopUpProtocol {
    
    
    @IBOutlet weak var diningHeader: CommonHeaderView!
    @IBOutlet weak var diningCollectionView: UICollectionView!
    
    //@IBOutlet weak var loadingView: LoadingView!
    var diningListArray : NSArray!
    var diningListImageArray = NSArray()
    var popUpView : ComingSoonPopUp = ComingSoonPopUp()
    var fromHome : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDiningArtsUi()
        setDiningDataFromJson()
        registerNib()
        
    }
    func setupDiningArtsUi() {
        //loadingView.isHidden = false
        //loadingView.showLoading()
        diningListImageArray = ["idam","in_q_cafe","mia_cafe","al_reward_cafe","mia_catering","mathaf_maqha","cafe_#999"];
        diningHeader.headerViewDelegate = self
        diningHeader.headerTitle.text = NSLocalizedString("DINING_TITLE", comment: "DINING_TITLE in the Dining page")
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            
            diningHeader.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        }
        else {
            diningHeader.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }

    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK: Service call
    func setDiningDataFromJson(){
        let url = Bundle.main.url(forResource: "DiningJson", withExtension: "json")
        
        let dataObject = NSData(contentsOf: url!)
        if let jsonObj = try? JSONSerialization.jsonObject(with: dataObject! as Data, options: .allowFragments) as? NSDictionary {
            
            diningListArray = jsonObj!.value(forKey: "items")
                as! NSArray
        }
    }
    func registerNib() {
        let nib = UINib(nibName: "HeritageCell", bundle: nil)
        diningCollectionView?.register(nib, forCellWithReuseIdentifier: "heritageCellId")
    }
    //MARK: collectionView Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diningListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let publicArtsCell : HeritageCollectionCell = diningCollectionView.dequeueReusableCell(withReuseIdentifier: "heritageCellId", for: indexPath) as! HeritageCollectionCell
        let publicArtsDataDict = diningListArray.object(at: indexPath.row) as! NSDictionary
        publicArtsCell.setPublicArtsListCellValues(cellValues: publicArtsDataDict, imageName: diningListImageArray.object(at: indexPath.row) as! String)
//        loadingView.stopLoading()
//        loadingView.isHidden = true
        return publicArtsCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightValue = UIScreen.main.bounds.height/100
        return CGSize(width: diningCollectionView.frame.width+10, height: heightValue*27)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            loadDiningDetailAnimation()
        }
        else {
            loadComingSoonPopup()
        }
        
    }
    func loadComingSoonPopup() {
        popUpView  = ComingSoonPopUp(frame: self.view.frame)
        popUpView.comingSoonPopupDelegate = self
        popUpView.loadPopup()
        self.view.addSubview(popUpView)
        
    }
    //MARk: ComingSoonPopUp Delegates
    func closeButtonPressed() {
        self.popUpView.removeFromSuperview()
    }
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        if (fromHome == true) {
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "homeId") as! HomeViewController
            
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = homeViewController
        }
        else {
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    func loadDiningDetailAnimation() {
        let diningDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "diningDetailId") as! DiningDetailViewController
       
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(diningDetailView, animated: false, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}

//
//  HeritageListViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 21/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class HeritageListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HeaderViewProtocol,comingSoonPopUpProtocol {
    
    
    
    
    @IBOutlet weak var heritageHeader: CommonHeaderView!
    
    @IBOutlet weak var heritageCollectionView: UICollectionView!
    @IBOutlet weak var loadingView: LoadingView!
    
    var heritageListArray : NSArray!
    var heritageListImageArray = NSArray()
    var popUpView : ComingSoonPopUp = ComingSoonPopUp()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getheritageDataFromJson()
        registerNib()
        
    }
    func setupUI() {
        loadingView.isHidden = false
        loadingView.showLoading()
        heritageListImageArray = ["al_zubarah","tower_of_qatar","forts_of_qatar","wells_of_qatar"];
        heritageHeader.headerViewDelegate = self
        heritageHeader.headerTitle.text = "HERITAGE SITES"
    }
    func registerNib() {
        let nib = UINib(nibName: "HeritageCell", bundle: nil)
        heritageCollectionView?.register(nib, forCellWithReuseIdentifier: "heritageCellId")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK: Service call
    func getheritageDataFromJson(){
        let url = Bundle.main.url(forResource: "HeritageListJson", withExtension: "json")
        
        let dataObject = NSData(contentsOf: url!)
        if let jsonObj = try? JSONSerialization.jsonObject(with: dataObject! as Data, options: .allowFragments) as? NSDictionary {
            
            heritageListArray = jsonObj!.value(forKey: "items")
                as! NSArray
        }
    }
    //MARK: collectionview delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heritageListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let heritageCell : HeritageCollectionCell = heritageCollectionView.dequeueReusableCell(withReuseIdentifier: "heritageCellId", for: indexPath) as! HeritageCollectionCell
        let heritageDataDict = heritageListArray.object(at: indexPath.row) as! NSDictionary
        heritageCell.setHeritageListCellValues(cellValues: heritageDataDict, imageName: heritageListImageArray.object(at: indexPath.row) as! String)
        loadingView.stopLoading()
        loadingView.isHidden = true
        return heritageCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightValue = UIScreen.main.bounds.height/100
        return CGSize(width: heritageCollectionView.frame.width, height: heightValue*27)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            loadHeritageDetailAnimation()
        }
        else {
            loadComingSoonPopup()
        }
        
    }
    func loadComingSoonPopup() {
        popUpView  = ComingSoonPopUp(frame: self.view.frame)
        popUpView.comingSoonPopupDelegate = self
        self.view.addSubview(popUpView)
        
    }
    //MARk: ComingSoonPopUp Delegates
    func closeButtonPressed() {
        self.popUpView.removeFromSuperview()
    }
    func loadHeritageDetailAnimation() {
        let heritageDtlView = self.storyboard?.instantiateViewController(withIdentifier: "heritageDetailViewId") as! HeritageDetailViewController
        heritageDtlView.pageNameString = PageName.heritageDetail
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(heritageDtlView, animated: false, completion: nil)
        
        
    }
    //MARK: Header delegates
    func headerCloseButtonPressed() {
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "homeId") as! HomeViewController
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = homeViewController
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}

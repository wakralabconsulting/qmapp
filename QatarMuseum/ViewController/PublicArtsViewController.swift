//
//  PublicArtsViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 22/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class PublicArtsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HeaderViewProtocol,comingSoonPopUpProtocol {
    
    
    @IBOutlet weak var pulicArtsHeader: CommonHeaderView!
    @IBOutlet weak var publicArtsCollectionView: UICollectionView!
    
    @IBOutlet weak var loadingView: LoadingView!
    var publicArtsListArray : NSArray!
    var publicArtsListImageArray = NSArray()
    var popUpView : ComingSoonPopUp = ComingSoonPopUp()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPublicArtsUi()
        getPublicArtsDataFromJson()
        registerNib() 
        
    }

    func setupPublicArtsUi() {
        loadingView.isHidden = false
        loadingView.showLoading()
        publicArtsListImageArray = ["gandhi's_three_monkeys","7_by_richard_serra","lusail_handball_installation","smokey_by_tony_smith","qatar_univercity_installation","airport_installation","east_west-west_east_by_richard_serra","the_miraculas_journey","calligrafiti_by_el_seed","maman","perceval","healthy_living_from_the_start"];
        pulicArtsHeader.headerViewDelegate = self
        pulicArtsHeader.headerTitle.text = NSLocalizedString("PUBLIC_ARTS_TITLE", comment: "PUBLIC_ARTS_TITLE Label in the PublicArts page")

    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK: Service call
    func getPublicArtsDataFromJson(){
        let url = Bundle.main.url(forResource: "PublicArtsListJson", withExtension: "json")
        
        let dataObject = NSData(contentsOf: url!)
        if let jsonObj = try? JSONSerialization.jsonObject(with: dataObject! as Data, options: .allowFragments) as? NSDictionary {
            
            publicArtsListArray = jsonObj!.value(forKey: "items")
                as! NSArray
        }
    }
    func registerNib() {
        let nib = UINib(nibName: "HeritageCell", bundle: nil)
        publicArtsCollectionView?.register(nib, forCellWithReuseIdentifier: "heritageCellId")
    }
    //MARK: collectionView Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return publicArtsListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let publicArtsCell : HeritageCollectionCell = publicArtsCollectionView.dequeueReusableCell(withReuseIdentifier: "heritageCellId", for: indexPath) as! HeritageCollectionCell
        let publicArtsDataDict = publicArtsListArray.object(at: indexPath.row) as! NSDictionary
        publicArtsCell.setPublicArtsListCellValues(cellValues: publicArtsDataDict, imageName: publicArtsListImageArray.object(at: indexPath.row) as! String)
        loadingView.stopLoading()
        loadingView.isHidden = true
        return publicArtsCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightValue = UIScreen.main.bounds.height/100
        return CGSize(width: publicArtsCollectionView.frame.width, height: heightValue*27)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            loadPublicArtsDetailAnimation()
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
    func loadPublicArtsDetailAnimation() {
        let publicDtlView = self.storyboard?.instantiateViewController(withIdentifier: "heritageDetailViewId") as! HeritageDetailViewController
        publicDtlView.pageNameString = PageName.publicArtsDetail
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(publicDtlView, animated: false, completion: nil)
        
        
    }
    //MARK: Header delegate
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

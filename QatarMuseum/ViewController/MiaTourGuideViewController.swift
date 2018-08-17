//
//  MiaTourGuideViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 17/07/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class MiaTourGuideViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,HeaderViewProtocol,comingSoonPopUpProtocol,UICollectionViewDelegateFlowLayout,MiaTourProtocol {
    @IBOutlet weak var miaTourCollectionView: UICollectionView!
    @IBOutlet weak var topbarView: CommonHeaderView!
    
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
    var miaTourImageArray = NSArray()
    var miaTourDataFullArray : NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        registerNib()
        getMiaTourGuideDataFromJson()
    }

    func setUpUI() {
        miaTourImageArray = ["science_tour","museum_of_islamic_art","coming_soon_1","coming_soon_2"];
        topbarView.headerViewDelegate = self
        topbarView.headerTitle.isHidden = true
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
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
    //MARK: Service call
    func getMiaTourGuideDataFromJson(){
        let url = Bundle.main.url(forResource: "MiaTourGuideJson", withExtension: "json")
        let dataObject = NSData(contentsOf: url!)
        if let jsonObj = try? JSONSerialization.jsonObject(with: dataObject! as Data, options: .allowFragments) as? NSDictionary {
            miaTourDataFullArray = jsonObj!.value(forKey: "items")
                as! NSArray
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return miaTourDataFullArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : HomeCollectionViewCell = miaTourCollectionView.dequeueReusableCell(withReuseIdentifier: "homeCellId", for: indexPath) as! HomeCollectionViewCell
        let homeDataDict = miaTourDataFullArray.object(at: indexPath.row) as! NSDictionary
        cell.setTourGuideCellData(homeCellData: homeDataDict, imageName: miaTourImageArray.object(at: indexPath.row) as! String)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            loadMiaTourDetail()
        } else {
            loadComingSoonPopup()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightValue = UIScreen.main.bounds.height/100
        return CGSize(width: miaTourCollectionView.frame.width, height: heightValue*27)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let miaTourHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "miaTourHeader", for: indexPath) as! MiaCollectionReusableView
        miaTourHeaderView.miaTourDelegate = self
        miaTourHeaderView.miaTourGuideText.text = "Welcome to Qatar Museum Premises. \n Explore the architrcture and the objects on display. \n Scan the QR codes available on the galleries for more information."
        miaTourHeaderView.selfGuidedText.text = "You may also try our self guided tours. \n Immerse yourself into the journeys curated specially for you by our experts."
        
        return miaTourHeaderView
    }

    func loadMiaTourDetail() {
        let miaView =  self.storyboard?.instantiateViewController(withIdentifier: "miaDetailId") as! MiaTourDetailViewController
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(miaView, animated: false, completion: nil)
    }
    func loadComingSoonPopup() {
        popupView  = ComingSoonPopUp(frame: self.view.frame)
        popupView.comingSoonPopupDelegate = self
        popupView.loadPopup()
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
        let miaView =  self.storyboard?.instantiateViewController(withIdentifier: "miaExploreId") as! MiaTourGuideExploreViewController
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(miaView, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

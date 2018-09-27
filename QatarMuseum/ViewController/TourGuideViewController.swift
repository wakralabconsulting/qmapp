//
//  TourGuideViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 16/07/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Crashlytics
import UIKit

class TourGuideViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,HeaderViewProtocol,comingSoonPopUpProtocol,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var tourCollectionView: UICollectionView!
    @IBOutlet weak var topbarView: CommonHeaderView!
    
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
    var tourImageArray = NSArray()
    var tourDataFullArray : NSArray!
    var fromHome : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        registerNib()
        getTourGuideDataFromJson()
    }

    func setUpUI() {
        let imagName1 = NSLocalizedString("MUSEUM_TITLE", comment: "MUSEUM_TITLE  in the Tour Guide page")
        let imagName2 = NSLocalizedString("TOUR_GUIDE_IMG_NAME_2", comment: "TOUR_GUIDE_IMG_NAME_2  in the Tour Guide page")
        let imagName3 = NSLocalizedString("TOUR_GUIDE_IMG_NAME_3", comment: "TOUR_GUIDE_IMG_NAME_3  in the Tour Guide page")
        let imagName4 = NSLocalizedString("TOUR_GUIDE_IMG_NAME_4", comment: "TOUR_GUIDE_IMG_NAME_4  in the Tour Guide page")
        let imagName5 = NSLocalizedString("TOUR_GUIDE_IMG_NAME_5", comment: "TOUR_GUIDE_IMG_NAME_5  in the Tour Guide page")
        tourImageArray = ["museum_of_islamic_art","mathaf_arab_museum","firestation","coming_soon_1","national_museum_of_qatar"];
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
        tourCollectionView?.register(nib, forCellWithReuseIdentifier: "homeCellId")
        
        //tourCollectionView.registerClass(, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "tourHeader")
    }
    //MARK: Service call
    func getTourGuideDataFromJson(){
            let url = Bundle.main.url(forResource: "TourGuideJson", withExtension: "json")
            let dataObject = NSData(contentsOf: url!)
            if let jsonObj = try? JSONSerialization.jsonObject(with: dataObject! as Data, options: .allowFragments) as? NSDictionary {
                
                tourDataFullArray = jsonObj!.value(forKey: "items")
                    as! NSArray
            }
   
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tourDataFullArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : HomeCollectionViewCell = tourCollectionView.dequeueReusableCell(withReuseIdentifier: "homeCellId", for: indexPath) as! HomeCollectionViewCell
        let homeDataDict = tourDataFullArray.object(at: indexPath.row) as! NSDictionary
        cell.tourGuideImage.image = UIImage(named: "location")
        cell.setTourGuideCellData(homeCellData: homeDataDict, imageName: tourImageArray.object(at: indexPath.row) as! String)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            loadMiaTour() 
        } else {
            loadComingSoonPopup()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightValue = UIScreen.main.bounds.height/100
        return CGSize(width: tourCollectionView.frame.width, height: heightValue*27)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let tourHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "tourHeader", for: indexPath) as! TourGuideCollectionReusableView
        tourHeaderView.tourGuideTitle.text = NSLocalizedString("TOUR_GUIDES", comment: "TOUR_GUIDES  in the Tour Guide page")
        tourHeaderView.tourGuideText.text = NSLocalizedString("TOUR_GUIDE_TEXT", comment: "TOUR_GUIDE_TEXT  in the Tour Guide page")
        
        
        
        return tourHeaderView
    }
    func loadMiaTour() {
        let miaView =  self.storyboard?.instantiateViewController(withIdentifier: "miaTourGuideId") as! MiaTourGuideViewController
        
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
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "homeId") as! HomeViewController
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = homeViewController
       
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

 

}

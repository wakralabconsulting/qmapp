//
//  ExhibitionsViewController.swift
//  QatarMuseum
//
//  Created by Exalture on 10/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit
import Alamofire

enum ExhbitionPageName {
    case homeExhibition
    case museumExhibition
}
class ExhibitionsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HeaderViewProtocol,comingSoonPopUpProtocol {
    @IBOutlet weak var exhibitionHeaderView: CommonHeaderView!
    @IBOutlet weak var exhibitionCollectionView: UICollectionView!
    @IBOutlet weak var exbtnLoadingView: LoadingView!
    
    var exhibition: [Exhibition]! = []
    var museumExhibitionArray : NSArray!
    var museumExhibitionImageArray = NSArray()
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
    var exhibitionsPageNameString : ExhbitionPageName?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpExhibitionPageUi()
        registerNib()
        getExhibitionDataFromJson()
    }
    
    func setUpExhibitionPageUi() {
        exbtnLoadingView.isHidden = false
        exbtnLoadingView.showLoading()
         museumExhibitionImageArray = ["powder_and_damask","imperial_thread","driven_by_german_design","tamim_al_majd","dajar_women"];
         exhibitionHeaderView.headerViewDelegate = self
        //exhibitionHeaderView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        
        exhibitionHeaderView.headerTitle.text = NSLocalizedString("EXHIBITIONS_TITLE", comment: "EXHIBITIONS_TITLE Label in the Exhibitions page")
        
        popupView.comingSoonPopupDelegate = self
        
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            exhibitionHeaderView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        } else {
            exhibitionHeaderView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
      
    }
    
    func registerNib() {
        let nib = UINib(nibName: "ExhibitionsCellXib", bundle: nil)
        exhibitionCollectionView?.register(nib, forCellWithReuseIdentifier: "exhibitionCellId")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Service call
    func getExhibitionDataFromJson(){
        if (exhibitionsPageNameString == ExhbitionPageName.homeExhibition) {
            _ = Alamofire.request(QatarMuseumRouter.ExhibitionList()).responseObject { (response: DataResponse<Exhibitions>) -> Void in
                switch response.result {
                case .success(let data):
                    self.exhibition = data.exhibitions
                    self.exhibitionCollectionView.reloadData()
                case .failure(let error):
                    if let unhandledError = handleError(viewController: self, errorType: error as! BackendError) {
                        var errorMessage: String
                        var errorTitle: String
                        switch unhandledError.code {
                        default: print(unhandledError.code)
                            errorTitle = String(format: NSLocalizedString("UNKNOWN_ERROR_ALERT_TITLE",
                                                                          comment: "Setting the title of the alert"))
                            errorMessage = String(format: NSLocalizedString("ERROR_MESSAGE",
                                                                            comment: "Setting the content of the alert"))
                        }
                        presentAlert(self, title: errorTitle, message: errorMessage)
                    }
                }
            }
        } else {
            let url = Bundle.main.url(forResource: "MuseumExhibitionJson", withExtension: "json")
            let dataObject = NSData(contentsOf: url!)
            if let jsonObj = try? JSONSerialization.jsonObject(with: dataObject! as Data, options: .allowFragments) as? NSDictionary {
                
                museumExhibitionArray = jsonObj!.value(forKey: "items")
                    as! NSArray
            }
        }
    }
    
    //MARK: collectionview delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch exhibitionsPageNameString {
        case .homeExhibition?:
            return exhibition.count
        case .museumExhibition?:
            return museumExhibitionArray.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let exhibitionCell : ExhibitionsCollectionCell = exhibitionCollectionView.dequeueReusableCell(withReuseIdentifier: "exhibitionCellId", for: indexPath) as! ExhibitionsCollectionCell
        switch exhibitionsPageNameString {
        case .homeExhibition?:
            exhibitionCell.setExhibitionCellValues(exhibition: exhibition[indexPath.row])
            exhibitionCell.exhibitionCellItemBtnTapAction = {
                () in
                self.loadExhibitionCellPages(cellObj: exhibitionCell, selectedIndex: indexPath.row)
            }
        case .museumExhibition?:
            let exhibitionDataDict = museumExhibitionArray.object(at: indexPath.row) as! NSDictionary
            exhibitionCell.setMuseumExhibitionCellValues(cellValues: exhibitionDataDict, imageName: museumExhibitionImageArray.object(at: indexPath.row) as! String)
        default:
            break
        }
        
        exbtnLoadingView.stopLoading()
        exbtnLoadingView.isHidden = true
        return exhibitionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightValue = UIScreen.main.bounds.height/100
        return CGSize(width: exhibitionCollectionView.frame.width, height: heightValue*27)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // loadExhibitionDetail()
        if exhibitionsPageNameString == ExhbitionPageName.homeExhibition, let exhibitionId = exhibition[indexPath.row].id {
            loadExhibitionDetailAnimation(exhibitionId: exhibitionId)
        } else if exhibitionsPageNameString == ExhbitionPageName.museumExhibition && indexPath.row == 0 {
            loadExhibitionDetailAnimation(exhibitionId: "")
        } else {
            addComingSoonPopup()
        }
    }
    
    func loadExhibitionCellPages(cellObj: ExhibitionsCollectionCell, selectedIndex: Int) {
        
    }
    
    func addComingSoonPopup() {
        let viewFrame : CGRect = self.view.frame
        popupView.frame = viewFrame
        popupView.loadPopup()
        self.view.addSubview(popupView)
    }
    
    func loadExhibitionDetailAnimation(exhibitionId: String) {
        let exhibitionDtlView = self.storyboard?.instantiateViewController(withIdentifier: "exhibitionDtlId") as! ExhibitionDetailViewController
        if (exhibitionsPageNameString == ExhbitionPageName.homeExhibition) {
            exhibitionDtlView.fromHome = true
            exhibitionDtlView.id = exhibitionId
        } else {
            exhibitionDtlView.fromHome = false
        }
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(exhibitionDtlView, animated: false, completion: nil)
    }
 
    //MARK: Header delegate
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        switch exhibitionsPageNameString {
        case .homeExhibition?:
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "homeId") as! HomeViewController
            
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = homeViewController
        case .museumExhibition?:
            self.dismiss(animated: false, completion: nil)
        default:
            break
        }
    }

    func closeButtonPressed() {
        self.popupView.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

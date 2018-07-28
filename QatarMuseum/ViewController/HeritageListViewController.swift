//
//  HeritageListViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 21/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Alamofire
import UIKit

class HeritageListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HeaderViewProtocol,comingSoonPopUpProtocol {
    
    @IBOutlet weak var heritageHeader: CommonHeaderView!
    @IBOutlet weak var heritageCollectionView: UICollectionView!
    @IBOutlet weak var loadingView: LoadingView!

    var popUpView : ComingSoonPopUp = ComingSoonPopUp()
    var heritageListArray: [HeritageList]! = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getheritageDataFromServer()
        registerNib()
        
    }
    func setupUI() {
        loadingView.isHidden = false
        loadingView.showLoading()
        
        heritageHeader.headerViewDelegate = self
        heritageHeader.headerTitle.text = NSLocalizedString("HERITAGE_SITES_TITLE", comment: "HERITAGE_SITES_TITLE  in the Heritage page")
        heritageHeader.headerTitle.font = UIFont.headerFont
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            heritageHeader.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        }
        else {
            heritageHeader.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }

    }
    func registerNib() {
        let nib = UINib(nibName: "HeritageCell", bundle: nil)
        heritageCollectionView?.register(nib, forCellWithReuseIdentifier: "heritageCellId")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
   
    //MARK: collectionview delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heritageListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let heritageCell : HeritageCollectionCell = heritageCollectionView.dequeueReusableCell(withReuseIdentifier: "heritageCellId", for: indexPath) as! HeritageCollectionCell
        
        heritageCell.setHeritageListCellValues(heritageList: heritageListArray[indexPath.row])
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
        popUpView.loadPopup()
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
    //MARK: WebServiceCall
    func getheritageDataFromServer()
    {
       
            _ = Alamofire.request(QatarMuseumRouter.HeritageList()).responseObject { (response: DataResponse<HeritageLists>) -> Void in
                switch response.result {
                case .success(let data):
                    self.heritageListArray = data.heritageLists
                    self.heritageCollectionView.reloadData()
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
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}

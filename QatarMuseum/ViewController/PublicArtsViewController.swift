//
//  PublicArtsViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 22/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Alamofire
import CoreData
import Firebase

import UIKit

class PublicArtsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HeaderViewProtocol,comingSoonPopUpProtocol {
    @IBOutlet weak var pulicArtsHeader: CommonHeaderView!
    @IBOutlet weak var publicArtsCollectionView: UICollectionView!
    @IBOutlet weak var loadingView: LoadingView!
    
    var publicArtsListImageArray = NSArray()
    var popUpView : ComingSoonPopUp = ComingSoonPopUp()
    var publicArtsListArray: [PublicArtsList]! = []
    let networkReachability = NetworkReachabilityManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPublicArtsUi()
        registerNib()
        if  (networkReachability?.isReachable)! {
            getPublicArtsListDataFromServer()
        }
        else {
            self.fetchPublicArtsListFromCoredata()
        }
        recordScreenView()
    }

    func setupPublicArtsUi() {
        loadingView.isHidden = false
        loadingView.showLoading()
        
        pulicArtsHeader.headerViewDelegate = self
        pulicArtsHeader.headerTitle.text = NSLocalizedString("PUBLIC_ARTS_TITLE", comment: "PUBLIC_ARTS_TITLE Label in the PublicArts page")
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            pulicArtsHeader.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        } else {
            pulicArtsHeader.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }

    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        
        publicArtsCell.setPublicArtsListCellValues(publicArtsList: publicArtsListArray[indexPath.row])
        loadingView.stopLoading()
        loadingView.isHidden = true
        return publicArtsCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightValue = UIScreen.main.bounds.height/100
        return CGSize(width: publicArtsCollectionView.frame.width, height: heightValue*27)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        loadPublicArtsDetail(idValue: publicArtsListArray[indexPath.row].id!)
        
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
    func loadPublicArtsDetail(idValue: String) {
        let publicDtlView = self.storyboard?.instantiateViewController(withIdentifier: "heritageDetailViewId") as! HeritageDetailViewController
        publicDtlView.pageNameString = PageName.publicArtsDetail
        publicDtlView.publicArtsDetailId = idValue
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
    //MARK: WebServiceCall
    func getPublicArtsListDataFromServer()
    {
        
        _ = Alamofire.request(QatarMuseumRouter.PublicArtsList()).responseObject { (response: DataResponse<PublicArtsLists>) -> Void in
            switch response.result {
            case .success(let data):
                self.publicArtsListArray = data.publicArtsList
                self.saveOrUpdatePublicArtsCoredata()
                self.publicArtsCollectionView.reloadData()
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
    //MARK: Coredata Method
    func saveOrUpdatePublicArtsCoredata() {
        if (publicArtsListArray.count > 0) {
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                let fetchData = checkAddedToCoredata(entityName: "PublicArtsEntity", publicArtsId: nil) as! [PublicArtsEntity]
                if (fetchData.count > 0) {
                    for i in 0 ... publicArtsListArray.count-1 {
                        let managedContext = getContext()
                        let publicArtsListDict = publicArtsListArray[i]
                        let fetchResult = checkAddedToCoredata(entityName: "PublicArtsEntity", publicArtsId: publicArtsListArray[i].id)
                        //update
                        if(fetchResult.count != 0) {
                            let publicArtsdbDict = fetchResult[0] as! PublicArtsEntity
                            
                            publicArtsdbDict.name = publicArtsListDict.name
                            publicArtsdbDict.image = publicArtsListDict.image
                            publicArtsdbDict.latitude =  publicArtsListDict.latitude
                            publicArtsdbDict.longitude = publicArtsListDict.longitude
                            publicArtsdbDict.sortcoefficient = publicArtsListDict.sortcoefficient
                            
                            do{
                                try managedContext.save()
                            }
                            catch{
                                print(error)
                            }
                        }
                        else {
                            //save
                            self.saveToCoreData(publicArtsListDict: publicArtsListDict, managedObjContext: managedContext)
                            
                        }
                    }
                }
                else {
                    for i in 0 ... publicArtsListArray.count-1 {
                        let managedContext = getContext()
                        let publicArtsListDict : PublicArtsList?
                        publicArtsListDict = publicArtsListArray[i]
                        self.saveToCoreData(publicArtsListDict: publicArtsListDict!, managedObjContext: managedContext)
                        
                    }
                }
            }
            else {
                let fetchData = checkAddedToCoredata(entityName: "PublicArtsEntityArabic", publicArtsId: nil) as! [PublicArtsEntityArabic]
                if (fetchData.count > 0) {
                    for i in 0 ... publicArtsListArray.count-1 {
                        let managedContext = getContext()
                        let publicArtsListDict = publicArtsListArray[i]
                        let fetchResult = checkAddedToCoredata(entityName: "PublicArtsEntityArabic", publicArtsId: publicArtsListArray[i].id)
                        //update
                        if(fetchResult.count != 0) {
                            let publicArtsdbDict = fetchResult[0] as! PublicArtsEntityArabic
                            publicArtsdbDict.namearabic = publicArtsListDict.name
                            publicArtsdbDict.imagearabic = publicArtsListDict.image
                            publicArtsdbDict.latitudearabic =  publicArtsListDict.latitude
                            publicArtsdbDict.longitudearabic = publicArtsListDict.longitude
                            publicArtsdbDict.sortcoefficientarabic = publicArtsListDict.sortcoefficient
                            do{
                                try managedContext.save()
                            }
                            catch{
                                print(error)
                            }
                        }
                        else {
                            //save
                            self.saveToCoreData(publicArtsListDict: publicArtsListDict, managedObjContext: managedContext)
                            
                        }
                    }
                }
                else {
                    for i in 0 ... publicArtsListArray.count-1 {
                        let managedContext = getContext()
                        let publicArtsListDict : PublicArtsList?
                        publicArtsListDict = publicArtsListArray[i]
                        self.saveToCoreData(publicArtsListDict: publicArtsListDict!, managedObjContext: managedContext)
                        
                    }
                }
            }
        }
    }
    func saveToCoreData(publicArtsListDict: PublicArtsList, managedObjContext: NSManagedObjectContext) {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            let publicArtsInfo: PublicArtsEntity = NSEntityDescription.insertNewObject(forEntityName: "PublicArtsEntity", into: managedObjContext) as! PublicArtsEntity
            publicArtsInfo.id = publicArtsListDict.id
            publicArtsInfo.name = publicArtsListDict.name
            publicArtsInfo.image = publicArtsListDict.image
            publicArtsInfo.latitude = publicArtsListDict.name
            publicArtsInfo.longitude = publicArtsListDict.image
            publicArtsInfo.sortcoefficient = publicArtsListDict.sortcoefficient
            
        }
        else {
            let publicArtsInfo: PublicArtsEntityArabic = NSEntityDescription.insertNewObject(forEntityName: "PublicArtsEntityArabic", into: managedObjContext) as! PublicArtsEntityArabic
            publicArtsInfo.id = publicArtsListDict.id
            publicArtsInfo.namearabic = publicArtsListDict.name
            publicArtsInfo.imagearabic = publicArtsListDict.image
            publicArtsInfo.latitudearabic = publicArtsListDict.name
            publicArtsInfo.longitudearabic = publicArtsListDict.image
            publicArtsInfo.sortcoefficientarabic = publicArtsListDict.sortcoefficient
        }
        do {
            try managedObjContext.save()
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func fetchPublicArtsListFromCoredata() {
        
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                var publicArtsArray = [PublicArtsEntity]()
                let managedContext = getContext()
                let publicArtsFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "PublicArtsEntity")
                publicArtsArray = (try managedContext.fetch(publicArtsFetchRequest) as? [PublicArtsEntity])!
                if (publicArtsArray.count > 0) {
                    for i in 0 ... publicArtsArray.count-1 {
                        
                        self.publicArtsListArray.insert(PublicArtsList(id: publicArtsArray[i].id, name: publicArtsArray[i].name, latitude: publicArtsArray[i].latitude, longitude: publicArtsArray[i].longitude, image: publicArtsArray[i].image, sortcoefficient: publicArtsArray[i].sortcoefficient), at: i)
                        
                    }
                    if(publicArtsListArray.count == 0){
                        self.showNodata()
                    }
                    publicArtsCollectionView.reloadData()
                }
                else{
                    self.showNodata()
                }
            }
            else {
                var publicArtsArray = [PublicArtsEntityArabic]()
                let managedContext = getContext()
                let publicArtsFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "PublicArtsEntityArabic")
                publicArtsArray = (try managedContext.fetch(publicArtsFetchRequest) as? [PublicArtsEntityArabic])!
                if (publicArtsArray.count > 0) {
                    for i in 0 ... publicArtsArray.count-1 {
                        
                         self.publicArtsListArray.insert(PublicArtsList(id: publicArtsArray[i].id, name: publicArtsArray[i].namearabic, latitude: publicArtsArray[i].latitudearabic, longitude: publicArtsArray[i].longitudearabic, image: publicArtsArray[i].imagearabic, sortcoefficient: publicArtsArray[i].sortcoefficientarabic), at: i)
                        
                    }
                    if(publicArtsListArray.count == 0){
                        self.showNodata()
                    }
                    publicArtsCollectionView.reloadData()
                }
                else{
                    self.showNodata()
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    func getContext() -> NSManagedObjectContext{
        
        let appDelegate =  UIApplication.shared.delegate as? AppDelegate
        if #available(iOS 10.0, *) {
            return
                appDelegate!.persistentContainer.viewContext
        } else {
            return appDelegate!.managedObjectContext
        }
    }
    func checkAddedToCoredata(entityName: String?,publicArtsId: String?) -> [NSManagedObject]
    {
        let managedContext = getContext()
        var fetchResults : [NSManagedObject] = []
        let publicArtsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName!)
        if (publicArtsId != nil) {
            publicArtsFetchRequest.predicate = NSPredicate.init(format: "id == \(publicArtsId!)")
        }
        fetchResults = try! managedContext.fetch(publicArtsFetchRequest)
        return fetchResults
    }
    func showNodata() {
        var errorMessage: String
        errorMessage = String(format: NSLocalizedString("NO_RESULT_MESSAGE",
                                                        comment: "Setting the content of the alert"))
        self.loadingView.stopLoading()
        self.loadingView.noDataView.isHidden = false
        self.loadingView.isHidden = false
        self.loadingView.showNoDataView()
        self.loadingView.noDataLabel.text = errorMessage
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func recordScreenView() {
        title = self.nibName
        guard let screenName = title else {
            return
        }
        let screenClass = classForCoder.description()
        Analytics.setScreenName(screenName, screenClass: screenClass)
    }


}

//
//  HeritageListViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 21/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Alamofire
import CoreData
import Crashlytics
import Firebase
import UIKit

class HeritageListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HeaderViewProtocol,comingSoonPopUpProtocol {
    
    @IBOutlet weak var heritageHeader: CommonHeaderView!
    @IBOutlet weak var heritageCollectionView: UICollectionView!
    @IBOutlet weak var loadingView: LoadingView!
    var popUpView : ComingSoonPopUp = ComingSoonPopUp()
    var heritageListArray: [Heritage]! = []
    let networkReachability = NetworkReachabilityManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if  (networkReachability?.isReachable)! {
            getHeritageDataFromServer()
        }
        else {
            self.fetchHeritageListFromCoredata()
        }
        registerNib()
        recordScreenView()
        
        
    }
   
    func setupUI() {
        loadingView.isHidden = false
        loadingView.showLoading()
        
        heritageHeader.headerViewDelegate = self
        heritageHeader.headerTitle.text = NSLocalizedString("HERITAGE_SITES_TITLE", comment: "HERITAGE_SITES_TITLE  in the Heritage page")
        heritageHeader.headerTitle.font = UIFont.headerFont
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
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
        
        //heritageCell.setHeritageListCellValues(heritageList: heritageListArray[indexPath.row])
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
        let heritageId = heritageListArray[indexPath.row].id
        loadHeritageDetail(heritageListId: heritageId!)
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
    func loadHeritageDetail(heritageListId: String) {
        let heritageDtlView = self.storyboard?.instantiateViewController(withIdentifier: "heritageDetailViewId") as! HeritageDetailViewController
        heritageDtlView.pageNameString = PageName.heritageDetail
        heritageDtlView.heritageDetailId = heritageListId
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
    func getHeritageDataFromServer()
    {
       
            _ = Alamofire.request(QatarMuseumRouter.HeritageList()).responseObject { (response: DataResponse<Heritages>) -> Void in
                switch response.result {
                case .success(let data):
                    self.heritageListArray = data.heritage
                    self.saveOrUpdateHeritageCoredata()
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
    
    //MARK: Coredata Method
    func saveOrUpdateHeritageCoredata() {
        if (heritageListArray.count > 0) {
         if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
        let fetchData = checkAddedToCoredata(entityName: "HeritageEntity", heritageId: nil) as! [HeritageEntity]
        if (fetchData.count > 0) {
            for i in 0 ... heritageListArray.count-1 {
                let managedContext = getContext()
                let heritageListDict = heritageListArray[i]
                let fetchResult = checkAddedToCoredata(entityName: "HeritageEntity", heritageId: heritageListArray[i].id)
                //update
                if(fetchResult.count != 0) {
                    let heritagedbDict = fetchResult[0] as! HeritageEntity
                    
                        heritagedbDict.listname = heritageListDict.name
                    
                    heritagedbDict.listimage = heritageListDict.image
                    heritagedbDict.listsortid =  heritageListDict.sortid
                    
                    do{
                        try managedContext.save()
                    }
                    catch{
                        print(error)
                    }
                }
                else {
                    //save
                    self.saveToCoreData(heritageListDict: heritageListDict, managedObjContext: managedContext)
                    
                }
            }
        }
        else {
            for i in 0 ... heritageListArray.count-1 {
                let managedContext = getContext()
                let heritageListDict : Heritage?
                heritageListDict = heritageListArray[i]
                self.saveToCoreData(heritageListDict: heritageListDict!, managedObjContext: managedContext)
                
            }
        }
        }
         else {
            let fetchData = checkAddedToCoredata(entityName: "HeritageEntityArabic", heritageId: nil) as! [HeritageEntityArabic]
            if (fetchData.count > 0) {
                for i in 0 ... heritageListArray.count-1 {
                    let managedContext = getContext()
                    let heritageListDict = heritageListArray[i]
                    let fetchResult = checkAddedToCoredata(entityName: "HeritageEntityArabic", heritageId: heritageListArray[i].id)
                    //update
                    if(fetchResult.count != 0) {
                        let heritagedbDict = fetchResult[0] as! HeritageEntityArabic
                        heritagedbDict.listnamearabic = heritageListDict.name
                        heritagedbDict.listimagearabic = heritageListDict.image
                        heritagedbDict.listsortidarabic =  heritageListDict.sortid
                        
                        do{
                            try managedContext.save()
                        }
                        catch{
                            print(error)
                        }
                    }
                    else {
                        //save
                        self.saveToCoreData(heritageListDict: heritageListDict, managedObjContext: managedContext)
                        
                    }
                }
            }
            else {
                for i in 0 ... heritageListArray.count-1 {
                    let managedContext = getContext()
                    let heritageListDict : Heritage?
                    heritageListDict = heritageListArray[i]
                    self.saveToCoreData(heritageListDict: heritageListDict!, managedObjContext: managedContext)
                    
                }
            }
        }
        }
    }
    func saveToCoreData(heritageListDict: Heritage, managedObjContext: NSManagedObjectContext) {
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            let heritageInfo: HeritageEntity = NSEntityDescription.insertNewObject(forEntityName: "HeritageEntity", into: managedObjContext) as! HeritageEntity
            heritageInfo.listid = heritageListDict.id
            heritageInfo.listname = heritageListDict.name
            
            heritageInfo.listimage = heritageListDict.image
            if(heritageListDict.sortid != nil) {
                heritageInfo.listsortid = heritageListDict.sortid
            }
        }
        else {
            let heritageInfo: HeritageEntityArabic = NSEntityDescription.insertNewObject(forEntityName: "HeritageEntityArabic", into: managedObjContext) as! HeritageEntityArabic
            heritageInfo.listid = heritageListDict.id
            heritageInfo.listnamearabic = heritageListDict.name
            
            heritageInfo.listimagearabic = heritageListDict.image
            if(heritageListDict.sortid != nil) {
                heritageInfo.listsortidarabic = heritageListDict.sortid
            }
        }
        do {
            try managedObjContext.save()
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func fetchHeritageListFromCoredata() {
        
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                var heritageArray = [HeritageEntity]()
                let managedContext = getContext()
                let homeFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "HeritageEntity")
                heritageArray = (try managedContext.fetch(homeFetchRequest) as? [HeritageEntity])!
                if (heritageArray.count > 0) {
                    for i in 0 ... heritageArray.count-1 {
                        
                        self.heritageListArray.insert(Heritage(id: heritageArray[i].listid, name: heritageArray[i].listname, location: nil, latitude: nil, longitude: nil, image: heritageArray[i].listimage, shortdescription: nil, longdescription: nil, sortid: heritageArray[i].listsortid), at: i)
                        
                    }
                    if(heritageListArray.count == 0){
                        self.showNodata()
                    }
                    heritageCollectionView.reloadData()
                }
                else{
                    self.showNodata()
                }
        }
            else {
                var heritageArray = [HeritageEntityArabic]()
                let managedContext = getContext()
                let homeFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "HeritageEntityArabic")
                heritageArray = (try managedContext.fetch(homeFetchRequest) as? [HeritageEntityArabic])!
                if (heritageArray.count > 0) {
                    for i in 0 ... heritageArray.count-1 {
                        
                        self.heritageListArray.insert(Heritage(id: heritageArray[i].listid, name: heritageArray[i].listnamearabic, location: nil, latitude: nil, longitude: nil, image: heritageArray[i].listimagearabic, shortdescription: nil, longdescription: nil, sortid: heritageArray[i].listsortidarabic), at: i)
                        
                    }
                    if(heritageListArray.count == 0){
                        self.showNodata()
                    }
                    heritageCollectionView.reloadData()
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
    func checkAddedToCoredata(entityName: String?,heritageId: String?) -> [NSManagedObject]
    {
        let managedContext = getContext()
        var fetchResults : [NSManagedObject] = []
        let homeFetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName!)
        if (heritageId != nil) {
            homeFetchRequest.predicate = NSPredicate.init(format: "listid == \(heritageId!)")
        }
        fetchResults = try! managedContext.fetch(homeFetchRequest)
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

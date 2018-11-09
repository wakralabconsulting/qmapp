//
//  DiningViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 29/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Alamofire
import CoreData
import Crashlytics
import UIKit

class DiningViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, HeaderViewProtocol,comingSoonPopUpProtocol,LoadingViewProtocol {
    @IBOutlet weak var diningHeader: CommonHeaderView!
    @IBOutlet weak var diningCollectionView: UICollectionView!
    @IBOutlet weak var loadingView: LoadingView!
    
    var diningListArray : [Dining]! = []
    var popUpView : ComingSoonPopUp = ComingSoonPopUp()
    var fromHome : Bool = false
    var fromSideMenu : Bool = false
    let networkReachability = NetworkReachabilityManager()
    var museumId : String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDiningArtsUi()
        if  (networkReachability?.isReachable)! {
            if(fromHome == true) {
                getDiningListFromServer()
            } else {
                getMuseumDiningListFromServer()
            }
        } else {
            if(fromHome == true) {
                fetchDiningListFromCoredata()
            } else {
                fetchMuseumDiningListFromCoredata()
            }
        }
        registerNib()
    }
    
    func setupDiningArtsUi() {
        loadingView.isHidden = false
        loadingView.showLoading()
        loadingView.loadingViewDelegate = self
        diningHeader.headerViewDelegate = self
        diningHeader.headerTitle.text = NSLocalizedString("DINING_TITLE", comment: "DINING_TITLE in the Dining page")
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            
            diningHeader.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        } else {
            diningHeader.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
       
        publicArtsCell.setDiningListValues(diningList: diningListArray[indexPath.row])
        loadingView.stopLoading()
        loadingView.isHidden = true
        return publicArtsCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightValue = UIScreen.main.bounds.height/100
        return CGSize(width: diningCollectionView.frame.width+10, height: heightValue*27)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let diningId = diningListArray[indexPath.row].id
        loadDiningDetailAnimation(idValue: diningId!)
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
        if (fromSideMenu == true) {
            transition.type = kCATransitionFade
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            self.view.window!.layer.add(transition, forKey: kCATransition)
            dismiss(animated: false, completion: nil)
        } else {
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            self.view.window!.layer.add(transition, forKey: kCATransition)
            if (fromHome == true) {
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "homeId") as! HomeViewController
                
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = homeViewController
            } else {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    func loadDiningDetailAnimation(idValue: String) {
        let diningDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "diningDetailId") as! DiningDetailViewController
       diningDetailView.diningDetailId = idValue
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(diningDetailView, animated: false, completion: nil)
        
    }
    //MARK: WebServiceCall
    func getDiningListFromServer()
    {
        _ = Alamofire.request(QatarMuseumRouter.DiningList()).responseObject { (response: DataResponse<Dinings>) -> Void in
            //URLCache.shared.removeAllCachedResponses()
            switch response.result {
            case .success(let data):
                self.diningListArray = data.dinings
                self.saveOrUpdateDiningCoredata()
                self.diningCollectionView.reloadData()
                self.loadingView.stopLoading()
                self.loadingView.isHidden = true
                if (self.diningListArray.count == 0) {
                    self.loadingView.stopLoading()
                    self.loadingView.noDataView.isHidden = false
                    self.loadingView.isHidden = false
                    self.loadingView.showNoDataView()
                }
            case .failure(let error):
                    var errorMessage: String
                    errorMessage = String(format: NSLocalizedString("NO_RESULT_MESSAGE",
                                                                    comment: "Setting the content of the alert"))
                    self.loadingView.stopLoading()
                    self.loadingView.noDataView.isHidden = false
                    self.loadingView.isHidden = false
                    self.loadingView.showNoDataView()
                    self.loadingView.noDataLabel.text = errorMessage
            }
        }
    }
    //MARK: Museum DiningWebServiceCall
    func getMuseumDiningListFromServer()
    {
        _ = Alamofire.request(QatarMuseumRouter.MuseumDiningList(["museum_id": museumId ?? 0])).responseObject { (response: DataResponse<Dinings>) -> Void in
            //URLCache.shared.removeAllCachedResponses()
            switch response.result {
            case .success(let data):
                self.diningListArray = data.dinings
                self.saveOrUpdateDiningCoredata()
                self.diningCollectionView.reloadData()
                self.loadingView.stopLoading()
                self.loadingView.isHidden = true
                if (self.diningListArray.count == 0) {
                    self.loadingView.stopLoading()
                    self.loadingView.noDataView.isHidden = false
                    self.loadingView.isHidden = false
                    self.loadingView.showNoDataView()
                }
            case .failure(let error):
                var errorMessage: String
                errorMessage = String(format: NSLocalizedString("NO_RESULT_MESSAGE",
                                                                comment: "Setting the content of the alert"))
                self.loadingView.stopLoading()
                self.loadingView.noDataView.isHidden = false
                self.loadingView.isHidden = false
                self.loadingView.showNoDataView()
                self.loadingView.noDataLabel.text = errorMessage
            }
        }
    }
    //MARK: Coredata Method
    func saveOrUpdateDiningCoredata() {
        if (diningListArray.count > 0) {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            let fetchData = checkAddedToCoredata(entityName: "DiningEntity", idKey: "id", idValue: nil) as! [DiningEntity]
            if (fetchData.count > 0) {
                for i in 0 ... diningListArray.count-1 {
                    let managedContext = getContext()
                    let diningListDict = diningListArray[i]
                    let fetchResult = checkAddedToCoredata(entityName: "DiningEntity", idKey: "id", idValue: diningListArray[i].id)
                    //update
                    if(fetchResult.count != 0) {
                        let diningdbDict = fetchResult[0] as! DiningEntity
                        diningdbDict.name = diningListDict.name
                        diningdbDict.image = diningListDict.image
                        diningdbDict.sortid =  diningListDict.sortid
                        diningdbDict.museumId =  diningListDict.museumId

                        do{
                            try managedContext.save()
                        }
                        catch{
                            print(error)
                        }
                    }
                    else {
                        //save
                        self.saveToCoreData(diningListDict: diningListDict, managedObjContext: managedContext)
                        
                    }
                }
            }
            else {
                for i in 0 ... diningListArray.count-1 {
                    let managedContext = getContext()
                    let diningListDict : Dining?
                    diningListDict = diningListArray[i]
                    self.saveToCoreData(diningListDict: diningListDict!, managedObjContext: managedContext)
                    
                }
            }
        }
        else {
            let fetchData = checkAddedToCoredata(entityName: "DiningEntityArabic", idKey: "id", idValue: nil) as! [DiningEntityArabic]
            if (fetchData.count > 0) {
                for i in 0 ... diningListArray.count-1 {
                    let managedContext = getContext()
                    let diningListDict = diningListArray[i]
                    let fetchResult = checkAddedToCoredata(entityName: "DiningEntityArabic", idKey: "id" , idValue: diningListArray[i].id)
                    //update
                    if(fetchResult.count != 0) {
                        let diningdbDict = fetchResult[0] as! DiningEntityArabic
                        diningdbDict.namearabic = diningListDict.name
                        diningdbDict.imagearabic = diningListDict.image
                        diningdbDict.sortidarabic =  diningListDict.sortid
                        diningdbDict.museumId =  diningListDict.museumId
                        
                        do{
                            try managedContext.save()
                        }
                        catch{
                            print(error)
                        }
                    }
                    else {
                        //save
                        self.saveToCoreData(diningListDict: diningListDict, managedObjContext: managedContext)
                        
                    }
                }
            }
            else {
                for i in 0 ... diningListArray.count-1 {
                    let managedContext = getContext()
                    let diningListDict : Dining?
                    diningListDict = diningListArray[i]
                    self.saveToCoreData(diningListDict: diningListDict!, managedObjContext: managedContext)
                    
                }
            }
        }
    }
    }
    func saveToCoreData(diningListDict: Dining, managedObjContext: NSManagedObjectContext) {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            let diningInfoInfo: DiningEntity = NSEntityDescription.insertNewObject(forEntityName: "DiningEntity", into: managedObjContext) as! DiningEntity
            diningInfoInfo.id = diningListDict.id
            diningInfoInfo.name = diningListDict.name
            
            diningInfoInfo.image = diningListDict.image
            if(diningListDict.sortid != nil) {
                diningInfoInfo.sortid = diningListDict.sortid
            }
            diningInfoInfo.museumId = diningListDict.museumId
        }
        else {
            let diningInfoInfo: DiningEntityArabic = NSEntityDescription.insertNewObject(forEntityName: "DiningEntityArabic", into: managedObjContext) as! DiningEntityArabic
            diningInfoInfo.id = diningListDict.id
            diningInfoInfo.namearabic = diningListDict.name
            
            diningInfoInfo.imagearabic = diningListDict.image
            if(diningListDict.sortid != nil) {
                diningInfoInfo.sortidarabic = diningListDict.sortid
            }
            diningInfoInfo.museumId = diningListDict.museumId
        }
        do {
            try managedObjContext.save()
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func fetchMuseumDiningListFromCoredata() {
        
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                var diningArray = [DiningEntity]()
                diningArray = checkAddedToCoredata(entityName: "DiningEntity", idKey: "museumId", idValue: museumId) as! [DiningEntity]
                
                if (diningArray.count > 0) {
                    for i in 0 ... diningArray.count-1 {
                        self.diningListArray.insert(Dining(id: diningArray[i].id, name: diningArray[i].name, location: diningArray[i].location, description: diningArray[i].diningdescription, image: diningArray[i].image, openingtime: diningArray[i].openingtime, closetime: diningArray[i].closetime, sortid: diningArray[i].sortid,museumId: diningArray[i].museumId, images: nil), at: i)
                    }
                    if(diningListArray.count == 0){
                        self.showNoNetwork()
                    }
                    diningCollectionView.reloadData()
                } else{
                    self.showNoNetwork()
                }
            } else {
                var diningArray = [DiningEntityArabic]()
                diningArray = checkAddedToCoredata(entityName: "DiningEntityArabic", idKey: "museumId", idValue: museumId) as! [DiningEntityArabic]
                if (diningArray.count > 0) {
                    for i in 0 ... diningArray.count-1 {
                        
                        self.diningListArray.insert(Dining(id: diningArray[i].id, name: diningArray[i].namearabic, location: diningArray[i].locationarabic, description: diningArray[i].descriptionarabic, image: diningArray[i].imagearabic, openingtime: diningArray[i].openingtimearabic, closetime: diningArray[i].closetimearabic, sortid: diningArray[i].sortidarabic,museumId: diningArray[i].museumId, images: nil), at: i)
                        
                        
                    }
                    if(diningListArray.count == 0){
                        self.showNoNetwork()
                    }
                    diningCollectionView.reloadData()
                }
                else{
                    self.showNoNetwork()
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func fetchDiningListFromCoredata() {
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                var diningArray = [DiningEntity]()
                let managedContext = getContext()
                let homeFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "DiningEntity")
                diningArray = (try managedContext.fetch(homeFetchRequest) as? [DiningEntity])!
                if (diningArray.count > 0) {
                    for i in 0 ... diningArray.count-1 {
                        self.diningListArray.insert(Dining(id: diningArray[i].id, name: diningArray[i].name, location: diningArray[i].location, description: diningArray[i].diningdescription, image: diningArray[i].image, openingtime: diningArray[i].openingtime, closetime: diningArray[i].closetime, sortid: diningArray[i].sortid,museumId: diningArray[i].museumId, images: nil), at: i)

                    }
                    if(diningListArray.count == 0){
                        self.showNoNetwork()
                    }
                    diningCollectionView.reloadData()
                } else {
                    self.showNoNetwork()
                }
            } else {
                var diningArray = [DiningEntityArabic]()
                let managedContext = getContext()
                let diningFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "DiningEntityArabic")
                diningArray = (try managedContext.fetch(diningFetchRequest) as? [DiningEntityArabic])!
                if (diningArray.count > 0) {
                    for i in 0 ... diningArray.count-1 {
                        self.diningListArray.insert(Dining(id: diningArray[i].id, name: diningArray[i].namearabic, location: diningArray[i].locationarabic, description: diningArray[i].descriptionarabic, image: diningArray[i].imagearabic, openingtime: diningArray[i].openingtimearabic, closetime: diningArray[i].closetimearabic, sortid: diningArray[i].sortidarabic,museumId: diningArray[i].museumId, images: nil), at: i)
                    }
                    if(diningListArray.count == 0){
                        self.showNoNetwork()
                    }
                    diningCollectionView.reloadData()
                }
                else{
                    self.showNoNetwork()
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
    func checkAddedToCoredata(entityName: String?,idKey:String?, idValue: String?) -> [NSManagedObject]
    {
        let managedContext = getContext()
        var fetchResults : [NSManagedObject] = []
        let homeFetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName!)
        if (idValue != nil) {
            homeFetchRequest.predicate = NSPredicate.init(format: "\(idKey!) == \(idValue!)")
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
    //MARK: LoadingView Delegate
    func tryAgainButtonPressed() {
        if  (networkReachability?.isReachable)! {
            if(fromHome == true) {
                self.getDiningListFromServer()
            } else {
                self.getMuseumDiningListFromServer()
            }
        }
    }
    func showNoNetwork() {
        self.loadingView.stopLoading()
        self.loadingView.noDataView.isHidden = false
        self.loadingView.isHidden = false
        self.loadingView.showNoNetworkView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

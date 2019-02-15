//
//  ExhibitionsViewController.swift
//  QatarMuseum
//
//  Created by Exalture on 10/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//
import Alamofire
import CoreData
import Crashlytics
import Firebase
import UIKit

enum ExhbitionPageName {
    case homeExhibition
    case museumExhibition
    case heritageList
}
class ExhibitionsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout,HeaderViewProtocol,comingSoonPopUpProtocol,LoadingViewProtocol {
    @IBOutlet weak var exhibitionHeaderView: CommonHeaderView!
    @IBOutlet weak var exhibitionCollectionView: UITableView!
    @IBOutlet weak var exbtnLoadingView: LoadingView!
    
    var exhibition: [Exhibition]! = []
    var heritageListArray: [Heritage]! = []
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
    var exhibitionsPageNameString : ExhbitionPageName?
    let networkReachability = NetworkReachabilityManager()
    var museumId : String? = nil
    var fromSideMenu : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpExhibitionPageUi()
        registerNib()
        
       
        self.recordScreenView()
    }
    
    func setUpExhibitionPageUi() {
        exbtnLoadingView.isHidden = false
        exbtnLoadingView.showLoading()
        exbtnLoadingView.loadingViewDelegate = self
        exhibitionHeaderView.headerViewDelegate = self
        if ((exhibitionsPageNameString == ExhbitionPageName.homeExhibition) || (exhibitionsPageNameString == ExhbitionPageName.museumExhibition)) {
            exhibitionHeaderView.headerTitle.text = NSLocalizedString("EXHIBITIONS_TITLE", comment: "EXHIBITIONS_TITLE Label in the Exhibitions page")
            NotificationCenter.default.addObserver(self, selector: #selector(ExhibitionsViewController.receiveExhibitionListNotificationEn(notification:)), name: NSNotification.Name(exhibitionsListNotificationEn), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(ExhibitionsViewController.receiveExhibitionListNotificationAr(notification:)), name: NSNotification.Name(exhibitionsListNotificationAr), object: nil)
            if  (networkReachability?.isReachable)! {
                if (exhibitionsPageNameString == ExhbitionPageName.homeExhibition) {
                    DispatchQueue.global(qos: .background).async {
                        self.getExhibitionDataFromServer()
                    }
                    self.fetchExhibitionsListFromCoredata()
                } else if (exhibitionsPageNameString == ExhbitionPageName.museumExhibition){
                    getMuseumExhibitionDataFromServer()
                }
                
            } else {
                if (exhibitionsPageNameString == ExhbitionPageName.homeExhibition) {
                    self.fetchExhibitionsListFromCoredata()
                } else if (exhibitionsPageNameString == ExhbitionPageName.museumExhibition){
                    self.fetchMuseumExhibitionsListFromCoredata()
                }
            }
            
        } else if (exhibitionsPageNameString == ExhbitionPageName.heritageList) {
            exhibitionHeaderView.headerTitle.text = NSLocalizedString("HERITAGE_SITES_TITLE", comment: "HERITAGE_SITES_TITLE  in the Heritage page")
            exhibitionHeaderView.headerTitle.font = UIFont.headerFont
            self.fetchHeritageListFromCoredata()
            NotificationCenter.default.addObserver(self, selector: #selector(ExhibitionsViewController.receiveHeritageListNotificationEn(notification:)), name: NSNotification.Name(heritageListNotificationEn), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(ExhibitionsViewController.receiveHeritageListNotificationAr(notification:)), name: NSNotification.Name(heritageListNotificationAr), object: nil)
            if  (networkReachability?.isReachable)! {
                DispatchQueue.global(qos: .background).async {
                    self.getHeritageDataFromServer()
                }
            }
        }
        
        popupView.comingSoonPopupDelegate = self
        
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            exhibitionHeaderView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        } else {
            exhibitionHeaderView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
        
    }
    
    func registerNib() {
        self.exhibitionCollectionView.register(UINib(nibName: "ExhibitionsCellXib", bundle: nil), forCellReuseIdentifier: "exhibitionCellId")
        self.exhibitionCollectionView.register(UINib(nibName: "HeritageCellXib", bundle: nil), forCellReuseIdentifier: "heritageCellXibId")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Service call
    func getExhibitionDataFromServer() {
        _ = Alamofire.request(QatarMuseumRouter.ExhibitionList(LocalizationLanguage.currentAppleLanguage())).responseObject { (response: DataResponse<Exhibitions>) -> Void in
            switch response.result {
            case .success(let data):
                self.saveOrUpdateExhibitionsCoredata(exhibition: data.exhibitions)
            case .failure(let error):
                print("error")
            }
        }
    }
    //MARK: MuseumExhibitions Service Call
    func getMuseumExhibitionDataFromServer() {
       
        _ = Alamofire.request(QatarMuseumRouter.MuseumExhibitionList(["museum_id": museumId ?? 0])).responseObject { (response: DataResponse<Exhibitions>) -> Void in
            switch response.result {
            case .success(let data):
                self.exhibition = data.exhibitions
                self.saveOrUpdateExhibitionsCoredata(exhibition: data.exhibitions)
                self.exhibitionCollectionView.reloadData()
                self.exbtnLoadingView.stopLoading()
                self.exbtnLoadingView.isHidden = true
                if (self.exhibition.count == 0) {
                    self.exbtnLoadingView.stopLoading()
                    self.exbtnLoadingView.noDataView.isHidden = false
                    self.exbtnLoadingView.isHidden = false
                    self.exbtnLoadingView.showNoDataView()
                }
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch exhibitionsPageNameString {
        case .homeExhibition?:
            return exhibition.count
        case .museumExhibition?:
            return exhibition.count
        case .heritageList?:
            return heritageListArray.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ((exhibitionsPageNameString == ExhbitionPageName.homeExhibition) || (exhibitionsPageNameString == ExhbitionPageName.museumExhibition)) {
            let exhibitionCell = exhibitionCollectionView.dequeueReusableCell(withIdentifier: "exhibitionCellId", for: indexPath) as! ExhibitionsCollectionCell
            exhibitionCell.setExhibitionCellValues(exhibition: exhibition[indexPath.row])
            exhibitionCell.exhibitionCellItemBtnTapAction = {
                () in
                self.loadExhibitionCellPages(cellObj: exhibitionCell, selectedIndex: indexPath.row)
            }
            exhibitionCell.selectionStyle = .none
            exbtnLoadingView.stopLoading()
            exbtnLoadingView.isHidden = true
            return exhibitionCell
        } else {
            //if (exhibitionsPageNameString == ExhbitionPageName.heritageList) {
            let heritageCell = exhibitionCollectionView.dequeueReusableCell(withIdentifier: "heritageCellXibId", for: indexPath) as! HeritageTableViewCell
            heritageCell.setHeritageListCellValues(heritageList: heritageListArray[indexPath.row])
            exbtnLoadingView.stopLoading()
            exbtnLoadingView.isHidden = true
            return heritageCell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightValue = UIScreen.main.bounds.height/100
        return heightValue*27
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ((exhibitionsPageNameString == ExhbitionPageName.homeExhibition) || (exhibitionsPageNameString == ExhbitionPageName.museumExhibition)) {
            if let exhibitionId = exhibition[indexPath.row].id {
                loadExhibitionDetailAnimation(exhibitionId: exhibitionId)
            }
            else {
                addComingSoonPopup()
            }
        } else if (exhibitionsPageNameString == ExhbitionPageName.heritageList) {
            let heritageId = heritageListArray[indexPath.row].id
            loadHeritageDetail(heritageListId: heritageId!)
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
    func loadExhibitionDetailAnimation(exhibitionId: String) {
        let exhibitionDtlView = self.storyboard?.instantiateViewController(withIdentifier: "exhibitionDtlId") as! ExhibitionDetailViewController
            exhibitionDtlView.fromHome = true
            exhibitionDtlView.exhibitionId = exhibitionId
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
        if (fromSideMenu == true) {
            transition.type = kCATransitionFade
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            self.view.window!.layer.add(transition, forKey: kCATransition)
            dismiss(animated: false, completion: nil)
        } else {
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
    }

    func closeButtonPressed() {
        self.popupView.removeFromSuperview()
    }
    
    //MARK: Coredata Method
    func saveOrUpdateExhibitionsCoredata(exhibition:[Exhibition]?) {
        if ((exhibition?.count)! > 0) {
            let appDelegate =  UIApplication.shared.delegate as? AppDelegate
            if #available(iOS 10.0, *) {
                let container = appDelegate!.persistentContainer
                container.performBackgroundTask() {(managedContext) in
                    self.coreDataInBackgroundThread(managedContext: managedContext, exhibition: exhibition)
                }
            } else {
                let managedContext = appDelegate!.managedObjectContext
                managedContext.perform {
                    self.coreDataInBackgroundThread(managedContext : managedContext, exhibition: exhibition)
                }
            }
        }
    }
    
    func coreDataInBackgroundThread(managedContext: NSManagedObjectContext,exhibition:[Exhibition]?) {
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            let fetchData = self.checkAddedToCoredata(entityName: "ExhibitionsEntity", idKey: "id", idValue: nil, managedContext: managedContext) as! [ExhibitionsEntity]
            if (fetchData.count > 0) {
                for i in 0 ... self.exhibition.count-1 {
                    let exhibitionsListDict = self.exhibition[i]
                    let fetchResult = self.checkAddedToCoredata(entityName: "ExhibitionsEntity", idKey: "id", idValue: self.exhibition[i].id, managedContext: managedContext)
                    //update
                    if(fetchResult.count != 0) {
                        let exhibitionsdbDict = fetchResult[0] as! ExhibitionsEntity
                        exhibitionsdbDict.name = exhibitionsListDict.name
                        exhibitionsdbDict.image = exhibitionsListDict.image
                        exhibitionsdbDict.startDate =  exhibitionsListDict.startDate
                        exhibitionsdbDict.endDate = exhibitionsListDict.endDate
                        exhibitionsdbDict.location =  exhibitionsListDict.location
                        exhibitionsdbDict.museumId = exhibitionsListDict.museumId
                        exhibitionsdbDict.status = exhibitionsListDict.status
                        do {
                            try managedContext.save()
                        }
                        catch {
                            print(error)
                        }
                    } else {
                        //save
                        self.saveToCoreData(exhibitionDict: exhibitionsListDict, managedObjContext: managedContext, exhibition: exhibition)
                    }
                }//for
            } else {
                for i in 0 ... self.exhibition.count-1 {
                    let exhibitionListDict : Exhibition?
                    exhibitionListDict = self.exhibition[i]
                    self.saveToCoreData(exhibitionDict: exhibitionListDict!, managedObjContext: managedContext, exhibition: exhibition)
                }
            }
        } else {
            let fetchData = self.checkAddedToCoredata(entityName: "ExhibitionsEntityArabic", idKey: "id", idValue: nil, managedContext: managedContext) as! [ExhibitionsEntityArabic]
            if (fetchData.count > 0) {
                for i in 0 ... self.exhibition.count-1 {
                    let exhibitionListDict = self.exhibition[i]
                    let fetchResult = self.checkAddedToCoredata(entityName: "ExhibitionsEntityArabic", idKey: "id", idValue: self.exhibition[i].id, managedContext: managedContext)
                    //update
                    if(fetchResult.count != 0) {
                        let exhibitiondbDict = fetchResult[0] as! ExhibitionsEntityArabic
                        exhibitiondbDict.nameArabic = exhibitionListDict.name
                        exhibitiondbDict.imageArabic = exhibitionListDict.image
                        exhibitiondbDict.startDateArabic =  exhibitionListDict.startDate
                        exhibitiondbDict.endDateArabic = exhibitionListDict.endDate
                        exhibitiondbDict.locationArabic =  exhibitionListDict.location
                        exhibitiondbDict.museumId =  exhibitionListDict.museumId
                        exhibitiondbDict.status =  exhibitionListDict.status
                        do {
                            try managedContext.save()
                        }
                        catch {
                            print(error)
                        }
                    } else {
                        //save
                        self.saveToCoreData(exhibitionDict: exhibitionListDict, managedObjContext: managedContext, exhibition: exhibition)
                    }
                }
            } else {
                for i in 0 ... self.exhibition.count-1 {
                    let exhibitionListDict : Exhibition?
                    exhibitionListDict = self.exhibition[i]
                    self.saveToCoreData(exhibitionDict: exhibitionListDict!, managedObjContext: managedContext, exhibition: exhibition)
                }
            }
        }
    }
    
    func saveToCoreData(exhibitionDict: Exhibition, managedObjContext: NSManagedObjectContext,exhibition:[Exhibition]?) {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            let exhibitionInfo: ExhibitionsEntity = NSEntityDescription.insertNewObject(forEntityName: "ExhibitionsEntity", into: managedObjContext) as! ExhibitionsEntity
            
            exhibitionInfo.id = exhibitionDict.id
            exhibitionInfo.name = exhibitionDict.name
            exhibitionInfo.image = exhibitionDict.image
            exhibitionInfo.startDate =  exhibitionDict.startDate
            exhibitionInfo.endDate = exhibitionDict.endDate
            exhibitionInfo.location =  exhibitionDict.location
            exhibitionInfo.museumId =  exhibitionDict.museumId
            exhibitionInfo.status =  exhibitionDict.status
        } else {
            let exhibitionInfo: ExhibitionsEntityArabic = NSEntityDescription.insertNewObject(forEntityName: "ExhibitionsEntityArabic", into: managedObjContext) as! ExhibitionsEntityArabic
            exhibitionInfo.id = exhibitionDict.id
            exhibitionInfo.nameArabic = exhibitionDict.name
            exhibitionInfo.imageArabic = exhibitionDict.image
            exhibitionInfo.startDateArabic =  exhibitionDict.startDate
            exhibitionInfo.endDateArabic = exhibitionDict.endDate
            exhibitionInfo.locationArabic =  exhibitionDict.location
            exhibitionInfo.museumId =  exhibitionDict.museumId
            exhibitionInfo.status =  exhibitionDict.status
        }
        do {
            try managedObjContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchExhibitionsListFromCoredata() {
        let managedContext = getContext()
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                var exhibitionArray = [ExhibitionsEntity]()
                let exhibitionFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "ExhibitionsEntity")
                exhibitionArray = (try managedContext.fetch(exhibitionFetchRequest) as? [ExhibitionsEntity])!
                if (exhibitionArray.count > 0) {
                    for i in 0 ... exhibitionArray.count-1 {
                        self.exhibition.insert(Exhibition(id: exhibitionArray[i].id, name: exhibitionArray[i].name, image: exhibitionArray[i].image,detailImage:nil, startDate: exhibitionArray[i].startDate, endDate: exhibitionArray[i].endDate, location: exhibitionArray[i].location, latitude: nil, longitude: nil, shortDescription: nil, longDescription: nil,museumId :exhibitionArray[i].museumId,status :exhibitionArray[i].status,displayDate :exhibitionArray[i].dispalyDate), at: i)
                        
                    }
                    if(exhibition.count == 0){
                        if(self.networkReachability?.isReachable == false) {
                            self.showNoNetwork()
                        } else {
                            self.exbtnLoadingView.showNoDataView()
                        }
                    }
                    DispatchQueue.main.async{
                        self.exhibitionCollectionView.reloadData()
                    }
                } else {
                    if(self.networkReachability?.isReachable == false) {
                        self.showNoNetwork()
                    } else {
                        self.exbtnLoadingView.showNoDataView()
                    }
                }
            } else {
                var exhibitionArray = [ExhibitionsEntityArabic]()
                let exhibitionFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "ExhibitionsEntityArabic")
                exhibitionArray = (try managedContext.fetch(exhibitionFetchRequest) as? [ExhibitionsEntityArabic])!
                if (exhibitionArray.count > 0) {
                    for i in 0 ... exhibitionArray.count-1 {
                        
                        self.exhibition.insert(Exhibition(id: exhibitionArray[i].id, name: exhibitionArray[i].nameArabic, image: exhibitionArray[i].imageArabic,detailImage:nil, startDate: exhibitionArray[i].startDateArabic, endDate: exhibitionArray[i].endDateArabic, location: exhibitionArray[i].locationArabic, latitude: nil, longitude: nil, shortDescription: nil, longDescription: nil,museumId :exhibitionArray[i].museumId,status :exhibitionArray[i].status,displayDate :exhibitionArray[i].displayDateAr), at: i)
                        
                    }
                    if(exhibition.count == 0){
                        if(self.networkReachability?.isReachable == false) {
                            self.showNoNetwork()
                        } else {
                            self.exbtnLoadingView.showNoDataView()
                        }
                    }
                    DispatchQueue.main.async{
                        self.exhibitionCollectionView.reloadData()
                    }
                } else {
                    if(self.networkReachability?.isReachable == false) {
                        self.showNoNetwork()
                    } else {
                        self.exbtnLoadingView.showNoDataView()
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    //MARK: MuseumExhibitionDatabase Fetch
    func fetchMuseumExhibitionsListFromCoredata() {
        let managedContext = getContext()
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                var exhibitionArray = [ExhibitionsEntity]()
                
                exhibitionArray = checkAddedToCoredata(entityName: "ExhibitionsEntity", idKey: "museumId", idValue: museumId, managedContext: managedContext) as! [ExhibitionsEntity]
                if (exhibitionArray.count > 0) {
                    for i in 0 ... exhibitionArray.count-1 {
                        self.exhibition.insert(Exhibition(id: exhibitionArray[i].id, name: exhibitionArray[i].name, image: exhibitionArray[i].image,detailImage:nil, startDate: exhibitionArray[i].startDate, endDate: exhibitionArray[i].endDate, location: exhibitionArray[i].location, latitude: nil, longitude: nil, shortDescription: nil, longDescription: nil,museumId :exhibitionArray[i].museumId,status :exhibitionArray[i].status, displayDate :exhibitionArray[i].dispalyDate), at: i)
                        
                    }
                    if(exhibition.count == 0){
                        self.showNoNetwork()
                    }
                    exhibitionCollectionView.reloadData()
                } else{
                    self.showNoNetwork()
                }
            } else {
                var exhibitionArray = [ExhibitionsEntityArabic]()
                exhibitionArray = checkAddedToCoredata(entityName: "ExhibitionsEntityArabic", idKey: "museumId", idValue: museumId, managedContext: managedContext) as! [ExhibitionsEntityArabic]
                if (exhibitionArray.count > 0) {
                    for i in 0 ... exhibitionArray.count-1 {
                        
                        self.exhibition.insert(Exhibition(id: exhibitionArray[i].id, name: exhibitionArray[i].nameArabic, image: exhibitionArray[i].imageArabic,detailImage:nil, startDate: exhibitionArray[i].startDateArabic, endDate: exhibitionArray[i].endDateArabic, location: exhibitionArray[i].locationArabic, latitude: nil, longitude: nil, shortDescription: nil, longDescription: nil,museumId :exhibitionArray[i].museumId,status :exhibitionArray[i].status,displayDate :exhibitionArray[i].displayDateAr), at: i)
                        
                    }
                    if(exhibition.count == 0){
                        self.showNoNetwork()
                    }
                    exhibitionCollectionView.reloadData()
                }
                else{
                    self.showNoNetwork()
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func checkAddedToCoredata(entityName: String?,idKey:String?, idValue: String?, managedContext: NSManagedObjectContext) -> [NSManagedObject] {
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
        self.exbtnLoadingView.stopLoading()
        self.exbtnLoadingView.noDataView.isHidden = false
        self.exbtnLoadingView.isHidden = false
        self.exbtnLoadingView.showNoDataView()
        self.exbtnLoadingView.noDataLabel.text = errorMessage
    }
    //MARK: LoadingView Delegate
    func tryAgainButtonPressed() {
        if  (networkReachability?.isReachable)! {
            let appDelegate =  UIApplication.shared.delegate as? AppDelegate
            if (exhibitionsPageNameString == ExhbitionPageName.homeExhibition) {
                appDelegate?.getExhibitionDataFromServer(lang: LocalizationLanguage.currentAppleLanguage())
            } else if (exhibitionsPageNameString == ExhbitionPageName.museumExhibition){
                self.getMuseumExhibitionDataFromServer()
            } else if (exhibitionsPageNameString == ExhbitionPageName.heritageList){
                appDelegate?.getHeritageDataFromServer(lang: LocalizationLanguage.currentAppleLanguage())
            }
        }
    }
    func showNoNetwork() {
        self.exbtnLoadingView.stopLoading()
        self.exbtnLoadingView.noDataView.isHidden = false
        self.exbtnLoadingView.isHidden = false
        self.exbtnLoadingView.showNoNetworkView()
    }
    @objc func receiveExhibitionListNotificationEn(notification: NSNotification) {
        if ((LocalizationLanguage.currentAppleLanguage() == ENG_LANGUAGE ) && (exhibition.count == 0)){
            self.fetchExhibitionsListFromCoredata()
        }
    }
    @objc func receiveExhibitionListNotificationAr(notification: NSNotification) {
        if ((LocalizationLanguage.currentAppleLanguage() == AR_LANGUAGE ) && (exhibition.count == 0)){
            self.fetchExhibitionsListFromCoredata()
        }
    }
    func recordScreenView() {
        let screenClass = String(describing: type(of: self))
        if ((exhibitionsPageNameString == ExhbitionPageName.homeExhibition) ||  (exhibitionsPageNameString == ExhbitionPageName.homeExhibition)) {
            Analytics.setScreenName(EXHIBITION_LIST, screenClass: screenClass)
        } else if (exhibitionsPageNameString == ExhbitionPageName.heritageList) {
            Analytics.setScreenName(HERITAGE_LIST, screenClass: screenClass)
        }
        
        
    }
    //MARK: Heritage Page
    //MARK: WebServiceCall
    func getHeritageDataFromServer() {
        _ = Alamofire.request(QatarMuseumRouter.HeritageList(LocalizationLanguage.currentAppleLanguage())).responseObject { (response: DataResponse<Heritages>) -> Void in
            switch response.result {
            case .success(let data):
                self.saveOrUpdateHeritageCoredata(heritageListArray: data.heritage)
                
            case .failure(let error):
                print("error")
                
            }
        }
    }
    //MARK: Coredata Method
    func saveOrUpdateHeritageCoredata(heritageListArray:[Heritage]?) {
        if ((heritageListArray?.count)! > 0) {
            let appDelegate =  UIApplication.shared.delegate as? AppDelegate
            if #available(iOS 10.0, *) {
                let container = appDelegate!.persistentContainer
                container.performBackgroundTask() {(managedContext) in
                    self.coreDataInBackgroundThread(managedContext: managedContext, heritageListArray: heritageListArray)
                }
            } else {
                let managedContext = appDelegate!.managedObjectContext
                managedContext.perform {
                    self.coreDataInBackgroundThread(managedContext : managedContext, heritageListArray: heritageListArray)
                }
            }
        }
    }
    func coreDataInBackgroundThread(managedContext: NSManagedObjectContext,heritageListArray:[Heritage]?) {
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            let fetchData = checkAddedToCoredata(entityName: "HeritageEntity", idKey: "listid", idValue: nil, managedContext: managedContext) as! [HeritageEntity]
            if (fetchData.count > 0) {
                for i in 0 ... (heritageListArray?.count)!-1 {
                    let heritageListDict = heritageListArray![i]
                    let fetchResult = checkAddedToCoredata(entityName: "HeritageEntity", idKey: "listid", idValue: heritageListArray![i].id, managedContext: managedContext)
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
                    } else {
                        //save
                        self.saveToCoreData(heritageListDict: heritageListDict, managedObjContext: managedContext)
                        
                    }
                }
            } else {
                for i in 0 ... (heritageListArray?.count)!-1 {
                    let heritageListDict : Heritage?
                    heritageListDict = heritageListArray?[i]
                    self.saveToCoreData(heritageListDict: heritageListDict!, managedObjContext: managedContext)
                }
            }
        } else {
            let fetchData = checkAddedToCoredata(entityName: "HeritageEntityArabic", idKey: "listid", idValue: nil, managedContext: managedContext) as! [HeritageEntityArabic]
            if (fetchData.count > 0) {
                for i in 0 ... (heritageListArray?.count)!-1 {
                    let heritageListDict = heritageListArray![i]
                    let fetchResult = checkAddedToCoredata(entityName: "HeritageEntityArabic", idKey: "listid", idValue: heritageListArray![i].id, managedContext: managedContext)
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
                for i in 0 ... (heritageListArray?.count)!-1 {
                    let heritageListDict : Heritage?
                    heritageListDict = heritageListArray?[i]
                    self.saveToCoreData(heritageListDict: heritageListDict!, managedObjContext: managedContext)
                    
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
        } else {
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
        let managedContext = getContext()
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                var heritageArray = [HeritageEntity]()
                let homeFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "HeritageEntity")
                heritageArray = (try managedContext.fetch(homeFetchRequest) as? [HeritageEntity])!
                if (heritageArray.count > 0) {
                    for i in 0 ... heritageArray.count-1 {
                        
                        self.heritageListArray.insert(Heritage(id: heritageArray[i].listid, name: heritageArray[i].listname, location: nil, latitude: nil, longitude: nil, image: heritageArray[i].listimage, shortdescription: nil, longdescription: nil,images: nil, sortid: heritageArray[i].listsortid), at: i)
                        
                    }
                    if(heritageListArray.count == 0){
                        if(self.networkReachability?.isReachable == false) {
                            self.showNoNetwork()
                        } else {
                            self.exbtnLoadingView.showNoDataView()
                        }
                    }
                    DispatchQueue.main.async{
                        self.exhibitionCollectionView.reloadData()
                    }
                } else {
                    if(self.networkReachability?.isReachable == false) {
                        self.showNoNetwork()
                    } else {
                        self.exbtnLoadingView.showNoDataView()
                    }
                }
            } else {
                var heritageArray = [HeritageEntityArabic]()
                let homeFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "HeritageEntityArabic")
                heritageArray = (try managedContext.fetch(homeFetchRequest) as? [HeritageEntityArabic])!
                if (heritageArray.count > 0) {
                    for i in 0 ... heritageArray.count-1 {
                        self.heritageListArray.insert(Heritage(id: heritageArray[i].listid, name: heritageArray[i].listnamearabic, location: nil, latitude: nil, longitude: nil, image: heritageArray[i].listimagearabic, shortdescription: nil, longdescription: nil,images: nil, sortid: heritageArray[i].listsortidarabic), at: i)
                        
                    }
                    if(heritageListArray.count == 0){
                        if(self.networkReachability?.isReachable == false) {
                            self.showNoNetwork()
                        } else {
                            self.exbtnLoadingView.showNoDataView()
                        }
                    }
                    exhibitionCollectionView.reloadData()
                } else {
                    if(self.networkReachability?.isReachable == false) {
                        self.showNoNetwork()
                    } else {
                        self.exbtnLoadingView.showNoDataView()
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    @objc func receiveHeritageListNotificationEn(notification: NSNotification) {
        if ((LocalizationLanguage.currentAppleLanguage() == ENG_LANGUAGE ) && (heritageListArray.count == 0)){
            self.fetchHeritageListFromCoredata()
        }
    }
    @objc func receiveHeritageListNotificationAr(notification: NSNotification) {
        if ((LocalizationLanguage.currentAppleLanguage() == AR_LANGUAGE ) && (heritageListArray.count == 0)){
            self.fetchHeritageListFromCoredata()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

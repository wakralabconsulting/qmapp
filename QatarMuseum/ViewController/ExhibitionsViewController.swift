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
    case publicArtsList
    case museumCollectionsList
    case diningList
}
class ExhibitionsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout,HeaderViewProtocol,comingSoonPopUpProtocol,LoadingViewProtocol {
    @IBOutlet weak var exhibitionHeaderView: CommonHeaderView!
    @IBOutlet weak var exhibitionCollectionView: UITableView!
    @IBOutlet weak var exbtnLoadingView: LoadingView!
    
    var exhibition: [Exhibition]! = []
    var heritageListArray: [Heritage]! = []
    var publicArtsListArray: [PublicArtsList]! = []
    var collection: [Collection] = []
    var diningListArray : [Dining]! = []
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
    var exhibitionsPageNameString : ExhbitionPageName?
    let networkReachability = NetworkReachabilityManager()
    var museumId : String? = nil
    var fromSideMenu : Bool = false
    var fromHome : Bool = false

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
        } else if (exhibitionsPageNameString == ExhbitionPageName.publicArtsList) {
            exhibitionHeaderView.headerTitle.text = NSLocalizedString("PUBLIC_ARTS_TITLE", comment: "PUBLIC_ARTS_TITLE Label in the PublicArts page")
            if  (networkReachability?.isReachable)! {
                DispatchQueue.global(qos: .background).async {
                    self.getPublicArtsListDataFromServer()
                }
            }
            self.fetchPublicArtsListFromCoredata()
            NotificationCenter.default.addObserver(self, selector: #selector(ExhibitionsViewController.receivePublicArtsListNotificationEn(notification:)), name: NSNotification.Name(publicArtsListNotificationEn), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(ExhibitionsViewController.receivePublicArtsListNotificationAr(notification:)), name: NSNotification.Name(publicArtsListNotificationAr), object: nil)
        } else if (exhibitionsPageNameString == ExhbitionPageName.museumCollectionsList) {
            exhibitionHeaderView.headerTitle.text = NSLocalizedString("COLLECTIONS_TITLE", comment: "COLLECTIONS_TITLE Label in the collections page").uppercased()
            NotificationCenter.default.addObserver(self, selector: #selector(ExhibitionsViewController.receiveCollectionListNotificationEn(notification:)), name: NSNotification.Name(collectionsListNotificationEn), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(ExhibitionsViewController.receiveCollectionListNotificationAr(notification:)), name: NSNotification.Name(collectionsListNotificationAr), object: nil)
            if((museumId == "63") || (museumId == "96")) {
                if (networkReachability?.isReachable)! {
                    DispatchQueue.global(qos: .background).async {
                        self.getCollectionList()
                    }
                }
                self.fetchCollectionListFromCoredata()
            } else {
                if (networkReachability?.isReachable)! {
                    self.getCollectionList()
                } else {
                    self.fetchCollectionListFromCoredata()
                }
            }
        } else if (exhibitionsPageNameString == ExhbitionPageName.diningList) {
            exhibitionHeaderView.headerTitle.text = NSLocalizedString("DINING_TITLE", comment: "DINING_TITLE in the Dining page")
            if(fromHome) {
                self.fetchDiningListFromCoredata()
                if  (networkReachability?.isReachable)! {
                    DispatchQueue.global(qos: .background).async {
                        self.getDiningListFromServer()
                    }
                }
            } else {
                self.fetchMuseumDiningListFromCoredata()
                if  (networkReachability?.isReachable)! {
                    DispatchQueue.global(qos: .background).async {
                        self.getMuseumDiningListFromServer()
                    }
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
            case .failure( _):
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
        case .publicArtsList?:
            return publicArtsListArray.count
        case .museumCollectionsList?:
            return collection.count
        case .diningList?:
            return diningListArray.count
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
        } else if (exhibitionsPageNameString == ExhbitionPageName.heritageList) {
            let heritageCell = exhibitionCollectionView.dequeueReusableCell(withIdentifier: "heritageCellXibId", for: indexPath) as! HeritageTableViewCell
            heritageCell.setHeritageListCellValues(heritageList: heritageListArray[indexPath.row])
            exbtnLoadingView.stopLoading()
            exbtnLoadingView.isHidden = true
            return heritageCell
        } else if (exhibitionsPageNameString == ExhbitionPageName.publicArtsList) {
            let publicArtsCell = exhibitionCollectionView.dequeueReusableCell(withIdentifier: "heritageCellXibId", for: indexPath) as! HeritageTableViewCell
            publicArtsCell.setPublicArtsListCellValues(publicArtsList: publicArtsListArray[indexPath.row])
            exbtnLoadingView.stopLoading()
            exbtnLoadingView.isHidden = true
            return publicArtsCell
        } else if (exhibitionsPageNameString == ExhbitionPageName.museumCollectionsList) {
            let collectionsCell = exhibitionCollectionView.dequeueReusableCell(withIdentifier: "heritageCellXibId", for: indexPath) as! HeritageTableViewCell
            collectionsCell.setCollectionsCellValues(collectionList: collection[indexPath.row])
            exbtnLoadingView.stopLoading()
            exbtnLoadingView.isHidden = true
            return collectionsCell
        } else {
            //if (exhibitionsPageNameString == ExhbitionPageName.diningList) {
            let diningListCell = exhibitionCollectionView.dequeueReusableCell(withIdentifier: "heritageCellXibId", for: indexPath) as! HeritageTableViewCell
            diningListCell.setDiningListValues(diningList: diningListArray[indexPath.row])
            exbtnLoadingView.stopLoading()
            exbtnLoadingView.isHidden = true
            return diningListCell
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
        } else if (exhibitionsPageNameString == ExhbitionPageName.heritageList) {
            loadPublicArtsDetail(idValue: publicArtsListArray[indexPath.row].id!)
        } else if (exhibitionsPageNameString == ExhbitionPageName.museumCollectionsList) {
            loadCollectionDetail(currentRow: indexPath.row)
        } else if (exhibitionsPageNameString == ExhbitionPageName.diningList) {
            let diningId = diningListArray[indexPath.row].id
            loadDiningDetailAnimation(idValue: diningId!)
        }
        
    }

    func loadExhibitionCellPages(cellObj: ExhibitionsCollectionCell, selectedIndex: Int) {
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
    func loadCollectionDetail(currentRow: Int?) {
        let collectionDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "collectionDetailId") as! CollectionDetailViewController
        collectionDetailView.collectionName = collection[currentRow!].name?.replacingOccurrences(of: "<[^>]+>|&nbsp;|&|#039;", with: "", options: .regularExpression, range: nil)
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(collectionDetailView, animated: false, completion: nil)
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
            case .museumExhibition?,.museumCollectionsList?:
                self.dismiss(animated: false, completion: nil)
            case .diningList?:
                if (fromHome == true) {
                    let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "homeId") as! HomeViewController
                    let appDelegate = UIApplication.shared.delegate
                    appDelegate?.window??.rootViewController = homeViewController
                } else {
                    self.dismiss(animated: false, completion: nil)
                }
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
                    DispatchQueue.main.async{
                        self.exhibitionCollectionView.reloadData()
                    }
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
                    DispatchQueue.main.async{
                        self.exhibitionCollectionView.reloadData()
                    }
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
            } else if (exhibitionsPageNameString == ExhbitionPageName.publicArtsList){
                appDelegate?.getPublicArtsListDataFromServer(lang: LocalizationLanguage.currentAppleLanguage())
            } else if (exhibitionsPageNameString == ExhbitionPageName.museumCollectionsList){
                if((museumId == "63") || (museumId == "96")) {
                    appDelegate?.getCollectionList(museumId: museumId, lang: LocalizationLanguage.currentAppleLanguage())
                    
                } else {
                    self.getCollectionList()
                }
            } else if (exhibitionsPageNameString == ExhbitionPageName.museumCollectionsList){
                if(fromHome == true) {
                    appDelegate?.getDiningListFromServer(lang: LocalizationLanguage.currentAppleLanguage())
                } else {
                    self.getMuseumDiningListFromServer()
                }
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
        } else if (exhibitionsPageNameString == ExhbitionPageName.publicArtsList) {
             Analytics.setScreenName(PUBLIC_ARTS_LIST, screenClass: screenClass)
        } else if (exhibitionsPageNameString == ExhbitionPageName.museumCollectionsList) {
            Analytics.setScreenName(MUSEUM_COLLECTION, screenClass: screenClass)
        } else if (exhibitionsPageNameString == ExhbitionPageName.diningList) {
            Analytics.setScreenName(DINING_LIST, screenClass: screenClass)
        }
        
        
    }
    //MARK: Heritage Page
    //MARK: WebServiceCall
    func getHeritageDataFromServer() {
        _ = Alamofire.request(QatarMuseumRouter.HeritageList(LocalizationLanguage.currentAppleLanguage())).responseObject { (response: DataResponse<Heritages>) -> Void in
            switch response.result {
            case .success(let data):
                self.saveOrUpdateHeritageCoredata(heritageListArray: data.heritage)
                
            case .failure(let _):
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
    //MARK: PublicArts Functions
    //MARK: WebServiceCall
    func getPublicArtsListDataFromServer() {
        _ = Alamofire.request(QatarMuseumRouter.PublicArtsList(LocalizationLanguage.currentAppleLanguage())).responseObject { (response: DataResponse<PublicArtsLists>) -> Void in
            switch response.result {
            case .success(let data):
                self.saveOrUpdatePublicArtsCoredata(publicArtsListArray: data.publicArtsList, lang: LocalizationLanguage.currentAppleLanguage())
            case .failure(let error):
                print("error")
            }
        }
    }
    //MARK: Coredata Method
    func saveOrUpdatePublicArtsCoredata(publicArtsListArray:[PublicArtsList]?,lang: String?) {
        if ((publicArtsListArray?.count)! > 0) {
            let appDelegate =  UIApplication.shared.delegate as? AppDelegate
            if #available(iOS 10.0, *) {
                let container = appDelegate!.persistentContainer
                container.performBackgroundTask() {(managedContext) in
                    self.publicArtsCoreDataInBackgroundThread(managedContext: managedContext, publicArtsListArray: publicArtsListArray, lang: lang)
                }
            } else {
                let managedContext = appDelegate!.managedObjectContext
                managedContext.perform {
                    self.publicArtsCoreDataInBackgroundThread(managedContext : managedContext, publicArtsListArray: publicArtsListArray, lang: lang)
                }
            }
        }
    }
    func publicArtsCoreDataInBackgroundThread(managedContext: NSManagedObjectContext,publicArtsListArray:[PublicArtsList]?,lang: String?) {
        if (lang == ENG_LANGUAGE) {
            let fetchData = checkAddedToCoredata(entityName: "PublicArtsEntity", idKey: "id", idValue: nil, managedContext: managedContext) as! [PublicArtsEntity]
            if (fetchData.count > 0) {
                for i in 0 ... (publicArtsListArray?.count)!-1 {
                    let publicArtsListDict = publicArtsListArray![i]
                    let fetchResult = checkAddedToCoredata(entityName: "PublicArtsEntity", idKey: "id", idValue: publicArtsListArray![i].id, managedContext: managedContext)
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
                        self.saveToPublicArtsCoreData(publicArtsListDict: publicArtsListDict, managedObjContext: managedContext, lang: lang)
                        
                    }
                }
            }
            else {
                for i in 0 ... (publicArtsListArray?.count)!-1 {
                    let publicArtsListDict : PublicArtsList?
                    publicArtsListDict = publicArtsListArray?[i]
                    self.saveToPublicArtsCoreData(publicArtsListDict: publicArtsListDict!, managedObjContext: managedContext, lang: lang)
                    
                }
            }
        }
        else {
            let fetchData = checkAddedToCoredata(entityName: "PublicArtsEntityArabic", idKey: "id", idValue: nil, managedContext: managedContext) as! [PublicArtsEntityArabic]
            if (fetchData.count > 0) {
                for i in 0 ... (publicArtsListArray?.count)!-1 {
                    let publicArtsListDict = publicArtsListArray![i]
                    let fetchResult = checkAddedToCoredata(entityName: "PublicArtsEntityArabic", idKey: "id", idValue: publicArtsListArray![i].id, managedContext: managedContext)
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
                        self.saveToPublicArtsCoreData(publicArtsListDict: publicArtsListDict, managedObjContext: managedContext, lang: lang)
                        
                    }
                }
            }
            else {
                for i in 0 ... (publicArtsListArray?.count)!-1 {
                    let publicArtsListDict : PublicArtsList?
                    publicArtsListDict = publicArtsListArray?[i]
                    self.saveToPublicArtsCoreData(publicArtsListDict: publicArtsListDict!, managedObjContext: managedContext, lang: lang)
                    
                }
            }
        }
    }
    
    func saveToPublicArtsCoreData(publicArtsListDict: PublicArtsList, managedObjContext: NSManagedObjectContext,lang: String?) {
        if (lang == ENG_LANGUAGE) {
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
        let managedContext = getContext()
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                var publicArtsArray = [PublicArtsEntity]()
                let publicArtsFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "PublicArtsEntity")
                publicArtsArray = (try managedContext.fetch(publicArtsFetchRequest) as? [PublicArtsEntity])!
                if (publicArtsArray.count > 0) {
                    for i in 0 ... publicArtsArray.count-1 {
                        
                        self.publicArtsListArray.insert(PublicArtsList(id: publicArtsArray[i].id, name: publicArtsArray[i].name, latitude: publicArtsArray[i].latitude, longitude: publicArtsArray[i].longitude, image: publicArtsArray[i].image, sortcoefficient: publicArtsArray[i].sortcoefficient), at: i)
                        
                    }
                    if(publicArtsListArray.count == 0){
                        if(self.networkReachability?.isReachable == false) {
                            self.showNoNetwork()
                        } else {
                            self.exbtnLoadingView.showNoDataView()
                        }
                    }
                    exhibitionCollectionView.reloadData()
                }
                else{
                    if(self.networkReachability?.isReachable == false) {
                        self.showNoNetwork()
                    } else {
                        self.exbtnLoadingView.showNoDataView()
                    }
                }
            }
            else {
                var publicArtsArray = [PublicArtsEntityArabic]()
                let publicArtsFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "PublicArtsEntityArabic")
                publicArtsArray = (try managedContext.fetch(publicArtsFetchRequest) as? [PublicArtsEntityArabic])!
                if (publicArtsArray.count > 0) {
                    for i in 0 ... publicArtsArray.count-1 {
                        
                        self.publicArtsListArray.insert(PublicArtsList(id: publicArtsArray[i].id, name: publicArtsArray[i].namearabic, latitude: publicArtsArray[i].latitudearabic, longitude: publicArtsArray[i].longitudearabic, image: publicArtsArray[i].imagearabic, sortcoefficient: publicArtsArray[i].sortcoefficientarabic), at: i)
                        
                    }
                    if(publicArtsListArray.count == 0){
                        if(self.networkReachability?.isReachable == false) {
                            self.showNoNetwork()
                        } else {
                            self.exbtnLoadingView.showNoDataView()
                        }
                    }
                    exhibitionCollectionView.reloadData()
                }
                else{
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
    @objc func receivePublicArtsListNotificationEn(notification: NSNotification) {
        if ((LocalizationLanguage.currentAppleLanguage() == ENG_LANGUAGE ) && (publicArtsListArray.count == 0)){
            self.fetchPublicArtsListFromCoredata()
        }
    }
    @objc func receivePublicArtsListNotificationAr(notification: NSNotification) {
        if ((LocalizationLanguage.currentAppleLanguage() == AR_LANGUAGE ) && (publicArtsListArray.count == 0)){
            self.fetchPublicArtsListFromCoredata()
        }
    }
    //MARK: MuseumCollectionList Methods
    //MARK: CollectionListWebservice call
    func getCollectionList() {
        _ = Alamofire.request(QatarMuseumRouter.CollectionList(LocalizationLanguage.currentAppleLanguage(),["museum_id": museumId ?? 0])).responseObject { (response: DataResponse<Collections>) -> Void in
            switch response.result {
            case .success(let data):
                if((self.museumId != "63") && (self.museumId != "96")) {
                    self.collection = data.collections!
                    self.exbtnLoadingView.stopLoading()
                    self.exbtnLoadingView.isHidden = true
                    if (self.collection.count == 0) {
                        self.exbtnLoadingView.stopLoading()
                        self.exbtnLoadingView.noDataView.isHidden = false
                        self.exbtnLoadingView.isHidden = false
                        self.exbtnLoadingView.showNoDataView()
                    } else {
                        self.exhibitionCollectionView.reloadData()
                    }
                }
                self.saveOrUpdateCollectionCoredata(collection: data.collections)
                
            case .failure( _):
                print("error")
                if((self.museumId != "63") && (self.museumId != "96")) {
                    var errorMessage: String
                    errorMessage = String(format: NSLocalizedString("NO_RESULT_MESSAGE",
                                                                    comment: "Setting the content of the alert"))
                    self.exbtnLoadingView.stopLoading()
                    self.exbtnLoadingView.noDataView.isHidden = false
                    self.exbtnLoadingView.isHidden = false
                    self.exbtnLoadingView.showNoDataView()
                    self.exbtnLoadingView.noDataLabel.text = errorMessage
                }
            }
        }
    }
    //MARK: CollectionList Coredata Method
    func saveOrUpdateCollectionCoredata(collection: [Collection]?) {
        if ((collection?.count)! > 0) {
            let appDelegate =  UIApplication.shared.delegate as? AppDelegate
            if #available(iOS 10.0, *) {
                let container = appDelegate!.persistentContainer
                container.performBackgroundTask() {(managedContext) in
                    self.coreDataInBackgroundThread(managedContext: managedContext, collection: collection!)
                }
            } else {
                let managedContext = appDelegate!.managedObjectContext
                managedContext.perform {
                    self.coreDataInBackgroundThread(managedContext : managedContext, collection: collection!)
                }
            }
        }
    }
    func coreDataInBackgroundThread(managedContext: NSManagedObjectContext,collection: [Collection]?) {
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            let fetchData = checkAddedToCoredata(entityName: "CollectionsEntity", idKey: "museumId", idValue: nil, managedContext: managedContext) as! [CollectionsEntity]
            if (fetchData.count > 0) {
                let isDeleted = self.deleteExistingEntityData(managedContext: managedContext, entityName: "CollectionsEntity")
                if(isDeleted == true) {
                    for i in 0 ... (collection?.count)!-1 {
                        let collectionListDict : Collection?
                        collectionListDict = collection?[i]
                        self.saveToCoreData(collectionListDict: collectionListDict!, managedObjContext: managedContext)
                    }
                    
                }
            }
            else {
                for i in 0 ... (collection?.count)!-1 {
                    let collectionListDict : Collection?
                    collectionListDict = collection?[i]
                    self.saveToCoreData(collectionListDict: collectionListDict!, managedObjContext: managedContext)
                }
            }
        } else { // For Arabic Database
            let fetchData = checkAddedToCoredata(entityName: "CollectionsEntityArabic", idKey: "museumId", idValue: nil, managedContext: managedContext) as! [CollectionsEntityArabic]
            if (fetchData.count > 0) {
                let isDeleted = self.deleteExistingEntityData(managedContext: managedContext, entityName: "CollectionsEntityArabic")
                if(isDeleted == true) {
                    for i in 0 ... (collection?.count)!-1 {
                        let collectionListDict : Collection?
                        collectionListDict = collection?[i]
                        self.saveToCoreData(collectionListDict: collectionListDict!, managedObjContext: managedContext)
                    }
                }
            }
            else {
                for i in 0 ... (collection?.count)!-1 {
                    let collectionListDict : Collection?
                    collectionListDict = collection?[i]
                    self.saveToCoreData(collectionListDict: collectionListDict!, managedObjContext: managedContext)
                }
            }
        }
    }
    func saveToCoreData(collectionListDict: Collection, managedObjContext: NSManagedObjectContext) {
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            let collectionInfo: CollectionsEntity = NSEntityDescription.insertNewObject(forEntityName: "CollectionsEntity", into: managedObjContext) as! CollectionsEntity
            collectionInfo.listName = collectionListDict.name?.replacingOccurrences(of: "<[^>]+>|&nbsp;", with: "", options: .regularExpression, range: nil)
            collectionInfo.listImage = collectionListDict.image
            collectionInfo.museumId = collectionListDict.museumId
            
        }
        else {
            let collectionInfo: CollectionsEntityArabic = NSEntityDescription.insertNewObject(forEntityName: "CollectionsEntityArabic", into: managedObjContext) as! CollectionsEntityArabic
            collectionInfo.listName = collectionListDict.name?.replacingOccurrences(of: "<[^>]+>|&nbsp;|&|#039;", with: "", options: .regularExpression, range: nil)
            collectionInfo.listImageAr = collectionListDict.image
            collectionInfo.museumId = collectionListDict.museumId
        }
        do {
            try managedObjContext.save()
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func fetchCollectionListFromCoredata() {
        let managedContext = getContext()
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                var collectionArray = [CollectionsEntity]()
                collectionArray = checkAddedToCoredata(entityName: "CollectionsEntity", idKey: "museumId", idValue: museumId, managedContext: managedContext) as! [CollectionsEntity]
                if (collectionArray.count > 0) {
                    for i in 0 ... collectionArray.count-1 {
                        self.collection.insert(Collection(name: collectionArray[i].listName?.replacingOccurrences(of: "<[^>]+>|&nbsp;|&|#039;", with: "", options: .regularExpression, range: nil), image: collectionArray[i].listImage, museumId: collectionArray[i].museumId), at: i)
                        
                    }
                    if(collection.count == 0){
                        if(self.networkReachability?.isReachable == false) {
                            self.showNoNetwork()
                        } else {
                            self.exbtnLoadingView.showNoDataView()
                        }
                    }
                    exhibitionCollectionView.reloadData()
                }
                else{
                    if(self.networkReachability?.isReachable == false) {
                        self.showNoNetwork()
                    } else {
                        self.exbtnLoadingView.showNoDataView()
                    }
                }
            }
            else {
                var collectionArray = [CollectionsEntityArabic]()
                collectionArray = checkAddedToCoredata(entityName: "CollectionsEntityArabic", idKey: "museumId", idValue: museumId, managedContext: managedContext) as! [CollectionsEntityArabic]
                if (collectionArray.count > 0) {
                    for i in 0 ... collectionArray.count-1 {
                        
                        self.collection.insert(Collection(name: collectionArray[i].listName?.replacingOccurrences(of: "<[^>]+>|&nbsp;|&|#039;", with: "", options: .regularExpression, range: nil), image: collectionArray[i].listImageAr, museumId: collectionArray[i].museumId), at: i)
                    }
                    if(collection.count == 0){
                        if(self.networkReachability?.isReachable == false) {
                            self.showNoNetwork()
                        } else {
                            self.exbtnLoadingView.showNoDataView()
                        }
                    }
                    exhibitionCollectionView.reloadData()
                }
                else{
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
    func deleteExistingEntityData(managedContext:NSManagedObjectContext,entityName : String?) ->Bool? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName!)
        let deleteRequest = NSBatchDeleteRequest( fetchRequest: fetchRequest)
        do{
            try managedContext.execute(deleteRequest)
            return true
        }catch _ as NSError {
            return false
        }
        
    }
    @objc func receiveCollectionListNotificationEn(notification: NSNotification) {
        if ((LocalizationLanguage.currentAppleLanguage() == ENG_LANGUAGE ) && (collection.count == 0)){
            self.fetchCollectionListFromCoredata()
        }
    }
    @objc func receiveCollectionListNotificationAr(notification: NSNotification) {
        if ((LocalizationLanguage.currentAppleLanguage() == AR_LANGUAGE ) && (collection.count == 0)){
            self.fetchCollectionListFromCoredata()
        }
    }
    //MARK: DiningList Methods
    //MARK: DiningList WebServiceCall
    func getDiningListFromServer()
    {
        _ = Alamofire.request(QatarMuseumRouter.DiningList(LocalizationLanguage.currentAppleLanguage())).responseObject { (response: DataResponse<Dinings>) -> Void in
            switch response.result {
            case .success(let data):
                self.saveOrUpdateDiningCoredata(diningListArray: data.dinings, lang: LocalizationLanguage.currentAppleLanguage())
            case .failure( _):
                print("error")
            }
        }
    }
    //MARK: Museum DiningWebServiceCall
    func getMuseumDiningListFromServer()
    {
        _ = Alamofire.request(QatarMuseumRouter.MuseumDiningList(["museum_id": museumId ?? 0])).responseObject { (response: DataResponse<Dinings>) -> Void in
            switch response.result {
            case .success(let data):
                self.saveOrUpdateDiningCoredata(diningListArray: data.dinings, lang: LocalizationLanguage.currentAppleLanguage())
            case .failure( _):
                print("error")
            }
        }
    }
    //MARK: Dining Coredata Method
    func saveOrUpdateDiningCoredata(diningListArray : [Dining]?,lang: String?) {
        if ((diningListArray?.count)! > 0) {
            let appDelegate =  UIApplication.shared.delegate as? AppDelegate
            if #available(iOS 10.0, *) {
                let container = appDelegate?.persistentContainer
                container?.performBackgroundTask() {(managedContext) in
                    self.diningCoreDataInBackgroundThread(managedContext: managedContext, diningListArray: diningListArray!, lang: lang)
                }
            } else {
                let managedContext = appDelegate?.managedObjectContext
                managedContext?.perform {
                    self.diningCoreDataInBackgroundThread(managedContext : managedContext!, diningListArray: diningListArray!, lang: lang)
                }
            }
        }
    }
    
    func diningCoreDataInBackgroundThread(managedContext: NSManagedObjectContext,diningListArray : [Dining]?,lang: String?) {
        if (lang == ENG_LANGUAGE) {
            let fetchData = checkAddedToCoredata(entityName: "DiningEntity", idKey: "id", idValue: nil, managedContext: managedContext) as! [DiningEntity]
            if (fetchData.count > 0) {
                for i in 0 ... (diningListArray?.count)!-1 {
                    let diningListDict = diningListArray![i]
                    let fetchResult = checkAddedToCoredata(entityName: "DiningEntity", idKey: "id", idValue: diningListArray![i].id, managedContext: managedContext)
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
                        self.saveToDiningCoreData(diningListDict: diningListDict, managedObjContext: managedContext, lang: lang)
                        
                    }
                }
            }
            else {
                for i in 0 ... (diningListArray?.count)!-1 {
                    let diningListDict : Dining?
                    diningListDict = diningListArray?[i]
                    self.saveToDiningCoreData(diningListDict: diningListDict!, managedObjContext: managedContext, lang: lang)
                }
            }
        } else {
            let fetchData = checkAddedToCoredata(entityName: "DiningEntityArabic", idKey: "id", idValue: nil, managedContext: managedContext) as! [DiningEntityArabic]
            if (fetchData.count > 0) {
                for i in 0 ... (diningListArray?.count)!-1 {
                    let diningListDict = diningListArray![i]
                    let fetchResult = checkAddedToCoredata(entityName: "DiningEntityArabic", idKey: "id" , idValue: diningListArray![i].id, managedContext: managedContext)
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
                        self.saveToDiningCoreData(diningListDict: diningListDict, managedObjContext: managedContext, lang: lang)
                        
                    }
                }
            }
            else {
                for i in 0 ... (diningListArray?.count)!-1 {
                    let diningListDict : Dining?
                    diningListDict = diningListArray?[i]
                    self.saveToDiningCoreData(diningListDict: diningListDict!, managedObjContext: managedContext, lang: lang)
                    
                }
            }
        }
    }
    
    func saveToDiningCoreData(diningListDict: Dining, managedObjContext: NSManagedObjectContext,lang: String?) {
        if (lang == ENG_LANGUAGE) {
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
        let managedContext = getContext()
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                var diningArray = [DiningEntity]()
                diningArray = checkAddedToCoredata(entityName: "DiningEntity", idKey: "museumId", idValue: museumId, managedContext: managedContext) as! [DiningEntity]
                
                if (diningArray.count > 0) {
                    for i in 0 ... diningArray.count-1 {
                        self.diningListArray.insert(Dining(id: diningArray[i].id, name: diningArray[i].name, location: diningArray[i].location, description: diningArray[i].diningdescription, image: diningArray[i].image, openingtime: diningArray[i].openingtime, closetime: diningArray[i].closetime, sortid: diningArray[i].sortid,museumId: diningArray[i].museumId, images: nil), at: i)
                    }
                    if(diningListArray.count == 0){
                        self.showNoNetwork()
                    }
                    DispatchQueue.main.async{
                        self.exhibitionCollectionView.reloadData()
                    }
                } else{
                    self.showNoNetwork()
                }
            } else {
                var diningArray = [DiningEntityArabic]()
                diningArray = checkAddedToCoredata(entityName: "DiningEntityArabic", idKey: "museumId", idValue: museumId, managedContext: managedContext) as! [DiningEntityArabic]
                if (diningArray.count > 0) {
                    for i in 0 ... diningArray.count-1 {
                        
                        self.diningListArray.insert(Dining(id: diningArray[i].id, name: diningArray[i].namearabic, location: diningArray[i].locationarabic, description: diningArray[i].descriptionarabic, image: diningArray[i].imagearabic, openingtime: diningArray[i].openingtimearabic, closetime: diningArray[i].closetimearabic, sortid: diningArray[i].sortidarabic,museumId: diningArray[i].museumId, images: nil), at: i)
                    }
                    if(diningListArray.count == 0){
                        self.showNoNetwork()
                    }
                    DispatchQueue.main.async{
                        self.exhibitionCollectionView.reloadData()
                    }
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
        let managedContext = getContext()
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                var diningArray = [DiningEntity]()
                let homeFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "DiningEntity")
                diningArray = (try managedContext.fetch(homeFetchRequest) as? [DiningEntity])!
                if (diningArray.count > 0) {
                    for i in 0 ... diningArray.count-1 {
                        self.diningListArray.insert(Dining(id: diningArray[i].id, name: diningArray[i].name, location: diningArray[i].location, description: diningArray[i].diningdescription, image: diningArray[i].image, openingtime: diningArray[i].openingtime, closetime: diningArray[i].closetime, sortid: diningArray[i].sortid,museumId: diningArray[i].museumId, images: nil), at: i)
                        
                    }
                    if(diningListArray.count == 0){
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
                var diningArray = [DiningEntityArabic]()
                let diningFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "DiningEntityArabic")
                diningArray = (try managedContext.fetch(diningFetchRequest) as? [DiningEntityArabic])!
                if (diningArray.count > 0) {
                    for i in 0 ... diningArray.count-1 {
                        self.diningListArray.insert(Dining(id: diningArray[i].id, name: diningArray[i].namearabic, location: diningArray[i].locationarabic, description: diningArray[i].descriptionarabic, image: diningArray[i].imagearabic, openingtime: diningArray[i].openingtimearabic, closetime: diningArray[i].closetimearabic, sortid: diningArray[i].sortidarabic,museumId: diningArray[i].museumId, images: nil), at: i)
                    }
                    if(diningListArray.count == 0){
                        if(self.networkReachability?.isReachable == false) {
                            self.showNoNetwork()
                        } else {
                            self.exbtnLoadingView.showNoDataView()
                        }
                    }
                    DispatchQueue.main.async{
                        self.exhibitionCollectionView.reloadData()
                    }
                }
                else{
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//
//  ParkListViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 19/03/19.
//  Copyright © 2019 Wakralab. All rights reserved.
//

import Alamofire
import CoreData
import MapKit
import UIKit

class ParkListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, HeaderViewProtocol,comingSoonPopUpProtocol,LoadingViewProtocol {
    
    @IBOutlet weak var headerView: CommonHeaderView!
    @IBOutlet weak var parkTableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
    var nmoqParkList: [NMoQParksList]! = []
    var nmoqParks: [NMoQPark]! = []
    let networkReachability = NetworkReachabilityManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setUI()
    }
    func setUI() {
        loadingView.isHidden = false
        loadingView.showLoading()
        loadingView.loadingViewDelegate = self
        headerView.headerViewDelegate = self
        headerView.headerTitle.text = NSLocalizedString("PARKS_HEADER_LABEL", comment: "PARKS_HEADER_LABEL Label in the Exhibitions page").uppercased()
        fetchNmoqParkListFromCoredata()
        fetchNmoqParkFromCoredata()
        NotificationCenter.default.addObserver(self, selector: #selector(ParkListViewController.receiveNmoqParkListNotificationEn(notification:)), name: NSNotification.Name(heritageListNotificationEn), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ParkListViewController.receiveNmoqParkListNotificationAr(notification:)), name: NSNotification.Name(heritageListNotificationAr), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ParkListViewController.receiveNmoqParkNotificationEn(notification:)), name: NSNotification.Name(nmoqParkNotificationEn), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ParkListViewController.receiveNmoqParkNotificationAr(notification:)), name: NSNotification.Name(nmoqParkNotificationAr), object: nil)
        if  (networkReachability?.isReachable)! {
            DispatchQueue.global(qos: .background).async {
                self.getNmoqParkListFromServer()
                self.getNmoqListOfParksFromServer()
            }
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func registerCell() {
        self.parkTableView.register(UINib(nibName: "ParkListView", bundle: nil), forCellReuseIdentifier: "parkListCellId")
        self.parkTableView.register(UINib(nibName: "NMoQListCell", bundle: nil), forCellReuseIdentifier: "nMoQListCellId")
        parkTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (nmoqParkList.count > 0) {
            return 2 + nmoqParks.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.loadingView.stopLoading()
        self.loadingView.isHidden = true
        if (indexPath.row == 0) {
            let cell = parkTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as UITableViewCell
            cell.textLabel?.numberOfLines = 0
            cell.selectionStyle = .none
            cell.textLabel?.textAlignment = .center
            cell.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
            cell.textLabel!.font = UIFont.collectionFirstDescriptionFont
            
            cell.textLabel?.text = nmoqParkList[0].mainDescription?.replacingOccurrences(of: "<[^>]+>|&nbsp;", with: "", options: .regularExpression, range: nil)
            return cell
        } else if indexPath.row > nmoqParks.count {
            let parkListSecondCell = parkTableView.dequeueReusableCell(withIdentifier: "parkListCellId", for: indexPath) as! ParkListTableViewCell
            parkListSecondCell.selectionStyle = .none
            parkListSecondCell.setParkListValues(parkListData: nmoqParkList[0])
            parkListSecondCell.loadMapView = {
                () in
                self.loadLocationMap(mobileLatitude: self.nmoqParkList[0].latitude, mobileLongitude: self.nmoqParkList[0].longitude)
            }
            return parkListSecondCell
        } else {
            let parkListCell = tableView.dequeueReusableCell(withIdentifier: "nMoQListCellId", for: indexPath) as! NMoQListCell
            parkListCell.selectionStyle = .none
            if (nmoqParks.count > 0) {
                parkListCell.setParkListData(parkList: nmoqParks[indexPath.row - 1])
            }
            
            return parkListCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ((indexPath.row == 1) || (indexPath.row == 2)) {
            let heightValue = UIScreen.main.bounds.height/100
            return heightValue*27
        } else {
            return UITableViewAutomaticDimension
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 1) {
            loadParkPlayGroundDetail()
        } else if (indexPath.row == 2) {
           loadParkHeritageGardenDetail()
        }
    }
    func loadParkPlayGroundDetail() {
        let collectionDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "collectionDetailId") as! CollectionDetailViewController
       // collectionDetailView.collectionName = collection[currentRow!].name?.replacingOccurrences(of: "<[^>]+>|&nbsp;|&|#039;", with: "", options: .regularExpression, range: nil)
        collectionDetailView.collectionPageNameString = CollectionPageName.PlayGroundPark
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(collectionDetailView, animated: false, completion: nil)
    }
    func loadParkHeritageGardenDetail() {
        let parksView =  self.storyboard?.instantiateViewController(withIdentifier: "parkViewId") as! ParksViewController
        parksView.parkPageNameString = ParkPageName.NMoQPark
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(parksView, animated: false, completion: nil)
    }
    func loadLocationMap( mobileLatitude: String?, mobileLongitude: String? ) {
        if (mobileLatitude != nil && mobileLatitude != "" && mobileLongitude != nil && mobileLongitude != "") {
            let latitudeString = (mobileLatitude)!
            let longitudeString = (mobileLongitude)!
            var latitude : Double?
            var longitude : Double?
            if let lat : Double = Double(latitudeString) {
                latitude = lat
            }
            if let long : Double = Double(longitudeString) {
                longitude = long
            }
            
            let destinationLocation = CLLocationCoordinate2D(latitude: latitude!,
                                                             longitude: longitude!)
            let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
            let destination = MKMapItem(placemark: destinationPlacemark)
            
            let detailStoryboard: UIStoryboard = UIStoryboard(name: "DetailPageStoryboard", bundle: nil)
            
            let mapDetailView = detailStoryboard.instantiateViewController(withIdentifier: "mapViewId") as! MapViewController
            mapDetailView.latitudeString = mobileLatitude
            mapDetailView.longiudeString = mobileLongitude
            mapDetailView.destination = destination
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = kCATransitionFade
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            self.present(mapDetailView, animated: false, completion: nil)
        }
        else {
            showLocationErrorPopup()
        }
    }
    
    func getNmoqParkListFromServer() {
        _ = Alamofire.request(QatarMuseumRouter.GetNmoqParkList(LocalizationLanguage.currentAppleLanguage())).responseObject { (response: DataResponse<NmoqParksLists>) -> Void in
            switch response.result {
            case .success(let data):
                self.saveOrUpdateNmoqParkListCoredata(nmoqParkList: data.nmoqParkList)
            case .failure( _):
                print("error")
            }
        }
    }
    
    func getNmoqListOfParksFromServer() {
        _ = Alamofire.request(QatarMuseumRouter.GetNmoqListParks(LocalizationLanguage.currentAppleLanguage())).responseObject { (response: DataResponse<NMoQParks>) -> Void in
            switch response.result {
            case .success(let data):
                print(data)
                self.saveOrUpdateNmoqParksCoredata(nmoqParkList: data.nmoqParks)
            case .failure( _):
                print("error")
            }
        }
    }
    
    //MARK: NMoqPark List Coredata Method
    func saveOrUpdateNmoqParkListCoredata(nmoqParkList:[NMoQParksList]?) {
        if ((nmoqParkList?.count)! > 0) {
            let appDelegate =  UIApplication.shared.delegate as? AppDelegate
            if #available(iOS 10.0, *) {
                let container = appDelegate!.persistentContainer
                container.performBackgroundTask() {(managedContext) in
                    self.nmoqParkListCoreDataInBackgroundThread(nmoqParkList: nmoqParkList, managedContext: managedContext)
                }
            } else {
                let managedContext = appDelegate!.managedObjectContext
                managedContext.perform {
                    self.nmoqParkListCoreDataInBackgroundThread(nmoqParkList: nmoqParkList, managedContext : managedContext)
                }
            }
        }
    }
    func nmoqParkListCoreDataInBackgroundThread(nmoqParkList:[NMoQParksList]?,managedContext: NSManagedObjectContext) {
        if (LocalizationLanguage.currentAppleLanguage() == ENG_LANGUAGE) {
            let fetchData = checkAddedToCoredata(entityName: "NMoQParkListEntity", idKey: "nid", idValue: nil, managedContext: managedContext) as! [NMoQParkListEntity]
            if (fetchData.count > 0) {
                for i in 0 ... (nmoqParkList?.count)!-1 {
                    let nmoqParkListDict = nmoqParkList![i]
                    let fetchResult = checkAddedToCoredata(entityName: "NMoQParkListEntity", idKey: "nid", idValue: nmoqParkListDict.nid, managedContext: managedContext)
                    //update
                    if(fetchResult.count != 0) {
                        let nmoqParkListdbDict = fetchResult[0] as! NMoQParkListEntity
                        nmoqParkListdbDict.title = nmoqParkListDict.title
                        nmoqParkListdbDict.parkTitle = nmoqParkListDict.parkTitle
                        nmoqParkListdbDict.mainDescription = nmoqParkListDict.mainDescription
                        nmoqParkListdbDict.parkDescription =  nmoqParkListDict.parkDescription
                        nmoqParkListdbDict.hoursTitle = nmoqParkListDict.hoursTitle
                        nmoqParkListdbDict.hoursDesc = nmoqParkListDict.hoursDesc
                        nmoqParkListdbDict.nid =  nmoqParkListDict.nid
                        nmoqParkListdbDict.longitude = nmoqParkListDict.longitude
                        nmoqParkListdbDict.latitude = nmoqParkListDict.latitude
                        nmoqParkListdbDict.locationTitle =  nmoqParkListDict.locationTitle
                        
                        //                        if(facilitiesListDict.images != nil){
                        //                            if((facilitiesListDict.images?.count)! > 0) {
                        //                                for i in 0 ... (facilitiesListDict.images?.count)!-1 {
                        //                                    var facilitiesImage: FacilitiesImgEntity!
                        //                                    let facilitiesImgaeArray: FacilitiesImgEntity = NSEntityDescription.insertNewObject(forEntityName: "FacilitiesImgEntity", into: managedContext) as! FacilitiesImgEntity
                        //                                    facilitiesImgaeArray.images = facilitiesListDict.images![i]
                        //
                        //                                    facilitiesImage = facilitiesImgaeArray
                        //                                    facilitiesListdbDict.addToFacilitiesImgRelation(facilitiesImage)
                        //                                    do {
                        //                                        try managedContext.save()
                        //                                    } catch let error as NSError {
                        //                                        print("Could not save. \(error), \(error.userInfo)")
                        //                                    }
                        //                                }
                        //                            }
                        //                        }
                        
                        do{
                            try managedContext.save()
                        }
                        catch{
                            print(error)
                        }
                    } else {
                        //save
                        self.saveNmoqParkListToCoreData(nmoqParkListDict: nmoqParkListDict, managedObjContext: managedContext)
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(facilitiesListNotificationEn), object: self)
            } else {
                for i in 0 ... (nmoqParkList?.count)!-1 {
                    let nmoqParkListDict : NMoQParksList?
                    nmoqParkListDict = nmoqParkList?[i]
                    self.saveNmoqParkListToCoreData(nmoqParkListDict: nmoqParkListDict!, managedObjContext: managedContext)
                }
                NotificationCenter.default.post(name: NSNotification.Name(facilitiesListNotificationEn), object: self)
            }
        } else {
            let fetchData = checkAddedToCoredata(entityName: "NMoQParkListEntityAr", idKey: "nid", idValue: nil, managedContext: managedContext) as! [NMoQParkListEntityAr]
            if (fetchData.count > 0) {
                for i in 0 ... (nmoqParkList?.count)!-1 {
                    let nmoqParkListDict = nmoqParkList![i]
                    let fetchResult = checkAddedToCoredata(entityName: "NMoQParkListEntityAr", idKey: "nid", idValue: nmoqParkListDict.nid, managedContext: managedContext)
                    //update
                    if(fetchResult.count != 0) {
                        let nmoqParkListdbDict = fetchResult[0] as! NMoQParkListEntityAr
                        nmoqParkListdbDict.title = nmoqParkListDict.title
                        nmoqParkListdbDict.parkTitle = nmoqParkListDict.parkTitle
                        nmoqParkListdbDict.mainDescription = nmoqParkListDict.mainDescription
                        nmoqParkListdbDict.parkDescription =  nmoqParkListDict.parkDescription
                        nmoqParkListdbDict.hoursTitle = nmoqParkListDict.hoursTitle
                        nmoqParkListdbDict.hoursDesc = nmoqParkListDict.hoursDesc
                        nmoqParkListdbDict.nid =  nmoqParkListDict.nid
                        nmoqParkListdbDict.longitude = nmoqParkListDict.longitude
                        nmoqParkListdbDict.latitude = nmoqParkListDict.latitude
                        nmoqParkListdbDict.locationTitle =  nmoqParkListDict.locationTitle
                        
                        //                        if(facilitiesListDict.images != nil){
                        //                            if((facilitiesListDict.images?.count)! > 0) {
                        //                                for i in 0 ... (facilitiesListDict.images?.count)!-1 {
                        //                                    var facilitiesImage: FacilitiesImgEntityAr!
                        //                                    let facilitiesImgaeArray: FacilitiesImgEntityAr = NSEntityDescription.insertNewObject(forEntityName: "FacilitiesImgEntityAr", into: managedContext) as! FacilitiesImgEntityAr
                        //                                    facilitiesImgaeArray.images = facilitiesListDict.images?[i]
                        //
                        //                                    facilitiesImage = facilitiesImgaeArray
                        //                                    facilitiesListdbDict.addToFacilitiesImgRelationAr(facilitiesImage)
                        //                                    do {
                        //                                        try managedContext.save()
                        //                                    } catch let error as NSError {
                        //                                        print("Could not save. \(error), \(error.userInfo)")
                        //                                    }
                        //                                }
                        //                            }
                        //                        }
                        
                        do{
                            try managedContext.save()
                        }
                        catch{
                            print(error)
                        }
                    } else {
                        //save
                        self.saveNmoqParkListToCoreData(nmoqParkListDict: nmoqParkListDict, managedObjContext: managedContext)
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(facilitiesListNotificationAr), object: self)
            } else {
                for i in 0 ... (nmoqParkList?.count)!-1 {
                    let nmoqParkListDict : NMoQParksList?
                    nmoqParkListDict = nmoqParkList![i]
                    self.saveNmoqParkListToCoreData(nmoqParkListDict: nmoqParkListDict!, managedObjContext: managedContext)
                }
                NotificationCenter.default.post(name: NSNotification.Name(facilitiesListNotificationAr), object: self)
            }
        }
    }
    func saveNmoqParkListToCoreData(nmoqParkListDict: NMoQParksList, managedObjContext: NSManagedObjectContext) {
        if (LocalizationLanguage.currentAppleLanguage() == ENG_LANGUAGE) {
            let nmoqParkListdbDict: NMoQParkListEntity = NSEntityDescription.insertNewObject(forEntityName: "NMoQParkListEntity", into: managedObjContext) as! NMoQParkListEntity
            nmoqParkListdbDict.title = nmoqParkListDict.title
            nmoqParkListdbDict.parkTitle = nmoqParkListDict.parkTitle
            nmoqParkListdbDict.mainDescription = nmoqParkListDict.mainDescription
            nmoqParkListdbDict.parkDescription =  nmoqParkListDict.parkDescription
            nmoqParkListdbDict.hoursTitle = nmoqParkListDict.hoursTitle
            nmoqParkListdbDict.hoursDesc = nmoqParkListDict.hoursDesc
            nmoqParkListdbDict.nid =  nmoqParkListDict.nid
            nmoqParkListdbDict.longitude = nmoqParkListDict.longitude
            nmoqParkListdbDict.latitude = nmoqParkListDict.latitude
            nmoqParkListdbDict.locationTitle =  nmoqParkListDict.locationTitle
            
            
            //            if(facilitiesListDict.images != nil){
            //                if((facilitiesListDict.images?.count)! > 0) {
            //                    for i in 0 ... (facilitiesListDict.images?.count)!-1 {
            //                        var facilitiesImage: FacilitiesImgEntity!
            //                        let facilitiesImgaeArray: FacilitiesImgEntity = NSEntityDescription.insertNewObject(forEntityName: "FacilitiesImgEntity", into: managedObjContext) as! FacilitiesImgEntity
            //                        facilitiesImgaeArray.images = facilitiesListDict.images![i]
            //
            //                        facilitiesImage = facilitiesImgaeArray
            //                        facilitiesListInfo.addToFacilitiesImgRelation(facilitiesImage)
            //                        do {
            //                            try managedObjContext.save()
            //                        } catch let error as NSError {
            //                            print("Could not save. \(error), \(error.userInfo)")
            //                        }
            //                    }
            //                }
            //            }
        } else {
            let nmoqParkListdbDict: NMoQParkListEntityAr = NSEntityDescription.insertNewObject(forEntityName: "NMoQParkListEntityAr", into: managedObjContext) as! NMoQParkListEntityAr
            nmoqParkListdbDict.title = nmoqParkListDict.title
            nmoqParkListdbDict.parkTitle = nmoqParkListDict.parkTitle
            nmoqParkListdbDict.mainDescription = nmoqParkListDict.mainDescription
            nmoqParkListdbDict.parkDescription =  nmoqParkListDict.parkDescription
            nmoqParkListdbDict.hoursTitle = nmoqParkListDict.hoursTitle
            nmoqParkListdbDict.hoursDesc = nmoqParkListDict.hoursDesc
            nmoqParkListdbDict.nid =  nmoqParkListDict.nid
            nmoqParkListdbDict.longitude = nmoqParkListDict.longitude
            nmoqParkListdbDict.latitude = nmoqParkListDict.latitude
            nmoqParkListdbDict.locationTitle =  nmoqParkListDict.locationTitle
            
            
            //            if(facilitiesListDict.images != nil){
            //                if((facilitiesListDict.images?.count)! > 0) {
            //                    for i in 0 ... (facilitiesListDict.images?.count)!-1 {
            //                        var facilitiesImage: FacilitiesImgEntityAr!
            //                        let facilitiesImgaeArray: FacilitiesImgEntityAr = NSEntityDescription.insertNewObject(forEntityName: "FacilitiesImgEntityAr", into: managedObjContext) as! FacilitiesImgEntityAr
            //                        facilitiesImgaeArray.images = facilitiesListDict.images?[i]
            //
            //                        facilitiesImage = facilitiesImgaeArray
            //                        facilitiesListInfo.addToFacilitiesImgRelationAr(facilitiesImage)
            //                        do {
            //                            try managedObjContext.save()
            //                        } catch let error as NSError {
            //                            print("Could not save. \(error), \(error.userInfo)")
            //                        }
            //                    }
            //                }
            //            }
        }
        do {
            try managedObjContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: NMoq List of Parks Coredata Method
    func saveOrUpdateNmoqParksCoredata(nmoqParkList:[NMoQPark]?) {
        if ((nmoqParkList?.count)! > 0) {
            let appDelegate =  UIApplication.shared.delegate as? AppDelegate
            if #available(iOS 10.0, *) {
                let container = appDelegate!.persistentContainer
                container.performBackgroundTask() {(managedContext) in
                    self.nmoqParkCoreDataInBackgroundThread(nmoqParkList: nmoqParkList, managedContext: managedContext)
                }
            } else {
                let managedContext = appDelegate!.managedObjectContext
                managedContext.perform {
                    self.nmoqParkCoreDataInBackgroundThread(nmoqParkList: nmoqParkList, managedContext : managedContext)
                }
            }
        }
    }
    
    func nmoqParkCoreDataInBackgroundThread(nmoqParkList:[NMoQPark]?,managedContext: NSManagedObjectContext) {
        if (LocalizationLanguage.currentAppleLanguage() == ENG_LANGUAGE) {
            let fetchData = checkAddedToCoredata(entityName: "NMoQParksEntity", idKey: "nid", idValue: nil, managedContext: managedContext) as! [NMoQParksEntity]
            if (fetchData.count > 0) {
                for i in 0 ... (nmoqParkList?.count)!-1 {
                    let nmoqParkListDict = nmoqParkList![i]
                    let fetchResult = checkAddedToCoredata(entityName: "NMoQParksEntity", idKey: "nid", idValue: nmoqParkListDict.nid, managedContext: managedContext)
                    //update
                    if(fetchResult.count != 0) {
                        let nmoqParkListdbDict = fetchResult[0] as! NMoQParksEntity
                        nmoqParkListdbDict.title = nmoqParkListDict.title
                        nmoqParkListdbDict.nid =  nmoqParkListDict.nid
                        nmoqParkListdbDict.sortId =  nmoqParkListDict.sortId

                        if(nmoqParkListDict.images != nil){
                            if((nmoqParkListDict.images?.count)! > 0) {
                                for i in 0 ... (nmoqParkListDict.images?.count)!-1 {
                                    var parkListImage: NMoQParkImgEntity!
                                    let parkListImageArray: NMoQParkImgEntity = NSEntityDescription.insertNewObject(forEntityName: "NMoQParkImgEntity", into: managedContext) as! NMoQParkImgEntity
                                    parkListImageArray.images = nmoqParkListDict.images![i]
                                    
                                    parkListImage = parkListImageArray
                                    nmoqParkListdbDict.addToParkImgRelation(parkListImage)
                                    do {
                                        try managedContext.save()
                                    } catch let error as NSError {
                                        print("Could not save. \(error), \(error.userInfo)")
                                    }
                                }
                            }
                        }
                        
                        do{
                            try managedContext.save()
                        }
                        catch{
                            print(error)
                        }
                    } else {
                        //save
                        self.saveNmoqParkToCoreData(nmoqParkListDict: nmoqParkListDict, managedObjContext: managedContext)
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(nmoqParkNotificationEn), object: self)
            } else {
                for i in 0 ... (nmoqParkList?.count)!-1 {
                    let nmoqParkListDict : NMoQPark?
                    nmoqParkListDict = nmoqParkList?[i]
                    self.saveNmoqParkToCoreData(nmoqParkListDict: nmoqParkListDict!, managedObjContext: managedContext)
                }
                NotificationCenter.default.post(name: NSNotification.Name(nmoqParkNotificationEn), object: self)
            }
        } else {
            let fetchData = checkAddedToCoredata(entityName: "NMoQParksEntityAr", idKey: "nid", idValue: nil, managedContext: managedContext) as! [NMoQParksEntityAr]
            if (fetchData.count > 0) {
                for i in 0 ... (nmoqParkList?.count)!-1 {
                    let nmoqParkListDict = nmoqParkList![i]
                    let fetchResult = checkAddedToCoredata(entityName: "NMoQParksEntityAr", idKey: "nid", idValue: nmoqParkListDict.nid, managedContext: managedContext)
                    //update
                    if(fetchResult.count != 0) {
                        let nmoqParkListdbDict = fetchResult[0] as! NMoQParksEntityAr
                        nmoqParkListdbDict.title = nmoqParkListDict.title
                        nmoqParkListdbDict.nid =  nmoqParkListDict.nid
                        nmoqParkListdbDict.sortId =  nmoqParkListDict.sortId
                        if(nmoqParkListDict.images != nil){
                            if((nmoqParkListDict.images?.count)! > 0) {
                                for i in 0 ... (nmoqParkListDict.images?.count)!-1 {
                                    var parkListImage: NMoQParkImgEntityAr!
                                    let parkListImageArray: NMoQParkImgEntityAr = NSEntityDescription.insertNewObject(forEntityName: "NMoQParkImgEntityAr", into: managedContext) as! NMoQParkImgEntityAr
                                    parkListImageArray.images = nmoqParkListDict.images![i]
                                    
                                    parkListImage = parkListImageArray
                                    nmoqParkListdbDict.addToParkImgRelationAr(parkListImage)
                                    do {
                                        try managedContext.save()
                                    } catch let error as NSError {
                                        print("Could not save. \(error), \(error.userInfo)")
                                    }
                                }
                            }
                        }
                        do{
                            try managedContext.save()
                        }
                        catch{
                            print(error)
                        }
                    } else {
                        //save
                        self.saveNmoqParkToCoreData(nmoqParkListDict: nmoqParkListDict, managedObjContext: managedContext)
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(nmoqParkNotificationAr), object: self)
            } else {
                for i in 0 ... (nmoqParkList?.count)!-1 {
                    let nmoqParkListDict : NMoQPark?
                    nmoqParkListDict = nmoqParkList![i]
                    self.saveNmoqParkToCoreData(nmoqParkListDict: nmoqParkListDict!, managedObjContext: managedContext)
                }
                NotificationCenter.default.post(name: NSNotification.Name(nmoqParkNotificationAr), object: self)
            }
        }
    }
    
    func saveNmoqParkToCoreData(nmoqParkListDict: NMoQPark, managedObjContext: NSManagedObjectContext) {
        if (LocalizationLanguage.currentAppleLanguage() == ENG_LANGUAGE) {
            let nmoqParkListdbDict: NMoQParksEntity = NSEntityDescription.insertNewObject(forEntityName: "NMoQParksEntity", into: managedObjContext) as! NMoQParksEntity
            nmoqParkListdbDict.title = nmoqParkListDict.title
            nmoqParkListdbDict.nid =  nmoqParkListDict.nid
            nmoqParkListdbDict.sortId =  nmoqParkListDict.sortId
            
            if(nmoqParkListDict.images != nil){
                if((nmoqParkListDict.images?.count)! > 0) {
                    for i in 0 ... (nmoqParkListDict.images?.count)!-1 {
                        var parkListImage: NMoQParkImgEntity!
                        let parkListImageArray: NMoQParkImgEntity = NSEntityDescription.insertNewObject(forEntityName: "NMoQParkImgEntity", into: managedObjContext) as! NMoQParkImgEntity
                        parkListImageArray.images = nmoqParkListDict.images![i]

                        parkListImage = parkListImageArray
                        nmoqParkListdbDict.addToParkImgRelation(parkListImage)
                        do {
                            try managedObjContext.save()
                        } catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                    }
                }
            }
        } else {
            let nmoqParkListdbDict: NMoQParksEntityAr = NSEntityDescription.insertNewObject(forEntityName: "NMoQParksEntityAr", into: managedObjContext) as! NMoQParksEntityAr
            nmoqParkListdbDict.title = nmoqParkListDict.title
            nmoqParkListdbDict.nid =  nmoqParkListDict.nid
            nmoqParkListdbDict.sortId =  nmoqParkListDict.sortId
            
            if(nmoqParkListDict.images != nil){
                if((nmoqParkListDict.images?.count)! > 0) {
                    for i in 0 ... (nmoqParkListDict.images?.count)!-1 {
                        var parkListImage: NMoQParkImgEntityAr!
                        let parkListImageArray: NMoQParkImgEntityAr = NSEntityDescription.insertNewObject(forEntityName: "NMoQParkImgEntityAr", into: managedObjContext) as! NMoQParkImgEntityAr
                        parkListImageArray.images = nmoqParkListDict.images![i]
                        
                        parkListImage = parkListImageArray
                        nmoqParkListdbDict.addToParkImgRelationAr(parkListImage)
                        do {
                            try managedObjContext.save()
                        } catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                    }
                }
            }
        }
        do {
            try managedObjContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchNmoqParkListFromCoredata() {
        let managedContext = getContext()
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                var parkListArray = [NMoQParkListEntity]()
                let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "NMoQParkListEntity")
                //fetchRequest.predicate = NSPredicate.init(format: "isTourGuide == \(isTourGuide)")
                parkListArray = (try managedContext.fetch(fetchRequest) as? [NMoQParkListEntity])!
                if (parkListArray.count > 0) {
                    //parkListArray.sort(by: {$0.sortId < $1.sortId})
                    for i in 0 ... parkListArray.count-1 {
                        let parkListDict = parkListArray[i]
//                        var imagesArray : [String] = []
//                        let imagesInfoArray = (tourListDict.tourImagesRelation?.allObjects) as! [NMoqTourImagesEntity]
//                        if(imagesInfoArray.count > 0) {
//                            for i in 0 ... imagesInfoArray.count-1 {
//                                imagesArray.append(imagesInfoArray[i].image!)
//                            }
//                        }
                        self.nmoqParkList.insert(NMoQParksList(title: parkListDict.title, parkTitle: parkListDict.parkTitle, mainDescription: parkListDict.mainDescription, parkDescription: parkListDict.parkDescription, hoursTitle: parkListDict.hoursTitle, hoursDesc: parkListDict.hoursDesc, nid: parkListDict.nid, longitude: parkListDict.longitude, latitude: parkListDict.latitude, locationTitle: parkListDict.locationTitle), at: i)
                    }
                    if(nmoqParkList.count == 0){
                        if(self.networkReachability?.isReachable == false) {
                            self.showNoNetwork()
                        } else {
                            self.loadingView.showNoDataView()
                        }
                    }
                    parkTableView.reloadData()
                } else{
                    if(self.networkReachability?.isReachable == false) {
                        self.showNoNetwork()
                    } else {
                        self.loadingView.showNoDataView()
                    }
                }
            } else {
                var parkListArray = [NMoQParkListEntityAr]()
                let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "NMoQParkListEntityAr")
               // fetchRequest.predicate = NSPredicate.init(format: "isTourGuide == \(isTourGuide)")
                parkListArray = (try managedContext.fetch(fetchRequest) as? [NMoQParkListEntityAr])!
                if (parkListArray.count > 0) {
                   // parkListArray.sort(by: {$0.sortId < $1.sortId})
                    for i in 0 ... parkListArray.count-1 {
                        let parkListDict = parkListArray[i]
//                        var imagesArray : [String] = []
//                        let imagesInfoArray = (tourListDict.tourImagesRelationAr?.allObjects) as! [NMoqTourImagesEntityAr]
//                        if(imagesInfoArray.count > 0) {
//                            for i in 0 ... imagesInfoArray.count-1 {
//                                imagesArray.append(imagesInfoArray[i].image!)
//                            }
//                        }
                        self.nmoqParkList.insert(NMoQParksList(title: parkListDict.title,parkTitle: parkListDict.parkTitle, mainDescription: parkListDict.mainDescription, parkDescription: parkListDict.parkDescription, hoursTitle: parkListDict.hoursTitle, hoursDesc: parkListDict.hoursDesc, nid: parkListDict.nid, longitude: parkListDict.longitude, latitude: parkListDict.latitude, locationTitle: parkListDict.locationTitle), at: i)
                    }
                    if(nmoqParkList.count == 0){
                        if(self.networkReachability?.isReachable == false) {
                            self.showNoNetwork()
                        } else {
                            self.loadingView.showNoDataView()
                        }
                    }
                    parkTableView.reloadData()
                } else{
                    if(self.networkReachability?.isReachable == false) {
                        self.showNoNetwork()
                    } else {
                        self.loadingView.showNoDataView()
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func fetchNmoqParkFromCoredata() {
        let managedContext = getContext()
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                var parkListArray = [NMoQParksEntity]()
                let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "NMoQParksEntity")
                parkListArray = (try managedContext.fetch(fetchRequest) as? [NMoQParksEntity])!
                    
                if (parkListArray.count > 0) {
                    for i in 0 ... parkListArray.count-1 {
                        let parkListDict = parkListArray[i]
                        var imagesArray : [String] = []
                        let imagesInfoArray = (parkListDict.parkImgRelation?.allObjects) as! [NMoQParkImgEntity]
                        if(imagesInfoArray.count > 0) {
                            for i in 0 ... imagesInfoArray.count-1 {
                                imagesArray.append(imagesInfoArray[i].images!)
                            }
                        }
                        self.nmoqParks.insert(NMoQPark(title: parkListDict.title, sortId: parkListDict.sortId, nid: parkListDict.nid, images: imagesArray), at: i)
                    }
                    if(nmoqParks.count == 0){
                        if(self.networkReachability?.isReachable == false) {
                            self.showNoNetwork()
                        } else {
                            self.loadingView.showNoDataView()
                        }
                    } else {
                        if self.nmoqParks.first(where: {$0.sortId != "" && $0.sortId != nil} ) != nil {
                            self.nmoqParks = self.nmoqParks.sorted(by: { Int16($0.sortId!)! < Int16($1.sortId!)! })
                        }
                    }
                    parkTableView.reloadData()
                } else{
                    if(self.networkReachability?.isReachable == false) {
                        self.showNoNetwork()
                    } else {
                        self.loadingView.showNoDataView()
                    }
                }
            } else {
                var parkListArray = [NMoQParksEntityAr]()
                let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "NMoQParksEntityAr")
                parkListArray = (try managedContext.fetch(fetchRequest) as? [NMoQParksEntityAr])!
                if (parkListArray.count > 0) {
                    for i in 0 ... parkListArray.count-1 {
                        let parkListDict = parkListArray[i]
                        var imagesArray : [String] = []
                        let imagesInfoArray = (parkListDict.parkImgRelationAr?.allObjects) as! [NMoQParkImgEntityAr]
                        if(imagesInfoArray.count > 0) {
                            for i in 0 ... imagesInfoArray.count-1 {
                                imagesArray.append(imagesInfoArray[i].images!)
                            }
                        }
                        self.nmoqParks.insert(NMoQPark(title: parkListDict.title, sortId: parkListDict.sortId, nid: parkListDict.nid, images: imagesArray), at: i)
                    }
                    if(nmoqParks.count == 0){
                        if(self.networkReachability?.isReachable == false) {
                            self.showNoNetwork()
                        } else {
                            self.loadingView.showNoDataView()
                        }
                    } else {
                        if self.nmoqParks.first(where: {$0.sortId != "" && $0.sortId != nil} ) != nil {
                            self.nmoqParks = self.nmoqParks.sorted(by: { Int16($0.sortId!)! < Int16($1.sortId!)! })
                        }
                    }
                    parkTableView.reloadData()
                } else{
                    if(self.networkReachability?.isReachable == false) {
                        self.showNoNetwork()
                    } else {
                        self.loadingView.showNoDataView()
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func checkAddedToCoredata(entityName: String?, idKey:String?, idValue: String?, managedContext: NSManagedObjectContext) -> [NSManagedObject] {
        var fetchResults : [NSManagedObject] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName!)
        if (idValue != nil) {
            fetchRequest.predicate = NSPredicate(format: "\(idKey!) == %@", idValue!)
        }
        fetchResults = try! managedContext.fetch(fetchRequest)
        return fetchResults
    }
    func showNoNetwork() {
        self.loadingView.stopLoading()
        self.loadingView.noDataView.isHidden = false
        self.loadingView.isHidden = false
        self.loadingView.showNoNetworkView()
    }
    func showLocationErrorPopup() {
        popupView  = ComingSoonPopUp(frame: self.view.frame)
        popupView.comingSoonPopupDelegate = self
        popupView.loadMapKitLocationErrorPopup()
        self.view.addSubview(popupView)
    }
    func headerCloseButtonPressed() {
        self.dismiss(animated: false, completion: nil)
    }
    func closeButtonPressed() {
        self.popupView.removeFromSuperview()
    }
    func tryAgainButtonPressed() {
        if  (networkReachability?.isReachable)! {
            let appDelegate =  UIApplication.shared.delegate as? AppDelegate
            appDelegate?.getNmoqParkListFromServer(lang: LocalizationLanguage.currentAppleLanguage())
        }
    }
    @objc func receiveNmoqParkListNotificationEn(notification: NSNotification) {
        if ((LocalizationLanguage.currentAppleLanguage() == ENG_LANGUAGE ) && (nmoqParkList.count == 0)){
            self.fetchNmoqParkListFromCoredata()
        }
    }
    @objc func receiveNmoqParkListNotificationAr(notification: NSNotification) {
        if ((LocalizationLanguage.currentAppleLanguage() == AR_LANGUAGE ) && (nmoqParkList.count == 0)){
            self.fetchNmoqParkListFromCoredata()
        }
    }
    
    @objc func receiveNmoqParkNotificationEn(notification: NSNotification) {
        if ((LocalizationLanguage.currentAppleLanguage() == ENG_LANGUAGE ) && (nmoqParks.count == 0)){
            self.fetchNmoqParkFromCoredata()
        }
    }
    
    @objc func receiveNmoqParkNotificationAr(notification: NSNotification) {
        if ((LocalizationLanguage.currentAppleLanguage() == AR_LANGUAGE ) && (nmoqParks.count == 0)){
            self.fetchNmoqParkFromCoredata()
        }
    }
}

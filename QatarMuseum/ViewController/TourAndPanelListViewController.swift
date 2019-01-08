//
//  TourAndPanelListViewController.swift
//  QatarMuseums
//
//  Created by Developer on 28/11/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import Alamofire
import CoreData
import Crashlytics
import UIKit

enum NMoQPageName {
    case Tours
    case PanelDiscussion
}

class TourAndPanelListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,HeaderViewProtocol,LoadingViewProtocol {
    @IBOutlet weak var collectionTableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var headerView: CommonHeaderView!
    
    var pageNameString : NMoQPageName?
    let networkReachability = NetworkReachabilityManager()
    var imageArray: [String] = []
    var titleArray: [String] = []
    var nmoqTourList: [NMoQTour]! = []
    var sortIdTest = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupUI()
        collectionTableView.delegate = self
        collectionTableView.dataSource = self
    }
    
    func setupUI() {
        loadingView.isHidden = false
        loadingView.showLoading()
        loadingView.loadingViewDelegate = self
        headerView.headerViewDelegate = self
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            headerView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        } else {
            headerView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
        if (pageNameString == NMoQPageName.Tours) {
            headerView.headerTitle.text = NSLocalizedString("TOUR_TITLE", comment: "TOUR_TITLE in the NMoQ page")
            fetchTourInfoFromCoredata()
            NotificationCenter.default.addObserver(self, selector: #selector(TourAndPanelListViewController.receiveNmoqTourListNotification(notification:)), name: NSNotification.Name(nmoqTourlistNotification), object: nil)
            if  (networkReachability?.isReachable)! {
                DispatchQueue.global(qos: .background).async {
                    self.getNMoQTourList()
                }
            }
        } else if (pageNameString == NMoQPageName.PanelDiscussion) {
            headerView.headerTitle.text = NSLocalizedString("PANEL_DISCUSSION", comment: "PANEL_DISCUSSION in the NMoQ page").uppercased()
            getNMoQSpecialEventList()
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func registerCell() {
        self.collectionTableView.register(UINib(nibName: "NMoQListCell", bundle: nil), forCellReuseIdentifier: "nMoQListCellId")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return nmoqTourList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nMoQListCellId", for: indexPath) as! NMoQListCell
        cell.setTourListDate(tourList: nmoqTourList[indexPath.row])
        loadingView.stopLoading()
        loadingView.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightValue = UIScreen.main.bounds.height/100
        return heightValue*27
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (pageNameString == NMoQPageName.Tours) {
            loadTourViewPage(selectedRow: indexPath.row)
        } else if (pageNameString == NMoQPageName.PanelDiscussion) {
            loadPanelDiscussionDetailPage(selectedRow: indexPath.row)
        }
    }
    
    func loadTourViewPage(selectedRow: Int?) {
        let tourView =  self.storyboard?.instantiateViewController(withIdentifier: "nMoQTourId") as! NMoQTourViewController
        tourView.tourDetailId = nmoqTourList[selectedRow!].nid
        tourView.headerTitle = nmoqTourList[selectedRow!].subtitle
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(tourView, animated: false, completion: nil)
        
//        let panelView =  self.storyboard?.instantiateViewController(withIdentifier: "paneldetailViewId") as! PanelDiscussionDetailViewController
//        //panelView.panelTitle = selectedCellTitle
//        panelView.panelDetailId = nmoqTourList[selectedRow!].nid
//        panelView.pageNameString = NMoQPanelPage.TourDetailPage
//        let transition = CATransition()
//        transition.duration = 0.25
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromRight
//        view.window!.layer.add(transition, forKey: kCATransition)
//        self.present(panelView, animated: false, completion: nil)
        

    }
    func loadPanelDiscussionDetailPage(selectedRow: Int?) {
        let panelView =  self.storyboard?.instantiateViewController(withIdentifier: "paneldetailViewId") as! PanelDiscussionDetailViewController
        //commented bcz now tour and panel have same data
        panelView.pageNameString = NMoQPanelPage.PanelDetailPage
        //panelView.pageNameString = NMoQPanelPage.TourDetailPage
        panelView.panelDetailId = nmoqTourList[selectedRow!].nid
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(panelView, animated: false, completion: nil)
    }
    
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
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
    }
    
    func showNoNetwork() {
        self.loadingView.stopLoading()
        self.loadingView.noDataView.isHidden = false
        self.loadingView.isHidden = false
        self.loadingView.showNoNetworkView()
    }
    //MARK: Service call
    func getNMoQTourList() {
        _ = Alamofire.request(QatarMuseumRouter.GetNMoQTourList()).responseObject { (response: DataResponse<NMoQTourList>) -> Void in
            switch response.result {
            case .success(let data):
                self.saveOrUpdateTourListCoredata(nmoqTourList: data.nmoqTourList)
            case .failure(let error):
                print("error")
            }
        }
    }
    func getNMoQSpecialEventList() {
        _ = Alamofire.request(QatarMuseumRouter.GetNMoQSpecialEventList()).responseObject { (response: DataResponse<NMoQTourList>) -> Void in
            switch response.result {
            case .success(let data):
                self.nmoqTourList = data.nmoqTourList
                if self.nmoqTourList.first(where: {$0.sortId != "" && $0.sortId != nil} ) != nil {
                    self.nmoqTourList = self.nmoqTourList.sorted(by: { Int16($0.sortId!)! < Int16($1.sortId!)! })
                }
                //self.saveOrUpdateHomeCoredata()
                self.collectionTableView.reloadData()
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
    
    //MARK: Tour List Coredata Method
    func saveOrUpdateTourListCoredata(nmoqTourList:[NMoQTour]?) {
        if ((nmoqTourList?.count)! > 0) {
            let appDelegate =  UIApplication.shared.delegate as? AppDelegate
            if #available(iOS 10.0, *) {
                let container = appDelegate!.persistentContainer
                container.performBackgroundTask() {(managedContext) in
                    self.tourListCoreDataInBackgroundThread(nmoqTourList: nmoqTourList, managedContext: managedContext)
                }
            } else {
                let managedContext = appDelegate!.managedObjectContext
                managedContext.perform {
                    self.tourListCoreDataInBackgroundThread(nmoqTourList: nmoqTourList, managedContext : managedContext)
                }
            }
        }
    }
    
    func tourListCoreDataInBackgroundThread(nmoqTourList:[NMoQTour]?,managedContext: NSManagedObjectContext) {
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            let fetchData = checkAddedToCoredata(entityName: "NMoQTourListEntity", idKey: "nid", idValue: nil, managedContext: managedContext) as! [NMoQTourListEntity]
            if (fetchData.count > 0) {
                for i in 0 ... (nmoqTourList?.count)!-1 {
                    let tourListDict = nmoqTourList![i]
                    let fetchResult = checkAddedToCoredata(entityName: "NMoQTourListEntity", idKey: "nid", idValue: tourListDict.nid, managedContext: managedContext)
                    //update
                    if(fetchResult.count != 0) {
                        let tourListdbDict = fetchResult[0] as! NMoQTourListEntity
                        tourListdbDict.title = tourListDict.title
                        tourListdbDict.dayDescription = tourListDict.dayDescription
                        tourListdbDict.subtitle =  tourListDict.subtitle
                        tourListdbDict.sortId = Int16(tourListDict.sortId!)!
                        tourListdbDict.nid =  tourListDict.nid
                        tourListdbDict.eventDate = tourListDict.eventDate
                        
                        if(tourListDict.images != nil){
                            if((tourListDict.images?.count)! > 0) {
                                for i in 0 ... (tourListDict.images?.count)!-1 {
                                    var tourImage: NMoqTourImagesEntity!
                                    let tourImgaeArray: NMoqTourImagesEntity = NSEntityDescription.insertNewObject(forEntityName: "NMoqTourImagesEntity", into: managedContext) as! NMoqTourImagesEntity
                                    tourImgaeArray.image = tourListDict.images?[i]
                                    
                                    tourImage = tourImgaeArray
                                    tourListdbDict.addToTourImagesRelation(tourImage)
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
                        self.saveTourListToCoreData(tourListDict: tourListDict, managedObjContext: managedContext)
                    }
                }
            } else {
                for i in 0 ... (nmoqTourList?.count)!-1 {
                    let tourListDict : NMoQTour?
                    tourListDict = nmoqTourList?[i]
                    self.saveTourListToCoreData(tourListDict: tourListDict!, managedObjContext: managedContext)
                }
            }
        }
    }
    func saveTourListToCoreData(tourListDict: NMoQTour, managedObjContext: NSManagedObjectContext) {
            let tourListInfo: NMoQTourListEntity = NSEntityDescription.insertNewObject(forEntityName: "NMoQTourListEntity", into: managedObjContext) as! NMoQTourListEntity
            tourListInfo.title = tourListDict.title
            tourListInfo.dayDescription = tourListDict.dayDescription
            tourListInfo.subtitle = tourListDict.subtitle
            tourListInfo.sortId = Int16(tourListDict.sortId!)!
            tourListInfo.nid = tourListDict.nid
            tourListInfo.eventDate = tourListDict.eventDate
        
        if(tourListDict.images != nil){
            if((tourListDict.images?.count)! > 0) {
                for i in 0 ... (tourListDict.images?.count)!-1 {
                    var tourImage: NMoqTourImagesEntity!
                    let tourImgaeArray: NMoqTourImagesEntity = NSEntityDescription.insertNewObject(forEntityName: "NMoqTourImagesEntity", into: managedObjContext) as! NMoqTourImagesEntity
                    tourImgaeArray.image = tourListDict.images?[i]
                    
                    tourImage = tourImgaeArray
                    tourListInfo.addToTourImagesRelation(tourImage)
                    do {
                        try managedObjContext.save()
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
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
    func fetchTourInfoFromCoredata() {
        let managedContext = getContext()
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                var tourListArray = [NMoQTourListEntity]()
                let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "NMoQTourListEntity")
                tourListArray = (try managedContext.fetch(fetchRequest) as? [NMoQTourListEntity])!
                if (tourListArray.count > 0) {
                    tourListArray.sort(by: {$0.sortId < $1.sortId})
                    for i in 0 ... tourListArray.count-1 {
                        let tourListDict = tourListArray[i]
                        var imagesArray : [String] = []
                        let imagesInfoArray = (tourListDict.tourImagesRelation?.allObjects) as! [NMoqTourImagesEntity]
                        if(imagesInfoArray.count > 0) {
                            for i in 0 ... imagesInfoArray.count-1 {
                                imagesArray.append(imagesInfoArray[i].image!)
                            }
                        }
                        self.nmoqTourList.insert(NMoQTour(title: tourListArray[i].title, dayDescription: tourListArray[i].dayDescription, images: imagesArray, subtitle: tourListArray[i].subtitle, sortId: String(tourListArray[i].sortId), nid: tourListArray[i].nid, eventDate: nil, date: nil, descriptioForModerator: nil, mobileLatitude: nil, moderatorName: nil, longitude: nil, contactEmail: nil, contactPhone: nil), at: i)
                    }
                    if(nmoqTourList.count == 0){
                        self.showNoNetwork()
                    }
                    collectionTableView.reloadData()
                } else{
                    self.showNoNetwork()
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
    @objc func receiveNmoqTourListNotification(notification: NSNotification) {
        self.fetchTourInfoFromCoredata()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


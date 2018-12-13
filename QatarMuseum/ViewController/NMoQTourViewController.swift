//
//  NMoQTourViewController.swift
//  QatarMuseums
//
//  Created by Developer on 30/11/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import Alamofire
import CoreData
import Crashlytics
import UIKit

class NMoQTourViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,HeaderViewProtocol,LoadingViewProtocol {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var headerView: CommonHeaderView!
    
    var tourTitle : String! = ""
    //    let networkReachability = NetworkReachabilityManager()
    var tourDesc: String = ""
    var tourName : [String]? = ["Day Tour", "Evening Tour"]
    var tourDetailId : String? = nil
    var nmoqTourDetail: [NMoQTourDetail]! = []

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupUI()
    }
    
    func setupUI() {
        loadingView.isHidden = false
        loadingView.showLoading()
        getNMoQTourDetail()
        loadingView.loadingViewDelegate = self
        headerView.headerViewDelegate = self
        
        
            tourDesc = NSLocalizedString("NMoQ_TOUR_DESC", comment: "NMoQ_TOUR_DESC in the NMoQ Tour page")
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                headerView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
            } else {
                headerView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
            }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func registerCell() {
        self.tableView.register(UINib(nibName: "NMoQListCell", bundle: nil), forCellReuseIdentifier: "nMoQListCellId")
        self.tableView.register(UINib(nibName: "NMoQTourDescriptionCell", bundle: nil), forCellReuseIdentifier: "nMoQTourDescriptionCellId")
        self.tableView.register(UINib(nibName: "PanelDetailView", bundle: nil), forCellReuseIdentifier: "panelCellID")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nmoqTourDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        loadingView.stopLoading()
        loadingView.isHidden = true
        let cell = tableView.dequeueReusableCell(withIdentifier: "nMoQListCellId", for: indexPath) as! NMoQListCell
        cell.setTourMiddleDate(tourList: nmoqTourDetail[indexPath.row])
                return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadTourSecondDetailPage(selectedRow: indexPath.row)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            let heightValue = UIScreen.main.bounds.height/100
            return heightValue*27
    }
    func loadTourSecondDetailPage(selectedRow: Int?) {
        let panelView =  self.storyboard?.instantiateViewController(withIdentifier: "paneldetailViewId") as! PanelDiscussionDetailViewController
        panelView.nmoqTourDetail = nmoqTourDetail
        panelView.selectedRow = selectedRow
        panelView.pageNameString = NMoQPanelPage.TourDetailPage
        panelView.panelDetailId = tourDetailId
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
    //MARK: ServiceCall
    func getNMoQTourDetail() {
        if(tourDetailId != nil) {
            _ = Alamofire.request(QatarMuseumRouter.GetNMoQTourDetail(["event_id" : tourDetailId!])).responseObject { (response: DataResponse<NMoQTourDetailList>) -> Void in
                switch response.result {
                case .success(let data):
                    self.nmoqTourDetail = data.nmoqTourDetailList
                    //self.saveOrUpdateHomeCoredata()
                    self.tableView.reloadData()
                    if(self.nmoqTourDetail.count == 0) {
                        let noResultMsg = NSLocalizedString("NO_RESULT_MESSAGE",
                                                            comment: "Setting the content of the alert")
                        self.loadingView.stopLoading()
                        self.loadingView.noDataView.isHidden = false
                        self.loadingView.isHidden = false
                        self.loadingView.showNoDataView()
                        self.loadingView.noDataLabel.text = noResultMsg
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
        
    }
    /*
    //MARK: Coredata Method
    func saveOrUpdateTourDetailCoredata() {
        if (nmoqTourDetail.count > 0) {
            let appDelegate =  UIApplication.shared.delegate as? AppDelegate
            if #available(iOS 10.0, *) {
                let container = appDelegate!.persistentContainer
                container.performBackgroundTask() {(managedContext) in
                    self.coreDataInBackgroundThread(managedContext: managedContext)
                }
            } else {
                let managedContext = appDelegate!.managedObjectContext
                managedContext.perform {
                    self.coreDataInBackgroundThread(managedContext : managedContext)
                }
            }
        }
    }
    func coreDataInBackgroundThread(managedContext: NSManagedObjectContext) {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            let fetchData = checkAddedToCoredata(entityName: "NmoqTourDetailEntity", idKey: "nmoqEvent", idValue: tourDetailId, managedContext: managedContext) as! [NmoqTourDetailEntity]
            if (fetchData.count > 0) {
                for i in 0 ... nmoqTourDetail.count-1 {
                    let tourDetailDict = nmoqTourDetail[i]
                    let fetchResult = checkAddedToCoredata(entityName: "NmoqTourDetailEntity", idKey: "nid", idValue: tourDetailDict.nid, managedContext: managedContext)
                    //update
                    if(fetchResult.count != 0) {
                        let tourDetaildbDict = fetchResult[0] as! NmoqTourDetailEntity
                        tourDetaildbDict.title = tourDetailDict.title
                        tourDetaildbDict.date = tourDetailDict.date
                        tourDetaildbDict.nmoqEvent =  tourDetailDict.nmoqEvent
                        tourDetaildbDict.register =  tourDetailDict.register
                        tourDetaildbDict.contactEmail = tourDetailDict.contactEmail
                        tourDetaildbDict.contactPhone = tourDetailDict.contactPhone
                        tourDetaildbDict.mobileLatitude =  tourDetailDict.mobileLatitude
                        tourDetaildbDict.longitude =  tourDetailDict.longitude
                        tourDetaildbDict.sort_id = tourDetailDict.sort_id
                        tourDetaildbDict.body = tourDetailDict.body
                        tourDetaildbDict.registered =  tourDetailDict.registered
                        tourDetaildbDict.nid =  tourDetailDict.nid
                        
                        if(tourDetailDict.imageBanner != nil){
                            if((tourDetailDict.imageBanner?.count)! > 0) {
                                for i in 0 ... (tourDetailDict.imageBanner?.count)!-1 {
                                    var tourImage: NMoqTourDetailImagesEntity
                                    let tourImgaeArray: NMoqTourDetailImagesEntity = NSEntityDescription.insertNewObject(forEntityName: "NMoqTourDetailImagesEntity", into: managedContext) as! NMoqTourDetailImagesEntity
                                    tourImgaeArray.imgBanner = tourDetailDict.imageBanner?[i]
                                    
                                    tourImage = tourImgaeArray
                                    tourDetaildbDict.addToNmoqTourDetailImgBannerRelation(tourImage)
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
                    }
                    else {
                        //save
                        self.saveToCoreData(parksDict: parksDict, managedObjContext: managedContext)
                        
                    }
                }
            }
            else {
                for i in 0 ... parksListArray.count-1 {
                    let parksDict : ParksList?
                    parksDict = parksListArray[i]
                    self.saveToCoreData(parksDict: parksDict!, managedObjContext: managedContext)
                    
                }
            }
        }
        
    }
    func saveToCoreData(parksDict: ParksList, managedObjContext: NSManagedObjectContext) {
            let parksInfo: ParksEntity = NSEntityDescription.insertNewObject(forEntityName: "ParksEntity", into: managedObjContext) as! ParksEntity
            parksInfo.title = parksDict.title
            parksInfo.parksDescription = parksDict.description
            parksInfo.image = parksDict.image
            if(parksDict.sortId != nil) {
                parksInfo.sortId = parksDict.sortId
            }
        do {
            try managedObjContext.save()
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func fetchParksFromCoredata() {
        let managedContext = getContext()
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                var parksArray = [ParksEntity]()
                let parksFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "ParksEntity")
                parksArray = (try managedContext.fetch(parksFetchRequest) as? [ParksEntity])!
                
                if (parksArray.count > 0) {
                    for i in 0 ... parksArray.count-1 {
                        self.parksListArray.insert(ParksList(title: parksArray[i].title, description: parksArray[i].parksDescription, sortId: parksArray[i].sortId, image: parksArray[i].image), at: i)
                        
                    }
                    if(parksListArray.count == 0){
                        self.showNoNetwork()
                    }
                    self.setTopbarImage()
                    parksTableView.reloadData()
                }
                else{
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
   */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//
//  CollectionDetailViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 31/07/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Alamofire
import CoreData
import UIKit

class CollectionDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,HeaderViewProtocol {
    @IBOutlet weak var collectionTableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var headerView: CommonHeaderView!
    
    var collectionListArray: NSArray!
    var collectionImageArray = NSArray()
    var collectionDetailArray: [Collection]! = []
    var collectionId: String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        getCollectionDetailDataFromJson()
        registerCell()
        setUI()
        
    }
    func setUI() {
        loadingView.isHidden = false
        loadingView.showLoading()
        collectionImageArray = ["mia_park","park_cafe","family_play"];
        headerView.headerViewDelegate = self
        headerView.headerBackButton.setImage(UIImage(named: "closeX1"), for: .normal)
        headerView.headerBackButton.contentEdgeInsets = UIEdgeInsets(top: 13, left: 18, bottom:13, right: 18)
       
    }
    //MARK: Service call
    func getCollectionDetailDataFromJson(){
        let url = Bundle.main.url(forResource: "CollectionDetailJson", withExtension: "json")
        
        let dataObject = NSData(contentsOf: url!)
        if let jsonObj = try? JSONSerialization.jsonObject(with: dataObject! as Data, options: .allowFragments) as? NSDictionary {
            
            collectionListArray = jsonObj!.value(forKey: "items")
                as! NSArray
        }
    }
    func registerCell() {
        self.collectionTableView.register(UINib(nibName: "CollectionDetailView", bundle: nil), forCellReuseIdentifier: "collectionCellId")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionListArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let collectionCell = tableView.dequeueReusableCell(withIdentifier: "collectionCellId", for: indexPath) as! CollectionDetailCell
//        if(indexPath.row == collectionListArray.count-1) {
//            collectionCell.favouriteHeight.constant = 130
//            collectionCell.favouriteView.isHidden = false
//            collectionCell.shareView.isHidden = false
//            collectionCell.favouriteButton.isHidden = false
//            collectionCell.shareButton.isHidden = false
//        } else {
            collectionCell.favouriteHeight.constant = 0
            collectionCell.favouriteView.isHidden = true
            collectionCell.shareView.isHidden = true
            collectionCell.favouriteButton.isHidden = true
            collectionCell.shareButton.isHidden = true
//        }
        collectionCell.favouriteButtonAction = {
            () in
            
        }
        collectionCell.shareButtonAction = {
            () in
            
        }
        let collectionDataDict = collectionListArray.object(at: indexPath.row) as! NSDictionary
        
        collectionCell.setCollectionCellValues(cellValues: collectionDataDict, imageName: collectionImageArray.object(at: indexPath.row) as! String, currentRow: indexPath.row)
        loadingView.stopLoading()
        loadingView.isHidden = true
        return collectionCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    /*
    //MARK: WebServiceCall
    func getCollectioDetailsFromServer()
    {
        _ = Alamofire.request(QatarMuseumRouter.CollectionDetail(["nid": collectionId!])).responseObject { (response: DataResponse<Collections>) -> Void in
            switch response.result {
            case .success(let data):
                self.collectionDetailArray = data.collections
                self.saveOrUpdateCollectionDetailCoredata()
                self.collectionTableView.reloadData()
                self.loadingView.stopLoading()
                self.loadingView.isHidden = true
                if (self.collectionDetailArray.count == 0) {
                    self.loadingView.stopLoading()
                    self.loadingView.noDataView.isHidden = false
                    self.loadingView.isHidden = false
                    self.loadingView.showNoDataView()
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
    //MARK: CollectionDetail Coredata Method
    func saveOrUpdateCollectionDetailCoredata() {
        if (collectionDetailArray.count > 0) {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                let fetchData = checkAddedToCoredata(entityName: "CollectionsEntity", idKey: "id" , idValue: collectionDetailArray[0].id) as! [CollectionsEntity]
                if (fetchData.count > 0) {
                    let managedContext = getContext()
                    let collectionDetailDict = collectionDetailArray[0]
                    
                    //update
                    let collectiondbDict = fetchData[0]
                    
                    collectiondbDict.listImage = collectionDetailDict.image
                    collectiondbDict.name = collectionDetailDict.name
                    collectiondbDict.museumRef =  collectionDetailDict.museumsReference
                    
                    
                    do{
                        try managedContext.save()
                    }
                    catch{
                        print(error)
                    }
                }
                else {
                    let managedContext = getContext()
                    let collectionDetailDict : Collection?
                    collectionDetailDict = collectionDetailArray[0]
                    self.saveToCoreData(exhibitionDetailDict: collectionDetailDict!, managedObjContext: managedContext)
                }
            }
            else {
                let fetchData = checkAddedToCoredata(entityName: "CollectionsEntityArabic", idKey:"id" , idValue: collectionDetailArray[0].id) as! [CollectionsEntityArabic]
                if (fetchData.count > 0) {
                    let managedContext = getContext()
                    let collectionDetailDict = collectionDetailArray[0]
                    
                    //update
                    
                    let collectiondbDict = fetchData[0]
                    collectiondbDict.listImage = collectiondbDict.name
                    collectiondbDict.name = collectiondbDict.image
                    collectiondbDict.museumRef =  collectiondbDict.startDate
                   
                    
                    do{
                        try managedContext.save()
                    }
                    catch{
                        print(error)
                    }
                }
                else {
                    let managedContext = getContext()
                    let collectionDetailDict : Collection?
                    collectionDetailDict = collectionDetailArray[0]
                    self.saveToCoreData(collectionDetailDict: collectionDetailDict!, managedObjContext: managedContext)
                }
            }
        }
    }
    func saveToCoreData(collectionDetailDict: Collection, managedObjContext: NSManagedObjectContext) {
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            let collectionInfo: CollectionsEntity = NSEntityDescription.insertNewObject(forEntityName: "CollectionsEntity", into: managedObjContext) as! CollectionsEntity
//            collectionInfo.id = collectionDetailDict.image
//            collectionInfo.detailName = collectionDetailDict.museumsReference
//            collectionInfo.detailImage = collectionDetailDict.name
            
            
        }
        else {
            let collectionInfo: ExhibitionsEntityArabic = NSEntityDescription.insertNewObject(forEntityName: "CollectionsEntityArabic", into: managedObjContext) as! CollectionsEntityArabic
//            collectionInfo.id = collectionDetailDict.id
//            collectionInfo.detailNameAr = collectionDetailDict.name
            
        }
        do {
            try managedObjContext.save()
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func fetchExhibitionDetailsFromCoredata() {
        
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                var collectionArray = [CollectionsEntity]()
                let managedContext = getContext()
                let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "CollectionsEntity")
                if(collectionId != nil) {
                    fetchRequest.predicate = NSPredicate.init(format: "id == \(fetchRequest)")
                }
                collectionArray = (try managedContext.fetch(fetchRequest) as? [CollectionsEntity])!
                let collectionDict = collectionArray[0]
                if (collectionArray.count > 0) {
                    
//                    self.collectionDetailArray.insert(Collection(name: collectionDict.listName, image: collectionDict.listImage, museumsReference: collectionDict.musmRef), at: 0)
                   
                    
                    if(collectionDetailArray.count == 0){
                        self.showNodata()
                    }
                    
                    collectionTableView.reloadData()
                }
                else{
                    self.showNodata()
                }
            }
            else {
                var collectionArray = [CollectionsEntityArabic]()
                let managedContext = getContext()
                let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "CollectionsEntityArabic")
                if(collectionId != nil) {
                    fetchRequest.predicate = NSPredicate.init(format: "id == \(collectionId!)")
                }
                collectionArray = (try managedContext.fetch(fetchRequest) as? [CollectionsEntityArabic])!
                let collectionDict = collectionArray[0]
                if (collectionArray.count > 0)  {
                    
                    // self.collectionDetailArray.insert(Collection(name: collectionDict.listNameAr, image: collectionDict.listImageAr, museumsReference: collectionDict.musmRefAr), at: 0)
                    
                    
                    if(collectionDetailArray.count == 0){
                        self.showNodata()
                    }
                    
                    collectionTableView.reloadData()
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
    func checkAddedToCoredata(entityName: String?,idKey:String?, idValue: String?) -> [NSManagedObject]
    {
        let managedContext = getContext()
        var fetchResults : [NSManagedObject] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName!)
        if (idValue != nil) {
            fetchRequest.predicate = NSPredicate.init(format: "\(idKey!) == \(idValue!)")
        }
        fetchResults = try! managedContext.fetch(fetchRequest)
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
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

   

}

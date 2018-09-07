//
//  MuseumCollectionsViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 22/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Alamofire
import UIKit
import CoreData

class MuseumCollectionsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HeaderViewProtocol,comingSoonPopUpProtocol {
    @IBOutlet weak var museumCollectionView: UICollectionView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var collectionsHeader: CommonHeaderView!
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
    var collection: [Collection] = []
    let networkReachability = NetworkReachabilityManager()
    var museumId: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        registerNib()
        if  (networkReachability?.isReachable)! {
            getCollectionList()
        }
        else {
            self.fetchCollectionListFromCoredata()
        }
        
    }
    
    func setUpUI() {
        loadingView.isHidden = false
        loadingView.showLoading()
        
        collectionsHeader.headerViewDelegate = self
        collectionsHeader.headerTitle.text = NSLocalizedString("COLLECTIONS_TITLE", comment: "COLLECTIONS_TITLE Label in the collections page").uppercased()

        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            collectionsHeader.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        } else {
            collectionsHeader.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Webservice call
    func getCollectionList() {
        _ = Alamofire.request(QatarMuseumRouter.CollectionList(["museum_id": museumId ?? 0])).responseObject { (response: DataResponse<Collections>) -> Void in
            switch response.result {
            case .success(let data):
                self.collection = data.collections!
                self.loadingView.stopLoading()
                self.loadingView.isHidden = true
                if (self.collection.count == 0) {
                    self.loadingView.stopLoading()
                    self.loadingView.noDataView.isHidden = false
                    self.loadingView.isHidden = false
                    self.loadingView.showNoDataView()
                }
                else {
                    self.saveOrUpdateCollectionCoredata()
                    self.museumCollectionView.reloadData()
                }
            case .failure( _):
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
    
    func registerNib() {
        let nib = UINib(nibName: "HeritageCell", bundle: nil)
        museumCollectionView?.register(nib, forCellWithReuseIdentifier: "heritageCellId")
    }
    
    //MARK: CollectionView Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionsCell : HeritageCollectionCell = museumCollectionView.dequeueReusableCell(withReuseIdentifier: "heritageCellId", for: indexPath) as! HeritageCollectionCell
        collectionsCell.setCollectionsCellValues(collectionList: collection[indexPath.row])
        loadingView.stopLoading()
        loadingView.isHidden = true
        return collectionsCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightValue = UIScreen.main.bounds.height/100
        return CGSize(width: museumCollectionView.frame.width, height: heightValue*27)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        loadCollectionDetail(currentRow: indexPath.row)
    }
    
    func loadCollectionDetail(currentRow: Int?) {
        let collectionDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "collectionDetailId") as! CollectionDetailViewController
        collectionDetailView.collectionId = collection[currentRow!].category
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(collectionDetailView, animated: false, completion: nil)
    }
    
    func addComingSoonPopup() {
        let viewFrame : CGRect = self.view.frame
         popupView.comingSoonPopupDelegate = self
        popupView.frame = viewFrame
        popupView.loadPopup()
        self.view.addSubview(popupView)
    }
 
    //MARK: HeaderView Delegates
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK: ComingSoon Delegate
    func closeButtonPressed() {
        self.popupView.removeFromSuperview()
    }
    
    //MARK: Coredata Method
    func saveOrUpdateCollectionCoredata() {
        if (collection.count > 0) {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                let fetchData = checkAddedToCoredata(entityName: "CollectionsEntity", idKey: "categoryId", idValue: nil) as! [CollectionsEntity]
                if (fetchData.count > 0) {
                    for i in 0 ... collection.count-1 {
                        let managedContext = getContext()
                        let collectionListDict : Collection?
                        collectionListDict = collection[i]
                        let fetchResult = checkAddedToCoredata(entityName: "CollectionsEntity", idKey: "categoryId", idValue: collection[i].category)
                        //update
                        if(fetchResult.count != 0) {
                            let collectionsdbDict = fetchResult[0] as! CollectionsEntity
                            collectionsdbDict.listName = collectionListDict?.name
                            collectionsdbDict.listImage = collectionListDict?.image
                            collectionsdbDict.collectionDesc = collectionListDict?.collectionDescription
                            collectionsdbDict.museumId = collectionListDict?.museumId
                            do {
                                try managedContext.save()
                            }
                            catch {
                                print(error)
                            }
                        } else {
                        self.saveToCoreData(collectionListDict: collectionListDict!, managedObjContext: managedContext)
                        }
                    }
                }
                else {
                    for i in 0 ... collection.count-1 {
                        let managedContext = getContext()
                        let collectionListDict : Collection?
                        collectionListDict = collection[i]
                        self.saveToCoreData(collectionListDict: collectionListDict!, managedObjContext: managedContext)
                    }
                }
            } else { // For Arabic Database
                let fetchData = checkAddedToCoredata(entityName: "CollectionsEntityArabic", idKey: "categoryId", idValue: nil) as! [CollectionsEntityArabic]
                if (fetchData.count > 0) {
                    for i in 0 ... collection.count-1 {
                        let managedContext = getContext()
                        let collectionListDict : Collection?
                        collectionListDict = collection[i]
                        let fetchResult = checkAddedToCoredata(entityName: "CollectionsEntityArabic", idKey: "categoryId", idValue: collection[i].category)
                        //update
                        if(fetchResult.count != 0) {
                            let collectionsdbDict = fetchResult[0] as! CollectionsEntityArabic
                            collectionsdbDict.listNameAr = collectionListDict?.name
                            collectionsdbDict.listImageAr = collectionListDict?.image
                            collectionsdbDict.collectionDescAr = collectionListDict?.collectionDescription
                            collectionsdbDict.museumId = collectionListDict?.museumId
                            do {
                                try managedContext.save()
                            }
                            catch {
                                print(error)
                            }
                        } else {
                            self.saveToCoreData(collectionListDict: collectionListDict!, managedObjContext: managedContext)
                        }
                    }
                }
                else {
                    for i in 0 ... collection.count-1 {
                        let managedContext = getContext()
                        let collectionListDict : Collection?
                        collectionListDict = collection[i]
                        self.saveToCoreData(collectionListDict: collectionListDict!, managedObjContext: managedContext)
                    }
                }
            }
        }
    }
    func saveToCoreData(collectionListDict: Collection, managedObjContext: NSManagedObjectContext) {
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            let collectionInfo: CollectionsEntity = NSEntityDescription.insertNewObject(forEntityName: "CollectionsEntity", into: managedObjContext) as! CollectionsEntity
            collectionInfo.listName = collectionListDict.name
            collectionInfo.listImage = collectionListDict.image
            collectionInfo.categoryId = collectionListDict.category
            collectionInfo.collectionDesc = collectionListDict.collectionDescription
            collectionInfo.museumId = collectionListDict.museumId
            
        }
        else {
            let collectionInfo: CollectionsEntityArabic = NSEntityDescription.insertNewObject(forEntityName: "CollectionsEntityArabic", into: managedObjContext) as! CollectionsEntityArabic
            collectionInfo.listNameAr = collectionListDict.name
            collectionInfo.listImageAr = collectionListDict.image
            collectionInfo.categoryId = collectionListDict.category
            collectionInfo.collectionDescAr = collectionListDict.collectionDescription
            collectionInfo.museumId = collectionListDict.museumId
        }
        do {
            try managedObjContext.save()
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func fetchCollectionListFromCoredata() {
        
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                var collectionArray = [CollectionsEntity]()
                collectionArray = checkAddedToCoredata(entityName: "CollectionsEntity", idKey: "museumId", idValue: museumId) as! [CollectionsEntity]
                if (collectionArray.count > 0) {
                    for i in 0 ... collectionArray.count-1 {
                        self.collection.insert(Collection(name: collectionArray[i].listName, image: collectionArray[i].listImage, category: collectionArray[i].categoryId,collectionDescription:collectionArray[i].collectionDesc,museumId:collectionArray[i].museumId, title: nil, about: nil, imgHighlight: nil, imageMain: nil, shortDesc: nil, highlightDesc: nil, longDesc: nil), at: i)
                        
                    }
                    if(collection.count == 0){
                        self.showNodata()
                    }
                    museumCollectionView.reloadData()
                }
                else{
                    self.showNodata()
                }
            }
            else {
                var collectionArray = [CollectionsEntityArabic]()
                collectionArray = checkAddedToCoredata(entityName: "CollectionsEntityArabic", idKey: "museumId", idValue: museumId) as! [CollectionsEntityArabic]
                if (collectionArray.count > 0) {
                    for i in 0 ... collectionArray.count-1 {
                        
                        self.collection.insert(Collection(name: collectionArray[i].listNameAr, image: collectionArray[i].listImageAr, category: collectionArray[i].categoryId,collectionDescription:collectionArray[i].collectionDescAr,museumId:collectionArray[i].museumId, title: nil, about: nil, imgHighlight: nil, imageMain: nil, shortDesc: nil, highlightDesc: nil, longDesc: nil), at: i)
                    }
                    if(collection.count == 0){
                        self.showNodata()
                    }
                    museumCollectionView.reloadData()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//
//  MiaTourGuideViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 17/07/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Alamofire
import CoreData
import Crashlytics
import UIKit

class MiaTourGuideViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,HeaderViewProtocol,comingSoonPopUpProtocol,UICollectionViewDelegateFlowLayout,MiaTourProtocol,LoadingViewProtocol {
    @IBOutlet weak var miaTourCollectionView: UICollectionView!
    @IBOutlet weak var topbarView: CommonHeaderView!
    
    @IBOutlet weak var loadingView: LoadingView!
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
 
    let networkReachability = NetworkReachabilityManager()
    var museumId :String = "63"
    var miaTourDataFullArray: [TourGuide] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        registerNib()
    }

    func setUpUI() {
        loadingView.isHidden = false
        loadingView.loadingViewDelegate = self
        loadingView.showLoading()
        if  (networkReachability?.isReachable)! {
            getTourGuideDataFromServer()
        } else {
            self.showNoNetwork()
        }
        
        topbarView.headerViewDelegate = self
        topbarView.headerTitle.isHidden = true
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            topbarView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        } else {
            topbarView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func registerNib() {
        let nib = UINib(nibName: "HomeCollectionCell", bundle: nil)
        miaTourCollectionView?.register(nib, forCellWithReuseIdentifier: "homeCellId")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return miaTourDataFullArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : HomeCollectionViewCell = miaTourCollectionView.dequeueReusableCell(withReuseIdentifier: "homeCellId", for: indexPath) as! HomeCollectionViewCell
        cell.setScienceTourGuideCellData(homeCellData: miaTourDataFullArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        loadMiaTourDetail(currentRow: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightValue = UIScreen.main.bounds.height/100
        return CGSize(width: miaTourCollectionView.frame.width, height: heightValue*27)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let miaTourHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "miaTourHeader", for: indexPath) as! MiaCollectionReusableView
        if (miaTourDataFullArray.count > 0) {
            miaTourHeaderView.setHeader()
        }
        miaTourHeaderView.miaTourDelegate = self
        return miaTourHeaderView
    }

    func loadMiaTourDetail(currentRow: Int?) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        
        let miaView =  self.storyboard?.instantiateViewController(withIdentifier: "miaDetailId") as! MiaTourDetailViewController
        if (miaTourDataFullArray != nil) {
            miaView.tourGuideDetail = miaTourDataFullArray[currentRow!]
        }
        self.present(miaView, animated: false, completion: nil)
    }
    func loadComingSoonPopup() {
        popupView  = ComingSoonPopUp(frame: self.view.frame)
        popupView.comingSoonPopupDelegate = self
        popupView.loadTourGuidePopup()
        self.view.addSubview(popupView)
        
    }
    //MARK: Poup Delegate
    func closeButtonPressed() {
        self.popupView.removeFromSuperview()
    }
    //MARK: Header delegate
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK: Mia Tour Guide Delegate
    func exploreButtonTapAction(miaHeader: MiaCollectionReusableView) {
        var searchstring = String()
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            searchstring = "12476"
        } else {
            searchstring = "12476"
        }
        
        
        if (miaTourDataFullArray != nil) {
            if let arrayOffset = miaTourDataFullArray.index(where: {$0.nid == searchstring}) {
                let miaView =  self.storyboard?.instantiateViewController(withIdentifier: "miaDetailId") as! MiaTourDetailViewController
                miaView.tourGuideDetail = miaTourDataFullArray[arrayOffset]
                let transition = CATransition()
                transition.duration = 0.3
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromRight
                view.window!.layer.add(transition, forKey: kCATransition)
                self.present(miaView, animated: false, completion: nil)
            }
            
        }
        
    }
    //MARK: WebServiceCall
    func getTourGuideDataFromServer() {
        _ = Alamofire.request(QatarMuseumRouter.MuseumTourGuide(["museum_id": museumId])).responseObject { (response: DataResponse<TourGuides>) -> Void in
            switch response.result {
            case .success(let data):
                self.miaTourDataFullArray = data.tourGuide!
                self.loadingView.stopLoading()
                self.loadingView.isHidden = true
                if(self.miaTourDataFullArray.count == 0) {
                    self.loadingView.stopLoading()
                    self.loadingView.noDataView.isHidden = false
                    self.loadingView.isHidden = false
                    self.loadingView.showNoDataView()
                    self.loadingView.noDataLabel.text = NSLocalizedString("NO_RESULT_MESSAGE",
                                                                          comment: "Setting the content of the alert")
                }
                self.miaTourCollectionView.reloadData()
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
   /*
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
                        self.diningListArray.insert(Dining(id: diningArray[i].id, name: diningArray[i].name, location: diningArray[i].location, description: diningArray[i].diningdescription, image: diningArray[i].image, openingtime: diningArray[i].openingtime, closetime: diningArray[i].closetime, sortid: diningArray[i].sortid,museumId: diningArray[i].museumId), at: i)
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
            else {
                var diningArray = [DiningEntityArabic]()
                diningArray = checkAddedToCoredata(entityName: "DiningEntityArabic", idKey: "museumId", idValue: museumId) as! [DiningEntityArabic]
                if (diningArray.count > 0) {
                    for i in 0 ... diningArray.count-1 {
                        
                        self.diningListArray.insert(Dining(id: diningArray[i].id, name: diningArray[i].namearabic, location: diningArray[i].locationarabic, description: diningArray[i].descriptionarabic, image: diningArray[i].imagearabic, openingtime: diningArray[i].openingtimearabic, closetime: diningArray[i].closetimearabic, sortid: diningArray[i].sortidarabic,museumId: diningArray[i].museumId), at: i)
                        
                        
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
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate =  UIApplication.shared.delegate as? AppDelegate
        if #available(iOS 10.0, *) {
            return appDelegate!.persistentContainer.viewContext
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
            fetchRequest.predicate = NSPredicate(format: "\(idKey!) == %@", idValue!)
            
        }
        fetchResults = try! managedContext.fetch(fetchRequest)
        return fetchResults
    }
    */
    
    
    //MARK: LoadingView Delegate
    func tryAgainButtonPressed() {
        if  (networkReachability?.isReachable)! {
            self.getTourGuideDataFromServer()
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
    }

}

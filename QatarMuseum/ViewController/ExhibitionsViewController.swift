//
//  ExhibitionsViewController.swift
//  QatarMuseum
//
//  Created by Exalture on 10/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

enum ExhbitionPageName {
    case homeExhibition
    case museumExhibition
}
class ExhibitionsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HeaderViewProtocol,comingSoonPopUpProtocol {
    @IBOutlet weak var exhibitionHeaderView: CommonHeaderView!
    @IBOutlet weak var exhibitionCollectionView: UICollectionView!
    @IBOutlet weak var exbtnLoadingView: LoadingView!
    
    var exhibition: [Exhibition]! = []
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
    var exhibitionsPageNameString : ExhbitionPageName?
    let networkReachability = NetworkReachabilityManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpExhibitionPageUi()
        registerNib()
        if  (networkReachability?.isReachable)! {
            getExhibitionDataFromServer()
        } else {
            self.fetchExhibitionsListFromCoredata()
        }
        
    }
    
    func setUpExhibitionPageUi() {
        exbtnLoadingView.isHidden = false
        exbtnLoadingView.showLoading()
        exhibitionHeaderView.headerViewDelegate = self
        //exhibitionHeaderView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        
        exhibitionHeaderView.headerTitle.text = NSLocalizedString("EXHIBITIONS_TITLE", comment: "EXHIBITIONS_TITLE Label in the Exhibitions page")
        popupView.comingSoonPopupDelegate = self
        
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            exhibitionHeaderView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        } else {
            exhibitionHeaderView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
    }
    
    func registerNib() {
        let nib = UINib(nibName: "ExhibitionsCellXib", bundle: nil)
        exhibitionCollectionView?.register(nib, forCellWithReuseIdentifier: "exhibitionCellId")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Service call
    func getExhibitionDataFromServer() {
        if (exhibitionsPageNameString == ExhbitionPageName.homeExhibition) {
            _ = Alamofire.request(QatarMuseumRouter.ExhibitionList()).responseObject { (response: DataResponse<Exhibitions>) -> Void in
                switch response.result {
                case .success(let data):
                    self.exhibition = data.exhibitions
                    self.saveOrUpdateExhibitionsCoredata()
                    self.exhibitionCollectionView.reloadData()
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
        } else {
           //for museums exhibition API
        }
    }
    
    //MARK: collectionview delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch exhibitionsPageNameString {
        case .homeExhibition?:
            return exhibition.count
        case .museumExhibition?:
            return exhibition.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let exhibitionCell : ExhibitionsCollectionCell = exhibitionCollectionView.dequeueReusableCell(withReuseIdentifier: "exhibitionCellId", for: indexPath) as! ExhibitionsCollectionCell
        switch exhibitionsPageNameString {
        case .homeExhibition?:
            exhibitionCell.setExhibitionCellValues(exhibition: exhibition[indexPath.row])
            exhibitionCell.exhibitionCellItemBtnTapAction = {
                () in
                self.loadExhibitionCellPages(cellObj: exhibitionCell, selectedIndex: indexPath.row)
            }
        case .museumExhibition?:
            exhibitionCell.setMuseumExhibitionCellValues(exhibition: exhibition[indexPath.row])
        default:
            break
        }
        
        exbtnLoadingView.stopLoading()
        exbtnLoadingView.isHidden = true
        return exhibitionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightValue = UIScreen.main.bounds.height/100
        return CGSize(width: exhibitionCollectionView.frame.width, height: heightValue*27)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // loadExhibitionDetail()
        if exhibitionsPageNameString == ExhbitionPageName.homeExhibition, let exhibitionId = exhibition[indexPath.row].id {
            loadExhibitionDetailAnimation(exhibitionId: exhibitionId)
        } else if exhibitionsPageNameString == ExhbitionPageName.museumExhibition && indexPath.row == 0 {
            loadExhibitionDetailAnimation(exhibitionId: "")
        } else {
            addComingSoonPopup()
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
    
    func loadExhibitionDetailAnimation(exhibitionId: String) {
        let exhibitionDtlView = self.storyboard?.instantiateViewController(withIdentifier: "exhibitionDtlId") as! ExhibitionDetailViewController
        if (exhibitionsPageNameString == ExhbitionPageName.homeExhibition) {
            exhibitionDtlView.fromHome = true
            exhibitionDtlView.exhibitionId = exhibitionId
        } else {
            exhibitionDtlView.fromHome = false
        }
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

    func closeButtonPressed() {
        self.popupView.removeFromSuperview()
    }
    //MARK: Coredata Method
    func saveOrUpdateExhibitionsCoredata() {
        if (exhibition.count > 0) {
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                let fetchData = checkAddedToCoredata(entityName: "ExhibitionsEntity", exhibitionId: nil) as! [ExhibitionsEntity]
                if (fetchData.count > 0) {
                    for i in 0 ... exhibition.count-1 {
                        let managedContext = getContext()
                        let exhibitionsListDict = exhibition[i]
                        let fetchResult = checkAddedToCoredata(entityName: "ExhibitionsEntity", exhibitionId: exhibition[i].id)
                        //update
                        if(fetchResult.count != 0) {
                            let exhibitionsdbDict = fetchResult[0] as! ExhibitionsEntity
                            exhibitionsdbDict.name = exhibitionsListDict.name
                            exhibitionsdbDict.image = exhibitionsListDict.image
                            exhibitionsdbDict.startDate =  exhibitionsListDict.startDate
                            exhibitionsdbDict.endDate = exhibitionsListDict.endDate
                            exhibitionsdbDict.location =  exhibitionsListDict.location
                            
                            do {
                                try managedContext.save()
                            }
                            catch {
                                print(error)
                            }
                        } else {
                            //save
                            self.saveToCoreData(exhibitionDict: exhibitionsListDict, managedObjContext: managedContext)
                        }
                    }
                } else {
                    for i in 0 ... exhibition.count-1 {
                        let managedContext = getContext()
                        let exhibitionListDict : Exhibition?
                        exhibitionListDict = exhibition[i]
                        self.saveToCoreData(exhibitionDict: exhibitionListDict!, managedObjContext: managedContext)
                    }
                }
            } else {
                let fetchData = checkAddedToCoredata(entityName: "ExhibitionsEntityArabic", exhibitionId: nil) as! [ExhibitionsEntityArabic]
                if (fetchData.count > 0) {
                    for i in 0 ... exhibition.count-1 {
                        let managedContext = getContext()
                        let exhibitionListDict = exhibition[i]
                        let fetchResult = checkAddedToCoredata(entityName: "ExhibitionsEntityArabic", exhibitionId: exhibition[i].id)
                        //update
                        if(fetchResult.count != 0) {
                            let exhibitiondbDict = fetchResult[0] as! ExhibitionsEntityArabic
                            exhibitiondbDict.nameArabic = exhibitionListDict.name
                            exhibitiondbDict.imageArabic = exhibitionListDict.image
                            exhibitiondbDict.startDateArabic =  exhibitionListDict.startDate
                            exhibitiondbDict.endDateArabic = exhibitionListDict.endDate
                            exhibitiondbDict.locationArabic =  exhibitionListDict.location
                            
                            do {
                                try managedContext.save()
                            }
                            catch {
                                print(error)
                            }
                        } else {
                            //save
                            self.saveToCoreData(exhibitionDict: exhibitionListDict, managedObjContext: managedContext)
                            
                        }
                    }
                } else {
                    for i in 0 ... exhibition.count-1 {
                        let managedContext = getContext()
                        let exhibitionListDict : Exhibition?
                        exhibitionListDict = exhibition[i]
                        self.saveToCoreData(exhibitionDict: exhibitionListDict!, managedObjContext: managedContext)
                        
                    }
                }
            }
        }
    }
    
    func saveToCoreData(exhibitionDict: Exhibition, managedObjContext: NSManagedObjectContext) {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            let exhibitionInfo: ExhibitionsEntity = NSEntityDescription.insertNewObject(forEntityName: "ExhibitionsEntity", into: managedObjContext) as! ExhibitionsEntity
          
            exhibitionInfo.id = exhibitionDict.id
            exhibitionInfo.name = exhibitionDict.name
            exhibitionInfo.image = exhibitionDict.image
            exhibitionInfo.startDate =  exhibitionDict.startDate
            exhibitionInfo.endDate = exhibitionDict.endDate
            exhibitionInfo.location =  exhibitionDict.location
        }
        else {
            let exhibitionInfo: ExhibitionsEntityArabic = NSEntityDescription.insertNewObject(forEntityName: "ExhibitionsEntityArabic", into: managedObjContext) as! ExhibitionsEntityArabic
            exhibitionInfo.id = exhibitionDict.id
            exhibitionInfo.nameArabic = exhibitionDict.name
            exhibitionInfo.imageArabic = exhibitionDict.image
            exhibitionInfo.startDateArabic =  exhibitionDict.startDate
            exhibitionInfo.endDateArabic = exhibitionDict.endDate
            exhibitionInfo.locationArabic =  exhibitionDict.location
        }
        do {
            try managedObjContext.save()
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func fetchExhibitionsListFromCoredata() {
        
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                var exhibitionArray = [ExhibitionsEntity]()
                let managedContext = getContext()
                let exhibitionFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "ExhibitionsEntity")
                exhibitionArray = (try managedContext.fetch(exhibitionFetchRequest) as? [ExhibitionsEntity])!
                if (exhibitionArray.count > 0) {
                    for i in 0 ... exhibitionArray.count-1 {
                        self.exhibition.insert(Exhibition(id: exhibitionArray[i].id, name: exhibitionArray[i].name, image: exhibitionArray[i].image,detailImage:nil, startDate: exhibitionArray[i].startDate, endDate: exhibitionArray[i].endDate, location: exhibitionArray[i].location, latitude: nil, longitude: nil, shortDescription: nil, longDescription: nil), at: i)
                        
                    }
                    if(exhibition.count == 0){
                        self.showNodata()
                    }
                    exhibitionCollectionView.reloadData()
                }
                else{
                    self.showNodata()
                }
            }
            else {
                var exhibitionArray = [ExhibitionsEntityArabic]()
                let managedContext = getContext()
                let exhibitionFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "ExhibitionsEntityArabic")
                exhibitionArray = (try managedContext.fetch(exhibitionFetchRequest) as? [ExhibitionsEntityArabic])!
                if (exhibitionArray.count > 0) {
                    for i in 0 ... exhibitionArray.count-1 {
                        
                        self.exhibition.insert(Exhibition(id: exhibitionArray[i].id, name: exhibitionArray[i].nameArabic, image: exhibitionArray[i].imageArabic,detailImage:nil, startDate: exhibitionArray[i].startDateArabic, endDate: exhibitionArray[i].endDateArabic, location: exhibitionArray[i].locationArabic, latitude: nil, longitude: nil, shortDescription: nil, longDescription: nil), at: i)
                        
                    }
                    if(exhibition.count == 0){
                        self.showNodata()
                    }
                    exhibitionCollectionView.reloadData()
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
    func checkAddedToCoredata(entityName: String?,exhibitionId: String?) -> [NSManagedObject]
    {
        let managedContext = getContext()
        var fetchResults : [NSManagedObject] = []
        let homeFetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName!)
        if (exhibitionId != nil) {
            homeFetchRequest.predicate = NSPredicate.init(format: "id == \(exhibitionId!)")
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

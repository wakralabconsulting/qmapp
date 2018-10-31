//
//  TourGuideViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 16/07/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Alamofire
import CoreData
import Crashlytics
import UIKit

class TourGuideViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,HeaderViewProtocol,comingSoonPopUpProtocol,UICollectionViewDelegateFlowLayout,LoadingViewProtocol {
    @IBOutlet weak var tourCollectionView: UICollectionView!
    @IBOutlet weak var topbarView: CommonHeaderView!
    
    @IBOutlet weak var loadingView: LoadingView!
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
    var fromHome : Bool = false
    var museumsList: [Home]! = []
    var fromSideMenu : Bool = false
    let networkReachability = NetworkReachabilityManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        registerNib()
    }

    func setUpUI() {
        self.loadingView.isHidden = false
        self.loadingView.showLoading()
        self.loadingView.loadingViewDelegate = self
        if  (networkReachability?.isReachable)! {
            getTourGuideMuseumsList()
        } else {
            self.fetchMuseumsInfoFromCoredata()
        }
        topbarView.headerViewDelegate = self
        topbarView.headerTitle.isHidden = true
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            
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
        tourCollectionView?.register(nib, forCellWithReuseIdentifier: "homeCellId")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return museumsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : HomeCollectionViewCell = tourCollectionView.dequeueReusableCell(withReuseIdentifier: "homeCellId", for: indexPath) as! HomeCollectionViewCell
        
        cell.tourGuideImage.image = UIImage(named: "location")
        cell.setTourGuideCellData(museumsListData: museumsList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (museumsList != nil) {
            if(((museumsList[indexPath.row].id) == "63") || ((museumsList[indexPath.row].id) == "96") || ((museumsList[indexPath.row].id) == "61") || ((museumsList[indexPath.row].id) == "635")) {
                loadMiaTour(currentRow: indexPath.row)
            } else {
                loadComingSoonPopup()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightValue = UIScreen.main.bounds.height/100
        return CGSize(width: tourCollectionView.frame.width, height: heightValue*27)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let tourHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "tourHeader", for: indexPath) as! TourGuideCollectionReusableView
        tourHeaderView.tourGuideTitle.text = NSLocalizedString("TOUR_GUIDES", comment: "TOUR_GUIDES  in the Tour Guide page")
        tourHeaderView.tourGuideText.text = NSLocalizedString("TOUR_GUIDE_TEXT", comment: "TOUR_GUIDE_TEXT  in the Tour Guide page")
        
        
        
        return tourHeaderView
    }
    func loadMiaTour(currentRow: Int?) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        let miaView =  self.storyboard?.instantiateViewController(withIdentifier: "miaTourGuideId") as! MiaTourGuideViewController
        if (museumsList != nil) {
            miaView.museumId = museumsList[currentRow!].id!
            self.present(miaView, animated: false, completion: nil)
        }
        
        
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
        if (fromSideMenu == true) {
            transition.type = kCATransitionFade
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            self.view.window!.layer.add(transition, forKey: kCATransition)
            dismiss(animated: false, completion: nil)
        } else {
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            self.view.window!.layer.add(transition, forKey: kCATransition)
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "homeId") as! HomeViewController
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = homeViewController
        }
    }
    //MARK: Service call
    func getTourGuideMuseumsList() {
        var searchstring = String()
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            searchstring = "12181"
        } else {
            searchstring = "12186"
        }
        _ = Alamofire.request(QatarMuseumRouter.HomeList()).responseObject { (response: DataResponse<HomeList>) -> Void in
            switch response.result {
            case .success(let data):
                self.museumsList = data.homeList
                self.saveOrUpdateMuseumsCoredata()
                self.loadingView.stopLoading()
                self.loadingView.isHidden = true
                if(self.museumsList.count > 0) {
                    //Removed Exhibition from Tour List
                    if let arrayOffset = self.museumsList.index(where: {$0.id == searchstring}) {
                        self.museumsList.remove(at: arrayOffset)
                    }
                }
                //self.saveOrUpdateHomeCoredata()
                self.tourCollectionView.reloadData()
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
    func saveOrUpdateMuseumsCoredata() {
        if (museumsList.count > 0) {
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                let fetchData = checkAddedToCoredata(entityName: "HomeEntity", homeId: nil) as! [HomeEntity]
                if (fetchData.count > 0) {
                    for i in 0 ... museumsList.count-1 {
                        let managedContext = getContext()
                        let museumListDict = museumsList[i]
                        let fetchResult = checkAddedToCoredata(entityName: "HomeEntity", homeId: museumsList[i].id)
                        //update
                        if(fetchResult.count != 0) {
                            let museumsdbDict = fetchResult[0] as! HomeEntity
                            
                            museumsdbDict.name = museumListDict.name
                            museumsdbDict.image = museumListDict.image
                            museumsdbDict.sortid =  museumListDict.sortId
                            museumsdbDict.tourguideavailable = museumListDict.isTourguideAvailable
                            
                            
                            do{
                                try managedContext.save()
                            }
                            catch{
                                print(error)
                            }
                        }
                        else {
                            //save
                            self.saveToCoreData(museumsListDict: museumListDict, managedObjContext: managedContext)
                            
                        }
                    }
                }
                else {
                    for i in 0 ... museumsList.count-1 {
                        let managedContext = getContext()
                        let museumsListDict : Home?
                        museumsListDict = museumsList[i]
                        self.saveToCoreData(museumsListDict: museumsListDict!, managedObjContext: managedContext)
                        
                    }
                }
            }
            else {
                let fetchData = checkAddedToCoredata(entityName: "HomeEntityArabic", homeId: nil) as! [HomeEntityArabic]
                if (fetchData.count > 0) {
                    for i in 0 ... museumsList.count-1 {
                        let managedContext = getContext()
                        let museumsListDict = museumsList[i]
                        
                        let fetchResult = checkAddedToCoredata(entityName: "HomeEntityArabic", homeId: museumsList[i].id)
                        //update
                        if(fetchResult.count != 0) {
                            let museumsdbDict = fetchResult[0] as! HomeEntityArabic
                            
                            museumsdbDict.arabicname = museumsListDict.name
                            museumsdbDict.arabicimage = museumsListDict.image
                            museumsdbDict.arabicsortid =  museumsListDict.sortId
                            museumsdbDict.arabictourguideavailable = museumsListDict.isTourguideAvailable
                            do{
                                try managedContext.save()
                            }
                            catch{
                                print(error)
                            }
                        }
                        else {
                            //save
                            self.saveToCoreData(museumsListDict: museumsListDict, managedObjContext: managedContext)
                            
                        }
                    }
                }
                else {
                    for i in 0 ... museumsList.count-1 {
                        let managedContext = getContext()
                        let museumsListDict : Home?
                        museumsListDict = museumsList[i]
                        self.saveToCoreData(museumsListDict: museumsListDict!, managedObjContext: managedContext)
                        
                    }
                }
            }
        }
    }
    
    func saveToCoreData(museumsListDict: Home, managedObjContext: NSManagedObjectContext) {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            let museumsInfo: HomeEntity = NSEntityDescription.insertNewObject(forEntityName: "HomeEntity", into: managedObjContext) as! HomeEntity
            museumsInfo.id = museumsListDict.id
            museumsInfo.name = museumsListDict.name
            museumsInfo.image = museumsListDict.image
            museumsInfo.tourguideavailable = museumsListDict.isTourguideAvailable
            museumsInfo.image = museumsListDict.image
            museumsInfo.sortid = museumsListDict.sortId
        }
        else{
            let museumsInfo: HomeEntityArabic = NSEntityDescription.insertNewObject(forEntityName: "HomeEntityArabic", into: managedObjContext) as! HomeEntityArabic
            museumsInfo.id = museumsListDict.id
            museumsInfo.arabicname = museumsListDict.name
            museumsInfo.arabicimage = museumsListDict.image
            museumsInfo.arabictourguideavailable = museumsListDict.isTourguideAvailable
            museumsInfo.arabicsortid = museumsListDict.sortId
        }
        do {
            try managedObjContext.save()
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func fetchMuseumsInfoFromCoredata() {
        self.loadingView.stopLoading()
        self.loadingView.isHidden = true
        var searchstring = String()
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            searchstring = "12181"
        } else {
            searchstring = "12186"
        }
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                var museumsArray = [HomeEntity]()
                let managedContext = getContext()
                let museumsFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "HomeEntity")
                museumsArray = (try managedContext.fetch(museumsFetchRequest) as? [HomeEntity])!
                if (museumsArray.count > 0) {
                    for i in 0 ... museumsArray.count-1 {
                        
                        self.museumsList.insert(Home(id:museumsArray[i].id , name: museumsArray[i].name,image: museumsArray[i].image,
                                                  tourguide_available: museumsArray[i].tourguideavailable, sort_id: museumsArray[i].sortid),
                                             at: i)
                    }
                    if(museumsList.count == 0){
                        self.showNoNetwork()
                    } else {
                        //Removed Exhibition from Tour List
                        if let arrayOffset = self.museumsList.index(where: {$0.id == searchstring}) {
                            self.museumsList.remove(at: arrayOffset)
                        }
                    }
                    tourCollectionView.reloadData()
                }
                else{
                    self.showNoNetwork()
                }
            }
            else {
                var museumsArray = [HomeEntityArabic]()
                let managedContext = getContext()
                let museumFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "HomeEntityArabic")
                museumsArray = (try managedContext.fetch(museumFetchRequest) as? [HomeEntityArabic])!
                if (museumsArray.count > 0) {
                    for i in 0 ... museumsArray.count-1 {
                        self.museumsList.insert(Home(id:museumsArray[i].id , name: museumsArray[i].arabicname,image: museumsArray[i].arabicimage,
                                                  tourguide_available: museumsArray[i].arabictourguideavailable, sort_id: museumsArray[i].arabicsortid),
                                             at: i)
                    }
                    if(museumsList.count == 0){
                        self.showNoNetwork()
                    } else {
                        //Removed Exhibition from Tour List
                        if let arrayOffset = self.museumsList.index(where: {$0.id == searchstring}) {
                            self.museumsList.remove(at: arrayOffset)
                        }
                    }
                    tourCollectionView.reloadData()
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
    func checkAddedToCoredata(entityName: String?, homeId: String?) -> [NSManagedObject]
    {
        let managedContext = getContext()
        var fetchResults : [NSManagedObject] = []
        let homeFetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName!)
        if (homeId != nil) {
            homeFetchRequest.predicate = NSPredicate.init(format: "id == \(homeId!)")
        }
        fetchResults = try! managedContext.fetch(homeFetchRequest)
        return fetchResults
    }
    //MARK: LoadingView Delegate
    func tryAgainButtonPressed() {
        if  (networkReachability?.isReachable)! {
            self.getTourGuideMuseumsList()
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

//
//  HeritageDetailViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 21/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Alamofire
import CoreData
import UIKit
enum PageName{
    case heritageDetail
    case publicArtsDetail
    case museumAbout
}
class HeritageDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var heritageDetailTableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    
    let imageView = UIImageView()
    let closeButton = UIButton()
    var blurView = UIVisualEffectView()
    var pageNameString : PageName?
    var heritageDetailtArray: [Heritage] = []
    var publicArtsDetailtArray: [PublicArtsDetail] = []
    var heritageDetailId : String? = nil
    var publicArtsDetailId : String? = nil
    let networkReachability = NetworkReachabilityManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUIContents()
        if ((pageNameString == PageName.heritageDetail) && (heritageDetailId != nil)) {
            if  (networkReachability?.isReachable)! {
                getHeritageDetailsFromServer()
            }
            else {
                self.fetchHeritageDetailsFromCoredata()
            }
        }
        else if ((pageNameString == PageName.publicArtsDetail) && (publicArtsDetailId != nil)) {
            getPublicArtsDetailsFromServer()
        }
    }
    
    func setupUIContents() {
        loadingView.isHidden = false
        loadingView.showLoading()
        setTopBarImage()
    }
    
    func setTopBarImage() {
        heritageDetailTableView.estimatedRowHeight = 50
        heritageDetailTableView.contentInset = UIEdgeInsetsMake(300, 0, 0, 0)
        
        imageView.frame = CGRect(x: 0, y:20, width: UIScreen.main.bounds.size.width, height: 300)
        if (pageNameString == PageName.heritageDetail) {
            if heritageDetailtArray.count != 0 {
                if let imageUrl = heritageDetailtArray[0].image{
                    imageView.kf.setImage(with: URL(string: imageUrl))
                }
            }
        } else if (pageNameString == PageName.publicArtsDetail){
            if publicArtsDetailtArray.count != 0 {
                if let imageUrl = publicArtsDetailtArray[0].image{
                    imageView.kf.setImage(with: URL(string: imageUrl))
                }
            }
        } else {
            imageView.image = UIImage.init(named: "museum_of_islamic_details")
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.light)
        blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = imageView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0
        imageView.addSubview(blurView)
        
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            closeButton.frame = CGRect(x: 10, y: 30, width: 40, height: 40)
        } else {
            closeButton.frame = CGRect(x: self.view.frame.width-50, y: 30, width: 40, height: 40)
        }
        closeButton.setImage(UIImage(named: "closeX1"), for: .normal)
        closeButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom:12, right: 12)
        
        closeButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeTouchDownAction), for: .touchDown)
        
        closeButton.layer.shadowColor = UIColor.black.cgColor
        closeButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        closeButton.layer.shadowRadius = 3
        closeButton.layer.shadowOpacity = 2.0
        view.addSubview(closeButton)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (pageNameString == PageName.heritageDetail) {
            return heritageDetailtArray.count
        } else if (pageNameString == PageName.publicArtsDetail){
            return publicArtsDetailtArray.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let heritageCell = tableView.dequeueReusableCell(withIdentifier: "heritageDetailCellId", for: indexPath) as! HeritageDetailCell
        if (pageNameString == PageName.heritageDetail) {
            heritageCell.setHeritageDetailData(heritageDetail: heritageDetailtArray[indexPath.row])
            heritageCell.midTitleDescriptionLabel.textAlignment = .center
        } else if(pageNameString == PageName.publicArtsDetail){
            heritageCell.setPublicArtsDetailValues(publicArsDetail: publicArtsDetailtArray[indexPath.row])
        } else {
            heritageCell.setMuseumAboutCellData()
        }
        heritageCell.favBtnTapAction = {
            () in
            self.setFavouritesAction(cellObj: heritageCell)
        }
        heritageCell.shareBtnTapAction = {
            () in
            self.setShareAction(cellObj: heritageCell)
        }
        heritageCell.locationButtonTapAction = {
            () in
            self.loadLocationInMap()
        }
        loadingView.stopLoading()
        loadingView.isHidden = true
        return heritageCell
    }
    
    func setFavouritesAction(cellObj :HeritageDetailCell) {
        if (cellObj.favoriteButton.tag == 0) {
            cellObj.favoriteButton.tag = 1
            cellObj.favoriteButton.setImage(UIImage(named: "heart_fillX1"), for: .normal)
        } else {
            cellObj.favoriteButton.tag = 0
            cellObj.favoriteButton.setImage(UIImage(named: "heart_emptyX1"), for: .normal)
        }
    }
    
    func setShareAction(cellObj :HeritageDetailCell) {
        
    }
    
    func loadLocationInMap() {
        let latitude = "10.0119266"
        let longitude =  "76.3492956"
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)")!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(URL(string:"comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)")!)
            }
        } else {
            let locationUrl = URL(string: "https://maps.google.com/?q=@\(latitude),\(longitude)")!
            UIApplication.shared.openURL(locationUrl)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 300 - (scrollView.contentOffset.y + 300)
        let height = min(max(y, 60), 400)
        imageView.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: height)
        
        if (imageView.frame.height >= 300 ){
            blurView.alpha  = 0.0
        } else if (imageView.frame.height >= 250 ){
            blurView.alpha  = 0.2
        } else if (imageView.frame.height >= 200 ){
            blurView.alpha  = 0.4
        } else if (imageView.frame.height >= 150 ){
            blurView.alpha  = 0.6
        } else if (imageView.frame.height >= 100 ){
            blurView.alpha  = 0.8
        } else if (imageView.frame.height >= 50 ){
            blurView.alpha  = 0.9
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    @objc func closeTouchDownAction(sender: UIButton!) {
        sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
    //MARK: WebServiceCall
    func getHeritageDetailsFromServer() {
        _ = Alamofire.request(QatarMuseumRouter.HeritageDetail(["nid": heritageDetailId!])).responseObject { (response: DataResponse<Heritages>) -> Void in
            switch response.result {
            case .success(let data):
                self.heritageDetailtArray = data.heritage!
                self.setTopBarImage()
                self.saveOrUpdateHeritageCoredata()
                self.heritageDetailTableView.reloadData()
                self.loadingView.stopLoading()
                self.loadingView.isHidden = true
                if (self.heritageDetailtArray.count == 0) {
                    self.loadingView.stopLoading()
                    self.loadingView.noDataView.isHidden = false
                    self.loadingView.isHidden = false
                    self.loadingView.showNoDataView()
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
    
    //MARK: PublicArts webservice call
    func getPublicArtsDetailsFromServer() {
        _ = Alamofire.request(QatarMuseumRouter.GetPublicArtsDetail(["nid": publicArtsDetailId!])).responseObject { (response: DataResponse<PublicArtsDetails>) -> Void in
            switch response.result {
            case .success(let data):
                self.publicArtsDetailtArray = data.publicArtsDetail!
                self.setTopBarImage()
                self.saveOrUpdateHeritageCoredata()
                self.heritageDetailTableView.reloadData()
                self.loadingView.stopLoading()
                self.loadingView.isHidden = true
                if (self.publicArtsDetailtArray.count == 0) {
                    self.loadingView.stopLoading()
                    self.loadingView.noDataView.isHidden = false
                    self.loadingView.isHidden = false
                    self.loadingView.showNoDataView()
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
    //MARK: Coredata Method
    func saveOrUpdateHeritageCoredata() {
        if (heritageDetailtArray.count > 0) {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            let fetchData = checkAddedToCoredata(entityName: "HeritageEntity", heritageId: heritageDetailtArray[0].id) as! [HeritageEntity]
           if (fetchData.count > 0) {
            let managedContext = getContext()
            let heritageDetailDict = heritageDetailtArray[0]
            
            //update
            let heritagedbDict = fetchData[0]
            
            heritagedbDict.listname = heritageDetailDict.name
            heritagedbDict.listimage = heritageDetailDict.image
            heritagedbDict.listsortid =  heritageDetailDict.sortid
            heritagedbDict.detaillocation = heritageDetailDict.location
            heritagedbDict.detailshortdescription = heritageDetailDict.shortdescription
            heritagedbDict.detaillongdescription =  heritageDetailDict.longdescription
            heritagedbDict.detaillatitude =  heritageDetailDict.latitude
            heritagedbDict.detaillongitude = heritageDetailDict.longitude
            
            do{
                try managedContext.save()
            }
            catch{
                print(error)
            }
           }
            else {
            let managedContext = getContext()
            let heritageListDict : Heritage?
            heritageListDict = heritageDetailtArray[0]
            self.saveToCoreData(heritageDetailDict: heritageListDict!, managedObjContext: managedContext)
            }
        }
        else {
            let fetchData = checkAddedToCoredata(entityName: "HeritageEntityArabic", heritageId: heritageDetailtArray[0].id) as! [HeritageEntityArabic]
            if (fetchData.count > 0) {
                let managedContext = getContext()
                let heritageDetailDict = heritageDetailtArray[0]
                
                //update
                
                let heritagedbDict = fetchData[0]
                heritagedbDict.listnamearabic = heritageDetailDict.name
                heritagedbDict.listimagearabic = heritageDetailDict.image
                heritagedbDict.listsortidarabic =  heritageDetailDict.sortid
                heritagedbDict.detaillocationarabic = heritageDetailDict.location
                heritagedbDict.detailshortdescarabic = heritageDetailDict.shortdescription
                heritagedbDict.detaillongdescriptionarabic =  heritageDetailDict.longdescription
                heritagedbDict.detaillatitudearabic =  heritageDetailDict.latitude
                heritagedbDict.detaillongitudearabic = heritageDetailDict.longitude
                
                do{
                    try managedContext.save()
                }
                catch{
                    print(error)
                }
            }
            else {
                let managedContext = getContext()
                let heritageListDict : Heritage?
                heritageListDict = heritageDetailtArray[0]
                self.saveToCoreData(heritageDetailDict: heritageListDict!, managedObjContext: managedContext)
            }
        }
        }
    }
    func saveToCoreData(heritageDetailDict: Heritage, managedObjContext: NSManagedObjectContext) {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            let heritageInfo: HeritageEntity = NSEntityDescription.insertNewObject(forEntityName: "HeritageEntity", into: managedObjContext) as! HeritageEntity
            heritageInfo.listid = heritageDetailDict.id
            heritageInfo.listname = heritageDetailDict.name
            
            heritageInfo.listimage = heritageDetailDict.image
            heritageInfo.detaillocation = heritageDetailDict.location
            heritageInfo.detailshortdescription = heritageDetailDict.shortdescription
            heritageInfo.detaillongdescription =  heritageDetailDict.longdescription
            heritageInfo.detaillatitude =  heritageDetailDict.latitude
            heritageInfo.detaillongitude = heritageDetailDict.longitude
            if(heritageDetailDict.sortid != nil) {
                heritageInfo.listsortid = heritageDetailDict.sortid
            }
        }
        else {
            let heritageInfo: HeritageEntityArabic = NSEntityDescription.insertNewObject(forEntityName: "HeritageEntityArabic", into: managedObjContext) as! HeritageEntityArabic
            heritageInfo.listid = heritageDetailDict.id
            heritageInfo.listnamearabic = heritageDetailDict.name
            
            heritageInfo.listimagearabic = heritageDetailDict.image
            heritageInfo.detaillocationarabic = heritageDetailDict.location
            heritageInfo.detailshortdescarabic = heritageDetailDict.shortdescription
            heritageInfo.detaillongdescriptionarabic =  heritageDetailDict.longdescription
            heritageInfo.detaillatitudearabic =  heritageDetailDict.latitude
            heritageInfo.detaillongitudearabic = heritageDetailDict.longitude
            if(heritageDetailDict.sortid != nil) {
                heritageInfo.listsortidarabic = heritageDetailDict.sortid
            }
        }
        do {
            try managedObjContext.save()
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func fetchHeritageDetailsFromCoredata() {
        
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                var heritageArray = [HeritageEntity]()
                let managedContext = getContext()
                let heritageFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "HeritageEntity")
                if(heritageDetailId != nil) {
                    heritageFetchRequest.predicate = NSPredicate.init(format: "listid == \(heritageDetailId!)")
                }
                heritageArray = (try managedContext.fetch(heritageFetchRequest) as? [HeritageEntity])!
                let heritageDict = heritageArray[0]
                if ((heritageArray.count > 0) && (heritageDict.detailshortdescription != nil) && (heritageDict.detaillongdescription != nil) ){
                        self.heritageDetailtArray.insert(Heritage(id: heritageDict.listid, name: heritageDict.listname, location: heritageDict.detaillocation, latitude: heritageDict.detaillatitude, longitude: heritageDict.detaillongitude, image: heritageDict.listimage, shortdescription: heritageDict.detailshortdescription, longdescription: heritageDict.detaillongdescription, sortid: heritageDict.listsortid), at: 0)
                        
                    
                    if(heritageDetailtArray.count == 0){
                        self.showNodata()
                    }
                    self.setTopBarImage()
                    heritageDetailTableView.reloadData()
                }
                else{
                    self.showNodata()
                }
            }
            else {
                var heritageArray = [HeritageEntityArabic]()
                let managedContext = getContext()
                let heritageFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "HeritageEntityArabic")
                if(heritageDetailId != nil) {
                    heritageFetchRequest.predicate = NSPredicate.init(format: "listid == \(heritageDetailId!)")
                }
                heritageArray = (try managedContext.fetch(heritageFetchRequest) as? [HeritageEntityArabic])!
                let heritageDict = heritageArray[0]
                if ((heritageArray.count > 0) && (heritageDict.detailshortdescarabic != nil) && (heritageDict.detaillongdescriptionarabic != nil)) {
                    
                        self.heritageDetailtArray.insert(Heritage(id: heritageDict.listid, name: heritageDict.listnamearabic, location: heritageDict.detaillocationarabic, latitude: heritageDict.detaillatitudearabic, longitude: heritageDict.detaillongitudearabic, image: heritageDict.listimagearabic, shortdescription: heritageDict.detailshortdescarabic, longdescription: heritageDict.detaillongdescriptionarabic, sortid: heritageDict.listsortidarabic), at: 0)
                        
                    
                    if(heritageDetailtArray.count == 0){
                        self.showNodata()
                    }
                    self.setTopBarImage()
                    heritageDetailTableView.reloadData()
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
    func checkAddedToCoredata(entityName: String?,heritageId: String?) -> [NSManagedObject]
    {
        let managedContext = getContext()
        var fetchResults : [NSManagedObject] = []
        let heritageFetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName!)
        if (heritageId != nil) {
            heritageFetchRequest.predicate = NSPredicate.init(format: "listid == \(heritageId!)")
        }
        fetchResults = try! managedContext.fetch(heritageFetchRequest)
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

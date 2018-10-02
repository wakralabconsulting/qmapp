//
//  MuseumAboutViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 01/10/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//



import Alamofire
import CoreData
import Firebase
import  MapKit
import UIKit
enum PageName2{
    case heritageDetail
    case publicArtsDetail
    case museumAbout
}
class MuseumAboutViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, comingSoonPopUpProtocol,iCarouselDelegate,iCarouselDataSource,UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var heritageDetailTableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    
   
    
    
    
   
    let imageView = UIImageView()
    let closeButton = UIButton()
    var blurView = UIVisualEffectView()
    var pageNameString : PageName2?
    var heritageDetailtArray: [Heritage] = []
    var publicArtsDetailtArray: [PublicArtsDetail] = []
    //var aboutDetailtArray: [MuseumAbout] = []
    var aboutDetailtArray : [Museum] = []
    var heritageDetailId : String? = nil
    var publicArtsDetailId : String? = nil
    let networkReachability = NetworkReachabilityManager()
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
    var museumId : String? = nil
    var imgArray = NSArray()
    var carousel = iCarousel()
    var imgButton = UIButton()
    var transparentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIContents()
        if ((pageNameString == PageName2.heritageDetail) && (heritageDetailId != nil)) {
            if  (networkReachability?.isReachable)! {
                getHeritageDetailsFromServer()
            } else {
                self.fetchHeritageDetailsFromCoredata()
            }
        } else if ((pageNameString == PageName2.publicArtsDetail) && (publicArtsDetailId != nil)) {
            if  (networkReachability?.isReachable)! {
                getPublicArtsDetailsFromServer()
            } else {
                self.fetchPublicArtsDetailsFromCoredata()
            }
            
        } else if (pageNameString == PageName2.museumAbout) {
            if  (networkReachability?.isReachable)! {
                getAboutDetailsFromServer()
                
                //saveOrUpdateAboutCoredata()
            } else {
                self.fetchAboutDetailsFromCoredata()
            }
            
            
            
            
            
        }
        recordScreenView()
    }
    
    func setupUIContents() {
        loadingView.isHidden = false
        loadingView.showLoading()
        setTopBarImage()
        imgArray = ["dajar_women","artifactimg","001_MIA_MW.146_005","exhibition","firestation"]
        
    }
    
    func setTopBarImage() {
        heritageDetailTableView.estimatedRowHeight = 50
        heritageDetailTableView.contentInset = UIEdgeInsetsMake(300, 0, 0, 0)
        
        imageView.frame = CGRect(x: 0, y:20, width: UIScreen.main.bounds.size.width, height: 300)
        imageView.image = UIImage(named: "default_imageX2")
        if (pageNameString == PageName2.heritageDetail) {
            if heritageDetailtArray.count != 0 {
                if let imageUrl = heritageDetailtArray[0].image{
                    imageView.kf.setImage(with: URL(string: imageUrl))
                }
                else {
                    imageView.image = UIImage(named: "default_imageX2")
                }
            }
            else {
                imageView.image = nil
            }
        } else if (pageNameString == PageName2.publicArtsDetail){
            if publicArtsDetailtArray.count != 0 {
                if let imageUrl = publicArtsDetailtArray[0].image{
                    imageView.kf.setImage(with: URL(string: imageUrl))
                }
                else {
                    imageView.image = UIImage(named: "default_imageX2")
                }
            }
            else {
                imageView.image = nil
            }
        } else if (pageNameString == PageName2.museumAbout){
            
            if (aboutDetailtArray.count > 0)  {
                if(aboutDetailtArray[0].multimediaFile != nil) {
                    if ((aboutDetailtArray[0].multimediaFile?.count)! > 0) {
                        let url = aboutDetailtArray[0].multimediaFile
                        if( url![0] != nil) {
                            imageView.kf.setImage(with: URL(string: url![0]))
                            
                        }
                        else {
                            imageView.image = UIImage(named: "default_imageX2")
                        }
                    }
                }
            }
            else {
                imageView.image = nil
            }
            
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
        
        imgButton.setTitle("", for: .normal)
        imgButton.setTitleColor(UIColor.blue, for: .normal)
        imgButton.frame = imageView.frame
        
        imgButton.addTarget(self, action: #selector(self.imgButtonPressed(sender:)), for: .touchUpInside)
        
        self.view.addSubview(imgButton)
        
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.light)
        blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = imageView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0
        imageView.addSubview(blurView)
        
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
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
        if (pageNameString == PageName2.heritageDetail) {
            return heritageDetailtArray.count
        } else if (pageNameString == PageName2.publicArtsDetail){
            return publicArtsDetailtArray.count
        } else if (pageNameString == PageName2.museumAbout){
            if(aboutDetailtArray.count > 0) {
                return aboutDetailtArray.count
                // return 1
            } else {
                return 0
            }
            
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let heritageCell = tableView.dequeueReusableCell(withIdentifier: "heritageDetailCellId2", for: indexPath) as! MuseumAboutCell
        if (pageNameString == PageName2.heritageDetail) {
            heritageCell.setHeritageDetailData(heritageDetail: heritageDetailtArray[indexPath.row])
            heritageCell.midTitleDescriptionLabel.textAlignment = .center
        } else if(pageNameString == PageName2.publicArtsDetail){
            heritageCell.setPublicArtsDetailValues(publicArsDetail: publicArtsDetailtArray[indexPath.row])
        } else {
            heritageCell.setMuseumAboutCellData(aboutData: aboutDetailtArray[indexPath.row])
            // heritageCell.setMuseumAboutCellData(aboutData: aboutDetailtArray[0])
        }
        heritageCell.favBtnTapAction = {
            () in
           // self.setFavouritesAction(cellObj: heritageCell)
        }
        heritageCell.shareBtnTapAction = {
            () in
           // self.setShareAction(cellObj: heritageCell)
        }
        heritageCell.locationButtonTapAction = {
            () in
            self.loadLocationInMap(currentRow: indexPath.row)
        }
        loadingView.stopLoading()
        loadingView.isHidden = true
        return heritageCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
//    func setFavouritesAction(cellObj :HeritageDetailCell) {
//        if (cellObj.favoriteButton.tag == 0) {
//            cellObj.favoriteButton.tag = 1
//            cellObj.favoriteButton.setImage(UIImage(named: "heart_fillX1"), for: .normal)
//        } else {
//            cellObj.favoriteButton.tag = 0
//            cellObj.favoriteButton.setImage(UIImage(named: "heart_emptyX1"), for: .normal)
//        }
//    }
    
//    func setShareAction(cellObj :HeritageDetailCell) {
//
//    }
    
    func loadLocationInMap(currentRow: Int) {
        var latitudeString  = String()
        var longitudeString = String()
        var latitude : Double?
        var longitude : Double?
        if ((pageNameString == PageName2.museumAbout) && (aboutDetailtArray[0].mobileLatitude != nil) && (aboutDetailtArray[0].mobileLongtitude != nil)) {
            latitudeString = (aboutDetailtArray[0].mobileLatitude)!
            longitudeString = (aboutDetailtArray[0].mobileLongtitude)!
        } else if ((pageNameString == PageName2.heritageDetail) && (heritageDetailtArray[currentRow].latitude != nil) && (heritageDetailtArray[currentRow].longitude != nil)) {
            latitudeString = heritageDetailtArray[currentRow].latitude!
            longitudeString = heritageDetailtArray[currentRow].longitude!
        }
        //else if ((pageNameString == PageName.publicArtsDetail) && (publicArtsDetailtArray[currentRow]. != nil) && (publicArtsDetailtArray[currentRow].longitude != nil))
        //        {
        //            latitudeString = publicArtsDetailtArray[currentRow].latitude
        //            longitudeString = publicArtsDetailtArray[currentRow].longitude
        //        }
        
        if latitudeString != nil && longitudeString != nil && latitudeString != "" && longitudeString != ""{
            if (pageNameString == PageName2.museumAbout) {
                if let lat : Double = Double(latitudeString) {
                    latitude = lat
                }
                if let long : Double = Double(longitudeString) {
                    longitude = long
                }
                
            } else {
                latitude = convertDMSToDDCoordinate(latLongString: latitudeString)
                longitude = convertDMSToDDCoordinate(latLongString: longitudeString)
            }
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(latitude!),\(longitude!)&zoom=14&views=traffic&q=\(latitude!),\(longitude!)")!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL(string:"comgooglemaps://?center=\(latitude!),\(longitude!)&zoom=14&views=traffic&q=\(latitude!),\(longitude!)")!)
                }
            } else {
                let locationUrl = URL(string: "https://maps.google.com/?q=@\(latitude!),\(longitude!)")!
                UIApplication.shared.openURL(locationUrl)
            }
        } else {
            showLocationErrorPopup()
        }
    }
    
    func showLocationErrorPopup() {
        popupView  = ComingSoonPopUp(frame: self.view.frame)
        popupView.comingSoonPopupDelegate = self
        popupView.loadLocationErrorPopup()
        self.view.addSubview(popupView)
    }
    
    //MARK: Poup Delegate
    func closeButtonPressed() {
        self.popupView.removeFromSuperview()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 300 - (scrollView.contentOffset.y + 300)
        let height = min(max(y, 60), 400)
        imageView.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: height)
        imgButton.frame = imageView.frame
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
                self.saveOrUpdatePublicArtsCoredata()
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
    //MARK: Heritage Coredata Method
    func saveOrUpdateHeritageCoredata() {
        if (heritageDetailtArray.count > 0) {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                let fetchData = checkAddedToCoredata(entityName: "HeritageEntity", idKey: "listid" , idValue: heritageDetailtArray[0].id) as! [HeritageEntity]
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
                let fetchData = checkAddedToCoredata(entityName: "HeritageEntityArabic", idKey:"listid" , idValue: heritageDetailtArray[0].id) as! [HeritageEntityArabic]
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
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
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
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                var heritageArray = [HeritageEntity]()
                let managedContext = getContext()
                let heritageFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "HeritageEntity")
                if(heritageDetailId != nil) {
                    heritageFetchRequest.predicate = NSPredicate.init(format: "listid == \(heritageDetailId!)")
                    heritageArray = (try managedContext.fetch(heritageFetchRequest) as? [HeritageEntity])!
                    
                    if (heritageArray.count > 0) {
                        let heritageDict = heritageArray[0]
                        if((heritageDict.detailshortdescription != nil) && (heritageDict.detaillongdescription != nil) ) {
                            self.heritageDetailtArray.insert(Heritage(id: heritageDict.listid, name: heritageDict.listname, location: heritageDict.detaillocation, latitude: heritageDict.detaillatitude, longitude: heritageDict.detaillongitude, image: heritageDict.listimage, shortdescription: heritageDict.detailshortdescription, longdescription: heritageDict.detaillongdescription, sortid: heritageDict.listsortid), at: 0)
                            
                            
                            if(heritageDetailtArray.count == 0){
                                self.showNodata()
                            }
                            self.setTopBarImage()
                            heritageDetailTableView.reloadData()
                        }else{
                            self.showNodata()
                        }
                    }else{
                        self.showNodata()
                    }
                }
                
            }
            else {
                var heritageArray = [HeritageEntityArabic]()
                let managedContext = getContext()
                let heritageFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "HeritageEntityArabic")
                if(heritageDetailId != nil) {
                    heritageFetchRequest.predicate = NSPredicate.init(format: "listid == \(heritageDetailId!)")
                    heritageArray = (try managedContext.fetch(heritageFetchRequest) as? [HeritageEntityArabic])!
                    
                    if (heritageArray.count > 0) {
                        let heritageDict = heritageArray[0]
                        if( (heritageDict.detailshortdescarabic != nil) && (heritageDict.detaillongdescriptionarabic != nil)) {
                            self.heritageDetailtArray.insert(Heritage(id: heritageDict.listid, name: heritageDict.listnamearabic, location: heritageDict.detaillocationarabic, latitude: heritageDict.detaillatitudearabic, longitude: heritageDict.detaillongitudearabic, image: heritageDict.listimagearabic, shortdescription: heritageDict.detailshortdescarabic, longdescription: heritageDict.detaillongdescriptionarabic, sortid: heritageDict.listsortidarabic), at: 0)
                            
                            
                            if(heritageDetailtArray.count == 0){
                                self.showNodata()
                            }
                            self.setTopBarImage()
                            heritageDetailTableView.reloadData()
                            
                        }else{
                            self.showNodata()
                        }
                    }
                    else{
                        self.showNodata()
                    }
                }
                
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    //MARK: PublicArts Coredata Method
    func saveOrUpdatePublicArtsCoredata() {
        if (publicArtsDetailtArray.count > 0) {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                let fetchData = checkAddedToCoredata(entityName: "PublicArtsEntity", idKey: "id" , idValue: publicArtsDetailtArray[0].id) as! [PublicArtsEntity]
                if (fetchData.count > 0) {
                    let managedContext = getContext()
                    let publicArtsDetailDict = publicArtsDetailtArray[0]
                    
                    //update
                    let publicArtsbDict = fetchData[0]
                    publicArtsbDict.name = publicArtsDetailDict.name
                    publicArtsbDict.detaildescription = publicArtsDetailDict.description
                    publicArtsbDict.shortdescription = publicArtsDetailDict.shortdescription
                    publicArtsbDict.image = publicArtsDetailDict.image
                    do{
                        try managedContext.save()
                    }
                    catch{
                        print(error)
                    }
                }
                else {
                    let managedContext = getContext()
                    let publicArtsDetailDict : PublicArtsDetail?
                    publicArtsDetailDict = publicArtsDetailtArray[0]
                    self.saveToCoreData(publicArtseDetailDict: publicArtsDetailDict!, managedObjContext: managedContext)
                }
            }
            else {
                let fetchData = checkAddedToCoredata(entityName: "PublicArtsEntityArabic", idKey:"id" , idValue: publicArtsDetailtArray[0].id) as! [PublicArtsEntityArabic]
                if (fetchData.count > 0) {
                    let managedContext = getContext()
                    let publicArtsDetailDict = publicArtsDetailtArray[0]
                    
                    //update
                    
                    let publicArtsdbDict = fetchData[0]
                    publicArtsdbDict.namearabic = publicArtsDetailDict.name
                    publicArtsdbDict.descriptionarabic = publicArtsDetailDict.description
                    publicArtsdbDict.shortdescriptionarabic = publicArtsDetailDict.shortdescription
                    publicArtsdbDict.imagearabic = publicArtsDetailDict.image
                    do{
                        try managedContext.save()
                    }
                    catch{
                        print(error)
                    }
                }
                else {
                    let managedContext = getContext()
                    let publicArtsListDict : PublicArtsDetail?
                    publicArtsListDict = publicArtsDetailtArray[0]
                    self.saveToCoreData(publicArtseDetailDict: publicArtsListDict!, managedObjContext: managedContext)
                }
            }
        }
    }
    func saveToCoreData(publicArtseDetailDict: PublicArtsDetail, managedObjContext: NSManagedObjectContext) {
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            let publicArtsInfo: PublicArtsEntity = NSEntityDescription.insertNewObject(forEntityName: "PublicArtsEntity", into: managedObjContext) as! PublicArtsEntity
            publicArtsInfo.id = publicArtseDetailDict.id
            publicArtsInfo.name = publicArtseDetailDict.name
            publicArtsInfo.detaildescription = publicArtseDetailDict.description
            publicArtsInfo.shortdescription = publicArtseDetailDict.shortdescription
            publicArtsInfo.image = publicArtseDetailDict.image
            
        }
        else {
            let publicArtsInfo: PublicArtsEntityArabic = NSEntityDescription.insertNewObject(forEntityName: "PublicArtsEntityArabic", into: managedObjContext) as! PublicArtsEntityArabic
            publicArtsInfo.id = publicArtseDetailDict.id
            publicArtsInfo.namearabic = publicArtseDetailDict.name
            publicArtsInfo.descriptionarabic = publicArtseDetailDict.description
            publicArtsInfo.shortdescriptionarabic = publicArtseDetailDict.shortdescription
            publicArtsInfo.imagearabic = publicArtseDetailDict.image
        }
        do {
            try managedObjContext.save()
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func fetchPublicArtsDetailsFromCoredata() {
        
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                var publicArtsArray = [PublicArtsEntity]()
                let managedContext = getContext()
                let publicArtsFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "PublicArtsEntity")
                if(publicArtsDetailId != nil) {
                    publicArtsFetchRequest.predicate = NSPredicate.init(format: "id == \(publicArtsDetailId!)")
                    publicArtsArray = (try managedContext.fetch(publicArtsFetchRequest) as? [PublicArtsEntity])!
                    
                    if (publicArtsArray.count > 0) {
                        let publicArtsDict = publicArtsArray[0]
                        if((publicArtsDict.detaildescription != nil) && (publicArtsDict.shortdescription != nil) ) {
                            self.publicArtsDetailtArray.insert(PublicArtsDetail(id:publicArtsDict.id , name:publicArtsDict.name, description: publicArtsDict.detaildescription, shortdescription: publicArtsDict.shortdescription, image: publicArtsDict.image), at: 0)
                            
                            if(publicArtsDetailtArray.count == 0){
                                self.showNodata()
                            }
                            self.setTopBarImage()
                            heritageDetailTableView.reloadData()
                        }else {
                            self.showNodata()
                        }
                    }
                    else{
                        self.showNodata()
                    }
                }
                
            }
            else {
                var publicArtsArray = [PublicArtsEntityArabic]()
                let managedContext = getContext()
                let publicArtsFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "PublicArtsEntityArabic")
                if(publicArtsDetailId != nil) {
                    publicArtsFetchRequest.predicate = NSPredicate.init(format: "id == \(publicArtsDetailId!)")
                    publicArtsArray = (try managedContext.fetch(publicArtsFetchRequest) as? [PublicArtsEntityArabic])!
                    
                    if (publicArtsArray.count > 0)  {
                        let publicArtsDict = publicArtsArray[0]
                        if((publicArtsDict.descriptionarabic != nil) && (publicArtsDict.shortdescriptionarabic != nil)) {
                            self.publicArtsDetailtArray.insert(PublicArtsDetail(id:publicArtsDict.id , name:publicArtsDict.namearabic, description: publicArtsDict.descriptionarabic, shortdescription: publicArtsDict.shortdescriptionarabic, image: publicArtsDict.imagearabic), at: 0)
                            
                            
                            if(publicArtsDetailtArray.count == 0){
                                self.showNodata()
                            }
                            self.setTopBarImage()
                            heritageDetailTableView.reloadData()
                        }
                        else{
                            self.showNodata()
                        }
                    }
                    else{
                        self.showNodata()
                    }
                }
                
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    //MARK:MUSEUMABOUT
    /*
     
     func getAboutDetailsFromServer() {
     _ = Alamofire.request(QatarMuseumRouter.MuseumAbout(["mid": museumId ?? "0"])).responseObject { (response: DataResponse<MuseumAboutDetails>) -> Void in
     switch response.result {
     case .success(let data):
     self.aboutDetailtArray = data.museumAbout!
     self.setTopBarImage()
     self.saveOrUpdateAboutCoredata()
     self.heritageDetailTableView.reloadData()
     self.loadingView.stopLoading()
     self.loadingView.isHidden = true
     if (self.aboutDetailtArray.count == 0) {
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
     */
    
    func getAboutDetailsFromServer()
    {
        _ = Alamofire.request(QatarMuseumRouter.LandingPageMuseums(["nid": museumId ?? 0])).responseObject { (response: DataResponse<Museums>) -> Void in
            switch response.result {
            case .success(let data):
                self.aboutDetailtArray = data.museum!
                self.setTopBarImage()
                self.saveOrUpdateAboutCoredata()
                self.heritageDetailTableView.reloadData()
                self.loadingView.stopLoading()
                self.loadingView.isHidden = true
                if (self.aboutDetailtArray.count == 0) {
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
    //MARK: About CoreData
    func saveOrUpdateAboutCoredata() {
        if (aboutDetailtArray.count > 0) {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                let fetchData = checkAddedToCoredata(entityName: "AboutEntity", idKey: "id" , idValue: aboutDetailtArray[0].id) as! [AboutEntity]
                
                if (fetchData.count > 0) {
                    let managedContext = getContext()
                    let aboutDetailDict = aboutDetailtArray[0]
                    
                    //update
                    let aboutdbDict = fetchData[0]
                    if(aboutDetailDict.multimediaFile != nil) {
                        if ((aboutDetailtArray[0].multimediaFile?.count)! > 0) {
                            let url = aboutDetailDict.multimediaFile![0]
                            aboutdbDict.image = url
                        }
                    }
                    
                    aboutdbDict.name = aboutDetailDict.name
                    aboutdbDict.id = aboutDetailDict.id
                    aboutdbDict.tourguideAvailable = aboutDetailDict.tourguideAvailable
                    aboutdbDict.contactNumber = aboutDetailDict.contactNumber
                    aboutdbDict.contactEmail = aboutDetailDict.contactEmail
                    aboutdbDict.mobileLongtitude = aboutDetailDict.mobileLongtitude
                    aboutdbDict.subtitle = aboutDetailDict.subtitle
                    aboutdbDict.openingTime = aboutDetailDict.openingTime
                    if(aboutDetailDict.mobileDescription?.count == 1) {
                        let titleDescription = aboutDetailDict.mobileDescription![0]
                        aboutdbDict.titleDesc = titleDescription
                    } else if((aboutDetailDict.mobileDescription?.count)! > 1) {
                        let titleDescription = aboutDetailDict.mobileDescription![0]
                        aboutdbDict.titleDesc = titleDescription
                        let subTitleDescription = aboutDetailDict.mobileDescription![1]
                        aboutdbDict.subTitleDesc = subTitleDescription.replacingOccurrences(of: "<[^>]+>|&nbsp;", with: "", options: .regularExpression, range: nil)
                    }
                    aboutdbDict.mobileLatitude = aboutDetailDict.mobileLatitude
                    aboutdbDict.tourGuideAvailability = aboutDetailDict.tourGuideAvailability
                    
                    
                    if((aboutDetailDict.mobileDescription?.count)! > 0) {
                        for i in 0 ... (aboutDetailDict.mobileDescription?.count)!-1 {
                            var aboutDescEntity: AboutDescriptionEntity!
                            let aboutDesc: AboutDescriptionEntity = NSEntityDescription.insertNewObject(forEntityName: "AboutDescriptionEntity", into: managedContext) as! AboutDescriptionEntity
                            aboutDesc.mobileDesc = aboutDetailDict.mobileDescription![i].replacingOccurrences(of: "<[^>]+>|&nbsp;", with: "", options: .regularExpression, range: nil)
                            
                            aboutDescEntity = aboutDesc
                            aboutdbDict.addToMobileDescRelation(aboutDescEntity)
                            
                            do {
                                try managedContext.save()
                                
                                
                            } catch let error as NSError {
                                print("Could not save. \(error), \(error.userInfo)")
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
                    let managedContext = getContext()
                    let aboutDetailDict : Museum?
                    aboutDetailDict = aboutDetailtArray[0]
                    self.saveToCoreData(aboutDetailDict: aboutDetailDict!, managedObjContext: managedContext)
                }
            }
            else {
                let fetchData = checkAddedToCoredata(entityName: "AboutEntityArabic", idKey:"id" , idValue: aboutDetailtArray[0].id) as! [AboutEntityArabic]
                if (fetchData.count > 0) {
                    let managedContext = getContext()
                    let aboutDetailDict = aboutDetailtArray[0]
                    
                    //update
                    
                    let aboutdbDict = fetchData[0]
                    
                    if(aboutDetailDict.multimediaFile != nil) {
                        if ((aboutDetailtArray[0].multimediaFile?.count)! > 0) {
                            let url = aboutDetailDict.multimediaFile![0]
                            aboutdbDict.image = url
                        }
                    }
                    
                    aboutdbDict.nameAr = aboutDetailDict.name
                    aboutdbDict.id = aboutDetailDict.id
                    aboutdbDict.tourguideAvailableAr = aboutDetailDict.tourguideAvailable
                    aboutdbDict.contactNumberAr = aboutDetailDict.contactNumber
                    aboutdbDict.contactEmailAr = aboutDetailDict.contactEmail
                    aboutdbDict.mobileLongtitudeAr = aboutDetailDict.mobileLongtitude
                    aboutdbDict.subtitleAr = aboutDetailDict.subtitle
                    aboutdbDict.openingTimeAr = aboutDetailDict.openingTime
                    if(aboutDetailDict.mobileDescription?.count == 1) {
                        let titleDescription = aboutDetailDict.mobileDescription![0]
                        aboutdbDict.titleDescAr = titleDescription
                    } else if((aboutDetailDict.mobileDescription?.count)! > 1) {
                        let titleDescription = aboutDetailDict.mobileDescription![0]
                        aboutdbDict.titleDescAr = titleDescription
                        let subTitleDescription = aboutDetailDict.mobileDescription![1]
                        aboutdbDict.subTitleDescAr = subTitleDescription
                    }
                    aboutdbDict.mobileLatitudear = aboutDetailDict.mobileLatitude
                    aboutdbDict.tourGuideAvlblyAr = aboutDetailDict.tourGuideAvailability
                    
                    
                    if((aboutDetailDict.mobileDescription?.count)! > 0) {
                        for i in 0 ... (aboutDetailDict.mobileDescription?.count)!-1 {
                            var aboutDescEntity: AboutDescriptionEntityAr!
                            let aboutDesc: AboutDescriptionEntityAr = NSEntityDescription.insertNewObject(forEntityName: "AboutDescriptionEntityAr", into: managedContext) as! AboutDescriptionEntityAr
                            aboutDesc.mobileDesc = aboutDetailDict.mobileDescription![i].replacingOccurrences(of: "<[^>]+>|&nbsp;", with: "", options: .regularExpression, range: nil)
                            
                            aboutDescEntity = aboutDesc
                            aboutdbDict.addToMobileDescRelation(aboutDescEntity)
                            
                            do {
                                try managedContext.save()
                                
                                
                            } catch let error as NSError {
                                print("Could not save. \(error), \(error.userInfo)")
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
                    let managedContext = getContext()
                    let aboutDetailDict : Museum?
                    aboutDetailDict = aboutDetailtArray[0]
                    self.saveToCoreData(aboutDetailDict: aboutDetailDict!, managedObjContext: managedContext)
                }
            }
        }
    }
    func saveToCoreData(aboutDetailDict: Museum, managedObjContext: NSManagedObjectContext) {
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            let aboutdbDict: AboutEntity = NSEntityDescription.insertNewObject(forEntityName: "AboutEntity", into: managedObjContext) as! AboutEntity
            
            
            
            if(aboutDetailDict.multimediaFile != nil) {
                if ((aboutDetailtArray[0].multimediaFile?.count)! > 0) {
                    let url = aboutDetailDict.multimediaFile![0]
                    aboutdbDict.image = url
                }
            }
            
            aboutdbDict.name = aboutDetailDict.name
            aboutdbDict.id = aboutDetailDict.id
            aboutdbDict.tourguideAvailable = aboutDetailDict.tourguideAvailable
            aboutdbDict.contactNumber = aboutDetailDict.contactNumber
            aboutdbDict.contactEmail = aboutDetailDict.contactEmail
            aboutdbDict.mobileLongtitude = aboutDetailDict.mobileLongtitude
            aboutdbDict.subtitle = aboutDetailDict.subtitle
            aboutdbDict.openingTime = aboutDetailDict.openingTime
            if(aboutDetailDict.mobileDescription?.count == 1) {
                let titleDescription = aboutDetailDict.mobileDescription![0]
                aboutdbDict.titleDesc = titleDescription
            } else if((aboutDetailDict.mobileDescription?.count)! > 1) {
                let titleDescription = aboutDetailDict.mobileDescription![0]
                aboutdbDict.titleDesc = titleDescription
                let subTitleDescription = aboutDetailDict.mobileDescription![1]
                aboutdbDict.subTitleDesc = subTitleDescription
            }
            aboutdbDict.mobileLatitude = aboutDetailDict.mobileLatitude
            aboutdbDict.tourGuideAvailability = aboutDetailDict.tourGuideAvailability
            
            if((aboutDetailDict.mobileDescription?.count)! > 0) {
                for i in 0 ... (aboutDetailDict.mobileDescription?.count)!-1 {
                    var aboutDescEntity: AboutDescriptionEntity!
                    let aboutDesc: AboutDescriptionEntity = NSEntityDescription.insertNewObject(forEntityName: "AboutDescriptionEntity", into: managedObjContext) as! AboutDescriptionEntity
                    aboutDesc.mobileDesc = aboutDetailDict.mobileDescription![i].replacingOccurrences(of: "<[^>]+>|&nbsp;", with: "", options: .regularExpression, range: nil)
                    
                    aboutDescEntity = aboutDesc
                    aboutdbDict.addToMobileDescRelation(aboutDescEntity)
                    
                    do {
                        try managedObjContext.save()
                        
                        
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                    
                }
            }
            
        }
        else {
            let aboutdbDict: AboutEntityArabic = NSEntityDescription.insertNewObject(forEntityName: "AboutEntityArabic", into: managedObjContext) as! AboutEntityArabic
            
            if(aboutDetailDict.multimediaFile != nil) {
                if ((aboutDetailtArray[0].multimediaFile?.count)! > 0) {
                    let url = aboutDetailDict.multimediaFile![0]
                    aboutdbDict.image = url
                }
            }
            aboutdbDict.nameAr = aboutDetailDict.name
            aboutdbDict.id = aboutDetailDict.id
            aboutdbDict.tourguideAvailableAr = aboutDetailDict.tourguideAvailable
            aboutdbDict.contactNumberAr = aboutDetailDict.contactNumber
            aboutdbDict.contactEmailAr = aboutDetailDict.contactEmail
            aboutdbDict.mobileLongtitudeAr = aboutDetailDict.mobileLongtitude
            aboutdbDict.subtitleAr = aboutDetailDict.subtitle
            aboutdbDict.openingTimeAr = aboutDetailDict.openingTime
            if(aboutDetailDict.mobileDescription?.count == 1) {
                let titleDescription = aboutDetailDict.mobileDescription![0]
                aboutdbDict.titleDescAr = titleDescription
            } else if((aboutDetailDict.mobileDescription?.count)! > 1) {
                let titleDescription = aboutDetailDict.mobileDescription![0]
                aboutdbDict.titleDescAr = titleDescription
                let subTitleDescription = aboutDetailDict.mobileDescription![1]
                aboutdbDict.subTitleDescAr = subTitleDescription
            }
            aboutdbDict.mobileLatitudear = aboutDetailDict.mobileLatitude
            aboutdbDict.tourGuideAvlblyAr = aboutDetailDict.tourGuideAvailability
            
            if((aboutDetailDict.mobileDescription?.count)! > 0) {
                for i in 0 ... (aboutDetailDict.mobileDescription?.count)!-1 {
                    var aboutDescEntity: AboutDescriptionEntityAr!
                    let aboutDesc: AboutDescriptionEntityAr = NSEntityDescription.insertNewObject(forEntityName: "AboutDescriptionEntityAr", into: managedObjContext) as! AboutDescriptionEntityAr
                    aboutDesc.mobileDesc = aboutDetailDict.mobileDescription![i].replacingOccurrences(of: "<[^>]+>|&nbsp;", with: "", options: .regularExpression, range: nil)
                    
                    aboutDescEntity = aboutDesc
                    aboutdbDict.addToMobileDescRelation(aboutDescEntity)
                    
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
    func fetchAboutDetailsFromCoredata() {
        
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                var aboutArray = [AboutEntity]()
                let managedContext = getContext()
                let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "AboutEntity")
                
                if(museumId != nil) {
                    //fetchRequest.predicate = NSPredicate.init(format: "id == \(museumId!)")
                    fetchRequest.predicate = NSPredicate(format: "id == %@", museumId!)
                    aboutArray = (try managedContext.fetch(fetchRequest) as? [AboutEntity])!
                    
                    if (aboutArray.count > 0 ){
                        let aboutDict = aboutArray[0]
                        
                        
                        // descriptionArray.append(aboutDict.titleDesc!)
                        // descriptionArray.append(aboutDict.subTitleDesc!)
                        
                        var imageArray : [String] = []
                        if(aboutDict.image != nil) {
                            imageArray.append(aboutDict.image!)
                        }
                        
                        
                        
                        
                        
                        
                        var descriptionArray : [String] = []
                        let aboutInfoArray = (aboutDict.mobileDescRelation?.allObjects) as! [AboutDescriptionEntity]
                        
                        for i in 0 ... aboutInfoArray.count-1 {
                            descriptionArray.append(aboutInfoArray[i].mobileDesc!)
                        }
                        
                        
                        self.aboutDetailtArray.insert(Museum(name: aboutDict.name, id: aboutDict.id, tourguideAvailable: aboutDict.tourguideAvailable, contactNumber: aboutDict.contactNumber, contactEmail: aboutDict.contactEmail, mobileLongtitude: aboutDict.mobileLongtitude, subtitle: aboutDict.subtitle, openingTime: aboutDict.openingTime, mobileDescription: descriptionArray, multimediaFile: imageArray, mobileLatitude: aboutDict.mobileLatitude, tourGuideAvailability: aboutDict.tourGuideAvailability),at: 0)
                        
                        
                        if(aboutDetailtArray.count == 0){
                            self.showNodata()
                        }
                        self.setTopBarImage()
                        heritageDetailTableView.reloadData()
                    }
                    else{
                        self.showNodata()
                    }
                }
                
            }
            else {
                var aboutArray = [AboutEntityArabic]()
                let managedContext = getContext()
                let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "AboutEntityArabic")
                if(museumId != nil) {
                    fetchRequest.predicate = NSPredicate.init(format: "id == \(museumId!)")
                    aboutArray = (try managedContext.fetch(fetchRequest) as? [AboutEntityArabic])!
                    
                    if (aboutArray.count > 0) {
                        let aboutDict = aboutArray[0]
                        var imageArray : [String] = []
                        if(aboutDict.image != nil) {
                            imageArray.append(aboutDict.image!)
                        }
                        var descriptionArray : [String] = []
                        let aboutInfoArray = (aboutDict.mobileDescRelation?.allObjects) as! [AboutDescriptionEntityAr]
                        
                        for i in 0 ... aboutInfoArray.count-1 {
                            descriptionArray.append(aboutInfoArray[i].mobileDesc!)
                        }
                        self.aboutDetailtArray.insert(Museum(name: aboutDict.nameAr, id: aboutDict.id, tourguideAvailable: aboutDict.tourguideAvailableAr, contactNumber: aboutDict.contactNumberAr, contactEmail: aboutDict.contactEmailAr, mobileLongtitude: aboutDict.mobileLongtitudeAr, subtitle: aboutDict.subtitleAr, openingTime: aboutDict.openingTimeAr, mobileDescription: descriptionArray, multimediaFile: imageArray, mobileLatitude: aboutDict.mobileLatitudear, tourGuideAvailability: aboutDict.tourGuideAvlblyAr),at: 0)
                        if(aboutDetailtArray.count == 0){
                            self.showNodata()
                        }
                        self.setTopBarImage()
                        heritageDetailTableView.reloadData()
                    }
                    else{
                        self.showNodata()
                    }
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
    func recordScreenView() {
        title = self.nibName
        guard let screenName = title else {
            return
        }
        let screenClass = classForCoder.description()
        Analytics.setScreenName(screenName, screenClass: screenClass)
    }
    //MARK: iCarousel Delegate
    func numberOfItems(in carousel: iCarousel) -> Int {
        return imgArray.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var itemView: UIImageView
        itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: carousel.frame.width, height: 300))
        itemView.contentMode = .scaleAspectFit
        //if let image = url {
        // itemView.setImageWithIndicator(imageUrl: image)
        itemView.image = UIImage(named: imgArray[index] as! String)
        //}
        
        return itemView
    }
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.4
        }
        return value
    }
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        
        transparentView.removeFromSuperview()
        carousel.tag = 0
        carousel.removeFromSuperview()
    }
    func setiCarouselView() {
        if (carousel.tag == 0) {
            transparentView.frame = self.view.frame
            transparentView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
            
            self.view.addSubview(transparentView)
            carousel = iCarousel(frame: CGRect(x: (self.view.frame.width - 320)/2, y: 200, width: 350, height: 300))
            carousel.delegate = self
            carousel.dataSource = self
            carousel.type = .rotary
            carousel.tag = 1
            view.addSubview(carousel)
           
            
            
        }
    }
    
    @objc func imgButtonPressed(sender: UIButton!) {
        
        setiCarouselView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//
//  DiningDetailViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 29/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Alamofire
import CoreData
import Crashlytics
import UIKit
import ZKCarousel

class DiningDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, comingSoonPopUpProtocol {
    @IBOutlet weak var diningTableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    
    let imageView = UIImageView()
    let closeButton = UIButton()
    var blurView = UIVisualEffectView()
    var diningDetailtArray: [Dining] = []
    var diningDetailId : String? = nil
    let networkReachability = NetworkReachabilityManager()
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
    
    let carousel : ZKCarousel! = ZKCarousel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUIContents()
        if  (networkReachability?.isReachable)! {
            getDiningDetailsFromServer()
        } else {
            self.fetchDiningDetailsFromCoredata()
        }
        setTopBarImage()
    }
    
    func setupUIContents() {
        loadingView.isHidden = false
        loadingView.showLoading()
    }
    
    func setTopBarImage() {
        diningTableView.estimatedRowHeight = 50
        diningTableView.contentInset = UIEdgeInsetsMake(300, 0, 0, 0)
        
        self.carousel.frame = CGRect(x: 0, y:20, width: UIScreen.main.bounds.size.width, height: 300)
        self.carousel.pageControl.isHidden = true

        
//        imageView.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: 300)
        imageView.image = UIImage(named: "default_imageX2")
        if diningDetailtArray.count != 0 {
            if let imageUrl = diningDetailtArray[0].image{
//                imageView.kf.setImage(with: URL(string: imageUrl))
                
                setupCarousel(imageUrlString: imageUrl)
                carousel.contentMode = .scaleAspectFill
                carousel.clipsToBounds = true
                self.view.addSubview(carousel)
            }
            else {
                imageView.image = UIImage(named: "default_imageX2")
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                view.addSubview(imageView)

            }
        }
        else {
            imageView.image = nil
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            view.addSubview(imageView)

        }
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
//        carousel.contentMode = .scaleAspectFill
//        carousel.clipsToBounds = true
//        self.view.addSubview(carousel)
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.light)
        blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = carousel.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0
        carousel.addSubview(blurView)
        
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            closeButton.frame = CGRect(x: 10, y: 30, width: 40, height: 40)
        } else {
            closeButton.frame = CGRect(x: self.view.frame.width-50, y: 30, width: 40, height: 40)
        }
        closeButton.setImage(UIImage(named: "closeX1"), for: .normal)
        closeButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom:12, right: 12)
        
        closeButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeTouchDownAction), for: .touchDown)
        view.addSubview(closeButton)
    }
    
    private func setupCarousel(imageUrlString: String) {
        
        var imageurllink = imageUrlString
        
        if imageurllink == ""{
            imageurllink = "https://cdn.rawgit.com/mushi-007/pmcsexe-text-repo/2d75fc54/default_imageX3.png"
        }else{
            imageurllink = imageUrlString
        }
        
        let pictureURL = URL(string: imageurllink)! // We can force unwrap because we are 100% certain the constructor will not return nil in this case.
        // Creating a session object with the default configuration.
        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: pictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let imagepub = UIImage(data: imageData)
                        // Do something with your image.
                        let diningName:String = self.diningDetailtArray[0].name!
                        
                        switch diningName{
                        case let str where str.contains("MATHAF MAQHA"):
                            print("MATHAF MAQHA")
                            // Create as many slides as you'd like to show in the carousel
                            self.carousel.pageControl.isHidden = true
//                            let slide1 = ZKCarouselSlide(image: UIImage(named: "mathaf")!, title: "", description: "")
                            let slide2 = ZKCarouselSlide(image: imagepub!, title: "", description: "")
                            
                            // Add the slides to the carousel
                            self.carousel.slides = [slide2]
                        case let str where str.contains("#999"):
                            print("#999")
                            // Create as many slides as you'd like to show in the carousel
                            
                            let slide1 = ZKCarouselSlide(image: UIImage(named: "cafe991")!, title: "", description: "")
                            let slide2 = ZKCarouselSlide(image: UIImage(named: "cafe992")!, title: "", description: "")
                            let slide3 = ZKCarouselSlide(image: UIImage(named: "cafe993")!, title: "", description: "")
                            let slide4 = ZKCarouselSlide(image: UIImage(named: "cafe994")!, title: "", description: "")
                            let slide = ZKCarouselSlide(image: imagepub!, title: "", description: "")
                            
                            // Add the slides to the carousel
                            self.carousel.slides = [slide, slide1, slide2, slide3, slide4]
                        case let str where str.contains("IDAM"):
                            print("IDAM")
                            // Create as many slides as you'd like to show in the carousel
                            
                            let slide1 = ZKCarouselSlide(image: UIImage(named: "idam1")!, title: "", description: "")
                            let slide2 = ZKCarouselSlide(image: UIImage(named: "idam2")!, title: "", description: "")
                            let slide3 = ZKCarouselSlide(image: UIImage(named: "idam3")!, title: "", description: "")
                            let slide4 = ZKCarouselSlide(image: UIImage(named: "idam4")!, title: "", description: "")
                            let slide = ZKCarouselSlide(image: imagepub!, title: "", description: "")
                            
                            // Add the slides to the carousel
                            self.carousel.slides = [slide, slide1, slide2, slide3, slide4]
                        case let str where str.contains("IN-Q CAFÉ AT HIA"):
                            print("IN-Q CAFÉ AT HIA")
                            // Create as many slides as you'd like to show in the carousel
                            self.carousel.pageControl.isHidden = true
//                            let slide1 = ZKCarouselSlide(image: UIImage(named: "inq")!, title: "", description: "")
                            let slide2 = ZKCarouselSlide(image: imagepub!, title: "", description: "")
                            
                            // Add the slides to the carousel
                            self.carousel.slides = [slide2]
                        case let str where str.contains("MIA CAFÉ"):
                            print("MIA CAFÉ")
                            // Create as many slides as you'd like to show in the carousel
                            self.carousel.pageControl.isHidden = true
//                            let slide1 = ZKCarouselSlide(image: UIImage(named: "miacafe")!, title: "", description: "")
                            let slide2 = ZKCarouselSlide(image: imagepub!, title: "", description: "")
                            
                            // Add the slides to the carousel
                            self.carousel.slides = [slide2]
                        case let str where str.contains("AL RIWAQ CAFÉ"):
                            print("AL RIWAQ CAFÉ")
                            // Create as many slides as you'd like to show in the carousel
                            self.carousel.pageControl.isHidden = true
//                            let slide1 = ZKCarouselSlide(image: UIImage(named: "riwaq")!, title: "", description: "")
                            let slide2 = ZKCarouselSlide(image: imagepub!, title: "", description: "")
                            
                            // Add the slides to the carousel
                            self.carousel.slides = [slide2]
                        case let str where str.contains("MIA CATERING"):
                            print("MIA CATERING")
                            // Create as many slides as you'd like to show in the carousel
                            self.carousel.pageControl.isHidden = true
//                            let slide1 = ZKCarouselSlide(image: UIImage(named: "mia-catering")!, title: "", description: "")
                            let slide2 = ZKCarouselSlide(image: imagepub!, title: "", description: "")
                            
                            // Add the slides to the carousel
                            self.carousel.slides = [slide2]
                        
                        default:
                            break
                        }
                        
                        // You can optionally use the 'interval' property to set the timing for automatic slide changes. The default is 1 second.
                        self.carousel.interval = 1.5
                        
                        // Optional - automatic switching between slides.
                        self.carousel.start()
                        
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()
        self.carousel.pageControl.isHidden = false
        //Mk here array of image will go
        imageView.kf.setImage(with: URL(string: imageUrlString))
        
    }
    
    //MARK: TableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return diningDetailtArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let diningCell = tableView.dequeueReusableCell(withIdentifier: "diningDetailCellId", for: indexPath) as! DiningDetailTableViewCell
        diningCell.titleLineView.isHidden = true
        diningCell.setDiningDetailValues(diningDetail: diningDetailtArray[indexPath.row])
        diningCell.locationButtonAction = {
            ()in
            self.loadLocationInMap(currentRow: indexPath.row)
        }
        diningCell.favBtnTapAction = {
            () in
            self.setFavouritesAction(cellObj: diningCell)
        }
        diningCell.shareBtnTapAction = {
            () in
            self.setShareAction(cellObj: diningCell)
        }
        loadingView.stopLoading()
        loadingView.isHidden = true
        return diningCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func setFavouritesAction(cellObj :DiningDetailTableViewCell) {
        if (cellObj.favoriteButton.tag == 0) {
            cellObj.favoriteButton.tag = 1
            cellObj.favoriteButton.setImage(UIImage(named: "heart_fillX1"), for: .normal)
        } else {
            cellObj.favoriteButton.tag = 0
            cellObj.favoriteButton.setImage(UIImage(named: "heart_emptyX1"), for: .normal)
        }
    }
    
    func setShareAction(cellObj :DiningDetailTableViewCell) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 300 - (scrollView.contentOffset.y + 300)
        let height = min(max(y, 60), 400)
        carousel.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: height)
        if (carousel.frame.height >= 300 ){
            blurView.alpha  = 0.0
        } else if (carousel.frame.height >= 250 ){
            blurView.alpha  = 0.2
        } else if (carousel.frame.height >= 200 ){
            blurView.alpha  = 0.4
        } else if (carousel.frame.height >= 150 ){
            blurView.alpha  = 0.6
        } else if (carousel.frame.height >= 100 ){
            blurView.alpha  = 0.8
        } else if (carousel.frame.height >= 50 ){
            blurView.alpha  = 0.9
        }
    }
    
    func loadLocationInMap(currentRow: Int) {
        var latitudeString :String?
        var longitudeString : String?
        
        if ((diningDetailtArray[currentRow].latitude != nil) && (diningDetailtArray[currentRow].longitude != nil)) {
            latitudeString = diningDetailtArray[currentRow].latitude
            longitudeString = diningDetailtArray[currentRow].longitude
        }
        
        if latitudeString != nil && longitudeString != nil {
            let latitude = convertDMSToDDCoordinate(latLongString: latitudeString!)
            let longitude = convertDMSToDDCoordinate(latLongString: longitudeString!)
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
    
    @objc func buttonAction(sender: UIButton!) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    @objc func closeTouchDownAction(sender: UIButton!) {
        sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: WebServiceCall
    func getDiningDetailsFromServer() {
        _ = Alamofire.request(QatarMuseumRouter.GetDiningDetail(["nid": diningDetailId!])).responseObject { (response: DataResponse<Dinings>) -> Void in
            switch response.result {
            case .success(let data):
                self.diningDetailtArray = data.dinings!
                self.setTopBarImage()
                self.saveOrUpdateDiningDetailCoredata()
                self.diningTableView.reloadData()
                self.loadingView.stopLoading()
                self.loadingView.isHidden = true
                if (self.diningDetailtArray.count == 0) {
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
    func saveOrUpdateDiningDetailCoredata() {
        if (diningDetailtArray.count > 0) {
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                let fetchData = checkAddedToCoredata(entityName: "DiningEntity", diningId: diningDetailtArray[0].id) as! [DiningEntity]
                if (fetchData.count > 0) {
                    
                        let managedContext = getContext()
                        let diningDetailDict = diningDetailtArray[0]
                    
                        //update
                    
                            let diningdbDict = fetchData[0] as! DiningEntity
                            diningdbDict.name = diningDetailDict.name
                            diningdbDict.image = diningDetailDict.image
                            diningdbDict.diningdescription = diningDetailDict.description
                            diningdbDict.closetime = diningDetailDict.closetime
                            diningdbDict.openingtime =  diningDetailDict.openingtime
                            diningdbDict.sortid =  diningDetailDict.sortid
                            diningdbDict.location =  diningDetailDict.location
                            
                            do{
                                try managedContext.save()
                            }
                            catch{
                                print(error)
                            }
                }
                else {
                  
                        let managedContext = getContext()
                        let diningListDict : Dining?
                        diningListDict = diningDetailtArray[0]
                        self.saveToCoreData(diningDetailDict: diningListDict!, managedObjContext: managedContext)
                }
            }
            else {
                let fetchData = checkAddedToCoredata(entityName: "DiningEntityArabic", diningId: diningDetailtArray[0].id) as! [DiningEntityArabic]
                if (fetchData.count > 0) {
                    let managedContext = getContext()
                    let diningDetailDict = diningDetailtArray[0]
                    
                    //update
                    let diningdbDict = fetchData[0]
                    diningdbDict.namearabic = diningDetailDict.name
                    diningdbDict.imagearabic = diningDetailDict.image
                    diningdbDict.sortidarabic =  diningDetailDict.sortid
                    diningdbDict.descriptionarabic = diningDetailDict.description
                    diningdbDict.closetimearabic = diningDetailDict.closetime
                    diningdbDict.openingtimearabic =  diningDetailDict.openingtime
                    diningdbDict.locationarabic =  diningDetailDict.location
                    
                    do{
                        try managedContext.save()
                    }
                    catch{
                        print(error)
                    }
                }
                else {
                    let managedContext = getContext()
                    let diningListDict : Dining?
                    diningListDict = diningDetailtArray[0]
                    self.saveToCoreData(diningDetailDict: diningListDict!, managedObjContext: managedContext)
                }
            }
        }
    }
    func saveToCoreData(diningDetailDict: Dining, managedObjContext: NSManagedObjectContext) {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            let diningInfo: DiningEntity = NSEntityDescription.insertNewObject(forEntityName: "DiningEntity", into: managedObjContext) as! DiningEntity
            diningInfo.id = diningDetailDict.id
            diningInfo.name = diningDetailDict.name
            diningInfo.image = diningDetailDict.image
            diningInfo.diningdescription = diningDetailDict.description
            diningInfo.closetime = diningDetailDict.closetime
            diningInfo.openingtime =  diningDetailDict.openingtime
            diningInfo.location =  diningDetailDict.location
            if(diningDetailDict.sortid != nil) {
                diningInfo.sortid = diningDetailDict.sortid
            }
            
        }
        else {
            let diningInfo: DiningEntityArabic = NSEntityDescription.insertNewObject(forEntityName: "DiningEntityArabic", into: managedObjContext) as! DiningEntityArabic
            diningInfo.locationarabic = diningDetailDict.id
            diningInfo.namearabic = diningDetailDict.name
            
            diningInfo.imagearabic = diningDetailDict.image
            diningInfo.descriptionarabic = diningDetailDict.description
            diningInfo.closetimearabic = diningDetailDict.closetime
            diningInfo.openingtimearabic =  diningDetailDict.openingtime
            diningInfo.locationarabic =  diningDetailDict.location
            if(diningDetailDict.sortid != nil) {
                diningInfo.sortidarabic = diningDetailDict.sortid
            }
        }
        do {
            try managedObjContext.save()
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func fetchDiningDetailsFromCoredata() {
        
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                var diningArray = [DiningEntity]()
                let managedContext = getContext()
                let diningFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "DiningEntity")
                if(diningDetailId != nil) {
                    diningFetchRequest.predicate = NSPredicate.init(format: "id == \(diningDetailId!)")
                }
                diningArray = (try managedContext.fetch(diningFetchRequest) as? [DiningEntity])!
                let diningDict = diningArray[0]
                if ((diningArray.count > 0) && (diningDict.diningdescription != nil)) {
                    self.diningDetailtArray.insert(Dining(id: diningDict.id, name: diningDict.name, location: diningDict.location, description: diningDict.diningdescription, image: diningDict.image, openingtime: diningDict.openingtime, closetime: diningDict.closetime, sortid: diningDict.sortid,museumId: nil), at: 0)
                    if(diningDetailtArray.count == 0){
                        self.showNodata()
                    }
                    self.setTopBarImage()
                    diningTableView.reloadData()
                }
                else{
                    self.showNodata()
                }
            }
            else {
                var diningArray = [DiningEntityArabic]()
                let managedContext = getContext()
                let diningFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "DiningEntityArabic")
                if(diningDetailId != nil) {
                    diningFetchRequest.predicate = NSPredicate.init(format: "id == \(diningDetailId!)")
                }
                diningArray = (try managedContext.fetch(diningFetchRequest) as? [DiningEntityArabic])!
                let diningDict = diningArray[0]
                if ((diningArray.count > 0) && (diningDict.descriptionarabic != nil)) {
                   
                    self.diningDetailtArray.insert(Dining(id: diningDict.id, name: diningDict.namearabic, location: diningDict.locationarabic, description: diningDict.descriptionarabic, image: diningDict.imagearabic, openingtime: diningDict.openingtimearabic, closetime: diningDict.closetimearabic, sortid: diningDict.sortidarabic, museumId:nil), at: 0)
                        
                    
                    if(diningDetailtArray.count == 0){
                        self.showNodata()
                    }
                    self.setTopBarImage()
                    diningTableView.reloadData()
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
    func checkAddedToCoredata(entityName: String?,diningId: String?) -> [NSManagedObject]
    {
        let managedContext = getContext()
        var fetchResults : [NSManagedObject] = []
        let diningFetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName!)
        if (diningId != nil) {
            diningFetchRequest.predicate = NSPredicate.init(format: "id == \(diningId!)")
        }
        fetchResults = try! managedContext.fetch(diningFetchRequest)
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

//
//  PanelDiscussionDetailViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 01/12/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import Alamofire
import CoreData
import MapKit
import UIKit
enum NMoQPanelPage {
    case PanelDetailPage
    case TourDetailPage
}
class PanelDiscussionDetailViewController: UIViewController,LoadingViewProtocol,UITableViewDelegate,UITableViewDataSource,HeaderViewProtocol,comingSoonPopUpProtocol,DeclinePopupProtocol {
    
    
    
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var headerView: CommonHeaderView!
    var panelTitle : String? = ""
    var pageNameString : NMoQPanelPage?
    var panelDetailId : String? = nil
    var nmoqSpecialEventDetail: [NMoQTour]! = []
    var nmoqTourDetail: [NMoQTourDetail]! = []
    var entityRegistration : NMoQEntityRegistration?
    var completedEntityReg : NMoQEntityRegistration?
    var userEventList: [NMoQUserEventList]! = []
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
    var selectedRow : Int?
    var unRegisterPopupView : AcceptDeclinePopup = AcceptDeclinePopup()
    var selectedPanelCell : PanelDetailCell?
    var newRegistrationId : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupUI()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func setupUI() {
        loadingView.isHidden = false
        loadingView.showLoading()
        loadingView.loadingViewDelegate = self
        headerView.headerViewDelegate = self
        
        
            headerView.headerBackButton.setImage(UIImage(named: "closeX1"), for: .normal)
            headerView.headerBackButton.contentEdgeInsets = UIEdgeInsets(top:12, left:17, bottom: 12, right:17)
        fetchUserEventListFromCoredata()
        if (pageNameString == NMoQPanelPage.PanelDetailPage) {
            //getNMoQSpecialEventDetail()
            getNMoQTourDetail()
        } else if (pageNameString == NMoQPanelPage.TourDetailPage) {
            //getNMoQTourDetail()
        }
        
    }
    func registerCell() {
        self.tableView.register(UINib(nibName: "PanelDetailView", bundle: nil), forCellReuseIdentifier: "panelCellID")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(pageNameString == NMoQPanelPage.PanelDetailPage) {
            //return nmoqSpecialEventDetail.count
            return nmoqTourDetail.count
        } else if(pageNameString == NMoQPanelPage.TourDetailPage){
            //return nmoqTourDetail.count
            if(nmoqTourDetail[selectedRow!] != nil) {
                return 1
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        loadingView.stopLoading()
        loadingView.isHidden = true
        let cell = tableView.dequeueReusableCell(withIdentifier: "panelCellID", for: indexPath) as! PanelDetailCell
        cell.selectionStyle = .none
        if(pageNameString == NMoQPanelPage.PanelDetailPage) {
            //cell.setPanelDetailCellContent(panelDetailData: nmoqSpecialEventDetail[indexPath.row])
            cell.setTourSecondDetailCellContent(tourDetailData: nmoqTourDetail[indexPath.row], userEventList: userEventList)
            cell.registerOrUnRegisterAction = {
                () in
                self.selectedPanelCell = cell
                 self.reisterOrUnregisterTapAction(currentRow: indexPath.row, selectedCell: cell)
                //self.reisterOrUnregisterTapAction(currentRow: self.selectedRow!, selectedCell: cell)
            }
            
        } else if (pageNameString == NMoQPanelPage.TourDetailPage){
            //cell.setTourSecondDetailCellContent(tourDetailData: nmoqTourDetail[indexPath.row], userEventList: userEventList)
            cell.setTourSecondDetailCellContent(tourDetailData: nmoqTourDetail[self.selectedRow!], userEventList: userEventList)
            cell.registerOrUnRegisterAction = {
                () in
                self.selectedPanelCell = cell
               // self.reisterOrUnregisterTapAction(currentRow: indexPath.row, selectedCell: cell)
                self.reisterOrUnregisterTapAction(currentRow: self.selectedRow!, selectedCell: cell)
            }
        }
        cell.loadMapView = {
            () in
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(pageNameString == NMoQPanelPage.PanelDetailPage) {
            return UITableViewAutomaticDimension
        } else {
            return UITableViewAutomaticDimension
        }
    }
    func loadLocationMap(currentRow: Int, destination: MKMapItem) {
        let detailStoryboard: UIStoryboard = UIStoryboard(name: "DetailPageStoryboard", bundle: nil)
        
        let mapDetailView = detailStoryboard.instantiateViewController(withIdentifier: "mapViewId") as! MapViewController
        mapDetailView.latitudeString = nmoqSpecialEventDetail[currentRow].mobileLatitude
        mapDetailView.latitudeString = nmoqSpecialEventDetail[currentRow].longitude
        mapDetailView.destination = destination
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(mapDetailView, animated: false, completion: nil)
        
    }
    func reisterOrUnregisterTapAction(currentRow: Int,selectedCell : PanelDetailCell?) {
        if (selectedCell?.interestSwitch.isOn)! {
            loadConfirmationPopup()
        } else {
            if(userEventList.count == 0) {
                self.getEntityRegistrationFromServer(currentRow: currentRow, selectedCell: selectedCell)
            } else {
                let haveConflict = checkConflictWithAlreadyRegisteredEvent(currentRow: currentRow)
                if((haveConflict == false) || (haveConflict == nil)) {
                    self.getEntityRegistrationFromServer(currentRow: currentRow, selectedCell: selectedCell)
                } else {
                    loadAlreadyRegisteredPopup()
                    //setRegistrationSwitchOff(selectedCell: selectedCell)
                }
            }
            
            

        }
        
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
    //MARK: WebService Call
    func getNMoQSpecialEventDetail() {
        if(panelDetailId != nil) {
            _ = Alamofire.request(QatarMuseumRouter.GetNMoQSpecialEventDetail(["event_id" : panelDetailId!])).responseObject { (response: DataResponse<NMoQTourList>) -> Void in
                switch response.result {
                case .success(let data):
                    self.nmoqSpecialEventDetail = data.nmoqTourList
                    //self.saveOrUpdateHomeCoredata()
                    self.tableView.reloadData()
                    if(self.nmoqSpecialEventDetail.count == 0) {
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
    func getNMoQTourDetail() {
        if(panelDetailId != nil) {
            _ = Alamofire.request(QatarMuseumRouter.GetNMoQTourDetail(["event_id" : panelDetailId!])).responseObject { (response: DataResponse<NMoQTourDetailList>) -> Void in
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
    
    //MARK: EntityRegistration API
    func getEntityRegistrationFromServer(currentRow: Int,selectedCell: PanelDetailCell?) {
        let time = getTimeStamp(currentRow: currentRow)
        if (time.startTime != nil && time.endTime != nil) {
            
         if((nmoqTourDetail[currentRow].nid != nil) && (UserDefaults.standard.value(forKey: "uid") != nil) && (UserDefaults.standard.value(forKey: "fieldFirstName") != nil) && (UserDefaults.standard.value(forKey: "fieldLastName") != nil)) {
        let entityId = nmoqTourDetail[currentRow].nid
        let userId = UserDefaults.standard.value(forKey: "uid") as! String
        let firstName = UserDefaults.standard.value(forKey: "fieldFirstName") as! String
        let lastName = UserDefaults.standard.value(forKey: "fieldLastName") as! String
        let fieldConfirmAttendance =
            [
                "und":[[
                    "value": "1"
                    ]]
        ]
        let fieldNumberOfAttendees =
            [
                "und":[[
                    "value": "2"
                    ]]
        ]
        let fieldFirstName =
            [
                "und":[[
                    "value": firstName,
                    "safe_value": firstName
                    ]]
        ]
        let fieldNmoqLastName =
            [
                "und":[[
                    "value": lastName,
                    "safe_value": lastName
                    ]]
        ]
        let fieldMembershipNumber =
            [
                "und":[[
                    "value": "144386",
                    
                    ]]
        ]
        let fieldQmaEduRegDate =
            [
                "und":[[
                    "value": time.startTime,
                    "value2": time.endTime,
                    "timezone": "Asia/Qatar",
                    "offset": "10800",
                    "offset2": "10800",
                    "timezone_db": "Asia/Qatar",
                    "date_type": "datestamp"
                    
                    ]]
        ]
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let timestampInString = String(timestamp)
        _ = Alamofire.request(QatarMuseumRouter.NMoQEntityRegistration(["type" : "nmoq_event_registration","entity_id": entityId!,"entity_type" :"node","user_uid": userId,"count": "1","author_uid": userId,"state": "pending","created": timestampInString,"updated": timestampInString,"field_confirm_attendance" :fieldConfirmAttendance,"field_number_of_attendees" : fieldNumberOfAttendees, "field_first_name_": fieldFirstName,"field_nmoq_last_name" : fieldNmoqLastName,"field_membership_number": fieldMembershipNumber,"field_qma_edu_reg_date":fieldQmaEduRegDate])).responseObject { (response: DataResponse<NMoQEntityRegistration>) -> Void in
                switch response.result {
                case .success(let data):
                    self.loadingView.stopLoading()
                    self.loadingView.isHidden = true
                    self.entityRegistration = data
                    self.newRegistrationId = self.entityRegistration?.registrationId
                    self.setEntityRegistrationAsComplete(currentRow: currentRow, timestamp: timestampInString, selectedCell: selectedCell)
                case .failure( _):
                    self.loadingView.stopLoading()
                    self.loadingView.isHidden = true
                    
                }
            }
    }
    }
        
    }
    func setEntityRegistrationAsComplete(currentRow: Int, timestamp: String,selectedCell: PanelDetailCell?) {
        if((newRegistrationId != nil) && (nmoqTourDetail[currentRow].nid != nil) && (UserDefaults.standard.value(forKey: "uid") != nil) && (UserDefaults.standard.value(forKey: "fieldFirstName") != nil) && (UserDefaults.standard.value(forKey: "fieldLastName") != nil)) {
            let time = getTimeStamp(currentRow: currentRow)
            if (time.startTime != nil && time.endTime != nil) {
            let regId = newRegistrationId
            let entityId = nmoqTourDetail[currentRow].nid
            let userId = UserDefaults.standard.value(forKey: "uid") as! String
            let firstName = UserDefaults.standard.value(forKey: "fieldFirstName") as! String
            let lastName = UserDefaults.standard.value(forKey: "fieldLastName") as! String
            let fieldConfirmAttendance =
                [
                    "und":[[
                        "value": "1"
                        ]]
            ]
            let fieldNumberOfAttendees =
                [
                    "und":[[
                        "value": "2"
                        ]]
            ]
            let fieldFirstName =
                [
                    "und":[[
                        "value": firstName,
                        "safe_value": firstName
                        ]]
            ]
            let fieldNmoqLastName =
                [
                    "und":[[
                        "value": lastName,
                        "safe_value": lastName
                        ]]
            ]
            let fieldMembershipNumber =
                [
                    "und":[[
                        "value": "144386",

                        ]]
            ]
            let fieldQmaEduRegDate =
                [
                    "und":[[
                        "value": time.startTime,
                        "value2": time.endTime,
                        "timezone": "Asia/Qatar",
                        "offset": "10800",
                        "offset2": "10800",
                        "timezone_db": "Asia/Qatar",
                        "date_type": "datestamp"

                        ]]
            ]
                _ = Alamofire.request(QatarMuseumRouter.SetUserRegistrationComplete(regId!,["registration_id": regId!,"type" : "nmoq_event_registration","entity_id": entityId!,"entity_type" :"node","user_uid": userId,"count": "1","author_uid": userId,"state": "complete","created": timestamp,"updated": timestamp,"field_confirm_attendance" :fieldConfirmAttendance,"field_number_of_attendees" : fieldNumberOfAttendees, "field_first_name_": fieldFirstName,"field_nmoq_last_name" : fieldNmoqLastName,"field_membership_number": fieldMembershipNumber,"field_qma_edu_reg_date":fieldQmaEduRegDate])).responseObject { (response: DataResponse<NMoQEntityRegistration>) -> Void in
                switch response.result {
                case .success(let data):
                    self.loadingView.stopLoading()
                    self.loadingView.isHidden = true
                    self.completedEntityReg = data
                    //self.userEventList.append(NMoQUserEventList(title: self.panelTitle, eventID: self.completedEntityReg?.entityId))
                    self.userEventList.append(NMoQUserEventList(title: self.panelTitle, eventID: self.completedEntityReg?.entityId, regID: self.completedEntityReg?.registrationId))
                    self.saveOrUpdateEventReistratedCoredata(tourEntity: self.nmoqTourDetail[currentRow], registrationId: self.completedEntityReg?.registrationId)
                    self.loadComingSoonPopup()
                    self.setRegistrationSwitchOn(selectedCell: selectedCell)
                case .failure( _):
                    self.loadingView.stopLoading()
                    self.loadingView.isHidden = true

                }
            }
        }
    }

    }
    func setEntityUnRegistration(currentRow: Int,selectedCell: PanelDetailCell?) {
        var regId : String? = nil
        if (newRegistrationId != nil) {
            regId = newRegistrationId
        } else {
            fetchUserEventListFromCoredata()
            if let registeredEvent = userEventList.first(where: {$0.eventID == nmoqTourDetail[currentRow].nid}) {
                regId = registeredEvent.regID
                
            }
        }
        if((regId != nil) && (UserDefaults.standard.value(forKey: "userPassword") != nil)  && (UserDefaults.standard.value(forKey: "displayName") != nil)) {
           // let regId = nmoqTourDetail[currentRow].nid
            let userName = UserDefaults.standard.value(forKey: "displayName") as! String
            let pwd = UserDefaults.standard.value(forKey: "userPassword") as! String
            
            _ = Alamofire.request(QatarMuseumRouter.SetUserUnRegistration(regId!,["name":userName,"pass":pwd])).responseData { (response) -> Void in
                switch response.result {
                case .success( _):
                    self.loadingView.stopLoading()
                    self.loadingView.isHidden = true
                    if(response.response?.statusCode == 200) {
                        if let index = self.userEventList.index(where: {$0.eventID == self.nmoqTourDetail[currentRow].nid}) {
                            self.userEventList.remove(at: index)
                        }
                        self.deleteRegisteredEvent(registrationId: regId)
                        self.setRegistrationSwitchOff(selectedCell: selectedCell)
                        
                    }
                case .failure( _):
                    self.loadingView.stopLoading()
                    self.loadingView.isHidden = true
                    
                }
            }
        }
        
    }
    
    //MARK: EventRegistrationCoreData
    func saveOrUpdateEventReistratedCoredata(tourEntity: NMoQTourDetail,registrationId: String?) {
        if (userEventList.count > 0) {
            let appDelegate =  UIApplication.shared.delegate as? AppDelegate
            if #available(iOS 10.0, *) {
                let container = appDelegate!.persistentContainer
                container.performBackgroundTask() {(managedContext) in
                    self.userEventCoreDataInBackgroundThread(managedContext: managedContext, tourEntity: tourEntity, registrationId: registrationId)
                }
            } else {
                let managedContext = appDelegate!.managedObjectContext
                managedContext.perform {
                    self.userEventCoreDataInBackgroundThread(managedContext : managedContext, tourEntity: tourEntity, registrationId: registrationId)
                }
            }
        }
    }
    
    func userEventCoreDataInBackgroundThread(managedContext: NSManagedObjectContext,tourEntity: NMoQTourDetail,registrationId: String?) {
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            if (userEventList.count > 0) {
                    let userEventInfo: RegisteredEventListEntity = NSEntityDescription.insertNewObject(forEntityName: "RegisteredEventListEntity", into: managedContext) as! RegisteredEventListEntity
                    userEventInfo.eventId = tourEntity.nid
                    userEventInfo.regId = registrationId
                    do{
                        try managedContext.save()
                    }
                    catch{
                        print(error)
                    }
            }
        }
    }
    
    @available(iOS 10.0, *)
    func calculateToursOverlap(times : [[String : String]]) -> Bool? {
        
        let dateFormat = "MM-dd-yyyy HH:mm" //Z is for zone

            var intervals = [DateInterval]()
        

        // Loop through date ranges to convert them to date intervals

        for item in times {

            if let start = convertStringToDate(string: item["start"]!, withFormat: dateFormat),

                let end = convertStringToDate(string: item["end"]!, withFormat: dateFormat) {

                intervals.append(DateInterval(start: start, end: end))

            }

        }
        
//        let cal = Calendar.current
//        let d1 = convertStringToDate(string: times[0]["start"]!, withFormat: dateFormat)
//        let d2 = convertStringToDate(string: times[0]["end"]!, withFormat: dateFormat) // April 27, 2018 12:00:00 AM
//        let components = cal.dateComponents([.hour], from: d2!, to: d1!)
//        let diff = components.hour!
//print(intervals)
//        print(diff)


        // Check for intersection

        let intersection = intersect(intervals: intervals)

        print(intersection) // Also here we can block actions based on intersection found
        if (intersection == nil) {
            return false
        } else {
            return true
        }

    }
    // Converts the string to date with given format if require
    
    func convertStringToDate(string: String, withFormat format: String)  -> Date? {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: string)
        
    }
    @available(iOS 10.0, *)
    func intersect(intervals: [DateInterval]) -> DateInterval? {
        var previous = intervals.first
        
        for (index, element) in intervals.enumerated() {
            
            if index == 0 {
                
                continue
            }
            previous = previous?.intersection(with: element)
            if previous == nil {
                
                break
                
            }
            
        }
        
        
        
        return previous
        
    }
    func checkConflictWithAlreadyRegisteredEvent(currentRow: Int?) -> Bool? {
//        let selectedEventId = nmoqTourDetail[currentRow!].nid
//        var eventIdArray = NSArray()
//        for i in  0 ... nmoqTourDetail.count-1 {
//            if(selectedEventId != nmoqTourDetail[i].nid) {
//                eventIdArray.adding(nmoqTourDetail[i].nid)
//                }
//            }
        for i  in 0 ... userEventList.count-1 {
            if let idArray = nmoqTourDetail.first(where: {$0.nid == userEventList[i].eventID}) {
                var timeEvents :[NMoQTourDetail] = []
                timeEvents.append(idArray)
                timeEvents.append(nmoqTourDetail[currentRow!])
                let haveConflict = self.setTimeArray( selectedEvent: timeEvents)
                return haveConflict
            }
        }
        return nil
            
        
    }
    func setTimeArray(selectedEvent: [NMoQTourDetail])-> Bool? {
        var times: [[String : String]] = []
        for i in 0 ... selectedEvent.count-1 {
            let time = selectedEvent[i].date?.replacingOccurrences(of: "<[^>]+>|&nbsp;|&|#039;", with: "", options: .regularExpression, range: nil)
            let timeArray = time?.components(separatedBy: "-")
            if((timeArray?.count)! == 3) {
                let startTime = timeArray![0] + "" + timeArray![1]
                let endTime = timeArray![0] + "" + timeArray![2]
                if(times.count == 0) {
                    times = [["start": startTime, "end":endTime]]
                } else {
                    times.append(["start": startTime, "end":endTime])
                    
                }
            }
        }
        if #available(iOS 10.0, *) {
            let haveConflict = calculateToursOverlap(times: times)
            return haveConflict
        } else {
            // Fallback on earlier versions
        }
        return nil
    }

    func fetchUserEventListFromCoredata() {
        if (userEventList.count > 0) {
            userEventList.removeAll()
        }
        
        let managedContext = getContext()
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                var eventArray = [RegisteredEventListEntity]()
                let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "RegisteredEventListEntity")
                eventArray = (try managedContext.fetch(fetchRequest) as? [RegisteredEventListEntity])!
                if (eventArray.count > 0) {
                    for i in 0 ... eventArray.count-1 {
                        self.userEventList.insert(NMoQUserEventList(title: eventArray[i].title, eventID: eventArray[i].eventId, regID: eventArray[i].regId), at: i)
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    func deleteRegisteredEvent(registrationId: String?) {
//        let managedContext = getContext()
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RegisteredEventListEntity")
//        fetchRequest.predicate = NSPredicate.init(format: "\("regId") == \(registrationId!)")
//        let deleteRequest = NSBatchDeleteRequest( fetchRequest: fetchRequest)
//        do{
//            try managedContext.execute(deleteRequest)
//            //fetchUserEventListFromCoredata()
//        }catch let error as NSError {
//            //handle error here
//
//        }
        let appDelegate =  UIApplication.shared.delegate as? AppDelegate
        if #available(iOS 10.0, *) {
            let container = appDelegate!.persistentContainer
            container.performBackgroundTask() {(managedContext) in
                self.deleteExistingEvent(managedContext: managedContext, registrationId: registrationId)
            }
        } else {
            let managedContext = appDelegate!.managedObjectContext
            managedContext.perform {
                self.deleteExistingEvent(managedContext: managedContext, registrationId: registrationId)
            }
        }
    }
//    func getContext() -> NSManagedObjectContext{
//
//        let appDelegate =  UIApplication.shared.delegate as? AppDelegate
//        if #available(iOS 10.0, *) {
//            return
//                appDelegate!.persistentContainer.viewContext
//        } else {
//            return appDelegate!.managedObjectContext
//        }
//    }
    func deleteExistingEvent(managedContext:NSManagedObjectContext,registrationId: String?)  {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RegisteredEventListEntity")
        fetchRequest.predicate = NSPredicate.init(format: "\("regId") == \(registrationId!)")
        let deleteRequest = NSBatchDeleteRequest( fetchRequest: fetchRequest)
        do{
            try managedContext.execute(deleteRequest)
            
        }catch let error as NSError {
            //handle error here
            
        }
        
    }
    func getTimeStamp(currentRow:Int?) ->(startTime:Int?,endTime:Int?) {
        let time = nmoqTourDetail[currentRow!].date?.replacingOccurrences(of: "<[^>]+>|&nbsp;|&|#039;", with: "", options: .regularExpression, range: nil)
        let timeArray = time?.components(separatedBy: "-")
        if((timeArray?.count)! == 3) {
            let startTime = timeArray![0] + "" + timeArray![1]
            let endTime = timeArray![0] + "" + timeArray![2]
            let dateFormat = "MM-dd-yyyy HH:mm"
            let start = convertStringToDate(string: startTime, withFormat: dateFormat)
            let end = convertStringToDate(string: endTime, withFormat: dateFormat)
            let startDateStamp:TimeInterval = start!.timeIntervalSince1970
            let dateSt:Int = Int(startDateStamp)
            let EndDateStamp:TimeInterval = end!.timeIntervalSince1970
            let dateEnd:Int = Int(EndDateStamp)
            return (dateSt,dateEnd)
        }
        return (nil,nil)
    }
    func setRegistrationSwitchOn(selectedCell: PanelDetailCell?) {
        //loadComingSoonPopup()
        selectedCell?.interestSwitch.tintColor = UIColor.settingsSwitchOnTint
        selectedCell?.interestSwitch.layer.cornerRadius = 16
        selectedCell?.interestSwitch.backgroundColor = UIColor.settingsSwitchOnTint
        selectedCell?.interestSwitch.isOn = false
    }
    func setRegistrationSwitchOff(selectedCell: PanelDetailCell?) {
        selectedCell?.interestSwitch.onTintColor = UIColor.red
        selectedCell?.interestSwitch.layer.cornerRadius = 16
        selectedCell?.interestSwitch.backgroundColor = UIColor.red
        selectedCell?.interestSwitch.isOn = true
    }
    func loadComingSoonPopup() {
        popupView  = ComingSoonPopUp(frame: self.view.frame)
        popupView.comingSoonPopupDelegate = self
        popupView.tag = 0
        popupView.loadRegistrationPopup()
        self.view.addSubview(popupView)
    }
    func loadAlreadyRegisteredPopup() {
        popupView  = ComingSoonPopUp(frame: self.view.frame)
        popupView.comingSoonPopupDelegate = self
        popupView.tag = 1
        popupView.loadAlreadyRegisteredPopupMessage()
        self.view.addSubview(popupView)
    }
    func closeButtonPressed() {
        if (popupView.tag == 1) {
            self.popupView.removeFromSuperview()
            setRegistrationSwitchOff(selectedCell: selectedPanelCell)
        }
        self.popupView.removeFromSuperview()

    }
    func loadConfirmationPopup() {
        unRegisterPopupView  = AcceptDeclinePopup(frame: self.view.frame)
        unRegisterPopupView.popupViewHeight.constant = 280
        unRegisterPopupView.showUnregisterYesOrNoMessage()
        unRegisterPopupView.declinePopupDelegate = self
        self.view.addSubview(unRegisterPopupView)
    }
    func declinePopupCloseButtonPressed() {
        
    }
    
    func yesButtonPressed() {
        setEntityUnRegistration(currentRow: selectedRow!, selectedCell: selectedPanelCell)
        self.unRegisterPopupView.removeFromSuperview()
    }
    
    func noButtonPressed() {
        setRegistrationSwitchOn(selectedCell: selectedPanelCell)
        self.unRegisterPopupView.removeFromSuperview()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

   

}

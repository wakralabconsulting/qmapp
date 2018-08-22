//
//  EventViewController.swift
//  QatarMuseum
//
//  Created by Exalture on 07/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Alamofire
import CoreData
import EventKit
import UIKit

var institutionType : String? = "any"
var ageGroupType: String? = "any"
var programmeType:String? = "any"
class EventViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, HeaderViewProtocol,FSCalendarDelegate,FSCalendarDataSource,UICollectionViewDelegateFlowLayout,EventPopUpProtocol,UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate,comingSoonPopUpProtocol {
    
    @IBOutlet weak var eventCollectionView: UICollectionView!
    @IBOutlet weak var calendarView: FSCalendar!

    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var headerView: CommonHeaderView!
    @IBOutlet weak var calendarInnerView: UIView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var listTitleLabel: UILabel!
    @IBOutlet weak var calendarLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var previousConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var loadingView: LoadingView!
    var effect:UIVisualEffect!
    var eventPopup : EventPopupView = EventPopupView()
    var selectedDateForEvent : Date = Date()
    var fromHome : Bool = false
    var isLoadEventPage : Bool = false
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
    var educationEventArray: [EducationEvent] = []
    var selectedEvent: EducationEvent?
    var needToRegister : String? = "false"
    let networkReachability = NetworkReachabilityManager()
    let store = EKEventStore()

    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendarView, action: #selector(self.calendarView.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        setUpUiContent()
    }
    func registerNib() {
        let nib = UINib(nibName: "EventCellView", bundle: nil)
        eventCollectionView?.register(nib, forCellWithReuseIdentifier: "eventCellId")
    }
    func setUpUiContent() {
        loadingView.isHidden = false
        loadingView.showLoading()
        headerView.headerViewDelegate = self
        headerView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        self.view.addGestureRecognizer(self.scopeGesture)
        listTitleLabel.font = UIFont.diningHeaderFont
    self.eventCollectionView.panGestureRecognizer.require(toFail: self.scopeGesture)
        if (isLoadEventPage == true) {
            listTitleLabel.text = NSLocalizedString("CALENDAR_EVENT_TITLE", comment: "CALENDAR_EVENT_TITLE Label in the Event page")
            headerView.headerTitle.text = NSLocalizedString("CALENDAR_TITLE", comment: "CALENDAR_TITLE Label in the Event page")
            listTitleLabel.textColor = UIColor.eventlisBlue
            institutionType = "any"
            ageGroupType = "any"
            programmeType = "any"
            if  (networkReachability?.isReachable)! {
                self.getEducationEventFromServer()
            }
            else {
                self.fetchEventFromCoredata()
            }
        }
        else {
            listTitleLabel.text = NSLocalizedString("EDUCATION_EVENT_TITLE", comment: "EDUCATION_EVENT_TITLE Label in the Event page")
            headerView.headerTitle.text = NSLocalizedString("EDUCATIONCALENDAR_TITILE", comment: "EDUCATIONCALENDAR_TITILE Label in the Event page")
            listTitleLabel.textColor = UIColor.blackColor
            headerView.settingsButton.isHidden = false
            if  (networkReachability?.isReachable)! {
                self.getEducationEventFromServer()
            }
            else {
                self.fetchEducationEventFromCoredata()
            }
        }
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            UserDefaults.standard.set(false, forKey: "Arabic")
            headerView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
            previousButton.setImage(UIImage(named: "previousImg"), for: .normal)
            nextButton.setImage(UIImage(named: "nextImg"), for: .normal)
            calendarView.locale = NSLocale.init(localeIdentifier: "en") as Locale
            calendarView.identifier = NSCalendar.Identifier.gregorian.rawValue
            calendarView.appearance.titleFont = UIFont.init(name: "DINNextLTPro-Bold", size: 19)
            
            calendarView.appearance.titleWeekendColor = UIColor.profilePink
            calendarLeftConstraint.constant = 45
            calendarRightConstraint.constant = 15
            previousConstraint.constant = 30
            nextConstraint.constant = 30
            
        }
        else {
           
            headerView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
            //For RTL
            calendarView?.locale = Locale(identifier: "ar")
            self.calendarView.transform = CGAffineTransform(scaleX: -1, y: 1)
            calendarView.setCurrentPage(Date(), animated: false)
            UserDefaults.standard.set(true, forKey: "Arabic")
            calendarView.appearance.titleFont = UIFont.init(name: "DINNextLTArabic-Bold", size: 18)
            calendarView.appearance.weekdayFont =  UIFont.init(name: "DINNextLTArabic-Regular", size: 13)
            previousButton.setImage(UIImage(named: "nextImg"), for: .normal)
            nextButton.setImage(UIImage(named: "previousImg"), for: .normal)
            calendarView.appearance.titleWeekendColor = UIColor.profilePink
            calendarLeftConstraint.constant = 45
            calendarRightConstraint.constant = 15
            previousConstraint.constant = 30
            nextConstraint.constant = 30
        }
    }
    //For RTL
    func minimumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "2016-07-08")!
    }
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        if ((LocalizationLanguage.currentAppleLanguage()) == AR_LANGUAGE) {
            formatter.locale = NSLocale(localeIdentifier: "ar") as Locale?
        }
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: CollectionView delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightValue = UIScreen.main.bounds.height/100
        
        return CGSize(width: eventCollectionView.frame.width, height: heightValue*15)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return educationEventArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : EventCollectionViewCell = eventCollectionView.dequeueReusableCell(withReuseIdentifier: "eventCellId", for: indexPath) as! EventCollectionViewCell
        cell.viewDetailsBtnAction = {
            () in
            self.loadEventPopup(currentRow: indexPath.row)
                
            }
        if (indexPath.row % 2 == 0) {
            cell.cellBackgroundView?.backgroundColor = UIColor.eventCellAshColor
        }
        else {
            cell.cellBackgroundView.backgroundColor = UIColor.whiteColor
        }
        if (isLoadEventPage == true) {
            cell.setEventCellValues(event: educationEventArray[indexPath.row])
        }
        else {
            cell.setEducationCalendarValues(educationEvent: educationEventArray[indexPath.row])
        }
        loadingView.stopLoading()
        loadingView.isHidden = true
        return cell
    
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        loadEventPopup(currentRow: indexPath.row)
    }
    //MARK: header delegate
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        if (fromHome == true) {
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "homeId") as! HomeViewController
            
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = homeViewController
        }
        else {
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    @objc func filterButtonPressed() {
        let filterView =  self.storyboard?.instantiateViewController(withIdentifier: "filterVcId") as! FilterViewController
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(filterView, animated: false, completion: nil)
    }
    func loadEventPopup(currentRow: Int) {
        eventPopup  = EventPopupView(frame: self.view.frame)
        eventPopup.eventPopupDelegate = self
        selectedEvent = educationEventArray[currentRow]
        needToRegister = educationEventArray[currentRow].registration
        if(needToRegister == "true") {
            let buttonTitle = NSLocalizedString("EDUCATION_POPUP_BUTTON_TITLE", comment: "POPUP_ADD_BUTTON_TITLE  in the popup view")
            eventPopup.addToCalendarButton.setTitle(buttonTitle, for: .normal)
        }
        else {
            let buttonTitle = NSLocalizedString("POPUP_ADD_BUTTON_TITLE", comment: "POPUP_ADD_BUTTON_TITLE  in the popup view")
            eventPopup.addToCalendarButton.setTitle(buttonTitle, for: .normal)
        }
        if (isLoadEventPage == true) {
            
            eventPopup.eventTitle.text = educationEventArray[currentRow].title?.uppercased()
            eventPopup.eventDescription.text = educationEventArray[currentRow].longDesc
            //let buttonTitle = NSLocalizedString("POPUP_ADD_BUTTON_TITLE", comment: "POPUP_ADD_BUTTON_TITLE  in the popup view")
           // eventPopup.addToCalendarButton.setTitle(buttonTitle, for: .normal)
        }
        else {
            eventPopup.eventTitle.text = educationEventArray[currentRow].title?.uppercased()
            eventPopup.eventDescription.text = educationEventArray[currentRow].longDesc
            
        }
        self.view.addSubview(eventPopup)
     
        
    }
  
    //MARK: Event popup delegate
    func eventCloseButtonPressed() {

            self.eventPopup.removeFromSuperview()
       
    }
    func addToCalendarButtonPressed() {
//        var date = NSDate()
//        if(selectedEvent?.date != nil) {
//            let timeint = (selectedEvent?.date! as? NSString)?.doubleValue
//            date = NSDate(timeIntervalSince1970: timeint!)
//        }
        if(needToRegister == "true") {
            self.eventPopup.removeFromSuperview()
            popupView  = ComingSoonPopUp(frame: self.view.frame)
            popupView.comingSoonPopupDelegate = self
            popupView.loadPopup()
            self.view.addSubview(popupView)
        }
        else {
            var calendar = Calendar.current
            //calendar.timeZone = TimeZone(identifier: "UTC")!
            let startDt = calendar.date(bySettingHour:14, minute: 0, second: 0, of: selectedEventDate)!
            let endDt = calendar.date(bySettingHour: 16, minute: 0, second: 0, of: selectedEventDate)!
            self.addEventToCalendar(title:  (selectedEvent?.title)!, description: selectedEvent?.longDesc, startDate: startDt, endDate: endDt)
            self.eventPopup.removeFromSuperview()
        }
//        if (isLoadEventPage == true) {
//            self.addEventToCalendar(title: (selectedEvent?.title)!, description: selectedEvent?.longDesc, startDate: date as Date, endDate: date as Date)
//            self.eventPopup.removeFromSuperview()
//        }
//        else {
//
//
//        }
        
    }
   
    func closeButtonPressed() {
        self.popupView.removeFromSuperview()
    }
    func addEventToCalendar(title: String, description: String?, startDate: Date?, endDate: Date?, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent.init(eventStore: self.store)
                event.title = title
                event.calendar = self.store.defaultCalendarForNewEvents
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
               // let alarm = EKAlarm.init(absoluteDate: Date.init(timeInterval: -3600, since: event.startDate))
               // event.addAlarm(alarm)
                
                do {
                   // try eventStore.save(event, span: .thisEvent)
                    try self.store.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                let message = NSLocalizedString("CALENDAR_ACCESS_MESSAGE", comment: "CALENDAR_ACCESS_MESSAGE in the Event page")
                let accessTitle = NSLocalizedString("CALENDAR_ACCESS_MTITLE", comment: "CALENDAR_ACCESS_MTITLE in the Event page")
                let alert = UIAlertController(title: accessTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                completion?(false, error as NSError?)
            }
        })
    }
    // MARK:- UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.eventCollectionView.contentOffset.y <= -self.eventCollectionView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendarView.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    //MARK: FSCalendar delegate
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
       
      
       
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
            
        }
        
        
        selectedDateForEvent = date
        
        //selected date got is less than one date. so add 1 to date for actual selected date
      //  let dayComponenet = NSDateComponents()
      //  dayComponenet.day = 1
       // selectedDateForEvent = Calendar.current.date(byAdding: .day, value: 1, to: date)!
    }
    func calendarCurrentMonthDidChange(_ calendar: FSCalendar) {
        
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return UIColor.red
    }
    
  
    
    @IBAction func previoudDateSelected(_ sender: UIButton) {
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            let _calendar = Calendar.current
            var dateComponents = DateComponents()
            dateComponents.month = -1 // For prev button
            calendarView.currentPage = _calendar.date(byAdding: dateComponents, to: calendarView.currentPage)!
            calendarView.setCurrentPage(calendarView.currentPage, animated: true)// calender is object of FSCalendar
        }
        else {
            let _calendar = Calendar.current
            var dateComponents = DateComponents()
            dateComponents.month = 1 // For next button
            calendarView.currentPage = _calendar.date(byAdding: dateComponents, to: calendarView.currentPage)!
            calendarView.setCurrentPage(calendarView.currentPage, animated: true)// calender is object of FSCalendar
        }
    }
    
    @IBAction func nextDateSelected(_ sender: UIButton) {
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            let _calendar = Calendar.current
            var dateComponents = DateComponents()
            dateComponents.month = 1 // For next button
            calendarView.currentPage = _calendar.date(byAdding: dateComponents, to: calendarView.currentPage)!
            calendarView.setCurrentPage(calendarView.currentPage, animated: true)// calender is object of FSCalendar
        }
        else {
            let _calendar = Calendar.current
            var dateComponents = DateComponents()
            dateComponents.month = -1 // For prev button
            calendarView.currentPage = _calendar.date(byAdding: dateComponents, to: calendarView.currentPage)!
            calendarView.setCurrentPage(calendarView.currentPage, animated: true)// calender is object of FSCalendar
        }
        
    }
    //MARK: WebServiceCall
    func getEducationEventFromServer() {
        let dateString = toMillis()
        _ = Alamofire.request(QatarMuseumRouter.EducationEvent(String: dateString!, String: ageGroupType!, String: institutionType!, String: programmeType!)).responseObject { (response: DataResponse<EducationEventList>) -> Void in
            switch response.result {
            case .success(let data):
                self.educationEventArray = data.educationEvent!
               let evetPosition = self.findItem(educationArray: self.educationEventArray, fixedStartTime: "14:00")
                if(self.sundayOrWednesday() == false) {
                    self.educationEventArray.insert(EducationEvent(eid: "15476", filter: nil, title: "Walk In Gallery Tours", shortDesc: "Join our Museum Guides for a tour of the Museum of Islamic Art's oustanding collection of objects, spread over 1,400 years and across three continents. No booking is required to be a part of the tour.", longDesc: "Monday - Science Tour\n Tuesday - Techniques Tour (from 1 July onwards)\n Thursday - MIA Architecture Tour\n Friday - Permanent Gallery Tour\nSaturday - Permanent Gallery Tour", location: " Museum of Islamic Art, Atrium", institution: "MIA", startTime: "14:00", endTime: "16:00", ageGroup: "adults", programType: "gallery tour", category: nil, registration: "false", date: "Every Monday, Tuesday, Thursday, Friday and Saturday",maxGroupSize: "40" ), at: evetPosition!)
                    
                }
                if (self.isLoadEventPage == true) {
                    self.saveOrUpdateEventCoredata()
                }
                else {
                    self.saveOrUpdateEducationEventCoredata()
                }
                self.eventCollectionView.reloadData()
                self.loadingView.stopLoading()
                self.loadingView.isHidden = true
                if (self.educationEventArray.count == 0) {
                    self.loadingView.stopLoading()
                    self.loadingView.noDataView.isHidden = false
                    self.loadingView.isHidden = false
                    self.loadingView.showNoDataView()
                    let message = NSLocalizedString("NO_EVENTS",
                                                    comment: "Setting the content of the alert")
                    self.loadingView.noDataLabel.text = message
                }
            case .failure( _):
                var errorMessage: String
                errorMessage = String(format: NSLocalizedString("NO_EVENTS",
                                                                comment: "Setting the content of the alert"))
                self.loadingView.stopLoading()
                self.loadingView.noDataView.isHidden = false
                self.loadingView.isHidden = false
                self.loadingView.showNoDataView()
                self.loadingView.noDataLabel.text = errorMessage
            }
        }
    }
    func toMillis() ->String?  {
        let timestamp = selectedDateForEvent.timeIntervalSince1970
        let dateString = String(timestamp)
        let delimiter = "."
        var token = dateString.components(separatedBy: delimiter)
        if token.count > 0 {
            return token[0]
        }
        return nil
    }
    func sundayOrWednesday() -> Bool {
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let components = calendar!.components([.weekday], from: selectedDateForEvent)
        if ((components.weekday == 1) || (components.weekday == 4)) {
            return true
        } else {
            return false
        }
    }
    func findItem(educationArray: [EducationEvent],fixedStartTime : String) -> Int? {
        var newEventPosition : Int? = 0
        for i in 0...educationArray.count-1 {
            if(educationEventArray[i].startTime != nil) {
                let apiTime = (educationEventArray[i].startTime! as NSString).integerValue
                let fixedTime = (fixedStartTime as NSString).integerValue
                if(fixedTime > apiTime) {
                    newEventPosition = i+1
                }
            }
        }
        return newEventPosition
    }
    
    //MARK: Coredata Method
    func saveOrUpdateEducationEventCoredata() {
        if (educationEventArray.count > 0) {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                let fetchData = checkAddedToCoredata(entityName: "EducationEventEntity", eventId: nil) as! [EducationEventEntity]
                if (fetchData.count > 0) {
                    for i in 0 ... educationEventArray.count-1 {
                        let managedContext = getContext()
                        let educationEventDict = educationEventArray[i]
                        let fetchResult = checkAddedToCoredata(entityName: "EducationEventEntity", eventId: educationEventArray[i].eId)
                        //update
                        if(fetchResult.count != 0) {
                            let educationdbDict = fetchResult[0] as! EducationEventEntity
                            educationdbDict.filter = educationEventDict.filter
                            educationdbDict.title = educationEventDict.title
                            educationdbDict.shortDesc =  educationEventDict.shortDesc
                            educationdbDict.longDesc = educationEventDict.longDesc
                            educationdbDict.location = educationEventDict.location
                            educationdbDict.institution =  educationEventDict.institution
                            educationdbDict.startTime = educationEventDict.startTime
                            educationdbDict.endTime = educationEventDict.endtime
                            educationdbDict.ageGroup =  educationEventDict.ageGroup
                            educationdbDict.pgmType = educationEventDict.programType
                            educationdbDict.category = educationEventDict.category
                            educationdbDict.registration =  educationEventDict.registration
                            educationdbDict.date = educationEventDict.date
                            do{
                                try managedContext.save()
                            }
                            catch{
                                print(error)
                            }
                        }
                        else {
                            //save
                            self.saveToCoreData(educationEventDict: educationEventDict, managedObjContext: managedContext)
                            
                        }
                    }
                }
                else {
                    for i in 0 ... educationEventArray.count-1 {
                        let managedContext = getContext()
                        let educationEventDict : EducationEvent?
                        educationEventDict = educationEventArray[i]
                        self.saveToCoreData(educationEventDict: educationEventDict!, managedObjContext: managedContext)
                        
                    }
                }
            }
            else {
                let fetchData = checkAddedToCoredata(entityName: "EducationEventEntityAr", eventId: nil) as! [EducationEventEntityAr]
                if (fetchData.count > 0) {
                    for i in 0 ... educationEventArray.count-1 {
                        let managedContext = getContext()
                        let educationEventDict = educationEventArray[i]
                        let fetchResult = checkAddedToCoredata(entityName: "EducationEventEntityAr", eventId: educationEventArray[i].eId)
                        //update
                        if(fetchResult.count != 0) {
                            let educationdbDict = fetchResult[0] as! EducationEventEntityAr
                            educationdbDict.filterAr = educationEventDict.filter
                            educationdbDict.titleAr = educationEventDict.title
                            educationdbDict.shortDescAr =  educationEventDict.shortDesc
                            educationdbDict.longDescAr = educationEventDict.longDesc
                            educationdbDict.locationAr = educationEventDict.location
                            educationdbDict.institutionAr =  educationEventDict.institution
                            educationdbDict.startTimeAr = educationEventDict.startTime
                            educationdbDict.endTimeAr = educationEventDict.endtime
                            educationdbDict.ageGrpAr =  educationEventDict.ageGroup
                            educationdbDict.pgmTypeAr = educationEventDict.programType
                            educationdbDict.categoryAr = educationEventDict.category
                            educationdbDict.registrationAr =  educationEventDict.registration
                            educationdbDict.dateAr = educationEventDict.date
                            do{
                                try managedContext.save()
                            }
                            catch{
                                print(error)
                            }
                        }
                        else {
                            //save
                            self.saveToCoreData(educationEventDict: educationEventDict, managedObjContext: managedContext)
                            
                        }
                    }
                }
                else {
                    for i in 0 ... educationEventArray.count-1 {
                        let managedContext = getContext()
                        let educationEventDict : EducationEvent?
                        educationEventDict = educationEventArray[i]
                        self.saveToCoreData(educationEventDict: educationEventDict!, managedObjContext: managedContext)
                        
                    }
                }
            }
        }
    }
    func saveToCoreData(educationEventDict: EducationEvent, managedObjContext: NSManagedObjectContext) {
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            let edducationInfo: EducationEventEntity = NSEntityDescription.insertNewObject(forEntityName: "EducationEventEntity", into: managedObjContext) as! EducationEventEntity
            edducationInfo.eid = educationEventDict.eId
            edducationInfo.filter = educationEventDict.filter
            edducationInfo.title = educationEventDict.title
            edducationInfo.shortDesc =  educationEventDict.shortDesc
            edducationInfo.longDesc = educationEventDict.longDesc
            edducationInfo.location = educationEventDict.location
            edducationInfo.institution =  educationEventDict.institution
            edducationInfo.startTime = educationEventDict.startTime
            edducationInfo.endTime = educationEventDict.endtime
            edducationInfo.ageGroup =  educationEventDict.ageGroup
            edducationInfo.pgmType = educationEventDict.programType
            edducationInfo.category = educationEventDict.category
            edducationInfo.registration =  educationEventDict.registration
            edducationInfo.date = educationEventDict.date
        }
        else {
            let edducationInfo: EducationEventEntityAr = NSEntityDescription.insertNewObject(forEntityName: "EducationEventEntityAr", into: managedObjContext) as! EducationEventEntityAr
            edducationInfo.eid = educationEventDict.eId
            edducationInfo.filterAr = educationEventDict.filter
            edducationInfo.titleAr = educationEventDict.title
            edducationInfo.shortDescAr =  educationEventDict.shortDesc
            edducationInfo.locationAr = educationEventDict.longDesc
            edducationInfo.locationAr = educationEventDict.location
            edducationInfo.institutionAr =  educationEventDict.institution
            edducationInfo.startTimeAr = educationEventDict.startTime
            edducationInfo.endTimeAr = educationEventDict.endtime
            edducationInfo.ageGrpAr =  educationEventDict.ageGroup
            edducationInfo.pgmTypeAr = educationEventDict.programType
            edducationInfo.categoryAr = educationEventDict.category
            edducationInfo.registrationAr =  educationEventDict.registration
            edducationInfo.dateAr = educationEventDict.date
        }
        do {
            try managedObjContext.save()
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func fetchEducationEventFromCoredata() {
        
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                var educationArray = [EducationEventEntity]()
                let managedContext = getContext()
                let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "EducationEventEntity")
                educationArray = (try managedContext.fetch(fetchRequest) as? [EducationEventEntity])!
                if (educationArray.count > 0) {
                    for i in 0 ... educationArray.count-1 {
                        self.educationEventArray.insert(EducationEvent(eid: educationArray[i].eid, filter: educationArray[i].filter, title: educationArray[i].title, shortDesc: educationArray[i].shortDesc, longDesc: educationArray[i].longDesc, location: educationArray[i].location, institution: educationArray[i].institution, startTime: educationArray[i].startTime, endTime: educationArray[i].endTime, ageGroup: educationArray[i].ageGroup, programType: educationArray[i].pgmType, category: educationArray[i].category, registration: educationArray[i].registration, date: educationArray[i].date, maxGroupSize: educationArray[i].maxGrpSize), at: i)
                    }
                    if(educationEventArray.count == 0){
                        self.showNodata()
                    }
                    eventCollectionView.reloadData()
                }
                else{
                    self.showNodata()
                }
            }
            else {
                var educationArray = [EducationEventEntityAr]()
                let managedContext = getContext()
                let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "EducationEventEntityAr")
                educationArray = (try managedContext.fetch(fetchRequest) as? [EducationEventEntityAr])!
                if (educationArray.count > 0) {
                    for i in 0 ... educationArray.count-1 {
                        
                        self.educationEventArray.insert(EducationEvent(eid: educationArray[i].eid, filter: educationArray[i].filterAr, title: educationArray[i].filterAr, shortDesc: educationArray[i].shortDescAr, longDesc: educationArray[i].longDescAr, location: educationArray[i].locationAr, institution: educationArray[i].institutionAr, startTime: educationArray[i].startTimeAr, endTime: educationArray[i].endTimeAr, ageGroup: educationArray[i].ageGrpAr, programType: educationArray[i].pgmTypeAr, category: educationArray[i].categoryAr, registration: educationArray[i].registrationAr, date: educationArray[i].dateAr , maxGroupSize: educationArray[i].maxGrpSizeAr), at: i)
                        
                    }
                    if(educationEventArray.count == 0){
                        self.showNodata()
                    }
                    eventCollectionView.reloadData()
                }
                else{
                    self.showNodata()
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    //MARK: EVENT DB
 
    func saveOrUpdateEventCoredata() {
        if (educationEventArray.count > 0) {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                let fetchData = checkAddedToCoredata(entityName: "EventEntity", eventId: nil) as! [EventEntity]
                if (fetchData.count > 0) {
                    for i in 0 ... educationEventArray.count-1 {
                        let managedContext = getContext()
                        let educationEventDict = educationEventArray[i]
                        let fetchResult = checkAddedToCoredata(entityName: "EventEntity", eventId: educationEventArray[i].eId)
                        //update
                        if(fetchResult.count != 0) {
                            let educationdbDict = fetchResult[0] as! EventEntity
                            educationdbDict.filter = educationEventDict.filter
                            educationdbDict.title = educationEventDict.title
                            educationdbDict.shortDesc =  educationEventDict.shortDesc
                            educationdbDict.longDesc = educationEventDict.longDesc
                            educationdbDict.location = educationEventDict.location
                            educationdbDict.institution =  educationEventDict.institution
                            educationdbDict.startTime = educationEventDict.startTime
                            educationdbDict.endTime = educationEventDict.endtime
                            educationdbDict.ageGroup =  educationEventDict.ageGroup
                            educationdbDict.pgmType = educationEventDict.programType
                            educationdbDict.category = educationEventDict.category
                            educationdbDict.registration =  educationEventDict.registration
                            educationdbDict.date = educationEventDict.date
                            do{
                                try managedContext.save()
                            }
                            catch{
                                print(error)
                            }
                        }
                        else {
                            //save
                            self.saveEventToCoreData(educationEventDict: educationEventDict, managedObjContext: managedContext)
                            
                        }
                    }
                }
                else {
                    for i in 0 ... educationEventArray.count-1 {
                        let managedContext = getContext()
                        let educationEventDict : EducationEvent?
                        educationEventDict = educationEventArray[i]
                        self.saveEventToCoreData(educationEventDict: educationEventDict!, managedObjContext: managedContext)
                        
                    }
                }
            }
            else {
                let fetchData = checkAddedToCoredata(entityName: "EventEntityArabic", eventId: nil) as! [EventEntityArabic]
                if (fetchData.count > 0) {
                    for i in 0 ... educationEventArray.count-1 {
                        let managedContext = getContext()
                        let educationEventDict = educationEventArray[i]
                        let fetchResult = checkAddedToCoredata(entityName: "EventEntityArabic", eventId: educationEventArray[i].eId)
                        //update
                        if(fetchResult.count != 0) {
                            let educationdbDict = fetchResult[0] as! EventEntityArabic
                            educationdbDict.filterAr = educationEventDict.filter
                            educationdbDict.titleAr = educationEventDict.title
                            educationdbDict.shortDescAr =  educationEventDict.shortDesc
                            educationdbDict.longDesAr = educationEventDict.longDesc
                            educationdbDict.locationAr = educationEventDict.location
                            educationdbDict.institutionAr =  educationEventDict.institution
                            educationdbDict.startTimeAr = educationEventDict.startTime
                            educationdbDict.endTimeAr = educationEventDict.endtime
                            educationdbDict.ageGroupAr =  educationEventDict.ageGroup
                            educationdbDict.pgmTypeAr = educationEventDict.programType
                            educationdbDict.categoryAr = educationEventDict.category
                            educationdbDict.registrationAr =  educationEventDict.registration
                            educationdbDict.dateAr = educationEventDict.date
                            do{
                                try managedContext.save()
                            }
                            catch{
                                print(error)
                            }
                        }
                        else {
                            //save
                            self.saveEventToCoreData(educationEventDict: educationEventDict, managedObjContext: managedContext)
                            
                        }
                    }
                }
                else {
                    for i in 0 ... educationEventArray.count-1 {
                        let managedContext = getContext()
                        let educationEventDict : EducationEvent?
                        educationEventDict = educationEventArray[i]
                        self.saveEventToCoreData(educationEventDict: educationEventDict!, managedObjContext: managedContext)
                        
                    }
                }
            }
        }
    }
    func saveEventToCoreData(educationEventDict: EducationEvent, managedObjContext: NSManagedObjectContext) {
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            let edducationInfo: EventEntity = NSEntityDescription.insertNewObject(forEntityName: "EventEntity", into: managedObjContext) as! EventEntity
            edducationInfo.eid = educationEventDict.eId
            edducationInfo.filter = educationEventDict.filter
            edducationInfo.title = educationEventDict.title
            edducationInfo.shortDesc =  educationEventDict.shortDesc
            edducationInfo.longDesc = educationEventDict.longDesc
            edducationInfo.location = educationEventDict.location
            edducationInfo.institution =  educationEventDict.institution
            edducationInfo.startTime = educationEventDict.startTime
            edducationInfo.endTime = educationEventDict.endtime
            edducationInfo.ageGroup =  educationEventDict.ageGroup
            edducationInfo.pgmType = educationEventDict.programType
            edducationInfo.category = educationEventDict.category
            edducationInfo.registration =  educationEventDict.registration
            edducationInfo.date = educationEventDict.date
        }
        else {
            let edducationInfo: EventEntityArabic = NSEntityDescription.insertNewObject(forEntityName: "EventEntityArabic", into: managedObjContext) as! EventEntityArabic
            edducationInfo.eid = educationEventDict.eId
            edducationInfo.filterAr = educationEventDict.filter
            edducationInfo.titleAr = educationEventDict.title
            edducationInfo.shortDescAr =  educationEventDict.shortDesc
            edducationInfo.locationAr = educationEventDict.longDesc
            edducationInfo.locationAr = educationEventDict.location
            edducationInfo.institutionAr =  educationEventDict.institution
            edducationInfo.startTimeAr = educationEventDict.startTime
            edducationInfo.endTimeAr = educationEventDict.endtime
            edducationInfo.ageGroupAr =  educationEventDict.ageGroup
            edducationInfo.pgmTypeAr = educationEventDict.programType
            edducationInfo.categoryAr = educationEventDict.category
            edducationInfo.registrationAr =  educationEventDict.registration
            edducationInfo.dateAr = educationEventDict.date
        }
        do {
            try managedObjContext.save()
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func fetchEventFromCoredata() {
        
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                var educationArray = [EventEntity]()
                let managedContext = getContext()
                let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "EventEntity")
                educationArray = (try managedContext.fetch(fetchRequest) as? [EventEntity])!
                if (educationArray.count > 0) {
                    for i in 0 ... educationArray.count-1 {
                        self.educationEventArray.insert(EducationEvent(eid: educationArray[i].eid, filter: educationArray[i].filter, title: educationArray[i].title, shortDesc: educationArray[i].shortDesc, longDesc: educationArray[i].longDesc, location: educationArray[i].location, institution: educationArray[i].institution, startTime: educationArray[i].startTime, endTime: educationArray[i].endTime, ageGroup: educationArray[i].ageGroup, programType: educationArray[i].pgmType, category: educationArray[i].category, registration: educationArray[i].registration, date: educationArray[i].date, maxGroupSize: educationArray[i].maxGrpSize), at: i)
                    }
                    if(educationEventArray.count == 0){
                        self.showNodata()
                    }
                    eventCollectionView.reloadData()
                }
                else{
                    self.showNodata()
                }
            }
            else {
                var educationArray = [EventEntityArabic]()
                let managedContext = getContext()
                let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "EventEntityArabic")
                educationArray = (try managedContext.fetch(fetchRequest) as? [EventEntityArabic])!
                if (educationArray.count > 0) {
                    for i in 0 ... educationArray.count-1 {
                        
                        self.educationEventArray.insert(EducationEvent(eid: educationArray[i].eid, filter: educationArray[i].filterAr, title: educationArray[i].filterAr, shortDesc: educationArray[i].shortDescAr, longDesc: educationArray[i].longDesAr, location: educationArray[i].locationAr, institution: educationArray[i].institutionAr, startTime: educationArray[i].startTimeAr, endTime: educationArray[i].endTimeAr, ageGroup: educationArray[i].ageGroupAr, programType: educationArray[i].pgmTypeAr, category: educationArray[i].categoryAr, registration: educationArray[i].registrationAr, date: educationArray[i].dateAr, maxGroupSize: educationArray[i].maxGrpSizeAr), at: i)
                        
                    }
                    if(educationEventArray.count == 0){
                        self.showNodata()
                    }
                    eventCollectionView.reloadData()
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
    func checkAddedToCoredata(entityName: String?,eventId: String?) -> [NSManagedObject]
    {
        let managedContext = getContext()
        var fetchResults : [NSManagedObject] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName!)
        if (eventId != nil) {
            fetchRequest.predicate = NSPredicate.init(format: "eid == \(eventId!)")
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
    
    
}

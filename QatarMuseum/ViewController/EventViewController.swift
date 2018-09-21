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
    let anyString = NSLocalizedString("ANYSTRING", comment: "ANYSTRING in the Filter page")
    var institutionType : String? = "any"
    var ageGroupType: String? = "any"
    var programmeType:String? = "any"

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
        institutionType = anyString
        ageGroupType = anyString
        programmeType = anyString
        
        
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
        self.educationEventArray = [EducationEvent]()
        headerView.headerViewDelegate = self
        headerView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        self.view.addGestureRecognizer(self.scopeGesture)
        listTitleLabel.font = UIFont.diningHeaderFont
        self.eventCollectionView.panGestureRecognizer.require(toFail: self.scopeGesture)
        if (isLoadEventPage == true) {
            listTitleLabel.text = NSLocalizedString("CALENDAR_EVENT_TITLE", comment: "CALENDAR_EVENT_TITLE Label in the Event page")
            headerView.headerTitle.text = NSLocalizedString("CALENDAR_TITLE", comment: "CALENDAR_TITLE Label in the Event page")
            listTitleLabel.textColor = UIColor.eventlisBlue
            institutionType = anyString
            ageGroupType = anyString
            programmeType = anyString
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
            headerView.settingsButton.isHidden = true
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
        eventPopup.tag = 0
        eventPopup  = EventPopupView(frame: self.view.frame)
        eventPopup.eventPopupDelegate = self
        selectedEvent = educationEventArray[currentRow]
        needToRegister = educationEventArray[currentRow].register
        if(needToRegister == "true") {
            let buttonTitle = NSLocalizedString("EDUCATION_POPUP_BUTTON_TITLE", comment: "POPUP_ADD_BUTTON_TITLE  in the popup view")
            eventPopup.addToCalendarButton.setTitle(buttonTitle, for: .normal)
            eventPopup.addToCalendarButton.backgroundColor = UIColor.lightGrayColor
            eventPopup.addToCalendarButton.setTitleColor(UIColor.whiteColor, for: .normal)
            eventPopup.addToCalendarButton.isEnabled = false
        }
        else {
            let buttonTitle = NSLocalizedString("POPUP_ADD_BUTTON_TITLE", comment: "POPUP_ADD_BUTTON_TITLE  in the popup view")
            eventPopup.addToCalendarButton.setTitle(buttonTitle, for: .normal)
        }
        if (isLoadEventPage == true) {
            
            eventPopup.eventTitle.text = educationEventArray[currentRow].title?.replacingOccurrences(of: "<[^>]+>|&nbsp;", with: "", options: .regularExpression, range: nil).uppercased()
            eventPopup.eventDescription.text = educationEventArray[currentRow].longDesc
            //let buttonTitle = NSLocalizedString("POPUP_ADD_BUTTON_TITLE", comment: "POPUP_ADD_BUTTON_TITLE  in the popup view")
           // eventPopup.addToCalendarButton.setTitle(buttonTitle, for: .normal)
        }
        else {
            eventPopup.eventTitle.text = educationEventArray[currentRow].title?.replacingOccurrences(of: "<[^>]+>|&nbsp;", with: "", options: .regularExpression, range: nil).uppercased()
            eventPopup.eventDescription.text = educationEventArray[currentRow].longDesc
            
        }
        self.view.addSubview(eventPopup)
     
        
    }
  
    //MARK: Event popup delegate
    func eventCloseButtonPressed() {
        
        self.eventPopup.removeFromSuperview()
        
       
    }
    func addToCalendarButtonPressed() {
        if (eventPopup.tag == 0) {
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
                self.eventPopup.removeFromSuperview()
                var calendar = Calendar.current
                //calendar.timeZone = TimeZone(identifier: "UTC")!
                let startDt = calendar.date(bySettingHour:14, minute: 0, second: 0, of: selectedDateForEvent)!
                let endDt = calendar.date(bySettingHour: 16, minute: 0, second: 0, of: selectedDateForEvent)!
                self.addEventToCalendar(title:  (selectedEvent?.title)!, description: selectedEvent?.longDesc, startDate: startDt, endDate: endDt)
                
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
        else {
            self.eventPopup.removeFromSuperview()
            let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            UIApplication.shared.openURL(openSettingsUrl!)
        }

        
    }
   
    func closeButtonPressed() {
        self.popupView.removeFromSuperview()
    }
    func addEventToCalendar(title: String, description: String?, startDate: Date?, endDate: Date?, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        let status = EKEventStore.authorizationStatus(for: .event)
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            eventStore.requestAccess(to: .event, completion: { (granted, error) in
                if (granted) && (error == nil) {
                    DispatchQueue.main.async {
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
                        self.view.hideAllToasts()
                        let eventAddedMessage =  NSLocalizedString("EVENT_ADDED_MESSAGE", comment: "EVENT_ADDED_MESSAGE")
                        self.view.makeToast(eventAddedMessage)
                    } catch let e as NSError {
                        completion?(false, e)
                        return
                    }
                    completion?(true, nil)
                }
                } else {
                    completion?(false, error as NSError?)
                }
            })
        case EKAuthorizationStatus.authorized:
            let event = EKEvent.init(eventStore: self.store)
            event.title = title
            event.calendar = self.store.defaultCalendarForNewEvents
            event.startDate = startDate
            event.endDate = endDate
            event.notes = description
            
            do {
                try self.store.save(event, span: .thisEvent)
                self.view.hideAllToasts()
                let eventAddedMessage =  NSLocalizedString("EVENT_ADDED_MESSAGE", comment: "EVENT_ADDED_MESSAGE")
                self.view.makeToast(eventAddedMessage)
            } catch let e as NSError {
                return
            }
        case EKAuthorizationStatus.denied, EKAuthorizationStatus.restricted:
            
            self.loadPermissionPopup()
        default:
            break
        }
       
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
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.main.async {
            self.educationEventArray = []
            self.eventCollectionView.reloadData()
            group.leave()
        }
        selectedDateForEvent = date
        group.notify(queue: .main) {
            if (self.isLoadEventPage == true) {
                if  (self.networkReachability?.isReachable)! {
                    self.getEducationEventFromServer()
                }
                else {
                    self.fetchEventFromCoredata()
                }
            }
            else {
                if  (self.networkReachability?.isReachable)! {
                    self.getEducationEventFromServer()
                }
                else {
                    self.fetchEducationEventFromCoredata()
                }
            }
        }
        
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
    /*
    //MARK: WebServiceCall
    func getEducationEventFromServer() {
        let dateString = toMillis()
        _ = Alamofire.request(QatarMuseumRouter.EducationEvent(String: dateString!, String: ageGroupType!, String: institutionType!, String: programmeType!)).responseObject { (response: DataResponse<EducationEventList>) -> Void in
            switch response.result {
            case .success(let data):
                self.educationEventArray = data.educationEvent!
             //  let evetPosition = self.findItem(educationArray: self.educationEventArray, fixedStartTime: "14:00")
              //  if(self.sundayOrWednesday() == false) {
//                    self.educationEventArray.insert(EducationEvent(eid: "15476", filter: nil, title: "Walk In Gallery Tours", shortDesc: "Join our Museum Guides for a tour of the Museum of Islamic Art's oustanding collection of objects, spread over 1,400 years and across three continents. No booking is required to be a part of the tour.", longDesc: "Monday - Science Tour\n Tuesday - Techniques Tour (from 1 July onwards)\n Thursday - MIA Architecture Tour\n Friday - Permanent Gallery Tour\nSaturday - Permanent Gallery Tour", location: " Museum of Islamic Art, Atrium", institution: "MIA", startTime: "14:00", endTime: "16:00", ageGroup: "adults", programType: "gallery tour", category: nil, registration: "false", date: "Every Monday, Tuesday, Thursday, Friday and Saturday",maxGroupSize: "40" ), at: evetPosition!)

                //}
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
   */
    //MARK: WebServiceCall
    func getEducationEventFromServer() {
       // let dateString = toMillis()
        let getDate = toDayMonthYear()
        if ((getDate.day != nil) && (getDate.month != nil) && (getDate.year != nil)) {
            _ = Alamofire.request(QatarMuseumRouter.EducationEvent(["institution" : "All","age" : "All", "programe" : "All","date_filter[value][month]" : getDate.month!, "date_filter[value][day]" : getDate.day!,"date_filter[value][year]" : getDate.year!,"cck_multiple_field_remove_fields" : "All"] )).responseObject { (response: DataResponse<EducationEventList>) -> Void in
                switch response.result {
                case .success(let data):
                    self.educationEventArray = data.educationEvent!
                    //  let evetPosition = self.findItem(educationArray: self.educationEventArray, fixedStartTime: "14:00")
                    //  if(self.sundayOrWednesday() == false) {
                    //                    self.educationEventArray.insert(EducationEvent(eid: "15476", filter: nil, title: "Walk In Gallery Tours", shortDesc: "Join our Museum Guides for a tour of the Museum of Islamic Art's oustanding collection of objects, spread over 1,400 years and across three continents. No booking is required to be a part of the tour.", longDesc: "Monday - Science Tour\n Tuesday - Techniques Tour (from 1 July onwards)\n Thursday - MIA Architecture Tour\n Friday - Permanent Gallery Tour\nSaturday - Permanent Gallery Tour", location: " Museum of Islamic Art, Atrium", institution: "MIA", startTime: "14:00", endTime: "16:00", ageGroup: "adults", programType: "gallery tour", category: nil, registration: "false", date: "Every Monday, Tuesday, Thursday, Friday and Saturday",maxGroupSize: "40" ), at: evetPosition!)
                    
                    //}
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

    }
    func toDayMonthYear() ->(day:String?, month:String?, year:String?) {
        let date = selectedDateForEvent
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        dateFormatter.dateFormat = "M"
        let selectedMonth: String = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "d"
        let selectedDay: String = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "yyyy"
        let selectedYear: String = dateFormatter.string(from: date)
        return(selectedDay,selectedMonth,selectedYear)
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
    func getUniqueDate() -> String? {
        let calendar = Calendar.current
        //calendar.timeZone = TimeZone(identifier: "UTC")!
        let startDt = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: selectedDateForEvent)!
        let timestamp = startDt.timeIntervalSince1970
        let dateString = String(timestamp)
        let delimiter = "."
        var token = dateString.components(separatedBy: delimiter)
        if token.count > 0 {
            return token[0]
        }
        
        return nil
    }
//    func findItem(educationArray: [EducationEvent],fixedStartTime : String) -> Int? {
//        var newEventPosition : Int? = 0
//        for i in 0...educationArray.count-1 {
//            if(educationEventArray[i].startTime != nil) {
//                let apiTime = (educationEventArray[i].startTime! as NSString).integerValue
//                let fixedTime = (fixedStartTime as NSString).integerValue
//                if(fixedTime > apiTime) {
//                    newEventPosition = i+1
//                }
//            }
//        }
//        return newEventPosition
//    }
    
    //MARK: Coredata Method
    func saveOrUpdateEducationEventCoredata() {
        if (educationEventArray.count > 0) {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                let dateID = getUniqueDate()
                let fetchData = checkAddedToCoredata(entityName: "EducationEventEntity", idKey: "dateId", idValue: dateID) as! [EducationEventEntity]
                let managedContext = getContext()
                if (fetchData.count > 0) {
                    for i in 0 ... educationEventArray.count-1 {
                        let educationDict = educationEventArray[i]
                        let fetchResultData = checkAddedToCoredata(entityName: "EducationEventEntity", idKey: "itemId", idValue: educationDict.itemId) as! [EducationEventEntity]
                        if ( fetchResultData.count > 0) {
                            let isDeleted = self.deleteExistingEvent(managedContext: managedContext, entityName: "EducationEventEntity")
                            if(isDeleted == true) {
                                self.saveToCoreData(educationEventDict: educationDict, dateId: dateID, managedObjContext: managedContext)
                            }
                        } else {
                            self.saveEventToCoreData(educationEventDict: educationDict, dateId: dateID, managedObjContext: managedContext)
                        }
                    }
                    
                }
                else {
                    for i in 0 ... educationEventArray.count-1 {
                        let educationEvent = educationEventArray[i]
                        self.saveToCoreData(educationEventDict: educationEvent, dateId: dateID, managedObjContext: managedContext)
                    }
                }
            }
            else {
                let dateID = getUniqueDate()
                let fetchData = checkAddedToCoredata(entityName: "EducationEventEntityAr", idKey: "dateId", idValue: dateID) as! [EducationEventEntityAr]
                let managedContext = getContext()
                if (fetchData.count > 0) {
                    for i in 0 ... educationEventArray.count-1 {
                        let educationDict = educationEventArray[i]
                        let fetchResultData = checkAddedToCoredata(entityName: "EducationEventEntityAr", idKey: "itemId", idValue: educationDict.itemId) as! [EducationEventEntityAr]
                        if ( fetchResultData.count > 0) {
                            let isDeleted = self.deleteExistingEvent(managedContext: managedContext, entityName: "EducationEventEntityAr")
                            if(isDeleted == true) {
                                self.saveToCoreData(educationEventDict: educationDict, dateId: dateID, managedObjContext: managedContext)
                            }
                        } else {
                            self.saveEventToCoreData(educationEventDict: educationDict, dateId: dateID, managedObjContext: managedContext)
                        }
                    }
                    
                   
                }
                else {
                   for i in 0 ... educationEventArray.count-1 {
                        let educationEvent = educationEventArray[i]
                    self.saveToCoreData(educationEventDict: educationEvent, dateId: dateID, managedObjContext: managedContext)
                    }
                }
            }
        }
    }
    func saveToCoreData(educationEventDict: EducationEvent,dateId: String?, managedObjContext: NSManagedObjectContext) {
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            //for i in 0...educationArray.count-1 {
                let edducationInfo: EducationEventEntity = NSEntityDescription.insertNewObject(forEntityName: "EducationEventEntity", into: managedObjContext) as! EducationEventEntity
            
//            if((educationEventDict.fieldRepeatDate?.count)! > 0) {
//                let fieldRepeatId = educationEventDict.fieldRepeatDate![0]
//                edducationInfo.fieldRepeatDate =  fieldRepeatId
//            }
              //  let educationEventDict = educationArray[i]
                edducationInfo.dateId = dateId
                edducationInfo.itemId = educationEventDict.itemId
                edducationInfo.fieldRepeatId = educationEventDict.fieldRepeatId
                edducationInfo.register = educationEventDict.register
                //edducationInfo.field =  educationEventDict.shortDesc
                edducationInfo.title = educationEventDict.title
                edducationInfo.pgmType = educationEventDict.programType
            
            if((educationEventDict.fieldRepeatDate?.count)! > 0) {
                for i in 0 ... (educationEventDict.fieldRepeatDate?.count)!-1 {
                    var eventDateEntity: EdEventDateEntity!
                    let edEventDate: EdEventDateEntity = NSEntityDescription.insertNewObject(forEntityName: "EdEventDateEntity", into: managedObjContext) as! EdEventDateEntity
                    edEventDate.fieldRepeatDate = educationEventDict.fieldRepeatDate![i].replacingOccurrences(of: "<[^>]+>|&nbsp;", with: "", options: .regularExpression, range: nil)
                    
                    eventDateEntity = edEventDate
                    edducationInfo.addToFieldRepeatDates(eventDateEntity)
                    
                    do {
                        try managedObjContext.save()
                        
                        
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                    
                }
            }
                
          
        }
        else {
        
                let edducationInfo: EducationEventEntityAr = NSEntityDescription.insertNewObject(forEntityName: "EducationEventEntityAr", into: managedObjContext) as! EducationEventEntityAr
            
                if((educationEventDict.fieldRepeatDate?.count)! > 0) {
                    let fieldRepeatId = educationEventDict.fieldRepeatDate![0]
                    edducationInfo.fieldRepeatDate =  fieldRepeatId
                }
            
                edducationInfo.dateId = dateId
                edducationInfo.itemId = educationEventDict.itemId
                edducationInfo.fieldRepeatId = educationEventDict.fieldRepeatId
                edducationInfo.registerAr = educationEventDict.register
                edducationInfo.titleAr = educationEventDict.title
                edducationInfo.pgmTypeAr = educationEventDict.programType
            
            if((educationEventDict.fieldRepeatDate?.count)! > 0) {
                for i in 0 ... (educationEventDict.fieldRepeatDate?.count)!-1 {
                    var eventDateEntity: EdEventDateEntityAr!
                    let edEventDate: EdEventDateEntityAr = NSEntityDescription.insertNewObject(forEntityName: "EdEventDateEntityAr", into: managedObjContext) as! EdEventDateEntityAr
                    edEventDate.fieldRepeatDate = educationEventDict.fieldRepeatDate![i].replacingOccurrences(of: "<[^>]+>|&nbsp;", with: "", options: .regularExpression, range: nil)
                    
                    eventDateEntity = edEventDate
                    edducationInfo.addToFieldRepeatDates(eventDateEntity)
                    
                    do {
                        try managedObjContext.save()
                        
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                    
                }
            }
            //}
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
                let dateID = getUniqueDate()
                educationArray = checkAddedToCoredata(entityName: "EducationEventEntity", idKey: "dateId", idValue: dateID) as! [EducationEventEntity]
                if (educationArray.count > 0) {
                    for i in 0 ... educationArray.count-1 {
                        var dateArray : [String] = []
                        let educationInfo = educationArray[i]
                        let educationInfoArray = (educationInfo.fieldRepeatDates?.allObjects) as! [EdEventDateEntity]
                        for i in 0 ... educationInfoArray.count-1 {
                            dateArray.append(educationInfoArray[i].fieldRepeatDate!)
                        }
                        self.educationEventArray.insert(EducationEvent(itemId: educationArray[i].itemId, fieldRepeatId: educationArray[i].fieldRepeatId, register: educationArray[i].register, fieldRepeatDate: dateArray, title: educationArray[i].title
                            , programType: educationArray[i].pgmType), at: i)
                    }
                    if(educationEventArray.count == 0){
                        self.showNodata()
                    }
                        self.eventCollectionView.reloadData()
                }
                else{
                    self.showNodata()
                }
            }
            else {
                var educationArray = [EducationEventEntityAr]()
                let dateID = getUniqueDate()
                educationArray = checkAddedToCoredata(entityName: "EducationEventEntityAr", idKey: "dateId", idValue: dateID) as! [EducationEventEntityAr]
                if (educationArray.count > 0) {
                    for i in 0 ... educationArray.count-1 {
                        var dateArray : [String] = []
                        let educationInfo = educationArray[i]
                        let educationInfoArray = (educationInfo.fieldRepeatDates?.allObjects) as! [EdEventDateEntityAr]
                        for i in 0 ... educationInfoArray.count-1 {
                            dateArray.append(educationInfoArray[i].fieldRepeatDate!)
                        }

                        self.educationEventArray.insert(EducationEvent(itemId: educationArray[i].itemId, fieldRepeatId: educationArray[i].fieldRepeatId, register: educationArray[i].registerAr, fieldRepeatDate: dateArray, title: educationArray[i].titleAr
                            , programType: educationArray[i].pgmTypeAr), at: i)
                        
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
                let dateID = getUniqueDate()
                let fetchData = checkAddedToCoredata(entityName: "EventEntity", idKey: "dateId", idValue: dateID) as! [EventEntity]
                let managedContext = getContext()
                if (fetchData.count > 0) {
                    for i in 0 ... educationEventArray.count-1 {
                        let educationDict = educationEventArray[i]
                        let fetchResultData = checkAddedToCoredata(entityName: "EventEntity", idKey: "itemId", idValue: educationDict.itemId) as! [EventEntity]
                        if ( fetchResultData.count > 0) {
                            let isDeleted = self.deleteExistingEvent(managedContext: managedContext, entityName: "EventEntity")
                            if(isDeleted == true) {
                                self.saveEventToCoreData(educationEventDict: educationDict, dateId: dateID, managedObjContext: managedContext)
                            }
                        } else {
                            self.saveEventToCoreData(educationEventDict: educationDict, dateId: dateID, managedObjContext: managedContext)
                        }
                    }
                }
                else {
                    for i in 0 ... educationEventArray.count-1 {
                        let managedContext = getContext()
                        let educationEvent = educationEventArray[i]
                        self.saveEventToCoreData(educationEventDict: educationEvent, dateId: dateID, managedObjContext: managedContext)
                    }
                }
            }
            else {
                let dateID = getUniqueDate()
                let fetchData = checkAddedToCoredata(entityName: "EventEntityArabic", idKey: "dateId", idValue: dateID) as! [EventEntityArabic]
                
                let managedContext = getContext()
                //Anything in Db
                if (fetchData.count > 0) {
                    for i in 0 ... educationEventArray.count-1 {
                        let educationDict = educationEventArray[i]
                        let fetchResultData = checkAddedToCoredata(entityName: "EventEntity", idKey: "itemId", idValue: educationDict.itemId) as! [EventEntity]
                        if ( fetchResultData.count > 0) {
                            let isDeleted = self.deleteExistingEvent(managedContext: managedContext, entityName: "EventEntityArabic")
                            if(isDeleted == true) {
                                self.saveEventToCoreData(educationEventDict: educationDict, dateId: dateID, managedObjContext: managedContext)
                            }
                        } else {
                            self.saveEventToCoreData(educationEventDict: educationDict, dateId: dateID, managedObjContext: managedContext)
                        }
                    }
                  
                }else {
                    for i in 0 ... educationEventArray.count-1 {
                        let educationEvent = educationEventArray[i]
                    self.saveEventToCoreData(educationEventDict: educationEvent, dateId: dateID, managedObjContext: managedContext)
                    }
                }

                }//Anything in Db
            
            }
    }
    func deleteExistingEvent(managedContext:NSManagedObjectContext,entityName : String?) ->Bool? {
        let dateID = getUniqueDate()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName!)
        fetchRequest.predicate = NSPredicate.init(format: "\("dateId") == \(dateID!)")
        let deleteRequest = NSBatchDeleteRequest( fetchRequest: fetchRequest)
        do{
            try managedContext.execute(deleteRequest)
            return true
        }catch let error as NSError {
            //handle error here
            return false
        }
     
    }
    func saveEventToCoreData(educationEventDict: EducationEvent,dateId: String?, managedObjContext: NSManagedObjectContext) {
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            
          //  for i in 0...educationArray.count-1 {
                let edducationInfo: EventEntity = NSEntityDescription.insertNewObject(forEntityName: "EventEntity", into: managedObjContext) as! EventEntity
                //let educationEventDict = educationArray[i]
//            if((educationEventDict.fieldRepeatDate?.count)! > 0) {
//                let fieldRepeatId = educationEventDict.fieldRepeatDate![0]
//                edducationInfo.fieldRepeatDate =  fieldRepeatId
//            }
            
            
                 edducationInfo.dateId = dateId
                edducationInfo.itemId = educationEventDict.itemId
                edducationInfo.fieldRepeatId = educationEventDict.fieldRepeatId
                edducationInfo.register = educationEventDict.register
                edducationInfo.title = educationEventDict.title
                edducationInfo.pgmType = educationEventDict.programType
            
            
            if((educationEventDict.fieldRepeatDate?.count)! > 0) {
                for i in 0 ... (educationEventDict.fieldRepeatDate?.count)!-1 {
                    var eventDateEntity: EventDateEntity!
                    let edEventDate: EventDateEntity = NSEntityDescription.insertNewObject(forEntityName: "EventDateEntity", into: managedObjContext) as! EventDateEntity
                    edEventDate.fieldRepeatDate = educationEventDict.fieldRepeatDate![i].replacingOccurrences(of: "<[^>]+>|&nbsp;", with: "", options: .regularExpression, range: nil)
                    
                    eventDateEntity = edEventDate
                    edducationInfo.addToFieldRepeatDates(eventDateEntity)
                    do {
                        try managedObjContext.save()
                        
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                    
                }
            }
          
            
        }
        else {
            
           
                let edducationInfo: EventEntityArabic = NSEntityDescription.insertNewObject(forEntityName: "EventEntityArabic", into: managedObjContext) as! EventEntityArabic
                 edducationInfo.dateId = dateId
                edducationInfo.itemId = educationEventDict.itemId
                edducationInfo.fieldRepeatId = educationEventDict.fieldRepeatId
                edducationInfo.registerAr = educationEventDict.register
                //edducationInfo.field =  educationEventDict.shortDesc
                edducationInfo.titleAr = educationEventDict.title
                edducationInfo.pgmTypeAr = educationEventDict.programType
            
            if((educationEventDict.fieldRepeatDate?.count)! > 0) {
                for i in 0 ... (educationEventDict.fieldRepeatDate?.count)!-1 {
                    var eventDateEntity: EventDateEntityAr!
                    let edEventDate: EventDateEntityAr = NSEntityDescription.insertNewObject(forEntityName: "EventDateEntityAr", into: managedObjContext) as! EventDateEntityAr
                    edEventDate.fieldRepeatDate = educationEventDict.fieldRepeatDate![i].replacingOccurrences(of: "<[^>]+>|&nbsp;", with: "", options: .regularExpression, range: nil)
                    
                    eventDateEntity = edEventDate
                    edducationInfo.addToFieldRepeatDates(eventDateEntity)
                    
                    do {
                        try managedObjContext.save()
                        
                        
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                    
                }
            }
            
            //}
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
                let dateID = getUniqueDate()
                educationArray = checkAddedToCoredata(entityName: "EventEntity", idKey: "dateId", idValue: dateID) as! [EventEntity]
                if (educationArray.count > 0) {
                    for i in 0 ... educationArray.count-1 {
                        var dateArray : [String] = []
                        let educationInfo = educationArray[i]
                        let educationInfoArray = (educationInfo.fieldRepeatDates?.allObjects) as! [EventDateEntity]
                        for i in 0 ... educationInfoArray.count-1 {
                            dateArray.append(educationInfoArray[i].fieldRepeatDate!)
                        }
                        self.educationEventArray.insert(EducationEvent(itemId: educationArray[i].itemId, fieldRepeatId: educationArray[i].fieldRepeatId, register: educationArray[i].register, fieldRepeatDate: dateArray, title: educationArray[i].title
                            , programType: educationArray[i].pgmType), at: i)
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
                let dateID = getUniqueDate()
                educationArray = checkAddedToCoredata(entityName: "EventEntityArabic", idKey: "dateId", idValue: dateID) as! [EventEntityArabic]
                if (educationArray.count > 0) {
                    for i in 0 ... educationArray.count-1 {
                        var dateArray : [String] = []
                        let educationInfo = educationArray[i]
                        let educationInfoArray = (educationInfo.fieldRepeatDates?.allObjects) as! [EventDateEntityAr]
                        for i in 0 ... educationInfoArray.count-1 {
                            dateArray.append(educationInfoArray[i].fieldRepeatDate!)
                        }
                        self.educationEventArray.insert(EducationEvent(itemId: educationArray[i].itemId, fieldRepeatId: educationArray[i].fieldRepeatId, register: educationArray[i].registerAr, fieldRepeatDate: dateArray, title: educationArray[i].titleAr
                            , programType: educationArray[i].pgmTypeAr), at: i)
                        
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
    func checkAddedToCoredata(entityName: String?,idKey:String?,idValue: String?) -> [NSManagedObject]
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
    //MARK: Event Popup Delegate
    func loadPermissionPopup() {
        eventPopup.eventTitle.isScrollEnabled = false
        
        eventPopup  = EventPopupView(frame: self.view.frame)
        eventPopup.eventPopupHeight.constant = 300
        eventPopup.eventPopupDelegate = self
        
        eventPopup.eventTitle.text = NSLocalizedString("PERMISSION_TITLE", comment: "PERMISSION_TITLE  in the popup view")
        eventPopup.eventDescription.text = NSLocalizedString("CALENDAR_PERMISSION", comment: "CALENDAR_PERMISSION  in the popup view")
        eventPopup.addToCalendarButton.setTitle(NSLocalizedString("SIDEMENU_SETTINGS_LABEL", comment: "SIDEMENU_SETTINGS_LABEL  in the popup view"), for: .normal)
        eventPopup.tag = 1
        self.view.addSubview(eventPopup)
    }
    
    
}

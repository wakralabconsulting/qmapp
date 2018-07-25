//
//  EventViewController.swift
//  QatarMuseum
//
//  Created by Exalture on 07/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit
import EventKit
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
    var effect:UIVisualEffect!
    var eventPopup : EventPopupView = EventPopupView()
    var selectedDateForEvent : Date = Date()
    var fromHome : Bool = false
    var isLoadEventPage : Bool = false
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
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
        setUpUiContent()
        registerNib()
    }
    func registerNib() {
        let nib = UINib(nibName: "EventCellView", bundle: nil)
        eventCollectionView?.register(nib, forCellWithReuseIdentifier: "eventCellId")
    }
    func setUpUiContent() {
        headerView.headerViewDelegate = self
        

        headerView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        self.view.addGestureRecognizer(self.scopeGesture)
    self.eventCollectionView.panGestureRecognizer.require(toFail: self.scopeGesture)
        if (isLoadEventPage == true) {
            listTitleLabel.text = NSLocalizedString("CALENDAR_EVENT_TITLE", comment: "CALENDAR_EVENT_TITLE Label in the Event page")
            headerView.headerTitle.text = NSLocalizedString("CALENDAR_TITLE", comment: "CALENDAR_TITLE Label in the Event page")
            listTitleLabel.textColor = UIColor.eventlisBlue
            
           eventPopup.eventTitle.text = NSLocalizedString("EVENT_POPUP_TITLE", comment: "EVENT_POPUP_TITLE  in the popup view")
            eventPopup.eventDescription.text = NSLocalizedString("EVENT_MESSAGE_TITLE", comment: "EVENT_MESSAGE_TITLE  in the popup view")
            eventPopup.addToCalendarButton.titleLabel?.text = NSLocalizedString("POPUP_ADD_BUTTON_TITLE", comment: "POPUP_ADD_BUTTON_TITLE  in the popup view")
        }
        else {
            listTitleLabel.text = NSLocalizedString("EDUCATION_EVENT_TITLE", comment: "EDUCATION_EVENT_TITLE Label in the Event page")
            headerView.headerTitle.text = NSLocalizedString("EDUCATIONCALENDAR_TITILE", comment: "EDUCATIONCALENDAR_TITILE Label in the Event page")
            listTitleLabel.textColor = UIColor.blackColor
            headerView.settingsButton.isHidden = false
            
            eventPopup.eventTitle.text = NSLocalizedString("EDUCATION_EVENT_POPUP_TITLE", comment: "EVENT_POPUP_TITLE  in the popup view")
            eventPopup.eventDescription.text = NSLocalizedString("EDUCATION_POPUP_MESSAGE", comment: "EDUCATION_POPUP_MESSAGE  in the popup view")
            eventPopup.addToCalendarButton.titleLabel?.text = NSLocalizedString("EDUCATION_POPUP_BUTTON_TITLE", comment: "POPUP_ADD_BUTTON_TITLE  in the popup view")
            
        }
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            
            headerView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
            previousButton.setImage(UIImage(named: "previousImg"), for: .normal)
            nextButton.setImage(UIImage(named: "nextImg"), for: .normal)
            
            calendarView.locale = NSLocale.init(localeIdentifier: "en") as Locale
            
        
            calendarView.identifier = NSCalendar.Identifier.gregorian.rawValue
            calendarView.appearance.titleFont = UIFont.init(name: "DINNextLTPro-Bold", size: 19)
            calendarView.appearance.titleWeekendColor = UIColor.profilePink
            calendarView.appearance.titleTodayColor = UIColor.black
            calendarView.appearance.titleSelectionColor = UIColor.black
        }
        else {
           
            headerView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
            //For RTL
                    calendarView.locale = NSLocale.init(localeIdentifier: "fa-IR") as Locale
                    calendarView.identifier = NSCalendar.Identifier.persian.rawValue
            calendarView.setCurrentPage(Date(), animated: false)
            
     
            calendarView.appearance.titleFont = UIFont.init(name: "DINNextLTArabic-Bold", size: 19)
            calendarView.appearance.titleTodayColor = UIColor.black
            calendarView.appearance.titleSelectionColor = UIColor.black
            
            previousButton.setImage(UIImage(named: "nextImg"), for: .normal)
            nextButton.setImage(UIImage(named: "previousImg"), for: .normal)
            calendarView.appearance.titleWeekendColor = UIColor.profilePink
        }
        
       
        

        
    }
    //For RTL
    func minimumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "2016-07-08")!
    }
   
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : EventCollectionViewCell = eventCollectionView.dequeueReusableCell(withReuseIdentifier: "eventCellId", for: indexPath) as! EventCollectionViewCell
       
        if (indexPath.row % 2 == 0) {
            cell.cellBackgroundView?.backgroundColor = UIColor.eventCellAshColor
        }
        else {
            cell.cellBackgroundView.backgroundColor = UIColor.whiteColor
        }
        if (isLoadEventPage == true) {
            cell.setEventCellValues()
        }
        else {
            cell.setEducationCalendarValues()
        }
        
        return cell
    
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        loadEventPopup()
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
    func loadEventPopup() {
        eventPopup  = EventPopupView(frame: self.view.frame)
        eventPopup.eventPopupDelegate = self
        if (isLoadEventPage == true) {
            
            eventPopup.eventTitle.text = NSLocalizedString("EVENT_POPUP_TITLE", comment: "EVENT_POPUP_TITLE  in the popup view")
            eventPopup.eventDescription.text = NSLocalizedString("EVENT_MESSAGE_TITLE", comment: "EVENT_MESSAGE_TITLE  in the popup view")
            let buttonTitle = NSLocalizedString("POPUP_ADD_BUTTON_TITLE", comment: "POPUP_ADD_BUTTON_TITLE  in the popup view")
            eventPopup.addToCalendarButton.setTitle(buttonTitle, for: .normal)
        }
        else {
           
            eventPopup.eventTitle.text = NSLocalizedString("EDUCATION_EVENT_POPUP_TITLE", comment: "EVENT_POPUP_TITLE  in the popup view")
            eventPopup.eventDescription.text = NSLocalizedString("EDUCATION_POPUP_MESSAGE", comment: "EDUCATION_POPUP_MESSAGE  in the popup view")
            let buttonTitle = NSLocalizedString("EDUCATION_POPUP_BUTTON_TITLE", comment: "POPUP_ADD_BUTTON_TITLE  in the popup view")
            eventPopup.addToCalendarButton.setTitle(buttonTitle, for: .normal)
            
        }
        self.view.addSubview(eventPopup)
     
        
    }
  
    //MARK: Event popup delegate
    func eventCloseButtonPressed() {

            self.eventPopup.removeFromSuperview()
       
    }
    func addToCalendarButtonPressed() {
        self.addEventToCalendar(title: "QM Event", description: "Event", startDate: selectedDateForEvent, endDate: selectedDateForEvent)
        if (isLoadEventPage == true) {
            self.eventPopup.removeFromSuperview()
        }
        else {
            self.eventPopup.removeFromSuperview()
            popupView  = ComingSoonPopUp(frame: self.view.frame)
            popupView.comingSoonPopupDelegate = self
            popupView.loadEducationRegSuccessPopup()
            self.view.addSubview(popupView)
        }
        
    }
    func closeButtonPressed() {
        self.popupView.removeFromSuperview()
    }
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
       
        
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                   
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
      
        
    }
    func calendarCurrentMonthDidChange(_ calendar: FSCalendar) {
        
    }
  
    
    @IBAction func previoudDateSelected(_ sender: UIButton) {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
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
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
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
    
    
}

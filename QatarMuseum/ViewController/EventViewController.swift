//
//  EventViewController.swift
//  QatarMuseum
//
//  Created by Exalture on 07/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit
import EventKit
class EventViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, HeaderViewProtocol,FSCalendarDelegate,FSCalendarDataSource,UICollectionViewDelegateFlowLayout,EventPopUpProtocol,UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var eventCollectionView: UICollectionView!
    @IBOutlet weak var calendarView: FSCalendar!

    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var headerView: CommonHeaderView!
    @IBOutlet weak var calendarInnerView: UIView!
    var effect:UIVisualEffect!
    var eventPopup : EventPopupView = EventPopupView()
    var selectedDateForEvent : Date = Date()
    var fromHome : Bool = false
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
        headerView.headerTitle.text = "CALENDAR"
        headerView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
      //  headerView.headerBackButton.contentEdgeInsets = UIEdgeInsets(top: 24, left: 25, bottom: 25, right: 23)
        self.view.addGestureRecognizer(self.scopeGesture)
        self.eventCollectionView.panGestureRecognizer.require(toFail: self.scopeGesture)
        
       
        //calendarView.appearance.titleWeekendColor = UIColor.init(red: 236/255, green: 65/255, blue: 136/255, alpha: 1)

        //For RTL
//        calendarView.locale = NSLocale.init(localeIdentifier: "fa-IR") as Locale
//        calendarView.identifier = NSCalendar.Identifier.persian.rawValue
//        calendarView.firstWeekday = 7
    }
    //For RTL
//    func minimumDate(for calendar: FSCalendar) -> Date {
//        return self.formatter.date(from: "2016-07-08")!
//    }
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
            cell.cellBackgroundView?.backgroundColor = UIColor(red: 248/256, green: 248/256, blue: 248/256, alpha: 1)
        }
        else {
            cell.cellBackgroundView.backgroundColor = UIColor(red: 255/256, green: 255/256, blue: 255/256, alpha: 1)
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
    func loadEventPopup() {
        eventPopup  = EventPopupView(frame: self.view.frame)
        eventPopup.eventPopupDelegate = self
        
        self.view.addSubview(eventPopup)
     
        
    }
  
    //MARK: Event popup delegate
    func eventCloseButtonPressed() {

            self.eventPopup.removeFromSuperview()
       
    }
    func addToCalendarButtonPressed() {
        self.addEventToCalendar(title: "QM Event", description: "Event", startDate: selectedDateForEvent, endDate: selectedDateForEvent)
        self.eventPopup.removeFromSuperview()
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
                let alert = UIAlertController(title: "Access Denied", message: "This app doesn't have access to your Calender. Please allow it from Settings", preferredStyle: UIAlertControllerStyle.alert)
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
       
        print(date)
       
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
            
        }
        selectedDateForEvent = date
       //selected date got is less than one date. so add 1 to date for actual selected date
//        let dayComponenet = NSDateComponents()
//        dayComponenet.day = 1
//        selectedDateForEvent = Calendar.current.date(byAdding: .day, value: 1, to: date)!
//        print(selectedDateForEvent)
        
    }
    func calendarCurrentMonthDidChange(_ calendar: FSCalendar) {
        // Do something
       // print(calendar.dataSource)
        //print(calendar.currentPage)
    }
  
//    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//
//        let key = self.formatter.string(from: date)
//        print(key)
////        if (calendarView.) {
////            <#code#>
////        }
//
//
////        NSString *key = [self.dateFormatter1 stringFromDate:date];
////        if ([_borderSelectionColors.allKeys containsObject:key]) {
////            return yelloLayerColor;
////        }
//        return true
//    }
//    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//return true
//    }
    
    @IBAction func previoudDateSelected(_ sender: UIButton) {
        let _calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = -1 // For prev button
        calendarView.currentPage = _calendar.date(byAdding: dateComponents, to: calendarView.currentPage)!
       calendarView.setCurrentPage(calendarView.currentPage, animated: true)// calender is object of FSCalendar
    }
    
    @IBAction func nextDateSelected(_ sender: UIButton) {
        let _calendar = Calendar.current
        var dateComponents = DateComponents()
         dateComponents.month = 1 // For next button
        calendarView.currentPage = _calendar.date(byAdding: dateComponents, to: calendarView.currentPage)!
        calendarView.setCurrentPage(calendarView.currentPage, animated: true)// calender is object of FSCalendar
    }
    
    
}

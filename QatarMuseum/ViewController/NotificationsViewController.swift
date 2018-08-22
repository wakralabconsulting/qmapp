//
//  NotificationsViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 19/07/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,HeaderViewProtocol {
    @IBOutlet weak var notificationsTableView: UITableView!
    @IBOutlet weak var notificationsHeader: CommonHeaderView!
    @IBOutlet weak var loadingView: LoadingView!
    
    var fromHome : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    func setUI() {
        loadingView.isHidden = false
        loadingView.showLoading()
        notificationsHeader.headerTitle.text = NSLocalizedString("NOTIFICATIONS_TITLE", comment: "NOTIFICATIONS_TITLE in the Notification page")
        notificationsHeader.headerViewDelegate = self
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            notificationsHeader.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        } else {
            notificationsHeader.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
        emptyNotificationData()
    }
    
    func emptyNotificationData() {
        self.loadingView.stopLoading()
        self.loadingView.noDataView.isHidden = false
        self.loadingView.isHidden = false
        self.loadingView.showYetNoNotificationDataView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightValue = UIScreen.main.bounds.height/100
        return heightValue*12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCellId", for: indexPath) as! NotificationsTableViewCell
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            cell.detailArrowButton.setImage(UIImage(named: "nextImg"), for: .normal)
        } else {
            cell.detailArrowButton.setImage(UIImage(named: "previousImg"), for: .normal)
        }
        if (indexPath.row % 2 == 0) {
            cell.innerView.backgroundColor = UIColor.notificationCellAsh
        } else {
            cell.innerView.backgroundColor = UIColor.white
        }
        cell.notificationDetailSelection = {
            () in
            self.loadNotificationDetail(cellObj: cell)
        }
        return cell
    }
    
    func loadNotificationDetail(cellObj: NotificationsTableViewCell) {
       
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

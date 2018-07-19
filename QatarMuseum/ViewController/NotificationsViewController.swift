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
    var fromHome : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }

    func setUI() {
        notificationsHeader.headerTitle.text = "NOTIFICATIONS"
        notificationsHeader.headerViewDelegate = self
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightValue = UIScreen.main.bounds.height/100
        return heightValue*12
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCellId", for: indexPath) as! NotificationsTableViewCell
        if (indexPath.row % 2 == 0) {
            cell.innerView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        }
        else {
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

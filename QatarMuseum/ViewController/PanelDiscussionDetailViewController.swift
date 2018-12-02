//
//  PanelDiscussionDetailViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 01/12/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import UIKit
enum NMoQPanelPage {
    case PanelDetailPage
    case TourDetailPage
}
class PanelDiscussionDetailViewController: UIViewController,LoadingViewProtocol,UITableViewDelegate,UITableViewDataSource,HeaderViewProtocol,DeclinePopupProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var headerView: CommonHeaderView!
    var panelTitle : String? = ""
    var pageNameString : NMoQPanelPage?
    
    var acceptDeclinePopupView : AcceptDeclinePopup = AcceptDeclinePopup()

    
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
        
    }
    func registerCell() {
        self.tableView.register(UINib(nibName: "PanelDetailView", bundle: nil), forCellReuseIdentifier: "panelCellID")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(pageNameString == NMoQPanelPage.PanelDetailPage) {
            return 1
        } else {
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        loadingView.stopLoading()
        loadingView.isHidden = true
        let cell = tableView.dequeueReusableCell(withIdentifier: "panelCellID", for: indexPath) as! PanelDetailCell
        cell.selectionStyle = .none
        if(pageNameString == NMoQPanelPage.PanelDetailPage) {
            cell.setPanelDetailCellContent(titleName: panelTitle)
            cell.detailSpecialEvent = self
            
            cell.interestSwitch.addTarget(self, action: #selector(self.registerSwitchClicked), for: .valueChanged)


        } else if (pageNameString == NMoQPanelPage.TourDetailPage){
            cell.setTourSecondDetailCellContent(titleName: panelTitle)
            cell.detailSpecialEvent = self
            cell.interestSwitch.addTarget(self, action: #selector(self.registerSwitchClicked), for: .valueChanged)

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
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func registerSwitchClicked(_ mySwitch: UISwitch) {
        
        if (mySwitch.isOn) {
            mySwitch.onTintColor = UIColor.red
//            loadConfirmationPopup()
        }
        else { // for accept
            //            accepetDeclineSwitch.tintColor = offColor
            //            accepetDeclineSwitch.layer.cornerRadius = 16
            //            accepetDeclineSwitch.backgroundColor = offColor
//            acceptNowButtonPressed()
            loadConfirmationPopup()
        }
        
    }
    
    func loadConfirmationPopup() {
        acceptDeclinePopupView  = AcceptDeclinePopup(frame: self.view.frame)
        acceptDeclinePopupView.popupViewHeight.constant = 270
        acceptDeclinePopupView.showRegisterUnregisterMessage()
        acceptDeclinePopupView.declinePopupDelegate = self
        self.view.addSubview(acceptDeclinePopupView)
    }
    
    func declinePopupCloseButtonPressed() {
            self.acceptDeclinePopupView.removeFromSuperview()
    }
    
    func yesButtonPressed() {
//        accepetDeclineSwitch.onTintColor = UIColor.red
//        accepetDeclineSwitch.isOn = true
//        updateRSVPUser(statusValue: "0")
        self.acceptDeclinePopupView.removeFromSuperview()
    }
    
    func noButtonPressed() {
        self.acceptDeclinePopupView.removeFromSuperview()
//        let offColor = UIColor.settingsSwitchOnTint
//        accepetDeclineSwitch.tintColor = offColor
//        accepetDeclineSwitch.layer.cornerRadius = 16
//        accepetDeclineSwitch.backgroundColor = offColor
//        accepetDeclineSwitch.isOn = false
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

   

}

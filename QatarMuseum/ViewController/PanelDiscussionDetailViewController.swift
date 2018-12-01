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
class PanelDiscussionDetailViewController: UIViewController,LoadingViewProtocol,UITableViewDelegate,UITableViewDataSource,HeaderViewProtocol {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var headerView: CommonHeaderView!
    var panelTitle : String? = ""
    var pageNameString : NMoQPanelPage?
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
        
        if(pageNameString == NMoQPanelPage.PanelDetailPage) {
            headerView.headerBackButton.setImage(UIImage(named: "closeX1"), for: .normal)
            headerView.headerBackButton.contentEdgeInsets = UIEdgeInsets(top:12, left:17, bottom: 12, right:17)
        } else {
            
        }
        
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
            
        } else if (pageNameString == NMoQPanelPage.TourDetailPage){
            cell.setTourSecondDetailCellContent(titleName: panelTitle)
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

//
//  NMoQTourViewController.swift
//  QatarMuseums
//
//  Created by Developer on 30/11/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import Crashlytics
import UIKit
enum NMoQTourPage {
    case Tour
    case PanelDetailPage
}
class NMoQTourViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,HeaderViewProtocol,LoadingViewProtocol {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var headerView: CommonHeaderView!
    
    var tourTitle : String! = ""
    var tourListmageArray: [String]! = ["art_culture_1.png", "sports_2.png"]
    //    let networkReachability = NetworkReachabilityManager()
    var tourDesc: String = ""
    var pageNameString : NMoQTourPage?
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupUI()
    }
    
    func setupUI() {
        loadingView.isHidden = false
        loadingView.showLoading()
        loadingView.loadingViewDelegate = self
        headerView.headerViewDelegate = self
        
        if(pageNameString == NMoQTourPage.Tour) {
            tourDesc = NSLocalizedString("NMoQ_TOUR_DESC", comment: "NMoQ_TOUR_DESC in the NMoQ Tour page")
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                headerView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
            } else {
                headerView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
            }
        } else {
            headerView.headerBackButton.setImage(UIImage(named: "closeX1"), for: .normal)
            headerView.headerBackButton.contentEdgeInsets = UIEdgeInsets(top:12, left:17, bottom: 12, right:17)
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func registerCell() {
        self.tableView.register(UINib(nibName: "NMoQListCell", bundle: nil), forCellReuseIdentifier: "nMoQListCellId")
        self.tableView.register(UINib(nibName: "NMoQTourDescriptionCell", bundle: nil), forCellReuseIdentifier: "nMoQTourDescriptionCellId")
        self.tableView.register(UINib(nibName: "PanelDetailView", bundle: nil), forCellReuseIdentifier: "panelCellID")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(pageNameString == NMoQTourPage.Tour) {
            return tourListmageArray.count + 1
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        loadingView.stopLoading()
        loadingView.isHidden = true
        if(pageNameString == NMoQTourPage.Tour) {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "nMoQTourDescriptionCellId", for: indexPath) as! NMoQTourDescriptionCell
                cell.titleLabel.text = tourTitle
                cell.descriptionLabel.text = tourDesc
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "nMoQListCellId", for: indexPath) as! NMoQListCell
                cell.cellImageView.image = UIImage(named: tourListmageArray[indexPath.row - 1])
                cell.dateLabel.text = ""
                if (indexPath.row == 1) {
                    cell.titleLabel.text = "Day Tour"
                    cell.dayLabel.text = "8 AM - 11 AM"
                } else {
                    cell.titleLabel.text = "Evening Tour"
                    cell.dayLabel.text = "6 PM - 10 PM"
                }
                
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "panelCellID", for: indexPath) as! PanelDetailCell
            cell.selectionStyle = .none
            cell.setPanelDetailCellContent(titleName: tourTitle)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(pageNameString == NMoQTourPage.Tour) {
            if indexPath.row == 0 {
                return 260.0
            }
            let heightValue = UIScreen.main.bounds.height/100
            return heightValue*27
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
        // Dispose of any resources that can be recreated.
    }
    
}

//
//  NMoQTourViewController.swift
//  QatarMuseums
//
//  Created by Developer on 30/11/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import Alamofire
import Crashlytics
import UIKit

class NMoQTourViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,HeaderViewProtocol,LoadingViewProtocol {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var headerView: CommonHeaderView!
    
    var tourTitle : String! = ""
    var tourListmageArray: [String]! = ["art_culture_1.png", "sports_2.png"]
    //    let networkReachability = NetworkReachabilityManager()
    var tourDesc: String = ""
    var tourName : [String]? = ["Day Tour", "Evening Tour"]
    var tourDetailId : String? = nil
    var nmoqTourDetail: [NMoQTourDetail]! = []

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupUI()
    }
    
    func setupUI() {
        loadingView.isHidden = false
        loadingView.showLoading()
        getNMoQTourDetail()
        loadingView.loadingViewDelegate = self
        headerView.headerViewDelegate = self
        
        
            tourDesc = NSLocalizedString("NMoQ_TOUR_DESC", comment: "NMoQ_TOUR_DESC in the NMoQ Tour page")
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                headerView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
            } else {
                headerView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
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
            //return tourListmageArray.count + 1
        //return tourListmageArray.count
        return nmoqTourDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        loadingView.stopLoading()
        loadingView.isHidden = true
//            if indexPath.row == 0 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "nMoQTourDescriptionCellId", for: indexPath) as! NMoQTourDescriptionCell
//                cell.titleLabel.text = tourTitle
//                cell.descriptionLabel.text = tourDesc
//                cell.selectionStyle = .none
//                return cell
//            } else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "nMoQListCellId", for: indexPath) as! NMoQListCell
//                cell.cellImageView.image = UIImage(named: tourListmageArray[indexPath.row - 1])
//                cell.dateLabel.text = ""
//                if (indexPath.row == 1) {
//                    cell.titleLabel.text = tourName?[indexPath.row-1]
//                    cell.dayLabel.text = "8 AM - 11 AM"
//                } else {
//                    cell.titleLabel.text = tourName?[indexPath.row-1]
//                    cell.dayLabel.text = "6 PM - 10 PM"
//                }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "nMoQListCellId", for: indexPath) as! NMoQListCell
        cell.setTourMiddleDate(tourList: nmoqTourDetail[indexPath.row])
//        cell.cellImageView.image = UIImage(named: tourListmageArray[indexPath.row])
//        cell.dateLabel.text = ""
//        if (indexPath.row == 0) {
//            cell.titleLabel.text = tourName?[indexPath.row]
//            cell.dayLabel.text = "8 AM - 11 AM"
//        } else {
//            cell.titleLabel.text = tourName?[indexPath.row]
//            cell.dayLabel.text = "6 PM - 10 PM"
//        }
        
                return cell
          //  }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // if indexPath.row != 0 {
//            loadTourSecondDetailPage(selectedCellTitle: tourName![indexPath.row-1])
        loadTourSecondDetailPage(selectedRow: indexPath.row)

        //}
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            if indexPath.row == 0 {
//                //return 260.0
//                return 0
//            }
            let heightValue = UIScreen.main.bounds.height/100
            return heightValue*27
    }
    func loadTourSecondDetailPage(selectedRow: Int?) {
        let panelView =  self.storyboard?.instantiateViewController(withIdentifier: "paneldetailViewId") as! PanelDiscussionDetailViewController
        panelView.nmoqTourDetail = nmoqTourDetail
        panelView.selectedRow = selectedRow
        panelView.pageNameString = NMoQPanelPage.TourDetailPage
        panelView.panelDetailId = tourDetailId
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(panelView, animated: false, completion: nil)
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
    //MARK: ServiceCall
    func getNMoQTourDetail() {
        if(tourDetailId != nil) {
            _ = Alamofire.request(QatarMuseumRouter.GetNMoQTourDetail(["event_id" : tourDetailId!])).responseObject { (response: DataResponse<NMoQTourDetailList>) -> Void in
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

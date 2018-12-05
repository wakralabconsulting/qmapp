//
//  TourAndPanelListViewController.swift
//  QatarMuseums
//
//  Created by Developer on 28/11/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import Alamofire
import Crashlytics
import UIKit

enum NMoQPageName {
    case Tours
    case PanelDiscussion
}

class TourAndPanelListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,HeaderViewProtocol,LoadingViewProtocol {
    @IBOutlet weak var collectionTableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var headerView: CommonHeaderView!
    
    var pageNameString : NMoQPageName?
    let networkReachability = NetworkReachabilityManager()
    var imageArray: [String] = []
    var titleArray: [String] = []
    var nmoqTourList: [NMoQTour]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupUI()
        collectionTableView.delegate = self
        collectionTableView.dataSource = self
    }
    
    func setupUI() {
        loadingView.isHidden = false
        loadingView.showLoading()
        loadingView.loadingViewDelegate = self
        headerView.headerViewDelegate = self
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            headerView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        } else {
            headerView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
        if (pageNameString == NMoQPageName.Tours) {
            //imageArray = tourImageArray
            //titleArray = tourNameArray
            headerView.headerTitle.text = NSLocalizedString("TOUR_TITLE", comment: "TOUR_TITLE in the NMoQ page")
            getNMoQTourList()
        } else if (pageNameString == NMoQPageName.PanelDiscussion) {
            headerView.headerTitle.text = NSLocalizedString("PANEL_DISCUSSION", comment: "PANEL_DISCUSSION in the NMoQ page").uppercased()
            getNMoQSpecialEventList()
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func registerCell() {
        self.collectionTableView.register(UINib(nibName: "NMoQListCell", bundle: nil), forCellReuseIdentifier: "nMoQListCellId")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return nmoqTourList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nMoQListCellId", for: indexPath) as! NMoQListCell
        cell.setTourListDate(tourList: nmoqTourList[indexPath.row])
        loadingView.stopLoading()
        loadingView.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightValue = UIScreen.main.bounds.height/100
        return heightValue*27
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (pageNameString == NMoQPageName.Tours) {
            loadTourViewPage(selectedCellTitle: nmoqTourList[indexPath.row].title!)
        } else if (pageNameString == NMoQPageName.PanelDiscussion) {
            loadPanelDiscussionDetailPage(selectedRow: indexPath.row)
        }
    }
    
    func loadTourViewPage(selectedCellTitle: String) {
        let tourView =  self.storyboard?.instantiateViewController(withIdentifier: "nMoQTourId") as! NMoQTourViewController
        tourView.tourTitle = selectedCellTitle
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(tourView, animated: false, completion: nil)
    }
    func loadPanelDiscussionDetailPage(selectedRow: Int?) {
        let panelView =  self.storyboard?.instantiateViewController(withIdentifier: "paneldetailViewId") as! PanelDiscussionDetailViewController
        panelView.pageNameString = NMoQPanelPage.PanelDetailPage
        panelView.panelDetailId = nmoqTourList[selectedRow!].nid
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
    //MARK: Service call
    func getNMoQTourList() {
        _ = Alamofire.request(QatarMuseumRouter.GetNMoQTourList()).responseObject { (response: DataResponse<NMoQTourList>) -> Void in
            switch response.result {
            case .success(let data):
                self.nmoqTourList = data.nmoqTourList
                
                
                //self.saveOrUpdateHomeCoredata()
                self.collectionTableView.reloadData()
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
    func getNMoQSpecialEventList() {
        _ = Alamofire.request(QatarMuseumRouter.GetNMoQSpecialEventList()).responseObject { (response: DataResponse<NMoQTourList>) -> Void in
            switch response.result {
            case .success(let data):
                self.nmoqTourList = data.nmoqTourList
                //self.saveOrUpdateHomeCoredata()
                self.collectionTableView.reloadData()
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


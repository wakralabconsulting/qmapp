//
//  TourAndPanelListViewController.swift
//  QatarMuseums
//
//  Created by Developer on 28/11/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

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
    var tourImageArray: [String]! = ["art_culture_1.png", "sports_2.png", "architecture_03.png", "fashion_4.png", "nature_5.png"]
    var tourNameArray: [String]! = ["Art & Culture", "Sports", "Architecture", "Fashion", "Nature"]
    
    var panelImageArray: [String]! = ["panel_discussion-1.png", "panel_discussion-2.png", "panel_discussion-3.png", "panel_discussion-4.png", "panel_discussion-5.png"]
    var panelNameArray: [String]! = ["Qatari Songs", "Artist Encounters", "QatART Art & Craft", "Join Art & Calligraphy", "Marbling Art"]
//    let networkReachability = NetworkReachabilityManager()
    var imageArray: [String] = []
    var titleArray: [String] = []

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
            imageArray = tourImageArray
            titleArray = tourNameArray
            headerView.headerTitle.text = NSLocalizedString("TOUR_TITLE", comment: "TOUR_TITLE in the NMoQ page")
        } else if (pageNameString == NMoQPageName.PanelDiscussion) {
            imageArray = panelImageArray
            titleArray = panelNameArray
            headerView.headerTitle.text = NSLocalizedString("PANEL_DISCUSSION_TITLE", comment: "PANEL_DISCUSSION_TITLE in the NMoQ page")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func registerCell() {
        self.collectionTableView.register(UINib(nibName: "NMoQListCell", bundle: nil), forCellReuseIdentifier: "nMoQListCellId")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nMoQListCellId", for: indexPath) as! NMoQListCell
        cell.cellImageView.image = UIImage(named: imageArray[indexPath.row])
        cell.titleLabel.text = titleArray[indexPath.row]
        cell.dayLabel.text = "DAY " + String(format: "%02d", indexPath.row + 1)
        cell.dateLabel.text = "28 MARCH 2018"
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
            loadTourViewPage(selectedCellTitle: titleArray[indexPath.row])
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


//
//  PanelDiscussionDetailViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 01/12/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import Alamofire
import MapKit
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
    var panelDetailId : String? = nil
    var nmoqSpecialEventDetail: [NMoQTour]! = []
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
        if (pageNameString == NMoQPanelPage.PanelDetailPage) {
            getNMoQSpecialEventDetail()
        }
        
    }
    func registerCell() {
        self.tableView.register(UINib(nibName: "PanelDetailView", bundle: nil), forCellReuseIdentifier: "panelCellID")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(pageNameString == NMoQPanelPage.PanelDetailPage) {
            return nmoqSpecialEventDetail.count
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
            cell.setPanelDetailCellContent(panelDetailData: nmoqSpecialEventDetail[indexPath.row])
            cell.loadMapView = {
                () in
                if (self.nmoqSpecialEventDetail[indexPath.row].mobileLatitude != nil && self.nmoqSpecialEventDetail[indexPath.row].mobileLatitude != "" && self.nmoqSpecialEventDetail[indexPath.row].longitude != nil && self.nmoqSpecialEventDetail[indexPath.row].longitude != "") {
                    let latitudeString = (self.nmoqSpecialEventDetail[indexPath.row].mobileLatitude)!
                    let longitudeString = (self.nmoqSpecialEventDetail[indexPath.row].longitude)!
                    var latitude : Double?
                    var longitude : Double?
                    if let lat : Double = Double(latitudeString) {
                        latitude = lat
                    }
                    if let long : Double = Double(longitudeString) {
                        longitude = long
                    }
                    
                    let destinationLocation = CLLocationCoordinate2D(latitude: latitude!,
                                                                     longitude: longitude!)
                    let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
                    let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
                    self.loadLocationMap(currentRow: indexPath.row, destination: destinationMapItem)
                }
            }
            
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
    func loadLocationMap(currentRow: Int, destination: MKMapItem) {
        let detailStoryboard: UIStoryboard = UIStoryboard(name: "DetailPageStoryboard", bundle: nil)
        
        let mapDetailView = detailStoryboard.instantiateViewController(withIdentifier: "mapViewId") as! MapViewController
        mapDetailView.latitudeString = nmoqSpecialEventDetail[currentRow].mobileLatitude
        mapDetailView.latitudeString = nmoqSpecialEventDetail[currentRow].longitude
        mapDetailView.destination = destination
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(mapDetailView, animated: false, completion: nil)
        
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
    func getNMoQSpecialEventDetail() {
        if(panelDetailId != nil) {
            _ = Alamofire.request(QatarMuseumRouter.GetNMoQSpecialEventDetail(["event_id" : panelDetailId!])).responseObject { (response: DataResponse<NMoQTourList>) -> Void in
                switch response.result {
                case .success(let data):
                    self.nmoqSpecialEventDetail = data.nmoqTourList
                    //self.saveOrUpdateHomeCoredata()
                    self.tableView.reloadData()
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
    }
    

   

}

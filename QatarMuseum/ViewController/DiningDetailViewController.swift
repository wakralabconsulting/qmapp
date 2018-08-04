//
//  DiningDetailViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 29/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Alamofire
import UIKit

class DiningDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var diningTableView: UITableView!
    
    @IBOutlet weak var loadingView: LoadingView!
    let imageView = UIImageView()
    let closeButton = UIButton()
    var blurView = UIVisualEffectView()
    var diningDetailtArray: [DiningDetail] = []
    var diningDetailId : String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUIContents()
        getDiningDetailsFromServer()
        setTopBarImage()
        
    }
    func setupUIContents() {
        loadingView.isHidden = false
        loadingView.showLoading()
    }
    func setTopBarImage() {
        diningTableView.estimatedRowHeight = 50
        diningTableView.contentInset = UIEdgeInsetsMake(300, 0, 0, 0)
        
        imageView.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: 300)
        if diningDetailtArray.count != 0 {
            if let imageUrl = diningDetailtArray[0].image{
                imageView.kf.setImage(with: URL(string: imageUrl))
            }
        }
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.light)
        blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = imageView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0
        imageView.addSubview(blurView)
        
        
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            closeButton.frame = CGRect(x: 10, y: 30, width: 40, height: 40)
        }
        else {
            closeButton.frame = CGRect(x: self.view.frame.width-50, y: 30, width: 40, height: 40)
        }
        closeButton.setImage(UIImage(named: "closeX1"), for: .normal)
        closeButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom:12, right: 12)
        
        closeButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeTouchDownAction), for: .touchDown)
        view.addSubview(closeButton)
    }
    //MARK: TableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return diningDetailtArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let diningCell = tableView.dequeueReusableCell(withIdentifier: "diningDetailCellId", for: indexPath) as! DiningDetailTableViewCell
        diningCell.titleLineView.isHidden = true
        diningCell.setDiningDetailValues(diningDetail: diningDetailtArray[indexPath.row])
        diningCell.locationButtonAction = {
            ()in
            self.loadLocationOnMap()
        }
        diningCell.favBtnTapAction = {
            () in
            self.setFavouritesAction(cellObj: diningCell)
        }
        diningCell.shareBtnTapAction = {
            () in
            self.setShareAction(cellObj: diningCell)
        }
        loadingView.stopLoading()
        loadingView.isHidden = true
        return diningCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func setFavouritesAction(cellObj :DiningDetailTableViewCell) {
        if (cellObj.favoriteButton.tag == 0) {
            cellObj.favoriteButton.tag = 1
            cellObj.favoriteButton.setImage(UIImage(named: "heart_fillX1"), for: .normal)
            
        }
        else {
            cellObj.favoriteButton.tag = 0
            cellObj.favoriteButton.setImage(UIImage(named: "heart_emptyX1"), for: .normal)
        }
    }
    func setShareAction(cellObj :DiningDetailTableViewCell) {
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 300 - (scrollView.contentOffset.y + 300)
        let height = min(max(y, 60), 400)
        imageView.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: height)
        
        
        if (imageView.frame.height >= 300 ){
            blurView.alpha  = 0.0
            
        }
        else if (imageView.frame.height >= 250 ){
            blurView.alpha  = 0.2
            
        }
        else if (imageView.frame.height >= 200 ){
            blurView.alpha  = 0.4
            
        }
        else if (imageView.frame.height >= 150 ){
            blurView.alpha  = 0.6
            
        }
        else if (imageView.frame.height >= 100 ){
            blurView.alpha  = 0.8
            
        }
        else if (imageView.frame.height >= 50 ){
            blurView.alpha  = 0.9
            
        }
        
    }
    func loadLocationOnMap() {
        let latitude = "10.0119266"
        let longitude =  "76.3492956"
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)")!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(URL(string:"comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)")!)
            }
        } else {
            let locationUrl = URL(string: "https://maps.google.com/?q=@\(latitude),\(longitude)")!
//            let webViewVc:WebViewController = self.storyboard?.instantiateViewController(withIdentifier: "webViewId") as! WebViewController
//            webViewVc.webViewUrl = locationUrl
//            webViewVc.titleString = NSLocalizedString("WEBVIEW_TITLE", comment: "WEBVIEW_TITLE title Label in the webview page")
//            self.present(webViewVc, animated: false, completion: nil)
            UIApplication.shared.openURL(locationUrl)
        }
    }
    @objc func buttonAction(sender: UIButton!) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
        
    }
    @objc func closeTouchDownAction(sender: UIButton!) {
        sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK: WebServiceCall
    func getDiningDetailsFromServer()
    {
        _ = Alamofire.request(QatarMuseumRouter.GetDiningDetail(["nid": diningDetailId!])).responseObject { (response: DataResponse<DiningDetails>) -> Void in
            switch response.result {
            case .success(let data):
                self.diningDetailtArray = data.diningDetail!
                self.setTopBarImage()
                self.diningTableView.reloadData()
                self.loadingView.stopLoading()
                self.loadingView.isHidden = true
                if (self.diningDetailtArray.count == 0) {
                    self.loadingView.stopLoading()
                    self.loadingView.noDataView.isHidden = false
                    self.loadingView.isHidden = false
                    self.loadingView.showNoDataView()
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}

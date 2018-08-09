//
//  ExhibitionDetailViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 12/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit
import Alamofire

class ExhibitionDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var exhibitionDetailTableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    
    let imageView = UIImageView()
    let closeButton = UIButton()
    var blurView = UIVisualEffectView()
    var fromHome : Bool = false
    var id : String!
    var exhibition: Exhibition!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUi()
        if (fromHome == true) {
            getExhibitionDetail()
        }
    }
    
    func setUi() {
        loadingView.isHidden = false
        loadingView.showLoading()
        setTopImageUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (fromHome == true) {
            if exhibition != nil {
                return 1
            }
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exhibitionDetailCellId", for: indexPath) as! ExhibitionDetailTableViewCell
        cell.descriptionLabel.textAlignment = .center
        if (fromHome == true) {
            if exhibition != nil {
                cell.setHomeExhibitionDetail(exhibition: exhibition)
            }
        } else {
            cell.setMuseumExhibitionDetail()
        }
        cell.favBtnTapAction = {
            () in
            self.setFavouritesAction(cellObj: cell)
        }
        cell.shareBtnTapAction = {
            () in
            self.setShareAction(cellObj: cell)
        }
        cell.locationButtonAction = {
            () in
            if self.exhibition != nil && self.exhibition.latitude != nil &&
                self.exhibition.longitude != nil && self.exhibition.latitude?.range(of:"0°") == nil
                && self.exhibition.longitude?.range(of:"0°") == nil {
                self.loadLocationInMap(latitude: self.exhibition.latitude!, longitude: self.exhibition.longitude!)
            } else {
                self.loadLocationInMap(latitude: "10.0119266", longitude: "76.3492956")
            }
        }
        
        loadingView.stopLoading()
        loadingView.isHidden = true
        return cell
    }
    
    func setFavouritesAction(cellObj :ExhibitionDetailTableViewCell) {
        //cellObj.favoriteButton.setImage(UIImage(named: "heart_emptyX1"), for: .normal)
    }
    
    func setShareAction(cellObj :ExhibitionDetailTableViewCell) {
       
    }
    
    func setTopImageUI() {
        exhibitionDetailTableView.estimatedRowHeight = 50
        exhibitionDetailTableView.contentInset = UIEdgeInsetsMake(300, 0, 0, 0)
        
        imageView.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: 300)
        if (fromHome == true) {
            if exhibition != nil, let imageUrl = exhibition.image {
                imageView.kf.setImage(with: URL(string: imageUrl))
            } else {
                imageView.image = UIImage.init(named: "exhibition_detail")
            }
        } else {
            imageView.image = UIImage.init(named: "powder_and_damask")
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
        } else {
            closeButton.frame = CGRect(x: self.view.frame.width-50, y: 30, width: 40, height: 40)
        }
        closeButton.setImage(UIImage(named: "closeX1"), for: .normal)
        closeButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom:12, right: 12)
        
        closeButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTouchDownAction), for: .touchDown)
        
        closeButton.layer.shadowColor = UIColor.black.cgColor
        closeButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        closeButton.layer.shadowRadius = 5
        closeButton.layer.shadowOpacity = 1.0
        view.addSubview(closeButton)
    }
    
    func loadLocationInMap(latitude: String, longitude: String) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)")!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(URL(string:"comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)")!)
            }
        } else {
            let locationUrl = URL(string: "https://maps.google.com/?q=@\(latitude),\(longitude)")!
            UIApplication.shared.openURL(locationUrl)
        }
    }
    
    func getExhibitionDetail() {
        _ = Alamofire.request(QatarMuseumRouter.ExhibitionDetail(id)).responseObject { (response: DataResponse<Exhibitions>) -> Void in
            switch response.result {
            case .success(let data):
                if data.exhibitions!.count > 0 {
                    self.exhibition = data.exhibitions![0]
                    self.setTopImageUI()
                    self.exhibitionDetailTableView.reloadData()
                    self.loadingView.stopLoading()
                    self.loadingView.isHidden = true
                } else {
                    self.loadingView.stopLoading()
                    self.loadingView.noDataView.isHidden = false
                    self.loadingView.isHidden = false
                    self.loadingView.showNoDataView()
                }
            case .failure( _):
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 300 - (scrollView.contentOffset.y + 300)
        let height = min(max(y, 60), 400)
        imageView.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: height)

        if (imageView.frame.height >= 300 ){
            blurView.alpha  = 0.0
        } else if (imageView.frame.height >= 250 ){
            blurView.alpha  = 0.2
        } else if (imageView.frame.height >= 200 ){
            blurView.alpha  = 0.4
        } else if (imageView.frame.height >= 150 ){
            blurView.alpha  = 0.6
        } else if (imageView.frame.height >= 100 ){
            blurView.alpha  = 0.8
        } else if (imageView.frame.height >= 50 ){
            blurView.alpha  = 0.9
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
            dismiss(animated: false, completion: nil)
    }
    
    @objc func closeButtonTouchDownAction(sender: UIButton!) {
        sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

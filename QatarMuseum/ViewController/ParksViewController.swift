//
//  ParksViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 22/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit


class ParksViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var parksTableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    let imageView = UIImageView()
    let closeButton = UIButton()
    var blurView = UIVisualEffectView()
    var parksListArray: NSArray!
    var parkImageArray = NSArray()
    var collectionListArray: NSArray!
    var collectionImageArray = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIContents()
        getParksDataFromJson()
        registerCell()
    }
    func setupUIContents() {
        loadingView.isHidden = false
        loadingView.showLoading()
        parksTableView.estimatedRowHeight = 50
        parksTableView.contentInset = UIEdgeInsetsMake(300, 0, 0, 0)
        
        imageView.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: 300)
        
        imageView.image = UIImage.init(named: "mia_park")
        
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
        
        parkImageArray = ["mia_park","park_cafe","family_play"];
        collectionImageArray = ["mia_park","park_cafe","family_play"];
    }
    //MARK: Service call
    func getParksDataFromJson(){
        let url = Bundle.main.url(forResource: "ParksJson", withExtension: "json")
        
        let dataObject = NSData(contentsOf: url!)
        if let jsonObj = try? JSONSerialization.jsonObject(with: dataObject! as Data, options: .allowFragments) as? NSDictionary {
            
            parksListArray = jsonObj!.value(forKey: "items")
                as! NSArray
        }
    }
    //MARK: Service call
    func getCollectionDetailDataFromJson(){
        let url = Bundle.main.url(forResource: "CollectionDetailJson", withExtension: "json")
        
        let dataObject = NSData(contentsOf: url!)
        if let jsonObj = try? JSONSerialization.jsonObject(with: dataObject! as Data, options: .allowFragments) as? NSDictionary {
            
            collectionListArray = jsonObj!.value(forKey: "items")
                as! NSArray
        }
    }
    func registerCell() {
        self.parksTableView.register(UINib(nibName: "ParkTableCellXib", bundle: nil), forCellReuseIdentifier: "parkCellId")
        self.parksTableView.register(UINib(nibName: "CollectionDetailView", bundle: nil), forCellReuseIdentifier: "collectionCellId")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK: TableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return parksListArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let parkCell = tableView.dequeueReusableCell(withIdentifier: "parkCellId", for: indexPath) as! ParkTableViewCell
            if (indexPath.row != 0) {
                parkCell.titleLineView.isHidden = true
                parkCell.imageViewHeight.constant = 200
                
            }
            else {
                parkCell.titleLineView.isHidden = false
                parkCell.imageViewHeight.constant = 0
            }
            if(indexPath.row == parksListArray.count-1) {
                parkCell.favouriteViewHeight.constant = 130
                parkCell.favouriteView.isHidden = false
                parkCell.shareView.isHidden = false
                parkCell.favouriteButton.isHidden = false
                parkCell.shareButton.isHidden = false
            }
            else {
                parkCell.favouriteViewHeight.constant = 0
                parkCell.favouriteView.isHidden = true
                parkCell.shareView.isHidden = true
                parkCell.favouriteButton.isHidden = true
                parkCell.shareButton.isHidden = true
            }
        parkCell.favouriteButtonAction = {
            ()in
            self.setFavouritesAction(cellObj: parkCell)
        }
        parkCell.shareButtonAction = {
            () in
        }
        parkCell.locationButtonTapAction = {
            () in
            self.loadLocationInMap()
        }
            let parkDataDict = parksListArray.object(at: indexPath.row) as! NSDictionary
        
            parkCell.setParksCellValues(cellValues: parkDataDict, imageName:parkImageArray.object(at: indexPath.row) as! String )
            loadingView.stopLoading()
            loadingView.isHidden = true
            return parkCell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func setFavouritesAction(cellObj :ParkTableViewCell) {
        if (cellObj.favouriteButton.tag == 0) {
            cellObj.favouriteButton.tag = 1
            cellObj.favouriteButton.setImage(UIImage(named: "heart_fillX1"), for: .normal)
            
        }
        else {
            cellObj.favouriteButton.tag = 0
            cellObj.favouriteButton.setImage(UIImage(named: "heart_emptyX1"), for: .normal)
        }
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
    func loadLocationInMap() {
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
            UIApplication.shared.openURL(locationUrl)
        }
    }
    @objc func buttonAction(sender: UIButton!) {
        sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
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
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 

}

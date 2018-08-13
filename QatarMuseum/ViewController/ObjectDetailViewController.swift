//
//  ObjectDetailViewController.swift
//  QatarMuseums
//
//  Created by Developer on 13/08/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class ObjectDetailViewController: UIViewController, HeaderViewProtocol, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var headerView: CommonHeaderView!
    @IBOutlet weak var objectTableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    
    let imageView = UIImageView()
    var blurView = UIVisualEffectView()
    let backButton = UIButton()
//    var objectDetail = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupUIContents()
        setTopBarImage()
    }
    
    func setupUI() {
        headerView.headerViewDelegate = self
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            headerView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        } else {
            headerView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
    }
    
    func setupUIContents() {
        loadingView.isHidden = false
        loadingView.showLoading()
    }
    
    func setTopBarImage() {
        objectTableView.estimatedRowHeight = 50
        objectTableView.contentInset = UIEdgeInsetsMake(300, 0, 0, 0)
        
        imageView.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: 300)
        imageView.image = UIImage.init(named: "science_tour_object")
        
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
            backButton.frame = CGRect(x: 10, y: 30, width: 40, height: 40)
            backButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        } else {
            backButton.frame = CGRect(x: self.view.frame.width-50, y: 30, width: 40, height: 40)
            backButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
//        closeButton.setImage(UIImage(named: "closeX1"), for: .normal)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom:12, right: 12)
//
//        closeButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTouchDownAction), for: .touchDown)
        view.addSubview(backButton)
    }
    
//
//    func setTopImageUI() {
//        exhibitionDetailTableView.estimatedRowHeight = 50
//        exhibitionDetailTableView.contentInset = UIEdgeInsetsMake(300, 0, 0, 0)
//
//        imageView.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: 300)
//        imageView.image = UIImage.init(named: "powder_and_damask")
//
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        view.addSubview(imageView)
//
//        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.light)
//        blurView = UIVisualEffectView(effect: darkBlur)
//        blurView.frame = imageView.bounds
//        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        blurView.alpha = 0
//        imageView.addSubview(blurView)
//
//        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
//            closeButton.frame = CGRect(x: 10, y: 30, width: 40, height: 40)
//        } else {
//            closeButton.frame = CGRect(x: self.view.frame.width-50, y: 30, width: 40, height: 40)
//        }
//        closeButton.setImage(UIImage(named: "closeX1"), for: .normal)
//        closeButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom:12, right: 12)
//
//        closeButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//        closeButton.addTarget(self, action: #selector(closeButtonTouchDownAction), for: .touchDown)
//
//        closeButton.layer.shadowColor = UIColor.black.cgColor
//        closeButton.layer.shadowOffset = CGSize(width: 5, height: 5)
//        closeButton.layer.shadowRadius = 5
//        closeButton.layer.shadowOpacity = 1.0
//        view.addSubview(closeButton)
//    }
//
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objectCell = tableView.dequeueReusableCell(withIdentifier: "objectDetailCellId", for: indexPath) as! ObjectDetailTableViewCell
//        diningCell.titleLineView.isHidden = true
//        diningCell.setDiningDetailValues(diningDetail: diningDetailtArray[indexPath.row])
//        diningCell.locationButtonAction = {
//            ()in
//            self.loadLocationOnMap()
//        }
//        diningCell.favBtnTapAction = {
//            () in
//            self.setFavouritesAction(cellObj: diningCell)
//        }
//        diningCell.shareBtnTapAction = {
//            () in
//            self.setShareAction(cellObj: diningCell)
//        }
        loadingView.stopLoading()
        loadingView.isHidden = true
        return objectCell
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
    
    @objc func backButtonTouchDownAction(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
    //MARK: Header delegate
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
}


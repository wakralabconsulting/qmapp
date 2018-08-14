//
//  ObjectDetailViewController.swift
//  QatarMuseums
//
//  Created by Developer on 13/08/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class ObjectDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var objectTableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    
    let imageView = UIImageView()
    var blurView = UIVisualEffectView()
    let backButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIContents()
        setTopBarImage()
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
        imageView.backgroundColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
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
            backButton.setImage(UIImage(named: "previousImg"), for: .normal)
        } else {
            backButton.frame = CGRect(x: self.view.frame.width-50, y: 30, width: 40, height: 40)
            backButton.setImage(UIImage(named: "nextImg"), for: .normal)
        }
        backButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTouchDownAction), for: .touchDown)
        view.addSubview(backButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "objectDetailCellId", for: indexPath) as! ObjectDetailTableViewCell
        if (indexPath.row == 0) {
            cell.setObjectDetail()
        } else if (indexPath.row == 1) {
            cell.setObjectHistoryDetail()
        }
        
        cell.favBtnTapAction = {
            () in
            self.setFavouritesAction(cellObj: cell)
        }
        cell.shareBtnTapAction = {
            () in
            self.setShareAction(cellObj: cell)
        }
        
        loadingView.stopLoading()
        loadingView.isHidden = true
        return cell
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
        if (scrollView.contentOffset.y < 0) {
            //reached top
            self.backButtonPressed()
        }
    }
    
    @objc func backButtonTouchDownAction(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
    @objc func backButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    func setFavouritesAction(cellObj: ObjectDetailTableViewCell) {
        if (cellObj.favoriteButton.tag == 0) {
            cellObj.favoriteButton.tag = 1
            cellObj.favoriteButton.setImage(UIImage(named: "heart_fillX1"), for: .normal)
        } else {
            cellObj.favoriteButton.tag = 0
            cellObj.favoriteButton.setImage(UIImage(named: "heart_emptyX1"), for: .normal)
        }
    }
    
    func setShareAction(cellObj: ObjectDetailTableViewCell) {
        
    }
}


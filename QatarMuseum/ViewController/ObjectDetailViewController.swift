//
//  ObjectDetailViewController.swift
//  QatarMuseums
//
//  Created by Developer on 13/08/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class ObjectDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ObjectImageViewProtocol,UIGestureRecognizerDelegate {
    @IBOutlet weak var objectTableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    
    let imageView = UIImageView()
    var blurView = UIVisualEffectView()
    let backButton = UIButton()
    var objectImagePopupView : ObjectImageView = ObjectImageView()
    let fullView: CGFloat = 100
    let closeButton = UIButton()
//    var partialView: CGFloat {
//        return UIScreen.main.bounds.height - 200
//    }
    
//    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
//        [unowned self] in
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture))
//
//        // let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleScopeGesture(_:)))
//        panGesture.delegate = self
//        panGesture.minimumNumberOfTouches = 1
//        panGesture.maximumNumberOfTouches = 2
//        return panGesture
//        }()
    override func viewDidLoad() {
        super.viewDidLoad()
        objectTableView.register(UITableViewCell.self, forCellReuseIdentifier: "imageCell")
        setupUIContents()
        //self.view.addGestureRecognizer(self.scopeGesture)
        //self.objectTableView.panGestureRecognizer.require(toFail: self.scopeGesture)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        UIView.animate(withDuration: 0.6, animations: { [weak self] in
//            let frame = self?.view.frame
//            let yComponent = self?.partialView
//            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height - 100)
//           // self?.view.frame = CGRect(x: 0, y: 0, width: frame!.width, height: frame!.height)
//        })
    }
    
    func setupUIContents() {
       // loadingView.isHidden = false
       // loadingView.showLoading()
        
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
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
    
    func setTopBarImage() {
        objectTableView.estimatedRowHeight = 50
        objectTableView.contentInset = UIEdgeInsetsMake(300, 0, 0, 0)
        
        imageView.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: 300)
        imageView.image = UIImage.init(named: "science_tour_object")
        imageView.backgroundColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(loadObjectImagePopup))
        imageView.addGestureRecognizer(tapGesture)
        
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 300
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
            let objectImageView = UIImageView()
            objectImageView.frame = CGRect(x: 0, y: 20, width: tableView.frame.width, height: 300)
            objectImageView.image = UIImage.init(named: "science_tour_object")
            objectImageView.backgroundColor = UIColor.white
            objectImageView.contentMode = .scaleAspectFit
            objectImageView.clipsToBounds = true
            cell.addSubview(objectImageView)
            
            objectImageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(loadObjectImagePopup))
            objectImageView.addGestureRecognizer(tapGesture)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "objectDetailCellId", for: indexPath) as! ObjectDetailTableViewCell
            if (indexPath.row == 1) {
                cell.setObjectDetail()
            } else if (indexPath.row == 2) {
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
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let y = 300 - (scrollView.contentOffset.y + 300)
//        let height = min(max(y, 60), 400)
//        imageView.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: height)
//        
//        if (imageView.frame.height >= 300 ){
//            blurView.alpha  = 0.0
//        } else if (imageView.frame.height >= 250 ){
//            blurView.alpha  = 0.2
//        } else if (imageView.frame.height >= 200 ){
//            blurView.alpha  = 0.4
//        } else if (imageView.frame.height >= 150 ){
//            blurView.alpha  = 0.6
//        } else if (imageView.frame.height >= 100 ){
//            blurView.alpha  = 0.8
//        } else if (imageView.frame.height >= 50 ){
//            blurView.alpha  = 0.9
//        }
//        if (scrollView.contentOffset.y < -300) {
//            //reached top
//            self.backButtonPressed()
//        }
    }
    
    //MARK: Poup Delegate
    func dismissImagePopUpView() {
        self.objectImagePopupView.removeFromSuperview()
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func loadObjectImagePopup() {
        objectImagePopupView = ObjectImageView(frame: self.view.frame)
        objectImagePopupView.objectImageViewDelegate = self
        objectImagePopupView.loadPopup(image : "science_tour_object")
        self.view.addSubview(objectImagePopupView)
    }
    
    @objc func backButtonTouchDownAction(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
    @objc func backButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.35
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
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
//        let translation = recognizer.translation(in: self.view)
//        let velocity = recognizer.velocity(in: self.view)
//
//        let y = self.view.frame.minY
//        if (y + translation.y >= fullView) && (y + translation.y <= partialView) {
//            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
//            recognizer.setTranslation(CGPoint.zero, in: self.view)
//            self.objectImagePopupView.removeFromSuperview()
//        }
//
//        if recognizer.state == .ended {
//            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
//
//            duration = duration > 1.3 ? 1 : duration
//
//            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
//                if  velocity.y >= 0 {
//                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
//
//                } else {
//                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
//
//                }
//
//            }, completion: { [weak self] _ in
//                if ( velocity.y < 0 ) {
//                    self?.objectTableView.isScrollEnabled = true
//                }
//            })
//        }
    }
    // MARK:- UIGestureRecognizerDelegate
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
//        let direction = gesture.velocity(in: view).y
//
//        let y = view.frame.minY
//        print(fullView)
//        print(objectTableView.contentOffset.y)
//        print(direction)
//        print(partialView)
//
//        if (y == fullView && objectTableView.contentOffset.y == 0 && direction > 0)  {
//            objectTableView.isScrollEnabled = false
//
//        } else {
//            objectTableView.isScrollEnabled = true
//
//
//
//        }
//
//        return false
//    }
    
    @objc func buttonAction(sender: UIButton!) {
       // sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//        let transition = CATransition()
//        transition.duration = 0.25
//        transition.type = kCATransitionFade
//        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
//        self.view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    @objc func closeButtonTouchDownAction(sender: UIButton!) {
        sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
}


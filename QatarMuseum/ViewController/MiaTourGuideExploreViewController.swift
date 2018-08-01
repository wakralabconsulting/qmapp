//
//  MiaTourGuideDetailViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 17/07/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit

class MiaTourGuideExploreViewController: UIViewController,HeaderViewProtocol,comingSoonPopUpProtocol {
    
    

    @IBOutlet weak var tourGuideDescription: UILabel!
    
    @IBOutlet weak var startTourButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var headerView: CommonHeaderView!
    
    var popupView : ComingSoonPopUp = ComingSoonPopUp()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    func setupUI() {
        tourGuideDescription.text = "Welcome to Qatar Museum Premises. \n Explore the architrcture and the objects on display. \n Scan the QR codes available on the galleries for more information."
        headerView.headerViewDelegate = self
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            
            headerView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        }
        else {
            headerView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    @IBAction func didTapPlayButton(_ sender: UIButton) {
        self.playButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        loadComingSoonPopup()
    }
    
    @IBAction func playButtonTouchDown(_ sender: UIButton) {
        self.playButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    @IBAction func didTapStartTour(_ sender: UIButton) {
        self.startTourButton.backgroundColor = UIColor.viewMycultureBlue
        self.startTourButton.setTitleColor(UIColor.white, for: .normal)
        self.startTourButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        loadComingSoonPopup()
    }
    @IBAction func startTourButtonTouchDown(_ sender: UIButton) {
        self.startTourButton.backgroundColor = UIColor.startTourLightBlue
        self.startTourButton.setTitleColor(UIColor.viewMyculTitleBlue, for: .normal)
        
        self.startTourButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    func loadComingSoonPopup() {
        popupView  = ComingSoonPopUp(frame: self.view.frame)
        popupView.comingSoonPopupDelegate = self
        popupView.loadPopup()
        self.view.addSubview(popupView)
        
    }
    //MARK: Poup Delegate
    func closeButtonPressed() {
        
        self.popupView.removeFromSuperview()
    }
    //MARK: Header delegate
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
        
    }
    
}

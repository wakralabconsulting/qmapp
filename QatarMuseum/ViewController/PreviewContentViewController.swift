//
//  PreviewContentViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 03/10/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import AVFoundation
import AVKit
import Crashlytics
import UIKit

class PreviewContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
//    @IBOutlet weak var previewContentView: UIView!
//    @IBOutlet weak var titleLabel: UITextView!
    @IBOutlet weak var accessNumberLabel: UILabel!
//    @IBOutlet weak var tourGuideImage: UIImageView!
    @IBOutlet weak var objectTableView: UITableView!

//    @IBOutlet weak var productionTitle: UILabel!
//    @IBOutlet weak var productionDateTitle: UILabel!
//    @IBOutlet weak var periodTitle: UILabel!
//    @IBOutlet weak var techniqueTitle: UILabel!
//    @IBOutlet weak var dimensionsTitle: UILabel!
//    @IBOutlet weak var productionText: UILabel!
//    @IBOutlet weak var productionDateText: UILabel!
//    @IBOutlet weak var periodText: UILabel!
//    @IBOutlet weak var techniqueText: UILabel!
//    @IBOutlet weak var dimensionsText: UILabel!
//
//    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var productionHeight: NSLayoutConstraint!
//    @IBOutlet weak var productionDateHeight: NSLayoutConstraint!
//    @IBOutlet weak var periodHeight: NSLayoutConstraint!
//    @IBOutlet weak var techniqueHeight: NSLayoutConstraint!
//    @IBOutlet weak var dimensionHeight: NSLayoutConstraint!
    
    var tourGuideDict : TourGuideFloorMap!
    var pageIndex = Int()
    let imageView = UIImageView()
    var blurView = UIVisualEffectView()
    var objectImagePopupView : ObjectImageView = ObjectImageView()
    var detailArray : [TourGuideFloorMap]! = []
    var playList: String = ""
    var timer: Timer?
    var avPlayer: AVPlayer!
    var isPaused: Bool!
    var firstLoad: Bool = true
    var selectedCell : ObjectDetailTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objectTableView.register(UITableViewCell.self, forCellReuseIdentifier: "imageCell")
        setPreviewData()
    }
    
    func setUI() {
//        previewContentView.clipsToBounds = true
//        previewContentView.layer.cornerRadius = 10
//        if #available(iOS 11.0, *) {
//            previewContentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        } else {
//            let rectShape = CAShapeLayer()
//            rectShape.bounds = previewContentView.frame
//            rectShape.position = previewContentView.center
//            rectShape.path = UIBezierPath(roundedRect: previewContentView.bounds,    byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
//            previewContentView.layer.mask = rectShape
//        }
    }

    func setPreviewData() {
        let tourGuideData = tourGuideDict
        let galleryNumber = tourGuideData?.galleyNumber?.replacingOccurrences(of: "<[^>]+>|&nbsp;|&#039;", with: "", options: .regularExpression, range: nil)
        let floorLevel = tourGuideData?.floorLevel?.replacingOccurrences(of: "<[^>]+>|&nbsp;|&#039;", with: "", options: .regularExpression, range: nil)
        accessNumberLabel.text = galleryNumber + ", " + floorLevel
//        if((tourGuideData?.production != nil) && (tourGuideData?.production != "")) {
//             productionTitle.text = NSLocalizedString("PRODUCTION_LABEL", comment: "PRODUCTION_LABEL  in the Popup")
//            productionText.text = tourGuideData?.production
//           // productionHeight.constant = 33
//        } else {
//           // productionHeight.constant = 0
//        }
//        if((tourGuideData?.productionDates != nil) && (tourGuideData?.productionDates != "")) {
//            productionDateTitle.text = NSLocalizedString("PRODUCTION_DATES_LABEL", comment: "PRODUCTION_DATES_LABEL  in the Popup")
//            productionDateText.text = tourGuideData?.productionDates
//           // productionDateHeight.constant = 33
//        } else {
//           // productionDateHeight.constant = 0
//        }
//        if((tourGuideData?.periodOrStyle != nil) && (tourGuideData?.periodOrStyle != "")) {
//            periodTitle.text = NSLocalizedString("PERIOD_STYLE_LABEL", comment: "PERIOD_STYLE_LABEL  in the Popup")
//            periodText.text = tourGuideData?.periodOrStyle
//           // periodHeight.constant = 33
//        }else {
//            //periodHeight.constant = 0
//        }
//        if((tourGuideData?.techniqueAndMaterials != nil) && (tourGuideData?.techniqueAndMaterials != "")) {
//            techniqueTitle.text = NSLocalizedString("TECHNIQUES_LABEL", comment: "TECHNIQUES_LABEL  in the Popup")
//            techniqueText.text = tourGuideData?.techniqueAndMaterials
//           // techniqueHeight.constant = 50
//        }else {
//            //techniqueHeight.constant = 0
//        }
//        if((tourGuideData?.dimensions != nil) && (tourGuideData?.dimensions != "")) {
//            dimensionsTitle.text = NSLocalizedString("DIMENSIONS_LABEL", comment: "DIMENSIONS_LABEL  in the Popup")
//            dimensionsText.text = tourGuideData?.dimensions
//            //dimensionHeight.constant = 33
//        }else {
//           // dimensionHeight.constant = 0
//        }
        
//        titleLabel.font = UIFont.discoverButtonFont
        accessNumberLabel.font = UIFont.sideMenuLabelFont
//        productionTitle.font = UIFont.clearButtonFont
//        productionDateTitle.font = UIFont.clearButtonFont
//        periodTitle.font = UIFont.clearButtonFont
//        techniqueTitle.font = UIFont.clearButtonFont
//        dimensionsTitle.font = UIFont.clearButtonFont
//        productionText.font = UIFont.exhibitionDateLabelFont
//        productionDateText.font = UIFont.exhibitionDateLabelFont
//        periodText.font = UIFont.exhibitionDateLabelFont
//        techniqueText.font = UIFont.exhibitionDateLabelFont
//        dimensionsText.font = UIFont.exhibitionDateLabelFont
//        if let imageUrl = tourGuideData?.image {
//            tourGuideImage.kf.setImage(with: URL(string: imageUrl))
//        }
        if(UIScreen.main.bounds.height <= 568) {
//            titleLabel.font = UIFont.eventCellTitleFont
            accessNumberLabel.font = UIFont.exhibitionDateLabelFont
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: TableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tourGuideDict != nil) {
            return 3
        }
        return 0
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
            objectImageView.image = UIImage(named: "default_imageX2")
            if let imageUrl = tourGuideDict.image {
                objectImageView.kf.setImage(with: URL(string: imageUrl))
            }
            if(objectImageView.image == nil) {
                objectImageView.image = UIImage(named: "default_imageX2")
            }

            objectImageView.backgroundColor = UIColor.white
            objectImageView.contentMode = .scaleAspectFit
            objectImageView.clipsToBounds = true
            cell.addSubview(objectImageView)
            cell.selectionStyle = .none
            objectImageView.isUserInteractionEnabled = true
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "objectDetailCellId", for: indexPath) as! ObjectDetailTableViewCell
            if (indexPath.row == 1) {
                cell.setObjectDetail(objectDetail: tourGuideDict)
            } else if (indexPath.row == 2) {
                cell.setObjectHistoryDetail(historyDetail: tourGuideDict)
            }
            
            cell.favBtnTapAction = {
                () in
                self.setFavouritesAction(cellObj: cell)
            }
            cell.shareBtnTapAction = {
                () in
                self.setShareAction(cellObj: cell)
            }
            cell.playBtnTapAction = {
                () in
                self.setPlayButtonAction(cellObj: cell)
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if((indexPath.row == 0) && (tourGuideDict.image != "")) {
            if let imageUrl = tourGuideDict.image {
                self.loadObjectImagePopup(imgName: imageUrl )
            }
        }
    }
    
    //MARK: Poup Delegate
    func dismissImagePopUpView() {
        self.objectImagePopupView.removeFromSuperview()
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func loadObjectImagePopup(imgName: String?) {
        objectImagePopupView = ObjectImageView(frame: self.view.frame)
        //objectImagePopupView.objectImageViewDelegate = self as! ObjectImageViewProtocol
        objectImagePopupView.loadPopup(image : imgName!)
        self.view.addSubview(objectImagePopupView)
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
    
    func setPlayButtonAction(cellObj: ObjectDetailTableViewCell) {
        selectedCell  = cellObj
        
        if(tourGuideDict != nil) {
            if((tourGuideDict.audioFile != nil) && (tourGuideDict.audioFile != "")){
                if (firstLoad == true) {
                    cellObj.playButton.setImage(UIImage(named:"pause_blackX1"), for: .normal)
                    cellObj.playList = tourGuideDict.audioFile!
                    cellObj.isPaused = false
                    cellObj.play(url: URL(string:cellObj.playList)!)
                    cellObj.setupTimer()
                } else {
                    cellObj.togglePlayPause()
                }
                firstLoad = false
            }
        }
    }
}

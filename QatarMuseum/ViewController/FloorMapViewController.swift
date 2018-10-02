//
//  FloorMapViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 15/08/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Alamofire
import GoogleMaps
import Crashlytics
import UIKit
import MaterialComponents.MaterialBottomSheet

enum levelNumber{
    case one
    case two
    case three
}

class FloorMapViewController: UIViewController, GMSMapViewDelegate, ObjectPopUpProtocol, HeaderViewProtocol,UIGestureRecognizerDelegate,MapDetailProtocol {
    
    
    @IBOutlet weak var viewForMap: GMSMapView!
    @IBOutlet weak var headerView: CommonHeaderView!
    @IBOutlet weak var thirdLevelView: UIView!
    @IBOutlet weak var secondLevelView: UIView!
    @IBOutlet weak var firstLevelView: UIView!
    @IBOutlet weak var thirdLevelButton: UIButton!
    @IBOutlet weak var secondLevelButton: UIButton!
    @IBOutlet weak var firstLevelButton: UIButton!
    @IBOutlet weak var secondLevelLabel: UILabel!
    @IBOutlet weak var numberTwo: UILabel!
    @IBOutlet weak var numberOne: UILabel!
    
    @IBOutlet weak var numberThree: UILabel!
    @IBOutlet weak var firstLevelLabel: UILabel!
    @IBOutlet weak var thirdLevelLabel: UILabel!
    @IBOutlet weak var levelView: UIView!
    @IBOutlet weak var numberSerchBtn: UIButton!
    
    var bottomSheetVC:MapDetailView = MapDetailView()
    var floorMapArray: [TourGuideFloorMap]! = []
    var tourGuideArray: [TourGuideFloorMap]! = []
    @IBOutlet weak var overlayView: UIView!
    var overlay = GMSGroundOverlay()
    let l2_atr1 = CLLocationCoordinate2D(latitude: 25.295141, longitude: 51.539185)
    let l2_atr2 = CLLocationCoordinate2D(latitude: 25.295500, longitude: 51.538855)
    let l2_atr3 = CLLocationCoordinate2D(latitude: 25.295468, longitude: 51.538905)
    let l2_atr4 = CLLocationCoordinate2D(latitude: 25.295510, longitude: 51.538803)
    let l2_atr5 = CLLocationCoordinate2D(latitude: 25.295450, longitude: 51.538830)
    let l2_atr6 = CLLocationCoordinate2D(latitude: 25.295540, longitude: 51.538835)
    let l2_atr7 = CLLocationCoordinate2D(latitude: 25.295571, longitude: 51.538840)
    let l2_atr8 = CLLocationCoordinate2D(latitude: 25.295558, longitude: 51.538841)
    let l2_atr9 = CLLocationCoordinate2D(latitude: 25.295643, longitude: 51.538895)
    let l2_atr10 = CLLocationCoordinate2D(latitude: 25.295654, longitude: 51.538918)
    let l2_atr11 = CLLocationCoordinate2D(latitude: 25.295652, longitude: 51.538927)
    let l2_atr12 = CLLocationCoordinate2D(latitude: 25.295686, longitude: 51.539265)
    let l2_atr13 = CLLocationCoordinate2D(latitude: 25.295566, longitude: 51.539397)
    let l3_atr1 = CLLocationCoordinate2D(latitude: 25.295230, longitude: 51.539170)
    let l3_atr2 = CLLocationCoordinate2D(latitude: 25.295245, longitude: 51.539210)
    let l3_atr3 = CLLocationCoordinate2D(latitude: 25.295330, longitude: 51.539414)
    let l3_atr4 = CLLocationCoordinate2D(latitude: 25.295664, longitude: 51.539330)
    let l3_atr5 = CLLocationCoordinate2D(latitude: 25.295628, longitude: 51.539360)
    let l3_atr6 = CLLocationCoordinate2D(latitude: 25.295505, longitude: 51.538905)
    let l2Marker = GMSMarker()
    let l2Marker2 = GMSMarker()
    let l2Marker3 = GMSMarker()
    let l2Marker4 = GMSMarker()
    let l2Marker5 = GMSMarker()
    let l2Marker6 = GMSMarker()
    let l2Marker7 = GMSMarker()
    let l2Marker8 = GMSMarker()
    let l2Marker9 = GMSMarker()
    let l2Marker10 = GMSMarker()
    let l2Marker11 = GMSMarker()
    let l2Marker12 = GMSMarker()
    let l2Marker13 = GMSMarker()
    let l3Marker1 = GMSMarker()
    let l3Marker2 = GMSMarker()
    let l3Marker3 = GMSMarker()
    let l3Marker4 = GMSMarker()
    let l3Marker5 = GMSMarker()
    let l3Marker6 = GMSMarker()
    var objectPopupView : ObjectPopupView = ObjectPopupView()
    var level : levelNumber?
    var zoomValue = Float()
    var fromScienceTour : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        viewForMap.delegate = self
        loadMap()
        initialSetUp()
        getFloorMapDataFromServer()
    }
    
    func initialSetUp() {
        overlayView.isHidden = true
        bottomSheetVC.mapdetailDelegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        tap.delegate = self // This is not required
        overlayView.addGestureRecognizer(tap)
        levelView.layer.shadowColor = UIColor.black.cgColor
        levelView.layer.shadowOpacity = 0.6
        levelView.layer.shadowOffset = CGSize.zero
        levelView.layer.shadowRadius = 10
        
        firstLevelView.layer.shadowColor = UIColor.black.cgColor
        firstLevelView.layer.shadowOpacity = 0.5
        firstLevelView.layer.shadowOffset = CGSize.zero
        firstLevelView.layer.shadowRadius = 1
        
        secondLevelView.layer.shadowColor = UIColor.black.cgColor
        secondLevelView.layer.shadowOpacity = 0.5
        secondLevelView.layer.shadowOffset = CGSize.zero
        secondLevelView.layer.shadowRadius = 1
        
        thirdLevelView.layer.shadowColor = UIColor.black.cgColor
        thirdLevelView.layer.shadowOpacity = 0.5
        thirdLevelView.layer.shadowOffset = CGSize.zero
        thirdLevelView.layer.shadowRadius = 1
        if (fromScienceTour == true) {
            firstLevelView.backgroundColor = UIColor.mapLevelColor
            secondLevelView.backgroundColor = UIColor.mapLevelColor
            thirdLevelView.backgroundColor = UIColor.white
            //numberSerchBtn.setImage(UIImage(named: "side_menu_blackX1"), for: .normal)
           // self.numberSerchBtn.contentEdgeInsets = UIEdgeInsets(top: 11, left: 5, bottom: 11, right: 5)
            numberSerchBtn.isHidden = true
            headerView.headerBackButton.isHidden = true
            headerView.settingsButton.isHidden = false
            headerView.settingsButton.setImage(UIImage(named: "side_menu_iconX1"), for: .normal)
            
            headerView.settingsButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 10, bottom:11, right: 8)
            
        } else {
            firstLevelView.backgroundColor = UIColor.white
            secondLevelView.backgroundColor = UIColor.mapLevelColor
            thirdLevelView.backgroundColor = UIColor.mapLevelColor
            numberSerchBtn.setImage(UIImage(named: "number_padX1"), for: .normal)
            headerView.headerBackButton.isHidden = false
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                
                headerView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
            }
            else {
                headerView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
            }
        }
        
        thirdLevelLabel.text = NSLocalizedString("LEVEL_STRING", comment: "LEVEL_STRING in floor map")
        secondLevelLabel.text = NSLocalizedString("LEVEL_STRING", comment: "LEVEL_STRING in floor map")
        firstLevelLabel.text = NSLocalizedString("LEVEL_STRING", comment: "LEVEL_STRING in floor map")
        headerView.headerViewDelegate = self
        headerView.headerTitle.text = NSLocalizedString("FLOOR_MAP_TITLE", comment: "FLOOR_MAP_TITLE  in the Floormap page")
        
    }
    
    func loadMap() {
        var camera = GMSCameraPosition()
        //Device Condition check for moving map to center of device screen
        if (UIScreen.main.bounds.height > 700) {
            camera = GMSCameraPosition.camera(withLatitude: 25.295447, longitude: 51.539195, zoom:19)
        }
        else {
            camera = GMSCameraPosition.camera(withLatitude: 25.296059, longitude: 51.538703, zoom:19)
        }
        viewForMap.animate(to: camera)
        do {
            if let styleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
                viewForMap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        viewForMap.mapType = .normal
        var icon = UIImage()
        if (fromScienceTour == true) {
            level = levelNumber.three
            icon = UIImage(named: "qm_level_3")!
            viewForMap.animate(toZoom: 19.5)
        } else {
            level = levelNumber.one
            icon = UIImage(named: "qm_level_1")!
        }
        let southWest = CLLocationCoordinate2D(latitude: 25.294730, longitude: 51.539021)
        let northEast = CLLocationCoordinate2D(latitude: 25.295685, longitude: 51.539945)
        let overlayBounds = GMSCoordinateBounds(coordinate: southWest, coordinate: northEast)
        overlay = GMSGroundOverlay.init(bounds: overlayBounds, icon: icon)
        //let camera2 = GMSCameraPosition.camera(withLatitude: 25.295447, longitude: 51.539195, zoom:19)
        overlay.anchor = CGPoint(x: 0, y: 1)
        overlay.map = self.viewForMap
        viewForMap?.camera = camera
        
        overlay.bearing = -22
        viewForMap.setMinZoom(19, maxZoom: 28)
        
        //let circleCenter = CLLocationCoordinate2DMake(25.294730,51.539021)
        let circleCenter = CLLocationCoordinate2DMake(25.296059,51.538703)
        let circ = GMSCircle(position: circleCenter, radius: 250)
        
        circ.strokeColor = UIColor.clear
        circ.map = viewForMap
        
        if (fromScienceTour == true) {
            if (UIScreen.main.bounds.height > 700) {
                camera = GMSCameraPosition.camera(withLatitude: 25.295447, longitude: 51.539195, zoom:19)
            }
            else {
                camera = GMSCameraPosition.camera(withLatitude: 25.295980, longitude: 51.538779, zoom:19)
            }
            
            viewForMap.animate(to: camera)
            viewForMap.animate(toZoom: 19.3)
        }
        
        
    }
    //Function for show level 2 marker
    func showLevelTwoMarker() {
        if (zoomValue > 19) {
            l2Marker.position = l2_atr1
            l2Marker.title = ""
            l2Marker.snippet = ""
            l2Marker.icon = UIImage(named: "SI.5.1999.Front.2000x2000")
            l2Marker.icon = self.imageWithImage(image: UIImage(named: "SI.5.1999.Front.2000x2000")!, scaledToSize: CGSize(width:38, height: 44))
            l2Marker.appearAnimation = .pop
            l2Marker.map = viewForMap
            
            l2Marker2.position = l2_atr2
            l2Marker2.title = ""
            l2Marker2.snippet = ""
            //l2Marker2.icon = UIImage(named: "MS.523.1999-1.2000x2000")
            l2Marker2.icon = self.imageWithImage(image: UIImage(named: "MS.523.1999-1.2000x2000")!, scaledToSize: CGSize(width:38, height: 44))
            l2Marker2.appearAnimation = .pop
            l2Marker2.map = viewForMap
            
            l2Marker3.position = l2_atr3
            l2Marker3.title = ""
            l2Marker3.snippet = ""
            l2Marker3.icon = self.imageWithImage(image: UIImage(named: "MW_548")!, scaledToSize: CGSize(width:38, height: 44))
            l2Marker3.appearAnimation = .pop
            l2Marker3.map = viewForMap
            
            l2Marker4.position = l2_atr4
            l2Marker4.title = ""
            l2Marker4.snippet = ""
            l2Marker4.icon = self.imageWithImage(image: UIImage(named: "MS.709.2010-1.2000x2000")!, scaledToSize: CGSize(width:38, height: 44))
            l2Marker4.appearAnimation = .pop
            l2Marker4.map = viewForMap
            
            l2Marker5.position = l2_atr5
            l2Marker5.title = ""
            l2Marker5.snippet = ""
            l2Marker5.icon = self.imageWithImage(image: UIImage(named: "MS.709.2010-2")!, scaledToSize: CGSize(width:38, height: 44))
            l2Marker5.appearAnimation = .pop
            l2Marker5.map = viewForMap
            
            l2Marker6.position = l2_atr6
            l2Marker6.title = ""
            l2Marker6.snippet = ""
            l2Marker6.icon = self.imageWithImage(image: UIImage(named: "MW.361.2007.2000x2000")!, scaledToSize: CGSize(width:38, height: 44))
            l2Marker6.appearAnimation = .pop
            l2Marker6.map = viewForMap
            
            l2Marker7.position = l2_atr7
            l2Marker7.title = ""
            l2Marker7.snippet = ""
            l2Marker7.icon = self.imageWithImage(image: UIImage(named: "MS.688.2008.Recto-1.2000x2000")!, scaledToSize: CGSize(width:38, height: 44))
            l2Marker7.appearAnimation = .pop
            l2Marker7.map = viewForMap
            
            l2Marker8.position = l2_atr8
            l2Marker8.title = ""
            l2Marker8.snippet = ""
            l2Marker8.icon = self.imageWithImage(image: UIImage(named: "MS.650 .1 recto-1")!, scaledToSize: CGSize(width:38, height: 44))
            l2Marker8.appearAnimation = .pop
            l2Marker8.map = viewForMap
            
            l2Marker9.position = l2_atr9
            l2Marker9.title = ""
            l2Marker9.snippet = ""
            l2Marker9.icon = self.imageWithImage(image: UIImage(named: "001_MIA_MW.146_005")!, scaledToSize: CGSize(width:38, height: 44))
            l2Marker9.appearAnimation = .pop
            l2Marker9.map = viewForMap
            
            l2Marker10.position = l2_atr10
            l2Marker10.title = ""
            l2Marker10.snippet = ""
            l2Marker10.icon = self.imageWithImage(image: UIImage(named: "MW.340.Front.2000x2000")!, scaledToSize: CGSize(width:38, height: 44))
            l2Marker10.appearAnimation = .pop
            l2Marker10.map = viewForMap
            
            l2Marker11.position = l2_atr11
            l2Marker11.title = ""
            l2Marker11.snippet = ""
            l2Marker11.icon = self.imageWithImage(image: UIImage(named: "MS.794-1")!, scaledToSize: CGSize(width:38, height: 44))
            l2Marker11.appearAnimation = .pop
            l2Marker11.map = viewForMap
            
            l2Marker12.position = l2_atr12
            l2Marker12.title = ""
            l2Marker12.snippet = ""
            l2Marker12.icon = self.imageWithImage(image: UIImage(named: "MW_56")!, scaledToSize: CGSize(width:38, height: 44))
            l2Marker12.appearAnimation = .pop
            l2Marker12.map = viewForMap
            
            l2Marker13.position = l2_atr13
            l2Marker13.title = ""
            l2Marker13.snippet = ""
            l2Marker13.icon = self.imageWithImage(image: UIImage(named: "MW.634-EMu.2000x2000")!, scaledToSize: CGSize(width:38, height: 44))
            l2Marker13.appearAnimation = .pop
            l2Marker13.map = viewForMap
            
            
        } else {
            l2Marker.map = nil
            l2Marker2.map = nil
            l2Marker3.map = nil
            l2Marker4.map = nil
            l2Marker5.map = nil
            l2Marker6.map = nil
            l2Marker7.map = nil
            l2Marker8.map = nil
            l2Marker9.map = nil
            l2Marker10.map = nil
            l2Marker11.map = nil
            l2Marker12.map = nil
            l2Marker13.map = nil
        }
    }
    //Function for show level 3 marker
    func showLevelThreeMarker() {
        if (zoomValue > 19) {
            l3Marker1.position = l3_atr1
            l3Marker1.title = "PO.297"
            l3Marker1.snippet = "PO.297"
            l3Marker1.icon = self.imageWithImage(image: UIImage(named: "PO.297.2006.1.2000x2000")!, scaledToSize: CGSize(width:38, height: 44))
            l3Marker1.appearAnimation = .pop
            l3Marker1.map = viewForMap
            
            l3Marker2.position = l3_atr2
            l3Marker2.title = ""
            l3Marker2.snippet = ""
            l3Marker2.icon = self.imageWithImage(image: UIImage(named: "PO.308")!, scaledToSize: CGSize(width:38, height: 44))
            l3Marker2.appearAnimation = .pop
            l3Marker2.map = viewForMap
            
            l3Marker3.position = l3_atr3
            l3Marker3.title = ""
            l3Marker3.snippet = ""
            l3Marker3.icon = self.imageWithImage(image: UIImage(named: "MS.647.A-59")!, scaledToSize: CGSize(width:38, height: 44))
            l3Marker3.appearAnimation = .pop
            l3Marker3.map = viewForMap
            
            l3Marker4.position = l3_atr4
            l3Marker4.title = ""
            l3Marker4.snippet = ""
            l3Marker4.icon = self.imageWithImage(image: UIImage(named: "HS.32-1.2000x2000")!, scaledToSize: CGSize(width:38, height: 44))
            l3Marker4.appearAnimation = .pop
            l3Marker4.map = viewForMap
            
            l3Marker5.position = l3_atr5
            l3Marker5.title = ""
            l3Marker5.snippet = ""
            l3Marker5.icon = self.imageWithImage(image: UIImage(named: "GL.322-0564.2000x2000")!, scaledToSize: CGSize(width:38, height: 44))
            l3Marker5.appearAnimation = .pop
            l3Marker5.map = viewForMap
            
            l3Marker6.position = l2_atr6
            l3Marker6.title = ""
            l3Marker6.snippet = ""
            l3Marker6.icon = self.imageWithImage(image: UIImage(named: "IV_61")!, scaledToSize: CGSize(width:38, height: 44))
            l3Marker6.appearAnimation = .pop
            l3Marker6.map = viewForMap
            
            
            
        } else {
            l3Marker1.map = nil
            l3Marker2.map = nil
            l3Marker3.map = nil
            l3Marker4.map = nil
            l3Marker5.map = nil
            l3Marker6.map = nil
        }
    }
    func showMarker(marker:GMSMarker,position: CLLocationCoordinate2D,titleString: String,imageName:String, zoomValue : Float){
        if (zoomValue > 19) {
            marker.position = position
            marker.title = titleString
            marker.snippet = "San Francisco"
            marker.icon = UIImage(named: imageName)
            marker.icon = self.imageWithImage(image: UIImage(named: imageName)!, scaledToSize: CGSize(width:28, height: 34))
            marker.appearAnimation = .pop
            marker.map = viewForMap
        } else {
            marker.map = nil
        }
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Floor Levels
    @IBAction func didTapThirdLevel(_ sender: UIButton) {
        level = levelNumber.three
        firstLevelView.backgroundColor = UIColor.mapLevelColor
        secondLevelView.backgroundColor = UIColor.mapLevelColor
        thirdLevelView.backgroundColor = UIColor.white
        overlay.icon = UIImage(named: "qm_level_3")
        removeMarkers()
        
        if (zoomValue > 19) {
            showLevelThreeMarker()
        }
    }
    
    @IBAction func didtapSecondbutton(_ sender: UIButton) {
        level = levelNumber.two
        firstLevelView.backgroundColor = UIColor.mapLevelColor
        secondLevelView.backgroundColor = UIColor.white
        thirdLevelView.backgroundColor = UIColor.mapLevelColor
        overlay.icon = UIImage(named: "qm_level_2")
        removeMarkers()
        if (zoomValue > 19) {
            showLevelTwoMarker()
        }
    }
    
    @IBAction func didTapFirstButton(_ sender: UIButton) {
        level = levelNumber.one
        firstLevelView.backgroundColor = UIColor.white
        secondLevelView.backgroundColor = UIColor.mapLevelColor
        thirdLevelView.backgroundColor = UIColor.mapLevelColor
        overlay.icon = UIImage(named: "qm_level_1")
        removeMarkers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadObjectPopup() {
        objectPopupView = ObjectPopupView(frame: self.view.frame)
        objectPopupView.objectPopupDelegate = self
        objectPopupView.loadPopup()
        self.view.addSubview(objectPopupView)
        

    }
    
    //MARK: map delegate
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let markerIcon = marker.icon
        if (level == levelNumber.two) {
            showLevelTwoMarker()
        }
        else if (level == levelNumber.three){
            showLevelThreeMarker()
        }
        marker.appearAnimation = .pop
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            marker.icon = self?.imageWithImage(image: markerIcon!, scaledToSize: CGSize(width:52, height: 62))
            })
        //loadObjectPopup()
        addBottomSheetView()
        return true
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let zoom = mapView.camera.zoom
        zoomValue = zoom
        //let center = CLLocationCoordinate2DMake(25.294730,51.539021)
        let center = CLLocationCoordinate2DMake(25.296059,51.538703)
        let radius = CLLocationDistance(250)
        
        let targetLoc = CLLocation.init(latitude: position.target.latitude, longitude: position.target.longitude)
        let centerLoc = CLLocation.init(latitude: center.latitude, longitude: center.longitude)
        
        if ((targetLoc.distance(from: centerLoc)) > radius) {
            let camera = GMSCameraPosition.camera(withLatitude: center.latitude, longitude: center.longitude, zoom: mapView.camera.zoom)
            viewForMap.animate(to: camera)
        }
        
        if (level == levelNumber.two) {
            showLevelTwoMarker()
            
        } else if(level == levelNumber.three) {
            showLevelThreeMarker()
        }
    }
    
    func removeMarkers() {
        l2Marker.map = nil
        l2Marker2.map = nil
        l2Marker3.map = nil
        l2Marker4.map = nil
        l2Marker5.map = nil
        l2Marker6.map = nil
        l2Marker7.map = nil
        l2Marker8.map = nil
        l2Marker9.map = nil
        l2Marker10.map = nil
        l2Marker11.map = nil
        l2Marker12.map = nil
        l2Marker13.map = nil
        l3Marker1.map = nil
        l3Marker2.map = nil
        l3Marker3.map = nil
        l3Marker4.map = nil
        l3Marker5.map = nil
        l3Marker6.map = nil
    }
    
    //MARK: Poup Delegate
    func objectPopupCloseButtonPressed() {
        self.objectPopupView.removeFromSuperview()
        if (level == levelNumber.two) {
            self.showLevelTwoMarker()
        } else {
            self.showLevelThreeMarker()
        }
    }
    //Present detail popup using Bottomsheet
    func viewDetailButtonTapAction() {
//        let objectDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "objectDetailId") as! ObjectDetailViewController
//
//        let bottomSheet = MDCBottomSheetController(contentViewController: objectDetailView)
//               bottomSheet.isScrimAccessibilityElement = true
//            bottomSheet.scrimAccessibilityLabel = "Close"
//      //  bottomSheet.trackingScrollView = objectDetailView.objectTableView
//        bottomSheet.preferredContentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
//
//        present(bottomSheet, animated: true)
    }
    @IBAction func didTapQrCode(_ sender: UIButton) {
    }
    
    @IBAction func didTapNumberSearch(_ sender: UIButton) {
//        if(fromScienceTour) {
//            let transition = CATransition()
//            transition.duration = 0.3
//            transition.type = kCATransitionPush
//            transition.subtype = kCATransitionFromLeft
//            self.view.window!.layer.add(transition, forKey: kCATransition)
//            self.dismiss(animated: false, completion: nil)
//        } else {
            let numberPadView = self.storyboard?.instantiateViewController(withIdentifier: "artifactNumberPadViewId") as! ArtifactNumberPadViewController
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = kCATransitionFade
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            self.present(numberPadView, animated: false, completion: nil)
//        }
        
    }
    
    //MARK:Header Protocol
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    func filterButtonPressed() {
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.dismiss(animated: false, completion: nil)
    }
    //Added BottomSheet for showing popup when we clicked in marker
    func addBottomSheetView(scrollable: Bool? = true) {
        overlayView.isHidden = false
        bottomSheetVC = MapDetailView()
        bottomSheetVC.mapdetailDelegate = self
        bottomSheetVC.popUpArray = floorMapArray
        self.addChildViewController(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParentViewController: self)
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
    func viewTapAction(sender: UITapGestureRecognizer) {
        if (sender.state == .began) {
            
            UIView.animate(withDuration: 1, delay: 0.0, options: [.allowUserInteraction], animations: {
                //                if  velocity.y >= 0 {
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                //                } else {
                //                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                //                }
                
            }, completion: { [weak self] _ in
                
            })
        }
    }
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        bottomSheetVC.removeFromParentViewController()
        bottomSheetVC.dismiss(animated: false, completion: nil)
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: 0, height: 0)
        overlayView.isHidden = true
        if (level == levelNumber.two) {
            showLevelTwoMarker()
            
        } else if(level == levelNumber.three) {
            showLevelThreeMarker()
        }
    }
    func dismissOvelay() {
        overlayView.isHidden = true
        if (level == levelNumber.two) {
            showLevelTwoMarker()
            
        } else if(level == levelNumber.three) {
            showLevelThreeMarker()
        }
    }
    //MARK: WebServiceCall
    func getFloorMapDataFromServer()
    {
        
        _ = Alamofire.request(QatarMuseumRouter.CollectionByTourGuide(["tour_guide_id": "12216"])).responseObject { (response: DataResponse<TourGuideFloorMaps>) -> Void in
            switch response.result {
            case .success(let data):
                self.floorMapArray = data.tourGuideFloorMap
            case .failure(let error):
                print("error")
            
                
                
            }
        }
    }

    
    
    
}

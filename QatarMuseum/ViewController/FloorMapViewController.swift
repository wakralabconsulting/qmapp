//
//  FloorMapViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 15/08/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import GoogleMaps
import UIKit
import MaterialComponents.MaterialBottomSheet

enum levelNumber{
    case one
    case two
    case three
}

class FloorMapViewController: UIViewController, GMSMapViewDelegate, ObjectPopUpProtocol, HeaderViewProtocol {
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
    }
    
    func initialSetUp() {
        if (fromScienceTour == true) {
            firstLevelView.backgroundColor = UIColor.mapLevelColor
            secondLevelView.backgroundColor = UIColor.mapLevelColor
            thirdLevelView.backgroundColor = UIColor.white
        } else {
            firstLevelView.backgroundColor = UIColor.white
            secondLevelView.backgroundColor = UIColor.mapLevelColor
            thirdLevelView.backgroundColor = UIColor.mapLevelColor
        }
        
        thirdLevelLabel.text = NSLocalizedString("LEVEL_STRING", comment: "LEVEL_STRING in floor map")
        secondLevelLabel.text = NSLocalizedString("LEVEL_STRING", comment: "LEVEL_STRING in floor map")
        firstLevelLabel.text = NSLocalizedString("LEVEL_STRING", comment: "LEVEL_STRING in floor map")
        headerView.headerViewDelegate = self
        headerView.headerTitle.text = NSLocalizedString("FLOOR_MAP_TITLE", comment: "FLOOR_MAP_TITLE  in the Floormap page")
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            
            headerView.headerBackButton.setImage(UIImage(named: "back_buttonX1"), for: .normal)
        }
        else {
            headerView.headerBackButton.setImage(UIImage(named: "back_mirrorX1"), for: .normal)
        }
    }
    
    func loadMap() {
        //let camera = GMSCameraPosition.camera(withLatitude: 25.295447, longitude: 51.539195, zoom:19)
         let camera = GMSCameraPosition.camera(withLatitude: 25.296059, longitude: 51.538703, zoom:19)
        viewForMap.camera = camera
        viewForMap?.animate(to: camera)
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
        
        overlay.anchor = CGPoint(x: 0, y: 1)
        overlay.map = self.viewForMap
        viewForMap?.camera = camera
        
        overlay.bearing = -22
        viewForMap.setMinZoom(19, maxZoom: 25)
        
        //let circleCenter = CLLocationCoordinate2DMake(25.294730,51.539021)
        let circleCenter = CLLocationCoordinate2DMake(25.296059,51.538703)
        let circ = GMSCircle(position: circleCenter, radius: 250)
        
        circ.strokeColor = UIColor.clear
        circ.map = viewForMap
        if (fromScienceTour == true) {
            viewForMap.animate(toZoom: 19.4)
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
            let markerWidth = 22 + (zoomValue-19)
            let markerHeight = 26 + (zoomValue-19)
//            showMarker(marker: l3Marker1, position: l3_atr1, titleString: "HelloWorld", imageName: "001_MIA_MW.146_005", imgWidth: Double(markerWidth), imgHeight: Double(markerHeight), zoomValue: zoomValue)
//            showMarker(marker: l3Marker2, position: l3_atr2, titleString: "HelloWorld", imageName: "GL.322-0564.2000x2000", imgWidth: Double(markerWidth), imgHeight: Double(markerHeight), zoomValue: zoomValue)
//            showMarker(marker: l3Marker3, position: l3_atr3, titleString: "HelloWorld", imageName: "HS.32-1.2000x2000", imgWidth: Double(markerWidth), imgHeight: Double(markerHeight), zoomValue: zoomValue)
//            showMarker(marker: l3Marker4, position: l3_atr4, titleString: "HelloWorld", imageName: "MS.523.1999-1.2000x2000", imgWidth: Double(markerWidth), imgHeight: Double(markerHeight), zoomValue: zoomValue)
//            showMarker(marker: l3Marker5, position: l3_atr5, titleString: "HelloWorld", imageName: "MS.688.2008.Recto-1.2000x2000", imgWidth: Double(markerWidth), imgHeight: Double(markerHeight), zoomValue: zoomValue)
//            showMarker(marker: l3Marker6, position: l3_atr6, titleString: "HelloWorld", imageName: "MS.709.2010-1.2000x2000", imgWidth: Double(markerWidth), imgHeight: Double(markerHeight), zoomValue: zoomValue)
            
            showMarker(marker: l3Marker1, position: l3_atr1, titleString: "HelloWorld", imageName: "001_MIA_MW.146_005", zoomValue: zoomValue)
            showMarker(marker: l3Marker2, position: l3_atr2, titleString: "HelloWorld", imageName: "GL.322-0564.2000x2000", zoomValue: zoomValue)
            showMarker(marker: l3Marker3, position: l3_atr3, titleString: "HelloWorld", imageName: "HS.32-1.2000x2000",zoomValue: zoomValue)
            showMarker(marker: l3Marker4, position: l3_atr4, titleString: "HelloWorld", imageName: "MS.523.1999-1.2000x2000", zoomValue: zoomValue)
            showMarker(marker: l3Marker5, position: l3_atr5, titleString: "HelloWorld", imageName: "MS.688.2008.Recto-1.2000x2000", zoomValue: zoomValue)
            showMarker(marker: l3Marker6, position: l3_atr6, titleString: "HelloWorld", imageName: "MS.709.2010-1.2000x2000", zoomValue: zoomValue)
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
            showMarker(marker: l2Marker, position: l2_atr1, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoomValue)
            showMarker(marker: l2Marker2, position: l2_atr2, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoomValue)
            showMarker(marker: l2Marker3, position: l2_atr3, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoomValue)
            showMarker(marker: l2Marker4, position: l2_atr4, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoomValue)
            showMarker(marker: l2Marker5, position: l2_atr5, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoomValue)
            showMarker(marker: l2Marker6, position: l2_atr6, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoomValue)
            showMarker(marker: l2Marker7, position: l2_atr7, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoomValue)
            showMarker(marker: l2Marker8, position: l2_atr8, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoomValue)
            showMarker(marker: l2Marker9, position: l2_atr9, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoomValue)
            showMarker(marker: l2Marker10, position: l2_atr10, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoomValue)
            showMarker(marker: l2Marker11, position: l2_atr11, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoomValue)
            showMarker(marker: l2Marker12, position: l2_atr12, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoomValue)
            showMarker(marker: l2Marker13, position: l2_atr13, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoomValue)
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
        marker.icon = self.imageWithImage(image: UIImage(named: "MS.709.2010-1.2000x2000")!, scaledToSize: CGSize(width:34, height: 40))
        loadObjectPopup()
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
            //addMarker(zoomValue: zoom)
            showMarker(marker: l2Marker, position: l2_atr1, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoom)
            showMarker(marker: l2Marker2, position: l2_atr2, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoom)
            showMarker(marker: l2Marker3, position: l2_atr3, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoom)
            showMarker(marker: l2Marker4, position: l2_atr4, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoom)
            showMarker(marker: l2Marker5, position: l2_atr5, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoom)
            showMarker(marker: l2Marker6, position: l2_atr6, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoom)
            showMarker(marker: l2Marker7, position: l2_atr7, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoom)
            showMarker(marker: l2Marker8, position: l2_atr8, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoom)
            showMarker(marker: l2Marker9, position: l2_atr9, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoom)
            showMarker(marker: l2Marker10, position: l2_atr10, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoom)
            showMarker(marker: l2Marker11, position: l2_atr11, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoom)
            showMarker(marker: l2Marker12, position: l2_atr12, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoom)
            showMarker(marker: l2Marker13, position: l2_atr13, titleString: "HelloWorld", imageName: "artifactimg", zoomValue: zoom)
        } else if(level == levelNumber.three) {
            showMarker(marker: l3Marker1, position: l3_atr1, titleString: "HelloWorld", imageName: "001_MIA_MW.146_005", zoomValue: zoom)
            showMarker(marker: l3Marker2, position: l3_atr2, titleString: "HelloWorld", imageName: "GL.322-0564.2000x2000", zoomValue: zoom)
            showMarker(marker: l3Marker3, position: l3_atr3, titleString: "HelloWorld", imageName: "HS.32-1.2000x2000", zoomValue: zoom)
            showMarker(marker: l3Marker4, position: l3_atr4, titleString: "HelloWorld", imageName: "MS.523.1999-1.2000x2000", zoomValue: zoom)
            showMarker(marker: l3Marker5, position: l3_atr5, titleString: "HelloWorld", imageName: "MS.688.2008.Recto-1.2000x2000", zoomValue: zoom)
            showMarker(marker: l3Marker6, position: l3_atr6, titleString: "HelloWorld", imageName: "MS.709.2010-1.2000x2000", zoomValue: zoom)
        }
    }
    
    func removeMarkers() {
        l2Marker2.map = nil
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
    }
    
    func viewDetailButtonTapAction() {
        let objectDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "objectDetailId") as! ObjectDetailViewController
//        let transition = CATransition()
//        transition.duration = 0.3
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromTop
//        view.window!.layer.add(transition, forKey: kCATransition)
//        self.present(objectDetailView, animated: false, completion: nil)
        
        
        //        let menu = BottomSheetTableViewMenu(style: .plain)
        //        let bottomSheet = MDCBottomSheetController(contentViewController: viewController)
        //
        //        // Present the bottom sheet
        //        present(bottomSheet, animated: true, completion: nil)
        
        let bottomSheet = MDCBottomSheetController(contentViewController: objectDetailView)
        //        bottomSheet.isScrimAccessibilityElement = true
        //        bottomSheet.scrimAccessibilityLabel = "Close"
                bottomSheet.trackingScrollView = objectDetailView.objectTableView
        bottomSheet.preferredContentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)

        present(bottomSheet, animated: true)
    }
    
    @IBAction func didTapQrCode(_ sender: UIButton) {
    }
    
    @IBAction func didTapNumberSearch(_ sender: UIButton) {
        let numberPadView = self.storyboard?.instantiateViewController(withIdentifier: "artifactNumberPadViewId") as! ArtifactNumberPadViewController
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(numberPadView, animated: false, completion: nil)
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
}

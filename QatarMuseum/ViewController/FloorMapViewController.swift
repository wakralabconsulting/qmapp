//
//  FloorMapViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 15/08/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Alamofire
import AVFoundation
import AVKit
import GoogleMaps
import Crashlytics
import UIKit
import MaterialComponents.MaterialBottomSheet

enum levelNumber{
    case one
    case two
    case three
}
enum fromTour{
    case exploreTour
    case scienceTour
    case HighlightTour
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
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playerSlider: UISlider!
    
    var bottomSheetVC:MapDetailView = MapDetailView()
    var floorMapArray: [TourGuideFloorMap]! = []
    var tourGuideArray: [TourGuideFloorMap]! = []
    var selectedScienceTour : String? = ""
    var selectedScienceTourLevel : String? = ""
    var selectedTourdGuidIndex : Int? = 0
    var selectedMarker = GMSMarker()
    var selectedMarkerImage = UIImage()
    var bounceTimerTwo = Timer()
    var bounceTimerThree = Timer()
    var playList: String = ""
    var timer: Timer?
    var avPlayer: AVPlayer!
    var isPaused: Bool!
    var firstLoad: Bool = true
    
    
    
    var overlay = GMSGroundOverlay()
    let L2_G1_SC3 = CLLocationCoordinate2D(latitude: 25.295141, longitude: 51.539185)
    let L2_G8 = CLLocationCoordinate2D(latitude: 25.295500, longitude: 51.538855)
    let L2_G8_SC1 = CLLocationCoordinate2D(latitude: 25.295468, longitude: 51.538905)
    let L2_G8_SC6_1 = CLLocationCoordinate2D(latitude: 25.295510, longitude: 51.538803)
    let L2_G8_SC6_2 = CLLocationCoordinate2D(latitude: 25.295450, longitude: 51.538830)
    let L2_G8_SC5 = CLLocationCoordinate2D(latitude: 25.295540, longitude: 51.538835)
    let L2_G8_SC4_1 = CLLocationCoordinate2D(latitude: 25.295571, longitude: 51.538840)
    let L2_G8_SC4_2 = CLLocationCoordinate2D(latitude: 25.295558, longitude: 51.538841)
    let L2_G9_SC7 = CLLocationCoordinate2D(latitude: 25.295643, longitude: 51.538895)
    let L2_G9_SC5_1 = CLLocationCoordinate2D(latitude: 25.295654, longitude: 51.538918)
    let L2_G9_SC5_2 = CLLocationCoordinate2D(latitude: 25.295652, longitude: 51.538927)
    let L2_G5_SC6 = CLLocationCoordinate2D(latitude: 25.295686, longitude: 51.539265)
   // let L2_G3_SC14 = CLLocationCoordinate2D(latitude: 25.295566, longitude: 51.539397)
    let L2_G3_SC13 = CLLocationCoordinate2D(latitude: 25.295566, longitude: 51.539429)
    
    let L3_G10_SC1_1 = CLLocationCoordinate2D(latitude: 25.295230, longitude: 51.539170)
    let L3_G10_SC1_2 = CLLocationCoordinate2D(latitude: 25.295245, longitude: 51.539210)
    let L3_G11_WR15 = CLLocationCoordinate2D(latitude: 25.295330, longitude: 51.539414)
    let L3_G13_5 = CLLocationCoordinate2D(latitude: 25.295664, longitude: 51.539330)
    let L3_G13_7 = CLLocationCoordinate2D(latitude: 25.295628, longitude: 51.539360)
    let L3_G17_3 = CLLocationCoordinate2D(latitude: 25.295505, longitude: 51.538905)
    
    
    // Highlight Tour
    let L2_G1_SC2 = CLLocationCoordinate2D(latitude: 25.295195, longitude: 51.539160);
    let L2_G1_SC7 = CLLocationCoordinate2D(latitude: 25.295215, longitude: 51.539395);
    let L2_G1_SC8 = CLLocationCoordinate2D(latitude: 25.295268, longitude: 51.539373);
    let L2_G1_SC13 = CLLocationCoordinate2D(latitude: 25.295180, longitude: 51.539248);
    let L2_G1_SC14 = CLLocationCoordinate2D(latitude: 25.295205, longitude: 51.539319);
    let L2_G2_2 = CLLocationCoordinate2D(latitude: 25.295220, longitude: 51.539450);
    let L2_G3_SC14_1 = CLLocationCoordinate2D(latitude: 25.295548, longitude: 51.539406);
    let L2_G3_SC14_2 = CLLocationCoordinate2D(latitude: 25.295580, longitude: 51.539392);
    let L2_G3_WR4 = CLLocationCoordinate2D(latitude: 25.295540, longitude: 51.539470);
    let L2_G4_SC5 = CLLocationCoordinate2D(latitude: 25.295690, longitude: 51.539312);
    let L2_G3_SC3 = CLLocationCoordinate2D(latitude: 25.295715, longitude: 51.539348);
    let L2_G5_SC5 = CLLocationCoordinate2D(latitude: 25.295715, longitude: 51.539205);
    let L2_G5_SC11 = CLLocationCoordinate2D(latitude: 25.295735, longitude: 51.539225);
    let L2_G7_SC13 = CLLocationCoordinate2D(latitude: 25.295395, longitude: 51.538915);
    let L2_G7_SC8 = CLLocationCoordinate2D(latitude: 25.295345, longitude: 51.538880);
    let L2_G7_SC4 = CLLocationCoordinate2D(latitude: 25.295450, longitude: 51.538908);
    
    let L3_G10_WR2_1 = CLLocationCoordinate2D(latitude: 25.295130, longitude: 51.539217);
    let L3_G10_WR2_2 = CLLocationCoordinate2D(latitude: 25.295138, longitude: 51.539240);
    let L3_G10_PODIUM14 = CLLocationCoordinate2D(latitude: 25.295188, longitude: 51.539240);
    let L3_G10_PODIUM9 = CLLocationCoordinate2D(latitude: 25.295222, longitude: 51.539333);
    let L3_G11_14 = CLLocationCoordinate2D(latitude: 25.295392, longitude: 51.539495);
    let L3_G12_11 = CLLocationCoordinate2D(latitude: 25.295530, longitude: 51.539390);
    let L3_G12_12 = CLLocationCoordinate2D(latitude: 25.295492, longitude: 51.539405);
    let L3_G12_17 = CLLocationCoordinate2D(latitude: 25.295480, longitude: 51.539440);
    let L3_G12_WR5 = CLLocationCoordinate2D(latitude: 25.295540, longitude: 51.539470);
    let L3_G13_2 = CLLocationCoordinate2D(latitude: 25.295690, longitude: 51.539402);
    let L3_G13_15 = CLLocationCoordinate2D(latitude: 25.295660, longitude: 51.539375);
    let L3_G14_7 = CLLocationCoordinate2D(latitude: 25.295693, longitude: 51.539270);
    let L3_G14_13 = CLLocationCoordinate2D(latitude: 25.295723, longitude: 51.539225);
    let L3_G15_13 = CLLocationCoordinate2D(latitude: 25.295150, longitude: 51.539135);
    let L3_G16_WR5 = CLLocationCoordinate2D(latitude: 25.295444, longitude: 51.538955);
    let L3_G17_8 = CLLocationCoordinate2D(latitude: 25.295504, longitude: 51.538880);
    let L3_G17_9 = CLLocationCoordinate2D(latitude: 25.295490, longitude: 51.538850);
    let L3_G18_1 = CLLocationCoordinate2D(latitude: 25.295555, longitude: 51.538892);
    let L3_G18_2 = CLLocationCoordinate2D(latitude: 25.295557, longitude: 51.538906);
    let L3_G18_11 = CLLocationCoordinate2D(latitude: 25.295613, longitude: 51.538914);
    
    let l2_g1_sc3 = GMSMarker()
    let l2_g8 = GMSMarker()
    let l2_g8_sc1 = GMSMarker()
    let l2_g8_sc6_1 = GMSMarker()
    let l2_g8_sc6_2 = GMSMarker()
    let l2_g8_sc5 = GMSMarker()
    let l2_g8_sc4_1 = GMSMarker()
    let l2_g8_sc4_2 = GMSMarker()
    let l2_g9_sc7 = GMSMarker()
    let l2_g9_sc5_1 = GMSMarker()
    let l2_g9_sc5_2 = GMSMarker()
    let l2_g5_sc6 = GMSMarker()
    let l2_g3_sc13 = GMSMarker()
    let l3_g10_sc1_1 = GMSMarker()
    let l3_g10_sc1_2 = GMSMarker()
    let l3_g11_wr15 = GMSMarker()
    let l3_g13_5 = GMSMarker()
    let l3_g13_7 = GMSMarker()
    let l3_g17_3 = GMSMarker()
    
    //Highligh Marker
    let l2_g1_sc2 = GMSMarker()
    let l2_g1_sc7 = GMSMarker()
    let l2_g1_sc8 = GMSMarker()
    let l2_g1_sc13 = GMSMarker()
    let l2_g1_sc14 = GMSMarker()
    let l2_g2_2 = GMSMarker()
    let l2_g3_sc14_1 = GMSMarker()
    let l2_g3_sc14_2 = GMSMarker()
    let l2_g3_wr4 = GMSMarker()
    let l2_g4_sc5 = GMSMarker()
    let l2_g3_sc3 = GMSMarker()
    let l2_g5_sc5 = GMSMarker()
    let l2_g5_sc11 = GMSMarker()
    let l2_g7_sc13 = GMSMarker()
    let l2_g7_sc8 = GMSMarker()
    let l2_g7_sc4 = GMSMarker()
    
    let l3_g10_wr2_1 = GMSMarker()
    let l3_g10_wr2_2 = GMSMarker()
    let l3_g10_podium14 = GMSMarker()
    let l3_g10_podium9 = GMSMarker()
    let l3_g11_14 = GMSMarker()
    let l3_g12_11 = GMSMarker()
    let l3_g12_12 = GMSMarker()
    let l3_g12_17 = GMSMarker()
    let l3_g12_wr5 = GMSMarker()
    let l3_g13_2 = GMSMarker()
    let l3_g13_15 = GMSMarker()
    let l3_g14_7 = GMSMarker()
    let l3_g14_13 = GMSMarker()
    let l3_g15_13 = GMSMarker()
    let l3_g16_wr5 = GMSMarker()
    let l3_g17_8 = GMSMarker()
    let l3_g17_9 = GMSMarker()
    let l3_g18_1 = GMSMarker()
    let l3_g18_2 = GMSMarker()
    let l3_g18_11 = GMSMarker()
    
    
    var objectPopupView : ObjectPopupView = ObjectPopupView()
    var level : levelNumber?
    var zoomValue = Float()
   // var fromScienceTour : Bool = false
    var fromTourString : fromTour?
    override func viewDidLoad() {
        super.viewDidLoad()

        viewForMap.delegate = self
        loadMap()
        initialSetUp()
        getFloorMapDataFromServer()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        bottomSheetVC.removeFromParentViewController()
        bottomSheetVC.dismiss(animated: false, completion: nil)
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
        if (fromTourString == fromTour.scienceTour) {
            
            if (selectedScienceTourLevel == "1"){
                playButton.isHidden = false
                playerSlider.isHidden = false
            }
            if(selectedScienceTourLevel == "2") {
                firstLevelView.backgroundColor = UIColor.mapLevelColor
                secondLevelView.backgroundColor = UIColor.white
                thirdLevelView.backgroundColor = UIColor.mapLevelColor
                
                playButton.isHidden = true
                playerSlider.isHidden = true
            } else {
                firstLevelView.backgroundColor = UIColor.mapLevelColor
                secondLevelView.backgroundColor = UIColor.mapLevelColor
                thirdLevelView.backgroundColor = UIColor.white
                
                playButton.isHidden = true
                playerSlider.isHidden = true
            }
            
            
            
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
            numberSerchBtn.isHidden = false
            numberSerchBtn.setImage(UIImage(named: "number_padX1"), for: .normal)
            headerView.headerBackButton.isHidden = false
            playButton.isHidden = false
            playerSlider.isHidden = false
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
        if (fromTourString == fromTour.scienceTour) {
            if(selectedScienceTourLevel == "3") {
                level = levelNumber.three
                icon = UIImage(named: "qm_level_3")!
                viewForMap.animate(toZoom: 19.5)
            } else {
                level = levelNumber.two
                icon = UIImage(named: "qm_level_2")!
                viewForMap.animate(toZoom: 19.5)
            }
            
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
        
        if (fromTourString == fromTour.scienceTour) {
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
        if (zoomValue > 18) {
            l2_g1_sc3.position = L2_G1_SC3
            l2_g1_sc3.title = "l2_g1_sc3"
            l2_g1_sc3.snippet = ""
            l2_g1_sc3.icon = UIImage(named: "SI.5.1999.Front.2000x2000")
            if((fromTourString == fromTour.scienceTour) && (selectedScienceTour == "l2_g1_sc3")) {
                l2_g1_sc3.icon = self.imageWithImage(image: UIImage(named: "SI.5.1999.Front.2000x2000")!, scaledToSize: CGSize(width:54, height: 64))
                self.setMarkerBounce()
                selectedMarker = l2_g1_sc3
                selectedMarkerImage = UIImage(named: "SI.5.1999.Front.2000x2000")!
            } else {
                l2_g1_sc3.icon = self.imageWithImage(image: UIImage(named: "SI.5.1999.Front.2000x2000")!, scaledToSize: CGSize(width:38, height: 44))
            }
            
            l2_g1_sc3.appearAnimation = .pop
            l2_g1_sc3.map = viewForMap
            
            l2_g8.position = L2_G8
            l2_g8.title = "l2_g8"
            l2_g8.snippet = ""
            //l2_g8.icon = UIImage(named: "MS.523.1999-1.2000x2000")
            if((fromTourString == fromTour.scienceTour) && (selectedScienceTour == "l2_g8")) {
                l2_g8.icon = self.imageWithImage(image: UIImage(named: "MS.523.1999-1.2000x2000")!, scaledToSize: CGSize(width:54, height: 64))
                self.setMarkerBounce()
                selectedMarker = l2_g8
                selectedMarkerImage = UIImage(named: "MS.523.1999-1.2000x2000")!
            } else {
                l2_g8.icon = self.imageWithImage(image: UIImage(named: "MS.523.1999-1.2000x2000")!, scaledToSize: CGSize(width:38, height: 44))
            }
            
            l2_g8.appearAnimation = .pop
            l2_g8.map = viewForMap
            
            l2_g8_sc1.position = L2_G8_SC1
            l2_g8_sc1.title = "l2_g8_sc1"
            l2_g8_sc1.snippet = ""
            if((fromTourString == fromTour.scienceTour) && (selectedScienceTour == "l2_g8_sc1")) {
                l2_g8_sc1.icon = self.imageWithImage(image: UIImage(named: "MW_548")!, scaledToSize: CGSize(width:58, height: 64))
                self.setMarkerBounce()
                selectedMarker = l2_g8_sc1
                selectedMarkerImage = UIImage(named: "MW_548")!
            } else {
                l2_g8_sc1.icon = self.imageWithImage(image: UIImage(named: "MW_548")!, scaledToSize: CGSize(width:38, height: 44))
            }
            
            l2_g8_sc1.appearAnimation = .pop
            l2_g8_sc1.map = viewForMap
            
            l2_g8_sc6_1.position = L2_G8_SC6_1
            l2_g8_sc6_1.title = "l2_g8_sc6_1"
            l2_g8_sc6_1.snippet = ""
            if((fromTourString == fromTour.scienceTour) && (selectedScienceTour == "l2_g8_sc6_1")) {
                l2_g8_sc6_1.icon = self.imageWithImage(image: UIImage(named: "MS.709.2010-1.2000x2000")!, scaledToSize: CGSize(width:54, height: 64))
                self.setMarkerBounce()
                selectedMarker = l2_g8_sc6_1
                selectedMarkerImage = UIImage(named: "MS.709.2010-1.2000x2000")!
            } else {
                l2_g8_sc6_1.icon = self.imageWithImage(image: UIImage(named: "MS.709.2010-1.2000x2000")!, scaledToSize: CGSize(width:38, height: 44))
            }
            
            l2_g8_sc6_1.appearAnimation = .pop
            l2_g8_sc6_1.map = viewForMap
            
            l2_g8_sc6_2.position = L2_G8_SC6_2
            l2_g8_sc6_2.title = "l2_g8_sc6_2"
            l2_g8_sc6_2.snippet = ""
            if((fromTourString == fromTour.scienceTour) && (selectedScienceTour == "l2_g8_sc6_2")) {
                l2_g8_sc6_2.icon = self.imageWithImage(image: UIImage(named: "MS.709.2010-2")!, scaledToSize: CGSize(width:54, height: 64))
                self.setMarkerBounce()
                selectedMarker = l2_g8_sc6_2
                selectedMarkerImage = UIImage(named: "MS.709.2010-2")!
            } else {
                l2_g8_sc6_2.icon = self.imageWithImage(image: UIImage(named: "MS.709.2010-2")!, scaledToSize: CGSize(width:38, height: 44))
            }
            
            l2_g8_sc6_2.appearAnimation = .pop
            l2_g8_sc6_2.map = viewForMap
            
            l2_g8_sc5.position = L2_G8_SC5
            l2_g8_sc5.title = "l2_g8_sc5"
            l2_g8_sc5.snippet = ""
            if((fromTourString == fromTour.scienceTour) && (selectedScienceTour == "l2_g8_sc5")) {
                l2_g8_sc5.icon = self.imageWithImage(image: UIImage(named: "MW.361.2007.2000x2000")!, scaledToSize: CGSize(width:54, height: 64))
                self.setMarkerBounce()
                selectedMarker = l2_g8_sc5
                selectedMarkerImage = UIImage(named: "MW.361.2007.2000x2000")!
            } else {
                l2_g8_sc5.icon = self.imageWithImage(image: UIImage(named: "MW.361.2007.2000x2000")!, scaledToSize: CGSize(width:38, height: 44))
            }
            
            l2_g8_sc5.appearAnimation = .pop
            l2_g8_sc5.map = viewForMap
            
            l2_g8_sc4_1.position = L2_G8_SC4_1
            l2_g8_sc4_1.title = "l2_g8_sc4_1"
            l2_g8_sc4_1.snippet = ""
            if((fromTourString == fromTour.scienceTour) && (selectedScienceTour == "l2_g8_sc4_1")) {
                l2_g8_sc4_1.icon = self.imageWithImage(image: UIImage(named: "MS.688.2008.Recto-1.2000x2000")!, scaledToSize: CGSize(width:54, height: 64))
                self.setMarkerBounce()
                selectedMarker = l2_g8_sc4_1
                selectedMarkerImage = UIImage(named: "MS.688.2008.Recto-1.2000x2000")!
            } else {
                l2_g8_sc4_1.icon = self.imageWithImage(image: UIImage(named: "MS.688.2008.Recto-1.2000x2000")!, scaledToSize: CGSize(width:38, height: 44))
            }
            
            l2_g8_sc4_1.appearAnimation = .pop
            l2_g8_sc4_1.map = viewForMap
            
            l2_g8_sc4_2.position = L2_G8_SC4_2
            l2_g8_sc4_2.title = "l2_g8_sc4_2"
            l2_g8_sc4_2.snippet = ""
            if((fromTourString == fromTour.scienceTour) && (selectedScienceTour == "l2_g8_sc4_2")) {
                l2_g8_sc4_2.icon = self.imageWithImage(image: UIImage(named: "MS.650 .1 recto-1")!, scaledToSize: CGSize(width:54, height: 64))
                self.setMarkerBounce()
                selectedMarker = l2_g8_sc4_2
                selectedMarkerImage = UIImage(named: "MS.650 .1 recto-1")!
            } else {
                l2_g8_sc4_2.icon = self.imageWithImage(image: UIImage(named: "MS.650 .1 recto-1")!, scaledToSize: CGSize(width:38, height: 44))
            }
            
            l2_g8_sc4_2.appearAnimation = .pop
            l2_g8_sc4_2.map = viewForMap
            
            l2_g9_sc7.position = L2_G9_SC7
            l2_g9_sc7.title = "l2_g9_sc7"
            l2_g9_sc7.snippet = ""
            if((fromTourString == fromTour.scienceTour) && (selectedScienceTour == "l2_g9_sc7")) {
                l2_g9_sc7.icon = self.imageWithImage(image: UIImage(named: "001_MIA_MW.146_005")!, scaledToSize: CGSize(width:54, height: 64))
                self.setMarkerBounce()
                selectedMarker = l2_g9_sc7
                selectedMarkerImage = UIImage(named: "001_MIA_MW.146_005")!
            } else {
                l2_g9_sc7.icon = self.imageWithImage(image: UIImage(named: "001_MIA_MW.146_005")!, scaledToSize: CGSize(width:38, height: 44))
            }
            
            l2_g9_sc7.appearAnimation = .pop
            l2_g9_sc7.map = viewForMap
            
            l2_g9_sc5_1.position = L2_G9_SC5_1
            l2_g9_sc5_1.title = "l2_g9_sc5_1"
            l2_g9_sc5_1.snippet = ""
            if((fromTourString == fromTour.scienceTour) && (selectedScienceTour == "l2_g9_sc5_1")) {
                l2_g9_sc5_1.icon = self.imageWithImage(image: UIImage(named: "MW.340.Front.2000x2000")!, scaledToSize: CGSize(width:54, height: 64))
                self.setMarkerBounce()
                selectedMarker = l2_g9_sc5_1
                selectedMarkerImage = UIImage(named: "MW.340.Front.2000x2000")!
            } else {
                l2_g9_sc5_1.icon = self.imageWithImage(image: UIImage(named: "MW.340.Front.2000x2000")!, scaledToSize: CGSize(width:38, height: 44))
            }
            
            l2_g9_sc5_1.appearAnimation = .pop
            l2_g9_sc5_1.map = viewForMap
            
            l2_g9_sc5_2.position = L2_G9_SC5_2
            l2_g9_sc5_2.title = "l2_g9_sc5_2"
            l2_g9_sc5_2.snippet = ""
            if((fromTourString == fromTour.scienceTour) && (selectedScienceTour == "l2_g9_sc5_2")) {
                l2_g9_sc5_2.icon = self.imageWithImage(image: UIImage(named: "MS.794-1")!, scaledToSize: CGSize(width:54, height: 64))
                self.setMarkerBounce()
                selectedMarker = l2_g9_sc5_2
                selectedMarkerImage = UIImage(named: "MS.794-1")!
            } else {
                l2_g9_sc5_2.icon = self.imageWithImage(image: UIImage(named: "MS.794-1")!, scaledToSize: CGSize(width:38, height: 44))
            }
            
            l2_g9_sc5_2.appearAnimation = .pop
            l2_g9_sc5_2.map = viewForMap
            
            l2_g5_sc6.position = L2_G5_SC6
            l2_g5_sc6.title = "l2_g5_sc6"
            l2_g5_sc6.snippet = ""
            if((fromTourString == fromTour.scienceTour) && (selectedScienceTour == "l2_g5_sc6")) {
                l2_g5_sc6.icon = self.imageWithImage(image: UIImage(named: "MW_56")!, scaledToSize: CGSize(width:54, height: 64))
                self.setMarkerBounce()
                selectedMarker = l2_g5_sc6
                selectedMarkerImage = UIImage(named: "MW_56")!
            } else {
                l2_g5_sc6.icon = self.imageWithImage(image: UIImage(named: "MW_56")!, scaledToSize: CGSize(width:38, height: 44))
            }
            
            l2_g5_sc6.appearAnimation = .pop
            l2_g5_sc6.map = viewForMap
            
            l2_g3_sc13.position = L2_G3_SC13
            l2_g3_sc13.title = "l2_g3_sc13"
            l2_g3_sc13.snippet = ""
            if((fromTourString == fromTour.scienceTour) && (selectedScienceTour == "l2_g3_sc13")) {
                l2_g3_sc13.icon = self.imageWithImage(image: UIImage(named: "MW.634-EMu.2000x2000")!, scaledToSize: CGSize(width:54, height: 64))
                self.setMarkerBounce()
                selectedMarker = l2_g3_sc13
                selectedMarkerImage = UIImage(named: "MW.634-EMu.2000x2000")!
            } else {
                l2_g3_sc13.icon = self.imageWithImage(image: UIImage(named: "MW.634-EMu.2000x2000")!, scaledToSize: CGSize(width:38, height: 44))
            }
            
            l2_g3_sc13.appearAnimation = .pop
            l2_g3_sc13.map = viewForMap
            
            
        } else {
            l2_g1_sc3.map = nil
            l2_g8.map = nil
            l2_g8_sc1.map = nil
            l2_g8_sc6_1.map = nil
            l2_g8_sc6_2.map = nil
            l2_g8_sc5.map = nil
            l2_g8_sc4_1.map = nil
            l2_g8_sc4_2.map = nil
            l2_g9_sc7.map = nil
            l2_g9_sc5_1.map = nil
            l2_g9_sc5_2.map = nil
            l2_g5_sc6.map = nil
            l2_g3_sc13.map = nil
        }
    }
    //Function for show level 3 marker
    func showLevelThreeMarker() {
        if (zoomValue > 18) {
            l3_g10_sc1_1.position = L3_G10_SC1_1
            l3_g10_sc1_1.title = "l3_g10_sc1_1"
            l3_g10_sc1_1.snippet = "PO.297"
            if((fromTourString == fromTour.scienceTour) && (selectedScienceTour == "l3_g10_sc1_1")) {
                l3_g10_sc1_1.icon = imageWithImage(image: UIImage(named: "PO.297.2006.1.2000x2000")!, scaledToSize: CGSize(width:54, height: 64))
                setMarkerBounce()
                selectedMarker = l3_g10_sc1_1
                selectedMarkerImage = UIImage(named: "PO.297.2006.1.2000x2000")!
                
            } else {
                
               l3_g10_sc1_1.icon = imageWithImage(image: UIImage(named: "PO.297.2006.1.2000x2000")!, scaledToSize: CGSize(width:38, height: 44))
                
            }
            
            l3_g10_sc1_1.appearAnimation = .pop
            l3_g10_sc1_1.map = viewForMap
            
            l3_g10_sc1_2.position = L3_G10_SC1_2
            l3_g10_sc1_2.title = "l3_g10_sc1_2"
            l3_g10_sc1_2.snippet = ""
            if((fromTourString == fromTour.scienceTour) && (selectedScienceTour == "l3_g10_sc1_2")) {
                l3_g10_sc1_2.icon = self.imageWithImage(image: UIImage(named: "PO.308")!, scaledToSize: CGSize(width:54, height: 64))
                setMarkerBounce()
                selectedMarker = l3_g10_sc1_2
                selectedMarkerImage = UIImage(named: "PO.308")!
            } else {
                l3_g10_sc1_2.icon = self.imageWithImage(image: UIImage(named: "PO.308")!, scaledToSize: CGSize(width:38, height: 44))
            }
            
            l3_g10_sc1_2.appearAnimation = .pop
            l3_g10_sc1_2.map = viewForMap
            
            l3_g11_wr15.position = L3_G11_WR15
            l3_g11_wr15.title = "l3_g11_wr15"
            l3_g11_wr15.snippet = ""
            if((fromTourString == fromTour.scienceTour) && (selectedScienceTour == "l3_g11_wr15")) {
                l3_g11_wr15.icon = self.imageWithImage(image: UIImage(named: "MS.647.A-59")!, scaledToSize: CGSize(width:54, height: 64))
                setMarkerBounce()
                selectedMarker = l3_g11_wr15
                selectedMarkerImage = UIImage(named: "MS.647.A-59")!
            } else {
                l3_g11_wr15.icon = self.imageWithImage(image: UIImage(named: "MS.647.A-59")!, scaledToSize: CGSize(width:38, height: 44))
            }
            
            l3_g11_wr15.appearAnimation = .pop
            l3_g11_wr15.map = viewForMap
            
            l3_g13_5.position = L3_G13_5
            l3_g13_5.title = "l3_g13_5"
            l3_g13_5.snippet = ""
            if((fromTourString == fromTour.scienceTour) && (selectedScienceTour == "l3_g13_5")) {
                l3_g13_5.icon = self.imageWithImage(image: UIImage(named: "GL.322-0564.2000x2000")!, scaledToSize: CGSize(width:54, height: 64))
                setMarkerBounce()
                selectedMarker = l3_g13_5
                selectedMarkerImage = UIImage(named: "GL.322-0564.2000x2000")!
            } else {
                l3_g13_5.icon = self.imageWithImage(image: UIImage(named: "GL.322-0564.2000x2000")!, scaledToSize: CGSize(width:38, height: 44))
            }
            
            l3_g13_5.appearAnimation = .pop
            l3_g13_5.map = viewForMap
            
            l3_g13_7.position = L3_G13_7
            l3_g13_7.title = "l3_g13_7"
            l3_g13_7.snippet = ""
            if((fromTourString == fromTour.scienceTour) && (selectedScienceTour == "l3_g13_7")) {
                l3_g13_7.icon = self.imageWithImage(image: UIImage(named: "HS.32-1.2000x2000")!, scaledToSize: CGSize(width:54, height: 64))
                setMarkerBounce()
                selectedMarker = l3_g13_7
                selectedMarkerImage = UIImage(named: "HS.32-1.2000x2000")!
                
            } else {
                l3_g13_7.icon = self.imageWithImage(image: UIImage(named: "HS.32-1.2000x2000")!, scaledToSize: CGSize(width:38, height: 44))
            }
            
            l3_g13_7.appearAnimation = .pop
            l3_g13_7.map = viewForMap
            
            l3_g17_3.position = L3_G17_3
            l3_g17_3.title = "l3_g17_3"
            l3_g17_3.snippet = ""
            if((fromTourString == fromTour.scienceTour) && (selectedScienceTour == "l3_g17_3")) {
                l3_g17_3.icon = self.imageWithImage(image: UIImage(named: "IV_61")!, scaledToSize: CGSize(width:54, height: 64))
                self.setMarkerBounce()
                selectedMarker = l3_g17_3
                selectedMarkerImage = UIImage(named: "IV_61")!
            } else {
                l3_g17_3.icon = self.imageWithImage(image: UIImage(named: "IV_61")!, scaledToSize: CGSize(width:38, height: 44))
            }
            
            l3_g17_3.appearAnimation = .pop
            l3_g17_3.map = viewForMap
            
            
            
        } else {
            l3_g10_sc1_1.map = nil
            l3_g10_sc1_2.map = nil
            l3_g11_wr15.map = nil
            l3_g13_5.map = nil
            l3_g13_7.map = nil
            l3_g17_3.map = nil
        }
    }
   
     func setMarkerBounce() {
        
        
        bounceTimerTwo = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(settMarkerSmall),
                                         userInfo: nil,
                                         repeats: true)
        bounceTimerThree = Timer.scheduledTimer(timeInterval: 1.2,
                                         target: self,
                                         selector: #selector(FloorMapViewController.highlightMarker),
                                         userInfo: nil,
                                         repeats: true)
    }
    @objc func highlightMarker() {
        selectedMarker.icon = self.imageWithImage(image: selectedMarkerImage, scaledToSize: CGSize(width:54, height: 64))
    }
    @objc func settMarkerSmall() {
        selectedMarker.icon = self.imageWithImage(image: selectedMarkerImage, scaledToSize: CGSize(width:38, height: 44))
    }
    func showMarker(marker:GMSMarker,position: CLLocationCoordinate2D,titleString: String,imageName:String, zoomValue : Float){
        if (zoomValue > 18) {
            marker.position = position
            marker.title = titleString
            marker.snippet = ""
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
        
        
        playButton.isHidden = true
        playerSlider.isHidden = true
        level = levelNumber.three
        firstLevelView.backgroundColor = UIColor.mapLevelColor
        secondLevelView.backgroundColor = UIColor.mapLevelColor
        thirdLevelView.backgroundColor = UIColor.white
        overlay.icon = UIImage(named: "qm_level_3")
        removeMarkers()
        
        if (zoomValue > 18) {
            showLevelThreeMarker()
        }
    }
    
    @IBAction func didtapSecondbutton(_ sender: UIButton) {
        playButton.isHidden = true
        playerSlider.isHidden = true
        level = levelNumber.two
        firstLevelView.backgroundColor = UIColor.mapLevelColor
        secondLevelView.backgroundColor = UIColor.white
        thirdLevelView.backgroundColor = UIColor.mapLevelColor
        overlay.icon = UIImage(named: "qm_level_2")
        removeMarkers()
        if (zoomValue > 18) {
            showLevelTwoMarker()
        }
    }
    
    @IBAction func didTapFirstButton(_ sender: UIButton) {
        playButton.isHidden = false
        playerSlider.isHidden = false
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
        let searchstring = marker.title
        selectedScienceTourLevel = ""
        if (level == levelNumber.two) {
            showLevelTwoMarker()
        }
        else if (level == levelNumber.three){
            showLevelThreeMarker()
        }
        marker.appearAnimation = .pop
        
//        UIView.animate(withDuration: 0.6, animations: { [weak self] in
//            marker.icon = self?.imageWithImage(image: markerIcon!, scaledToSize: CGSize(width:52, height: 62))
//            })
        //loadObjectPopup()
       
        if let arrayOffset = floorMapArray.index(where: {$0.artifactPosition == searchstring}) {
            self.setMarkerBounce()
            selectedMarker = marker
            selectedMarkerImage = markerIcon!
            addBottomSheetView(index: arrayOffset)
        }

        
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
        l2_g1_sc3.map = nil
        l2_g8.map = nil
        l2_g8_sc1.map = nil
        l2_g8_sc6_1.map = nil
        l2_g8_sc6_2.map = nil
        l2_g8_sc5.map = nil
        l2_g8_sc4_1.map = nil
        l2_g8_sc4_2.map = nil
        l2_g9_sc7.map = nil
        l2_g9_sc5_1.map = nil
        l2_g9_sc5_2.map = nil
        l2_g5_sc6.map = nil
        l2_g3_sc13.map = nil
        l3_g10_sc1_1.map = nil
        l3_g10_sc1_2.map = nil
        l3_g11_wr15.map = nil
        l3_g13_5.map = nil
        l3_g13_7.map = nil
        l3_g17_3.map = nil
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
        self.avPlayer = nil
        self.timer?.invalidate()
        self.dismiss(animated: false, completion: nil)
    }
    func filterButtonPressed() {
        self.avPlayer = nil
        self.timer?.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
    //Added BottomSheet for showing popup when we clicked in marker
    func addBottomSheetView(scrollable: Bool? = true,index: Int?) {
        overlayView.isHidden = false
        self.avPlayer = nil
        self.timer?.invalidate()
        bottomSheetVC = MapDetailView()
        bottomSheetVC.mapdetailDelegate = self
        bottomSheetVC.popUpArray = floorMapArray
        bottomSheetVC.selectedIndex = index
        self.addChildViewController(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParentViewController: self)
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }

    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        bottomSheetVC.removeFromParentViewController()
        bottomSheetVC.dismiss(animated: false, completion: nil)
        selectedScienceTour = ""
        
        bounceTimerTwo.invalidate()
        bounceTimerThree.invalidate()
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
        selectedScienceTour = ""
        bounceTimerTwo.invalidate()
        bounceTimerThree.invalidate()
        
        if (level == levelNumber.two) {
            showLevelTwoMarker()
            
        } else if(level == levelNumber.three) {
            showLevelThreeMarker()
        }
    }
    //MARK: Audio SetUp
    func play(url:URL) {
        self.avPlayer = AVPlayer(playerItem: AVPlayerItem(url: url))
        if #available(iOS 10.0, *) {
            self.avPlayer.automaticallyWaitsToMinimizeStalling = false
        }
        avPlayer!.volume = 1.0
        avPlayer.play()
    }
    @IBAction func playButtonClicked(_ sender: UIButton) {
        if (firstLoad == true) {
            self.playList = "http://www.qm.org.qa/sites/default/files/floors.mp3"
            self.play(url: URL(string:self.playList)!)
            self.setupTimer()
        }
        firstLoad = false
        
            self.togglePlayPause()
    }
    
    func togglePlayPause() {
        if #available(iOS 10.0, *) {
            if avPlayer.timeControlStatus == .playing  {
                playButton.setImage(UIImage(named:"play_blackX1"), for: .normal)
                avPlayer.pause()
                isPaused = true
            } else {
                playButton.setImage(UIImage(named:"pause_blackX1"), for: .normal)
                avPlayer.play()
                isPaused = false
            }
        } else {
            if((avPlayer.rate != 0) && (avPlayer.error == nil)) {
                playButton.setImage(UIImage(named:"play_blackX1"), for: .normal)
                avPlayer.pause()
                isPaused = true
            } else {
                playButton.setImage(UIImage(named:"pause_blackX1"), for: .normal)
                avPlayer.play()
                isPaused = false
            }
        }
    }
    @IBAction func sliderValueChange(_ sender: UISlider) {
        if(firstLoad) {
            self.playList = "http://www.qm.org.qa/sites/default/files/floors.mp3"
            self.avPlayer = AVPlayer(playerItem: AVPlayerItem(url: URL(string: playList)!))
        }
        let seconds : Int64 = Int64(sender.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        avPlayer!.seek(to: targetTime)
        if(isPaused == false){
            //seekLoadingLabel.alpha = 1
        }
    }
//    @IBAction func sliderTapped(_ sender: UILongPressGestureRecognizer) {
//        if let slider = sender.view as? UISlider {
//            if slider.isHighlighted { return }
//            let point = sender.location(in: slider)
//            let percentage = Float(point.x / slider.bounds.width)
//            let delta = percentage * (slider.maximumValue - slider.minimumValue)
//            let value = slider.minimumValue + delta
//            slider.setValue(value, animated: false)
//            let seconds : Int64 = Int64(value)
//            let targetTime:CMTime = CMTimeMake(seconds, 1)
//            avPlayer!.seek(to: targetTime)
//            if(isPaused == false){
//               // seekLoadingLabel.alpha = 1
//            }
//        }
//    }
    func setupTimer(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.didPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        timer = Timer(timeInterval: 0.001, target: self, selector: #selector(FloorMapViewController.tick), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    @objc func didPlayToEnd() {
       // self.nextTrack()
    }
    
    @objc func tick(){
        if(avPlayer.currentTime().seconds == 0.0){
           // loadingLabel.alpha = 1
        }else{
            //loadingLabel.alpha = 0
        }
        
        if(isPaused == false){
            if(avPlayer.rate == 0){
                avPlayer.play()
               // seekLoadingLabel.alpha = 1
            }else{
                //seekLoadingLabel.alpha = 0
            }
        }
        
        if((avPlayer.currentItem?.asset.duration) != nil){
            let currentTime1 : CMTime = (avPlayer.currentItem?.asset.duration)!
            let seconds1 : Float64 = CMTimeGetSeconds(currentTime1)
            let time1 : Float = Float(seconds1)
            playerSlider.minimumValue = 0
            playerSlider.maximumValue = time1
            let currentTime : CMTime = (self.avPlayer?.currentTime())!
            let seconds : Float64 = CMTimeGetSeconds(currentTime)
            let time : Float = Float(seconds)
            self.playerSlider.value = time
           // timeLabel.text =  self.formatTimeFromSeconds(totalSeconds: Int32(Float(Float64(CMTimeGetSeconds((self.avPlayer?.currentItem?.asset.duration)!)))))
            //currentTimeLabel.text = self.formatTimeFromSeconds(totalSeconds: Int32(Float(Float64(CMTimeGetSeconds((self.avPlayer?.currentItem?.currentTime())!)))))
            
        }else{
            playerSlider.value = 0
            playerSlider.minimumValue = 0
            playerSlider.maximumValue = 0
            //timeLabel.text = "Live stream \(self.formatTimeFromSeconds(totalSeconds: Int32(CMTimeGetSeconds((avPlayer.currentItem?.currentTime())!))))"
        }
    }
    func formatTimeFromSeconds(totalSeconds: Int32) -> String {
        let seconds: Int32 = totalSeconds%60
        let minutes: Int32 = (totalSeconds/60)%60
        let hours: Int32 = totalSeconds/3600
        return String(format: "%02d:%02d:%02d", hours,minutes,seconds)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true) {
            self.avPlayer = nil
            self.timer?.invalidate()
        }
    }
    
    //MARK: WebServiceCall
    func getFloorMapDataFromServer()
    {
        var tourGuideId : String? = ""
        if (fromTourString == fromTour.scienceTour) {
            tourGuideId = "12216"
        } else {
            //tourGuideId = "12476"
            //tourGuideId = "12216"
            //Highlight 12471
        }
        
        _ = Alamofire.request(QatarMuseumRouter.CollectionByTourGuide(["tour_guide_id": tourGuideId!])).responseObject { (response: DataResponse<TourGuideFloorMaps>) -> Void in
            switch response.result {
            case .success(let data):
                self.floorMapArray = data.tourGuideFloorMap
                if(self.fromTourString == fromTour.scienceTour) {
                    self.addBottomSheetView(index: self.selectedTourdGuidIndex)
                }
            case .failure(let error):
                print("error")
            
                
                
            }
        }
    }

    
    
    
}
extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

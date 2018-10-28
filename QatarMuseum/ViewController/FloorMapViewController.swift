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
import Crashlytics
import CoreData
import GoogleMaps
import UIKit

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
//fetchTourGuideFromCoredata

class FloorMapViewController: UIViewController, GMSMapViewDelegate, ObjectPopUpProtocol, HeaderViewProtocol,UIGestureRecognizerDelegate,MapDetailProtocol,LoadingViewProtocol {
    
    
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
    
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var seekLoadingLabel: UILabel!
    var bottomSheetVC:MapDetailView = MapDetailView()
    var floorMapArray: [TourGuideFloorMap]! = []
    //var tourGuideArray: [TourGuideFloorMap]! = []
    var selectedScienceTour : String? = ""
    var selectedScienceTourLevel : String? = ""
    var selectedTourdGuidIndex : Int? = 0
    var selectednid : String? = ""
    var selectedMarker = GMSMarker()
    var selectedMarkerImage = UIImage()
    var bounceTimerTwo = Timer()
    var bounceTimerThree = Timer()
    var playList: String = ""
    var timer: Timer?
    var avPlayer: AVPlayer!
    var isPaused: Bool!
    var firstLoad: Bool = true
    var levelTwoPositionArray = NSArray()
    var levelTwoMarkerArray = NSArray()
    var levelThreePositionArray = NSArray()
    var levelThreeMarkerArray = NSArray()
    var tourGuideId : String? = ""
    let networkReachability = NetworkReachabilityManager()
    
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
    //Already added
    /*
    let l2_g8_sc1 = GMSMarker()
    let l2_g8_sc5 = GMSMarker()
    let l2_g9_sc7 = GMSMarker()
    let l2_g1_sc3 = GMSMarker()
    */
    
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
   
    var fromTourString : fromTour?
    override func viewDidLoad() {
        super.viewDidLoad()

        viewForMap.delegate = self
        loadMap()
        initialSetUp()
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        bottomSheetVC.removeFromParentViewController()
        bottomSheetVC.dismiss(animated: false, completion: nil)
    }
    func initialSetUp() {
        loadingView.isHidden = false
        self.loadingView.showLoading()
        self.loadingView.loadingViewDelegate = self
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
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                playButton.setImage(UIImage(named:"play_blackX1"), for: .normal)
            } else {
                playButton.setImage(UIImage(named:"play_black-mirror"), for: .normal)
            }
            
            
            //numberSerchBtn.setImage(UIImage(named: "side_menu_blackX1"), for: .normal)
           // self.numberSerchBtn.contentEdgeInsets = UIEdgeInsets(top: 11, left: 5, bottom: 11, right: 5)
            numberSerchBtn.isHidden = true
            headerView.headerBackButton.isHidden = true
            headerView.settingsButton.isHidden = false
            headerView.settingsButton.setImage(UIImage(named: "side_menu_iconX1"), for: .normal)
            
            headerView.settingsButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 10, bottom:11, right: 8)
            
            
            levelTwoPositionArray = ["l2_g1_sc3","l2_g8","l2_g8_sc1","l2_g8_sc6_1","l2_g8_sc6_2","l2_g8_sc5","l2_g8_sc4_1","l2_g8_sc4_2","l2_g9_sc7","l2_g9_sc5_1","l2_g9_sc5_2","l2_g5_sc6","l2_g3_sc13"]
            levelTwoMarkerArray = [l2_g1_sc3,l2_g8,l2_g8_sc1,l2_g8_sc6_1,l2_g8_sc6_2,l2_g8_sc5,l2_g8_sc4_1,l2_g8_sc4_2,l2_g9_sc7,l2_g9_sc5_1,l2_g9_sc5_2,l2_g5_sc6,l2_g3_sc13]
            levelThreePositionArray = ["l3_g10_sc1_1","l3_g10_sc1_2","l3_g11_wr15","l3_g13_5","l3_g13_7","l3_g17_3"]
            levelThreeMarkerArray = [l3_g10_sc1_1,l3_g10_sc1_2,l3_g11_wr15,l3_g13_5,l3_g13_7,l3_g17_3]
            showLevelTwoMarker()
            showLevelThreeMarker()
            
        } else {
         if (fromTourString == fromTour.HighlightTour) {
            
            if (selectedScienceTourLevel == "1"){
                playButton.isHidden = false
                playerSlider.isHidden = false
                firstLevelView.backgroundColor = UIColor.white
                secondLevelView.backgroundColor = UIColor.mapLevelColor
                thirdLevelView.backgroundColor = UIColor.mapLevelColor
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
            numberSerchBtn.isHidden = true
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
            
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                playButton.setImage(UIImage(named:"play_blackX1"), for: .normal)
            } else {
                playButton.setImage(UIImage(named:"play_black-mirror"), for: .normal)
            }
            
            levelTwoPositionArray = ["l2_g1_sc2","l2_g1_sc7","l2_g1_sc8","l2_g1_sc13","l2_g1_sc14","l2_g2_2","l2_g3_sc14_1","l2_g3_sc14_2","l2_g3_wr4","l2_g4_sc5","l2_g3_sc3","l2_g5_sc5","l2_g5_sc11","l2_g7_sc13","l2_g7_sc8","l2_g7_sc4","l2_g1_sc3","l2_g8_sc1","l2_g8_sc5","l2_g9_sc7"]
            levelTwoMarkerArray = [l2_g1_sc2,l2_g1_sc7,l2_g1_sc8,l2_g1_sc13,l2_g1_sc14,l2_g2_2,l2_g3_sc14_1,l2_g3_sc14_2,l2_g3_wr4,l2_g4_sc5,l2_g3_sc3,l2_g5_sc5,l2_g5_sc11,l2_g7_sc13,l2_g7_sc8,l2_g7_sc4,l2_g1_sc3,l2_g8_sc1,l2_g8_sc5,l2_g9_sc7]
            levelThreePositionArray = ["l3_g10_wr2_1","l3_g10_wr2_2","l3_g10_podium14","l3_g10_podium9","l3_g11_14","l3_g12_11","l3_g12_12","l3_g12_17","l3_g12_wr5","l3_g13_2","l3_g13_15","l3_g14_7","l3_g14_13","l3_g15_13","l3_g16_wr5","l3_g17_8","l3_g17_9","l3_g18_1","l3_g18_2","l3_g18_11"]
            levelThreeMarkerArray = [l3_g10_wr2_1,l3_g10_wr2_2,l3_g10_podium14,l3_g10_podium9,l3_g11_14,l3_g12_11,l3_g12_12,l3_g12_17,l3_g12_wr5,l3_g13_2,l3_g13_15,l3_g14_7,l3_g14_13,l3_g15_13,l3_g16_wr5,l3_g17_8,l3_g17_9,l3_g18_1,l3_g18_2,l3_g18_11]
            showLevelTwoHighlightMarker()
            showLevelThreeHighlightMarker()
        }
        
        thirdLevelLabel.text = NSLocalizedString("LEVEL_STRING", comment: "LEVEL_STRING in floor map")
        secondLevelLabel.text = NSLocalizedString("LEVEL_STRING", comment: "LEVEL_STRING in floor map")
        firstLevelLabel.text = NSLocalizedString("LEVEL_STRING", comment: "LEVEL_STRING in floor map")
        headerView.headerViewDelegate = self
        headerView.headerTitle.text = NSLocalizedString("FLOOR_MAP_TITLE", comment: "FLOOR_MAP_TITLE  in the Floormap page")
        
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            if (fromTourString == fromTour.scienceTour) {
                tourGuideId = "12216"
            } else if ((fromTourString == fromTour.HighlightTour) || (fromTourString == fromTour.exploreTour)){
                tourGuideId = "12471"
            }
        } else {
            if (fromTourString == fromTour.scienceTour) {
                tourGuideId = "12226"
            } else if ((fromTourString == fromTour.HighlightTour) || (fromTourString == fromTour.exploreTour)){
                tourGuideId = "12471"
            }
        }
        if  (networkReachability?.isReachable)! {
            getFloorMapDataFromServer()
        } else {
            fetchTourGuideFromCoredata()
        }
    
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
            
        } else if (fromTourString == fromTour.HighlightTour) {
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
        
        if ((fromTourString == fromTour.scienceTour) || (fromTourString == fromTour.HighlightTour)){
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
            
            l2_g8.position = L2_G8
            l2_g8.title = "l2_g8"
            l2_g8.snippet = ""
            if((fromTourString == fromTour.scienceTour) && (selectedScienceTour == "l2_g8")) {
                l2_g8.icon = self.imageWithImage(image: UIImage(named: "MS.523.1999-1.2000x2000")!, scaledToSize: CGSize(width:54, height: 64))
                self.setMarkerBounce()
                selectedMarker = l2_g8
                selectedMarkerImage = UIImage(named: "MS.523.1999-1.2000x2000")!
            } else {
                l2_g8.icon = self.imageWithImage(image: UIImage(named: "MS.523.1999-1.2000x2000")!, scaledToSize: CGSize(width:38, height: 44))
            }
            
            l2_g8.appearAnimation = .pop
            
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
        
    }
    //Function for show level 3 marker
    func showLevelThreeMarker() {
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
    }
    //MARK: Highlight Marker
    func showLevelTwoHighlightMarker() {
        
        l2_g1_sc2.position = L2_G1_SC2
        l2_g1_sc2.title = "l2_g1_sc2"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l2_g1_sc2")) {
            l2_g1_sc2.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l2_g1_sc2
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l2_g1_sc2.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l2_g1_sc2.appearAnimation = .pop
        
        l2_g1_sc7.position = L2_G1_SC7
        l2_g1_sc7.title = "l2_g1_sc7"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l2_g1_sc7")) {
            l2_g1_sc7.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l2_g1_sc7
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l2_g1_sc7.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l2_g1_sc7.appearAnimation = .pop
        
        l2_g1_sc8.position = L2_G1_SC8
        l2_g1_sc8.title = "l2_g1_sc8"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l2_g1_sc8")) {
            l2_g1_sc8.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l2_g1_sc8
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l2_g1_sc8.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l2_g1_sc8.appearAnimation = .pop
        
        l2_g1_sc13.position = L2_G1_SC13
        l2_g1_sc13.title = "l2_g1_sc13"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l2_g1_sc13")) {
            l2_g1_sc13.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l2_g1_sc13
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l2_g1_sc13.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l2_g1_sc13.appearAnimation = .pop
        
        l2_g1_sc14.position = L2_G1_SC14
        l2_g1_sc14.title = "l2_g1_sc14"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l2_g1_sc14")) {
            l2_g1_sc14.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l2_g1_sc14
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l2_g1_sc14.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l2_g1_sc14.appearAnimation = .pop
        
        l2_g2_2.position = L2_G2_2
        l2_g2_2.title = "l2_g2_2"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l2_g2_2")) {
            l2_g2_2.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l2_g2_2
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l2_g2_2.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l2_g2_2.appearAnimation = .pop
        
        l2_g3_sc14_1.position = L2_G3_SC14_1
        l2_g3_sc14_1.title = "l2_g3_sc14_1"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l2_g3_sc14_1")) {
            l2_g3_sc14_1.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l2_g3_sc14_1
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l2_g3_sc14_1.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l2_g3_sc14_1.appearAnimation = .pop
        
        l2_g3_sc14_2.position = L2_G3_SC14_2
        l2_g3_sc14_2.title = "l2_g3_sc14_2"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l2_g3_sc14_2")) {
            l2_g3_sc14_2.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l2_g3_sc14_2
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l2_g3_sc14_2.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l2_g3_sc14_2.appearAnimation = .pop
        
        l2_g3_wr4.position = L2_G3_WR4
        l2_g3_wr4.title = "l2_g3_wr4"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l2_g3_wr4")) {
            l2_g3_wr4.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l2_g3_wr4
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l2_g3_wr4.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l2_g3_wr4.appearAnimation = .pop
        
        l2_g4_sc5.position = L2_G4_SC5
        l2_g4_sc5.title = "l2_g4_sc5"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l2_g4_sc5")) {
            l2_g4_sc5.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l2_g4_sc5
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l2_g4_sc5.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l2_g4_sc5.appearAnimation = .pop
        
        l2_g3_sc3.position = L2_G3_SC3
        l2_g3_sc3.title = "l2_g3_sc3"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l2_g3_sc3")) {
            l2_g3_sc3.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l2_g3_sc3
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l2_g3_sc3.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l2_g3_sc3.appearAnimation = .pop
        
        l2_g5_sc5.position = L2_G5_SC5
        l2_g5_sc5.title = "l2_g5_sc5"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l2_g5_sc5")) {
            l2_g5_sc5.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l2_g5_sc5
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l2_g5_sc5.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l2_g5_sc5.appearAnimation = .pop
        
        l2_g5_sc11.position = L2_G5_SC11
        l2_g5_sc11.title = "l2_g5_sc11"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l2_g5_sc11")) {
            l2_g5_sc11.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l2_g5_sc11
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l2_g5_sc11.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l2_g5_sc11.appearAnimation = .pop
        
        l2_g7_sc13.position = L2_G7_SC13
        l2_g7_sc13.title = "l2_g7_sc13"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l2_g7_sc13")) {
            l2_g7_sc13.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l2_g7_sc13
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l2_g7_sc13.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l2_g7_sc13.appearAnimation = .pop
        
        l2_g7_sc8.position = L2_G7_SC8
        l2_g7_sc8.title = "l2_g7_sc8"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l2_g7_sc8")) {
            l2_g7_sc8.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l2_g7_sc8
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l2_g7_sc8.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l2_g7_sc8.appearAnimation = .pop
        
        l2_g7_sc4.position = L2_G7_SC4
        l2_g7_sc4.title = "l2_g7_sc4"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l2_g7_sc4")) {
            l2_g7_sc4.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l2_g7_sc4
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l2_g7_sc4.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l2_g7_sc4.appearAnimation = .pop
        
        l2_g8_sc1.position = L2_G8_SC1
        l2_g8_sc1.title = "l2_g8_sc1"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l2_g8_sc1")) {
            l2_g8_sc1.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l2_g8_sc1
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l2_g8_sc1.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l2_g8_sc1.appearAnimation = .pop
        
        l2_g8_sc5.position = L2_G8_SC5
        l2_g8_sc5.title = "l2_g8_sc5"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l2_g8_sc5")) {
            l2_g8_sc5.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l2_g8_sc5
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l2_g8_sc5.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l2_g8_sc5.appearAnimation = .pop
        
        l2_g9_sc7.position = L2_G9_SC7
        l2_g9_sc7.title = "l2_g9_sc7"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l2_g9_sc7")) {
            l2_g9_sc7.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l2_g9_sc7
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l2_g9_sc7.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l2_g9_sc7.appearAnimation = .pop
        
        l2_g1_sc3.position = L2_G1_SC3
        l2_g1_sc3.title = "l2_g1_sc3"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l2_g1_sc3")) {
            l2_g1_sc3.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l2_g1_sc3
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l2_g1_sc3.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l2_g1_sc3.appearAnimation = .pop
       
    }
    func showLevelThreeHighlightMarker() {
        
        l3_g10_wr2_1.position = L3_G10_WR2_1
        l3_g10_wr2_1.title = "l3_g10_wr2_1"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l3_g10_wr2_1")) {
            l3_g10_wr2_1.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l3_g10_wr2_1
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l3_g10_wr2_1.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l3_g10_wr2_1.appearAnimation = .pop
        //l3_g10_wr2_1.map = viewForMap
        
        l3_g10_wr2_2.position = L3_G10_WR2_2
        l3_g10_wr2_2.title = "l3_g10_wr2_2"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l3_g10_wr2_2")) {
            l3_g10_wr2_2.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l3_g10_wr2_2
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l3_g10_wr2_2.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l3_g10_wr2_2.appearAnimation = .pop
        //l3_g10_wr2_2.map = viewForMap
        
        l3_g10_podium14.position = L3_G10_PODIUM14
        l3_g10_podium14.title = "l3_g10_podium14"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l3_g10_podium14")) {
            l3_g10_podium14.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l3_g10_podium14
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l3_g10_podium14.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l3_g10_podium14.appearAnimation = .pop
        //l3_g10_podium14.map = viewForMap
        
        l3_g10_podium9.position = L3_G10_PODIUM9
        l3_g10_podium9.title = "l3_g10_podium9"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l3_g10_podium9")) {
            l3_g10_podium9.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l3_g10_podium9
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l3_g10_podium9.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l3_g10_podium9.appearAnimation = .pop
        //l3_g10_podium9.map = viewForMap
        
        l3_g11_14.position = L3_G11_14
        l3_g11_14.title = "l3_g11_14"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l3_g11_14")) {
            l3_g11_14.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l3_g11_14
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l3_g11_14.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l3_g11_14.appearAnimation = .pop
       // l3_g11_14.map = viewForMap
        
        l3_g12_11.position = L3_G12_11
        l3_g12_11.title = "l3_g12_11"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l3_g12_11")) {
            l3_g12_11.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l3_g12_11
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l3_g12_11.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l3_g12_11.appearAnimation = .pop
        //l3_g12_11.map = viewForMap
        
        l3_g12_12.position = L3_G12_12
        l3_g12_12.title = "l3_g12_12"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l3_g12_12")) {
            l3_g12_12.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l3_g12_12
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l3_g12_12.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l3_g12_12.appearAnimation = .pop
        //l3_g12_12.map = viewForMap
        
        l3_g12_17.position = L3_G12_17
        l3_g12_17.title = "l3_g12_17"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l3_g12_17")) {
            l3_g12_17.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l3_g12_17
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l3_g12_17.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l3_g12_17.appearAnimation = .pop
        //l3_g12_17.map = viewForMap
        
        l3_g12_wr5.position = L3_G12_WR5
        l3_g12_wr5.title = "l3_g12_wr5"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l3_g12_wr5")) {
            l3_g12_wr5.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l3_g12_wr5
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l3_g12_wr5.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l3_g12_wr5.appearAnimation = .pop
        //l3_g12_wr5.map = viewForMap
        
        l3_g13_2.position = L3_G13_2
        l3_g13_2.title = "l3_g13_2"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l3_g13_2")) {
            l3_g13_2.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l3_g13_2
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l3_g13_2.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l3_g13_2.appearAnimation = .pop
       // l3_g13_2.map = viewForMap
        
        l3_g13_15.position = L3_G13_15
        l3_g13_15.title = "l3_g13_15"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l3_g13_15")) {
            l3_g13_15.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l3_g13_15
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l3_g13_15.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l3_g13_15.appearAnimation = .pop
        //l3_g13_15.map = viewForMap
        
        l3_g14_7.position = L3_G14_7
        l3_g14_7.title = "l3_g14_7"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l3_g14_7")) {
            l3_g14_7.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l3_g14_7
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l3_g14_7.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l3_g14_7.appearAnimation = .pop
        //l3_g14_7.map = viewForMap
        
        l3_g14_13.position = L3_G14_13
        l3_g14_13.title = "l3_g14_13"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l3_g14_13")) {
            l3_g14_13.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l3_g14_13
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l3_g14_13.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l3_g14_13.appearAnimation = .pop
       // l3_g14_13.map = viewForMap
        
        l3_g15_13.position = L3_G15_13
        l3_g15_13.title = "l3_g15_13"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l3_g15_13")) {
            l3_g15_13.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l3_g15_13
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l3_g15_13.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l3_g15_13.appearAnimation = .pop
        //l3_g15_13.map = viewForMap
        
        l3_g16_wr5.position = L3_G16_WR5
        l3_g16_wr5.title = "l3_g16_wr5"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l3_g16_wr5")) {
            l3_g16_wr5.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l3_g16_wr5
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l3_g16_wr5.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l3_g16_wr5.appearAnimation = .pop
        //l3_g16_wr5.map = viewForMap
        
        l3_g17_8.position = L3_G17_8
        l3_g17_8.title = "l3_g17_8"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l3_g17_8")) {
            l3_g16_wr5.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l3_g17_8
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l3_g17_8.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l3_g17_8.appearAnimation = .pop
        //l3_g17_8.map = viewForMap
        
        l3_g17_9.position = L3_G17_9
        l3_g17_9.title = "l3_g17_9"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l3_g17_9")) {
            l3_g17_9.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l3_g17_9
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l3_g17_9.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l3_g17_9.appearAnimation = .pop
        //l3_g17_9.map = viewForMap
        
        l3_g18_1.position = L3_G18_1
        l3_g18_1.title = "l3_g18_1"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l3_g18_1")) {
            l3_g18_1.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l3_g18_1
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l3_g18_1.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l3_g18_1.appearAnimation = .pop
        //l3_g18_1.map = viewForMap
        
        l3_g18_2.position = L3_G18_2
        l3_g18_2.title = "l3_g18_2"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l3_g18_2")) {
            l3_g18_2.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l3_g18_2
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l3_g18_2.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l3_g18_2.appearAnimation = .pop
        //l3_g18_2.map = viewForMap
        
        l3_g18_11.position = L3_G18_11
        l3_g18_11.title = "l3_g18_11"
        if((fromTourString == fromTour.HighlightTour) && (selectedScienceTour == "l3_g18_11")) {
            l3_g18_11.icon = self.imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:54, height: 64))
            self.setMarkerBounce()
            selectedMarker = l3_g18_11
            selectedMarkerImage = UIImage(named: "default_map_marker")!
        } else {
            l3_g18_11.icon = imageWithImage(image: UIImage(named: "default_map_marker")!, scaledToSize: CGSize(width:38, height: 44))
        }
        l3_g18_11.appearAnimation = .pop
        //l3_g18_11.map = viewForMap
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
            if((fromTourString == fromTour.HighlightTour) || (fromTourString == fromTour.exploreTour)) {
                showOrHideLevelThreeHighlightTour()
            } else {
                showOrHideLevelThreeScienceTour()
            }
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
        if (zoomValue > 18)  {
            if((fromTourString == fromTour.HighlightTour) || (fromTourString == fromTour.exploreTour)) {
                showOrHideLevelTwoHighlightTour()
            } else {
                self.showOrHideLevelTwoScienceTour()
            }
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
        marker.appearAnimation = .pop
        marker.groundAnchor = CGPoint(x: 0.5, y: 1.0)
       
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
        
        l2_g1_sc2.map = nil
        l2_g1_sc7.map = nil
        l2_g1_sc8.map = nil
        l2_g1_sc13.map = nil
        l2_g1_sc14.map = nil
        l2_g2_2.map = nil
        l2_g3_sc14_1.map = nil
        l2_g3_sc14_2.map = nil
        l2_g3_wr4.map = nil
        l2_g4_sc5.map = nil
        l2_g3_sc3.map = nil
        l2_g5_sc5.map = nil
        l2_g5_sc11.map = nil
        l2_g7_sc13.map = nil
        l2_g7_sc8.map = nil
        l2_g7_sc4.map = nil
        
        
        l3_g10_wr2_1.map = nil
        l3_g10_wr2_2.map = nil
        l3_g10_podium14.map = nil
        l3_g10_podium9.map = nil
        l3_g11_14.map = nil
        l3_g12_11.map = nil
        l3_g12_12.map = nil
        l3_g12_17.map = nil
        l3_g12_wr5.map = nil
        l3_g13_2.map = nil
        l3_g13_15.map = nil
        l3_g14_7.map = nil
        l3_g14_13.map = nil
        l3_g15_13.map = nil
        l3_g16_wr5.map = nil
        l3_g17_8.map = nil
        l3_g17_9.map = nil
        l3_g18_1.map = nil
        
        l3_g18_2.map = nil
        l3_g18_11.map = nil
    
    }
    
    //MARK: Poup Delegate
    func objectPopupCloseButtonPressed() {
        self.objectPopupView.removeFromSuperview()
        if ((fromTourString == fromTour.HighlightTour) || (fromTourString == fromTour.exploreTour))
        {
            if(level == levelNumber.two) {
                showOrHideLevelTwoHighlightTour()
            } else if(level == levelNumber.three) {
                showOrHideLevelThreeHighlightTour()
            }
        } else {
            if (level == levelNumber.two) {
                self.showOrHideLevelTwoScienceTour()
            } else {
                self.showOrHideLevelThreeScienceTour()
            }
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
        selectedMarker.icon = self.imageWithImage(image: selectedMarkerImage, scaledToSize: CGSize(width:38, height: 44))
        selectedScienceTour = ""
        
        bounceTimerTwo.invalidate()
        bounceTimerThree.invalidate()
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: 0, height: 0)
        overlayView.isHidden = true
        if ((fromTourString == fromTour.HighlightTour) || (fromTourString == fromTour.exploreTour))
        {
            if(level == levelNumber.two) {
                showOrHideLevelTwoHighlightTour()
            } else if(level == levelNumber.three) {
                showOrHideLevelThreeHighlightTour()
            }
        } else {
            if (level == levelNumber.two) {
                self.showOrHideLevelTwoScienceTour()
            } else if(level == levelNumber.three) {
                self.showOrHideLevelThreeScienceTour()
            }
        }
    }
    func dismissOvelay() {
        overlayView.isHidden = true
        selectedMarker.icon = self.imageWithImage(image: selectedMarkerImage, scaledToSize: CGSize(width:38, height: 44))
        selectedScienceTour = ""
        bounceTimerTwo.invalidate()
        bounceTimerThree.invalidate()
        if ((fromTourString == fromTour.HighlightTour) || (fromTourString == fromTour.exploreTour))
        {
            if(level == levelNumber.two) {
                showOrHideLevelTwoHighlightTour()
            } else if(level == levelNumber.three) {
                showOrHideLevelThreeHighlightTour()
            }
        } else {
            if (level == levelNumber.two) {
                self.showOrHideLevelTwoScienceTour()
            } else if(level == levelNumber.three) {
                self.showOrHideLevelThreeScienceTour()
            }
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
                if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                    playButton.setImage(UIImage(named:"play_blackX1"), for: .normal)
                } else {
                    playButton.setImage(UIImage(named:"play_black-mirror"), for: .normal)
                }
                avPlayer.pause()
                isPaused = true
            } else {
                playButton.setImage(UIImage(named:"pause_blackX1"), for: .normal)
                avPlayer.play()
                isPaused = false
            }
        } else {
            if((avPlayer.rate != 0) && (avPlayer.error == nil)) {
                if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                    playButton.setImage(UIImage(named:"play_blackX1"), for: .normal)
                } else {
                    playButton.setImage(UIImage(named:"play_black-mirror"), for: .normal)
                }
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
            seekLoadingLabel.alpha = 1
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
            seekLoadingLabel.alpha = 1
        }else{
            seekLoadingLabel.alpha = 0
        }
        
        if(isPaused == false){
            if(avPlayer.rate == 0){
                avPlayer.play()
                seekLoadingLabel.alpha = 1
            }else{
                seekLoadingLabel.alpha = 0
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
        _ = Alamofire.request(QatarMuseumRouter.CollectionByTourGuide(["tour_guide_id": tourGuideId!])).responseObject { (response: DataResponse<TourGuideFloorMaps>) -> Void in
            switch response.result {
            case .success(let data):
                self.floorMapArray = data.tourGuideFloorMap
                self.loadingView.stopLoading()
                self.loadingView.isHidden = true
                if (self.floorMapArray.count > 0) {
                    self.saveOrUpdateTourGuideCoredata()
                    if (self.fromTourString == fromTour.HighlightTour) {
                        if(self.selectedScienceTourLevel == "2" ) {
                            self.showOrHideLevelTwoHighlightTour()
                        } else if (self.selectedScienceTourLevel == "3" ) {
                            self.showOrHideLevelThreeHighlightTour()
                        }
                        if let arrayOffset = self.self.floorMapArray.index(where: {$0.nid == self.selectednid}) {
                            self.addBottomSheetView(index: arrayOffset)
                        }
                    } else if(self.fromTourString == fromTour.scienceTour) {
                        if(self.selectedScienceTourLevel == "2" ) {
                            self.showOrHideLevelTwoScienceTour()
                        } else if(self.selectedScienceTourLevel == "3") {
                            self.showOrHideLevelThreeScienceTour()
                        }
                        if let arrayOffset = self.floorMapArray.index(where: {$0.nid == self.selectednid}) {
                            self.addBottomSheetView(index: arrayOffset)
                        }
                    }
                }
                
            case .failure(let error):
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
    func showOrHideLevelTwoHighlightTour() {
        for i in 0 ... self.levelTwoPositionArray.count-1 {
            if let searchResult = self.floorMapArray.first(where: {$0.artifactPosition! == self.levelTwoPositionArray[i] as! String}) {
                (self.levelTwoMarkerArray[i] as! GMSMarker).map = self.viewForMap
            } else {
                (self.levelTwoMarkerArray[i] as! GMSMarker).map = nil
            }
        }

    }
    func showOrHideLevelThreeHighlightTour() {
        for i in 0 ... self.levelThreePositionArray.count-1 {
            if let searchResult = self.floorMapArray.first(where: {$0.artifactPosition! == self.levelThreePositionArray[i] as! String}) {
                (self.levelThreeMarkerArray[i] as! GMSMarker).map = self.viewForMap
            } else {
                (self.levelThreeMarkerArray[i] as! GMSMarker).map = nil
            }
        }
        
    }
    func showOrHideLevelTwoScienceTour() {
        for i in 0 ... self.levelTwoPositionArray.count-1 {
            if let searchResult = self.floorMapArray.first(where: {$0.artifactPosition! == self.levelTwoPositionArray[i] as! String}) {
                (self.levelTwoMarkerArray[i] as! GMSMarker).map = self.viewForMap
            } else {
                (self.levelTwoMarkerArray[i] as! GMSMarker).map = nil
            }
        }
        
    }
    func showOrHideLevelThreeScienceTour() {
        for i in 0 ... self.levelThreePositionArray.count-1 {
            if let searchResult = self.floorMapArray.first(where: {$0.artifactPosition! == self.levelThreePositionArray[i] as! String}) {
                (self.levelThreeMarkerArray[i] as! GMSMarker).map = self.viewForMap
            } else {
                (self.levelThreeMarkerArray[i] as! GMSMarker).map = nil
            }
        }
        
    }
    //MARK: TourGuide DataBase
    func saveOrUpdateTourGuideCoredata() {
        if (floorMapArray.count > 0) {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                let fetchData = checkAddedToCoredata(entityName: "FloorMapTourGuideEntity", idKey: "tourGuideId" , idValue: tourGuideId ) as! [FloorMapTourGuideEntity]
                
                if (fetchData.count > 0) {
                    for i in 0 ... floorMapArray.count-1 {
                        let managedContext = getContext()
                        let tourGuideDeatilDict = floorMapArray[i]
                        let fetchResult = checkAddedToCoredata(entityName: "FloorMapTourGuideEntity", idKey: "nid", idValue: floorMapArray[i].nid) as! [FloorMapTourGuideEntity]
                        
                        if(fetchResult.count != 0) {
                            
                            //update
                            let tourguidedbDict = fetchResult[0]
                            tourguidedbDict.title = tourGuideDeatilDict.title
                            tourguidedbDict.accessionNumber = tourGuideDeatilDict.accessionNumber
                            tourguidedbDict.nid =  tourGuideDeatilDict.nid
                            tourguidedbDict.curatorialDescription = tourGuideDeatilDict.curatorialDescription
                            tourguidedbDict.diam = tourGuideDeatilDict.diam
                            
                            tourguidedbDict.dimensions = tourGuideDeatilDict.dimensions
                            tourguidedbDict.mainTitle = tourGuideDeatilDict.mainTitle
                            tourguidedbDict.objectEngSummary =  tourGuideDeatilDict.objectENGSummary
                            tourguidedbDict.objectHistory = tourGuideDeatilDict.objectHistory
                            tourguidedbDict.production = tourGuideDeatilDict.production
                            
                            tourguidedbDict.productionDates = tourGuideDeatilDict.productionDates
                            tourguidedbDict.image = tourGuideDeatilDict.image
                            tourguidedbDict.tourGuideId =  tourGuideDeatilDict.tourGuideId
                            tourguidedbDict.artifactNumber = tourGuideDeatilDict.artifactNumber
                            tourguidedbDict.artifactPosition = tourGuideDeatilDict.artifactPosition
                            
                            tourguidedbDict.audioDescriptif = tourGuideDeatilDict.audioDescriptif
                            tourguidedbDict.audioFile = tourGuideDeatilDict.audioFile
                            tourguidedbDict.floorLevel =  tourGuideDeatilDict.floorLevel
                            tourguidedbDict.galleyNumber = tourGuideDeatilDict.galleyNumber
                            tourguidedbDict.artistOrCreatorOrAuthor = tourGuideDeatilDict.artistOrCreatorOrAuthor
                            tourguidedbDict.periodOrStyle = tourGuideDeatilDict.periodOrStyle
                            tourguidedbDict.techniqueAndMaterials = tourGuideDeatilDict.techniqueAndMaterials
                            
                            
                            if(tourGuideDeatilDict.images != nil) {
                                if((tourGuideDeatilDict.images?.count)! > 0) {
                                    for i in 0 ... (tourGuideDeatilDict.images?.count)!-1 {
                                        var tourGuideImgEntity: FloorMapImagesEntity!
                                        let tourGuideImg: FloorMapImagesEntity = NSEntityDescription.insertNewObject(forEntityName: "FloorMapImagesEntity", into: managedContext) as! FloorMapImagesEntity
                                        tourGuideImg.image = tourGuideDeatilDict.images?[i]
                                        
                                        tourGuideImgEntity = tourGuideImg
                                        tourguidedbDict.addToImagesRelation(tourGuideImgEntity)
                                        do {
                                            try managedContext.save()
                                            
                                        } catch let error as NSError {
                                            print("Could not save. \(error), \(error.userInfo)")
                                        }
                                        
                                    }
                                }
                            }
                            
                            do{
                                try managedContext.save()
                            }
                            catch{
                                print(error)
                            }
                        }else {
                            self.saveToCoreData(tourGuideDetailDict: tourGuideDeatilDict, managedObjContext: managedContext)
                        }
                    }//for
                }//if
                else {
                    for i in 0 ... floorMapArray.count-1 {
                        let managedContext = getContext()
                        let tourGuideDetailDict : TourGuideFloorMap?
                        tourGuideDetailDict = floorMapArray[i]
                        self.saveToCoreData(tourGuideDetailDict: tourGuideDetailDict!, managedObjContext: managedContext)
                    }
                    
                }
            }
            else {
                let fetchData = checkAddedToCoredata(entityName: "FloorMapTourGuideEntityAr", idKey:"tourGuideId" , idValue: tourGuideId) as! [FloorMapTourGuideEntityAr]
                if (fetchData.count > 0) {
                    for i in 0 ... floorMapArray.count-1 {
                        let managedContext = getContext()
                        let tourGuideDeatilDict = floorMapArray[i]
                        let fetchResult = checkAddedToCoredata(entityName: "FloorMapTourGuideEntityAr", idKey: "nid", idValue: floorMapArray[i].nid) as! [FloorMapTourGuideEntityAr]
                        //update
                        if(fetchResult.count != 0) {
                            let tourguidedbDict = fetchResult[0]
                            tourguidedbDict.title = tourGuideDeatilDict.title
                            tourguidedbDict.accessionNumber = tourGuideDeatilDict.accessionNumber
                            tourguidedbDict.nid =  tourGuideDeatilDict.nid
                            tourguidedbDict.curatorialDescription = tourGuideDeatilDict.curatorialDescription
                            tourguidedbDict.diam = tourGuideDeatilDict.diam
                            
                            tourguidedbDict.dimensions = tourGuideDeatilDict.dimensions
                            tourguidedbDict.mainTitle = tourGuideDeatilDict.mainTitle
                            tourguidedbDict.objectEngSummary =  tourGuideDeatilDict.objectENGSummary
                            tourguidedbDict.objectHistory = tourGuideDeatilDict.objectHistory
                            tourguidedbDict.production = tourGuideDeatilDict.production
                            
                            tourguidedbDict.productionDates = tourGuideDeatilDict.productionDates
                            tourguidedbDict.image = tourGuideDeatilDict.image
                            tourguidedbDict.tourGuideId =  tourGuideDeatilDict.tourGuideId
                            tourguidedbDict.artifactNumber = tourGuideDeatilDict.artifactNumber
                            tourguidedbDict.artifactPosition = tourGuideDeatilDict.artifactPosition
                            
                            tourguidedbDict.audioDescriptif = tourGuideDeatilDict.audioDescriptif
                            tourguidedbDict.audioFile = tourGuideDeatilDict.audioFile
                            tourguidedbDict.floorLevel =  tourGuideDeatilDict.floorLevel
                            tourguidedbDict.galleyNumber = tourGuideDeatilDict.galleyNumber
                            tourguidedbDict.artistOrCreatorOrAuthor = tourGuideDeatilDict.artistOrCreatorOrAuthor
                            tourguidedbDict.periodOrStyle = tourGuideDeatilDict.periodOrStyle
                            tourguidedbDict.techniqueAndMaterials = tourGuideDeatilDict.techniqueAndMaterials
                            
                            if(tourGuideDeatilDict.images != nil) {
                                if((tourGuideDeatilDict.images?.count)! > 0) {
                                    for i in 0 ... (tourGuideDeatilDict.images?.count)!-1 {
                                        var tourGuideImgEntity: FloorMapImagesEntityAr!
                                        let tourGuideImg: FloorMapImagesEntityAr = NSEntityDescription.insertNewObject(forEntityName: "FloorMapImagesEntityAr", into: managedContext) as! FloorMapImagesEntityAr
                                        tourGuideImg.image = tourGuideDeatilDict.images?[i]
                                        
                                        tourGuideImgEntity = tourGuideImg
                                        tourguidedbDict.addToImagesRelation(tourGuideImgEntity)
                                        do {
                                            try managedContext.save()
                                            
                                        } catch let error as NSError {
                                            print("Could not save. \(error), \(error.userInfo)")
                                        }
                                        
                                    }
                                }
                            }
                            do{
                                try managedContext.save()
                            }
                            catch{
                                print(error)
                            }
                        } else {
                            self.saveToCoreData(tourGuideDetailDict: tourGuideDeatilDict, managedObjContext: managedContext)
                        }
                    }//for
                } //if
                else {
                    for i in 0 ... floorMapArray.count-1 {
                        let managedContext = getContext()
                        let tourGuideDetailDict : TourGuideFloorMap?
                        tourGuideDetailDict = floorMapArray[i]
                        self.saveToCoreData(tourGuideDetailDict: tourGuideDetailDict!, managedObjContext: managedContext)
                    }
                    
                }
            }
        }
    }
    func saveToCoreData(tourGuideDetailDict: TourGuideFloorMap, managedObjContext: NSManagedObjectContext) {
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            let tourguidedbDict: FloorMapTourGuideEntity = NSEntityDescription.insertNewObject(forEntityName: "FloorMapTourGuideEntity", into: managedObjContext) as! FloorMapTourGuideEntity
            tourguidedbDict.title = tourGuideDetailDict.title
            tourguidedbDict.accessionNumber = tourGuideDetailDict.accessionNumber
            tourguidedbDict.nid =  tourGuideDetailDict.nid
            tourguidedbDict.curatorialDescription = tourGuideDetailDict.curatorialDescription
            tourguidedbDict.diam = tourGuideDetailDict.diam
            
            tourguidedbDict.dimensions = tourGuideDetailDict.dimensions
            tourguidedbDict.mainTitle = tourGuideDetailDict.mainTitle
            tourguidedbDict.objectEngSummary =  tourGuideDetailDict.objectENGSummary
            tourguidedbDict.objectHistory = tourGuideDetailDict.objectHistory
            tourguidedbDict.production = tourGuideDetailDict.production
            
            tourguidedbDict.productionDates = tourGuideDetailDict.productionDates
            tourguidedbDict.image = tourGuideDetailDict.image
            tourguidedbDict.tourGuideId =  tourGuideDetailDict.tourGuideId
            tourguidedbDict.artifactNumber = tourGuideDetailDict.artifactNumber
            tourguidedbDict.artifactPosition = tourGuideDetailDict.artifactPosition
            
            tourguidedbDict.audioDescriptif = tourGuideDetailDict.audioDescriptif
            tourguidedbDict.audioFile = tourGuideDetailDict.audioFile
            tourguidedbDict.floorLevel =  tourGuideDetailDict.floorLevel
            tourguidedbDict.galleyNumber = tourGuideDetailDict.galleyNumber
            tourguidedbDict.artistOrCreatorOrAuthor = tourGuideDetailDict.artistOrCreatorOrAuthor
            tourguidedbDict.periodOrStyle = tourGuideDetailDict.periodOrStyle
            tourguidedbDict.techniqueAndMaterials = tourGuideDetailDict.techniqueAndMaterials
            if(tourGuideDetailDict.images != nil) {
                if((tourGuideDetailDict.images?.count)! > 0) {
                    for i in 0 ... (tourGuideDetailDict.images?.count)!-1 {
                        var tourGuideImgEntity: FloorMapImagesEntity!
                        let tourGuideImg: FloorMapImagesEntity = NSEntityDescription.insertNewObject(forEntityName: "FloorMapImagesEntity", into: managedObjContext) as! FloorMapImagesEntity
                        tourGuideImg.image = tourGuideDetailDict.images?[i]
                        
                        tourGuideImgEntity = tourGuideImg
                        tourguidedbDict.addToImagesRelation(tourGuideImgEntity)
                        do {
                            try managedObjContext.save()
                            
                        } catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                        
                    }
                }
            }
            
        }
        else {
            let tourguidedbDict: FloorMapTourGuideEntityAr = NSEntityDescription.insertNewObject(forEntityName: "FloorMapTourGuideEntityAr", into: managedObjContext) as! FloorMapTourGuideEntityAr
            tourguidedbDict.title = tourGuideDetailDict.title
            tourguidedbDict.accessionNumber = tourGuideDetailDict.accessionNumber
            tourguidedbDict.nid =  tourGuideDetailDict.nid
            tourguidedbDict.curatorialDescription = tourGuideDetailDict.curatorialDescription
            tourguidedbDict.diam = tourGuideDetailDict.diam
            
            tourguidedbDict.dimensions = tourGuideDetailDict.dimensions
            tourguidedbDict.mainTitle = tourGuideDetailDict.mainTitle
            tourguidedbDict.objectEngSummary =  tourGuideDetailDict.objectENGSummary
            tourguidedbDict.objectHistory = tourGuideDetailDict.objectHistory
            tourguidedbDict.production = tourGuideDetailDict.production
            
            tourguidedbDict.productionDates = tourGuideDetailDict.productionDates
            tourguidedbDict.image = tourGuideDetailDict.image
            tourguidedbDict.tourGuideId =  tourGuideDetailDict.tourGuideId
            tourguidedbDict.artifactNumber = tourGuideDetailDict.artifactNumber
            tourguidedbDict.artifactPosition = tourGuideDetailDict.artifactPosition
            
            tourguidedbDict.audioDescriptif = tourGuideDetailDict.audioDescriptif
            tourguidedbDict.audioFile = tourGuideDetailDict.audioFile
            tourguidedbDict.floorLevel =  tourGuideDetailDict.floorLevel
            tourguidedbDict.galleyNumber = tourGuideDetailDict.galleyNumber
            tourguidedbDict.artistOrCreatorOrAuthor = tourGuideDetailDict.artistOrCreatorOrAuthor
            tourguidedbDict.periodOrStyle = tourGuideDetailDict.periodOrStyle
            tourguidedbDict.techniqueAndMaterials = tourGuideDetailDict.techniqueAndMaterials
            if(tourGuideDetailDict.images != nil) {
                if((tourGuideDetailDict.images?.count)! > 0) {
                    for i in 0 ... (tourGuideDetailDict.images?.count)!-1 {
                        var tourGuideImgEntity: FloorMapImagesEntityAr!
                        let tourGuideImg: FloorMapImagesEntityAr = NSEntityDescription.insertNewObject(forEntityName: "FloorMapImagesEntityAr", into: managedObjContext) as! FloorMapImagesEntityAr
                        tourGuideImg.image = tourGuideDetailDict.images?[i]
                        
                        tourGuideImgEntity = tourGuideImg
                        tourguidedbDict.addToImagesRelation(tourGuideImgEntity)
                        do {
                            try managedObjContext.save()
                            
                        } catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                        
                    }
                }
            }
        }
        do {
            try managedObjContext.save()
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func fetchTourGuideFromCoredata() {
        do {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                var tourGuideArray = [FloorMapTourGuideEntity]()
                tourGuideArray = checkAddedToCoredata(entityName: "FloorMapTourGuideEntity", idKey: "tourGuideId", idValue: tourGuideId) as! [FloorMapTourGuideEntity]
                if (tourGuideArray.count > 0) {
                    for i in 0 ... tourGuideArray.count-1 {
                        let tourGuideDict = tourGuideArray[i]
                        var imgsArray : [String] = []
                        let imgInfoArray = (tourGuideDict.imagesRelation?.allObjects) as! [FloorMapImagesEntity]
                        if(imgInfoArray != nil) {
                            if(imgInfoArray.count > 0) {
                                for i in 0 ... imgInfoArray.count-1 {
                                    imgsArray.append(imgInfoArray[i].image!)
                                }
                            }
                        }
                        self.floorMapArray.insert(TourGuideFloorMap(title: tourGuideDict.title, accessionNumber: tourGuideDict.accessionNumber, nid: tourGuideDict.nid, curatorialDescription: tourGuideDict.curatorialDescription, diam: tourGuideDict.diam, dimensions: tourGuideDict.dimensions, mainTitle: tourGuideDict.mainTitle, objectENGSummary: tourGuideDict.objectEngSummary, objectHistory: tourGuideDict.objectHistory, production: tourGuideDict.production, productionDates: tourGuideDict.productionDates, image: tourGuideDict.image, tourGuideId: tourGuideDict.tourGuideId,artifactNumber: tourGuideDict.artifactNumber, artifactPosition: tourGuideDict.artifactPosition, audioDescriptif: tourGuideDict.audioDescriptif, images: imgsArray, audioFile: tourGuideDict.audioFile, floorLevel: tourGuideDict.floorLevel, galleyNumber: tourGuideDict.galleyNumber, artistOrCreatorOrAuthor: tourGuideDict.artistOrCreatorOrAuthor, periodOrStyle: tourGuideDict.periodOrStyle, techniqueAndMaterials: tourGuideDict.techniqueAndMaterials), at: 0)
                        
                    }
                    
                    if (self.floorMapArray.count > 0) {
                        self.loadingView.stopLoading()
                        self.loadingView.isHidden = true
                        if (self.fromTourString == fromTour.HighlightTour) {
                            if(self.selectedScienceTourLevel == "2" ) {
                                self.showOrHideLevelTwoHighlightTour()
                            } else if (self.selectedScienceTourLevel == "3" ) {
                                self.showOrHideLevelThreeHighlightTour()
                            }
                            
                            if let arrayOffset = floorMapArray.index(where: {$0.nid == selectednid}) {
                                self.addBottomSheetView(index: arrayOffset)
                            }
                        } else if(self.fromTourString == fromTour.scienceTour) {
                            if(self.selectedScienceTourLevel == "2" ) {
                                self.showOrHideLevelTwoScienceTour()
                            } else if(self.selectedScienceTourLevel == "3") {
                                self.showOrHideLevelThreeScienceTour()
                            }
                            if let arrayOffset = floorMapArray.index(where: {$0.nid == selectednid}) {
                                self.addBottomSheetView(index: arrayOffset)
                            }
                        }
                    } else {
                        self.showNoNetwork()
                    }
                   
                } else {
                    self.showNoNetwork()
                }
                
                
                
            }
            else {
                var tourGuideArray = [FloorMapTourGuideEntityAr]()
                tourGuideArray = checkAddedToCoredata(entityName: "FloorMapTourGuideEntityAr", idKey: "tourGuideId", idValue: tourGuideId) as! [FloorMapTourGuideEntityAr]
                if(tourGuideArray.count > 0) {
                    for i in 0 ... tourGuideArray.count-1 {
                        let tourGuideDict = tourGuideArray[i]
                        var imgsArray : [String] = []
                        let imgInfoArray = (tourGuideDict.imagesRelation?.allObjects) as! [FloorMapImagesEntity]
                        if(imgInfoArray != nil) {
                            if(imgInfoArray.count > 0) {
                                for i in 0 ... imgInfoArray.count-1 {
                                    imgsArray.append(imgInfoArray[i].image!)
                                }
                            }
                        }
                        self.floorMapArray.insert(TourGuideFloorMap(title: tourGuideDict.title, accessionNumber: tourGuideDict.accessionNumber, nid: tourGuideDict.nid, curatorialDescription: tourGuideDict.curatorialDescription, diam: tourGuideDict.diam, dimensions: tourGuideDict.dimensions, mainTitle: tourGuideDict.mainTitle, objectENGSummary: tourGuideDict.objectEngSummary, objectHistory: tourGuideDict.objectHistory, production: tourGuideDict.production, productionDates: tourGuideDict.productionDates, image: tourGuideDict.image, tourGuideId: tourGuideDict.tourGuideId,artifactNumber: tourGuideDict.artifactNumber, artifactPosition: tourGuideDict.artifactPosition, audioDescriptif: tourGuideDict.audioDescriptif, images: imgsArray, audioFile: tourGuideDict.audioFile, floorLevel: tourGuideDict.floorLevel, galleyNumber: tourGuideDict.galleyNumber, artistOrCreatorOrAuthor: tourGuideDict.artistOrCreatorOrAuthor, periodOrStyle: tourGuideDict.periodOrStyle, techniqueAndMaterials: tourGuideDict.techniqueAndMaterials), at: 0)
                            
                        
                    }
                    if (self.floorMapArray.count > 0) {
                        self.loadingView.stopLoading()
                        self.loadingView.isHidden = true
                        if (self.fromTourString == fromTour.HighlightTour) {
                            if(self.selectedScienceTourLevel == "2" ) {
                                self.showOrHideLevelTwoHighlightTour()
                            } else if (self.selectedScienceTourLevel == "3" ) {
                                self.showOrHideLevelThreeHighlightTour()
                            }
                            if let arrayOffset = floorMapArray.index(where: {$0.nid == selectednid}) {
                                self.addBottomSheetView(index: arrayOffset)
                            }
                        } else if(self.fromTourString == fromTour.scienceTour) {
                            if(self.selectedScienceTourLevel == "2" ) {
                                self.showOrHideLevelTwoScienceTour()
                            } else if(self.selectedScienceTourLevel == "3") {
                                self.showOrHideLevelThreeScienceTour()
                            }
                            if let arrayOffset = floorMapArray.index(where: {$0.nid == selectednid}) {
                                self.addBottomSheetView(index: arrayOffset)
                            }
                        }
                    } else {
                        self.showNoNetwork()
                    }
                } else {
                    self.showNoNetwork()
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    func getContext() -> NSManagedObjectContext{
        
        let appDelegate =  UIApplication.shared.delegate as? AppDelegate
        if #available(iOS 10.0, *) {
            return
                appDelegate!.persistentContainer.viewContext
        } else {
            return appDelegate!.managedObjectContext
        }
    }
    func checkAddedToCoredata(entityName: String?,idKey:String?, idValue: String?) -> [NSManagedObject]
    {
        let managedContext = getContext()
        var fetchResults : [NSManagedObject] = []
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName!)
        if (idValue != nil) {
            fetchRequest.predicate = NSPredicate(format: "\(idKey!) == %@", idValue!)
            
        }
        fetchResults = try! managedContext.fetch(fetchRequest)
        return fetchResults
    }
    func showNodata() {

    }
    
    //MARK: LoadingView Delegate
    func tryAgainButtonPressed() {
        if  (networkReachability?.isReachable)! {
            self.getFloorMapDataFromServer()
        }
    }
    func showNoNetwork() {
        self.loadingView.stopLoading()
        self.loadingView.noDataView.isHidden = false
        self.loadingView.isHidden = false
        self.loadingView.showNoNetworkView()
    }
    
}
extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

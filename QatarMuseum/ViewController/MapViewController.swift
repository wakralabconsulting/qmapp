//
//  MapViewController.swift
//  QatarMuseums
//
//  Created by Exalture on 17/10/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import MapKit
import UIKit

class MapViewController: UIViewController,HeaderViewProtocol {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var headerView: CommonHeaderView!
    
    var aboutData : Museum?
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.headerViewDelegate = self
        
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//            locationManager.requestLocation()
//        }
        
        loadMapData()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func loadMapData() {
        var latitudeString  = String()
        var longitudeString = String()
        var latitude : Double?
        var longitude : Double?
        
        if (aboutData?.mobileLatitude != nil && aboutData?.mobileLatitude != "" && aboutData?.mobileLongtitude != nil && aboutData?.mobileLongtitude != "") {
            latitudeString = (aboutData?.mobileLatitude!)!
            longitudeString = (aboutData?.mobileLongtitude)!
            if let lat : Double = Double(latitudeString) {
                latitude = lat
            }
            if let long : Double = Double(longitudeString) {
                longitude = long
            }
            
            let location = CLLocationCoordinate2D(latitude: latitude!,
                                                  longitude: longitude!)
            
            // 2
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
            // let viewRegion = MKCoordinateRegionMakeWithDistance(location, 0.05, 0.05)
            //mapView.setRegion(viewRegion, animated: false)
            //3
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            //annotation.title = aboutData.name
            annotation.subtitle = aboutData?.name
            mapView.addAnnotation(annotation)
        }
    }
    
    @IBAction func setMapType(_ sender: UISwitch) {
        if sender.isOn == true {
            mapView.mapType = .satellite
        } else {
            mapView.mapType = .standard
        }
    }
    
    func headerCloseButtonPressed() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}

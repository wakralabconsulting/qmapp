//
//  ParkListTableViewCell.swift
//  QatarMuseums
//
//  Created by Exalture on 19/03/19.
//  Copyright © 2019 Wakralab. All rights reserved.
//

import MapKit
import UIKit

class ParkListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timimgTitle: UILabel!
    @IBOutlet weak var timimgTextLabel: UILabel!
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapOverlayView: UIView!
    var loadMapView : (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
        
    }
    func setUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        tap.delegate = self // This is not required
        mapOverlayView.addGestureRecognizer(tap)
    }
    func setParkListValues() {
        titleLabel.font = UIFont.invitationTextFont
        timimgTitle.font = UIFont.invitationTextFont
        locationTitle.font = UIFont.invitationTextFont
        descriptionLabel.font = UIFont.englishTitleFont
        timimgTextLabel.font = UIFont.englishTitleFont
        descriptionLabel.text = "adbj jdhd s kjsdskhksd  ksjdhkks d sjdksjdk sdksdhksjhdhs skdsd cskdcs sd shhsd ksdhk sdh sdhsd  sdj skd  dkhjshdk ksdjk sd skd ksdh skdjhshdk sd sdjshdhskd sd csdjh ksdhs dcksdhc sdkhkshd sdc sdhc sdc shuhriuerferjejke khgfrkgvk vjdfvhkdjhruhtrjlskjsdc ufhshfc sfch sfjcs fc scsfh sch fcisfhcsh  djsh dkfhvkfvndkjfvdk dkfvkdv dvdvd vdvdfv dfv dvhdvdbrfhriuriuerf d s csfhdfics cd"
        /*
         //Details For Map
         var latitudeString  = String()
         var longitudeString = String()
         var latitude : Double?
         var longitude : Double?
         
         if (facilitiesDetailData?.latitude != nil && facilitiesDetailData?.latitude != "" && facilitiesDetailData?.longtitude != nil && facilitiesDetailData?.longtitude != "") {
         latitudeString = (facilitiesDetailData?.latitude)!
         longitudeString = (facilitiesDetailData?.longtitude)!
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
         //3
         let annotation = MKPointAnnotation()
         annotation.coordinate = location
         mapView.addAnnotation(annotation)
 */
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.loadMapView?()
    }

}

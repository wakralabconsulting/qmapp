//
//  File.swift
//  QatarMuseums
//
//  Created by Exalture on 03/12/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import Foundation
struct NMoQTour: ResponseObjectSerializable, ResponseCollectionSerializable {
    var title: String? = nil
    var dayDescription: String? = nil
    var images: [String]? = []
    var subtitle: String? = nil
    var sort_id: String? = nil
    var nid: String? = nil
    var eventDate: String? = nil
    //For Special Events
    var date: String? = nil
    var descriptioForModerator: String? = nil
    var mobileLatitude: String? = nil
    var moderatorName: String? = nil
    var longitude: String? = nil
    var contactEmail: String? = nil
    var contactPhone: String? = nil
    
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.title = representation["Day"] as? String
            self.dayDescription = representation["descriptif_day"] as? String
            self.images = representation["Images"] as? [String]
            self.subtitle = representation["subtitle"] as? String
            self.sort_id = representation["sort_id"] as? String
            self.nid = representation["nid"] as? String
            self.eventDate = representation["NMoq_event_Date"] as? String
            //For Special Events
            self.date = representation["Date"] as? String
            self.descriptioForModerator = representation["description_for_moderator"] as? String
            self.mobileLatitude = representation["latitude"] as? String
            self.moderatorName = representation["moderator_name"] as? String
            self.longitude = representation["longitude"] as? String
            self.contactEmail = representation["contact_email"] as? String
            self.contactPhone = representation["contact_phone"] as? String
        }
    }
    
    //    init (title:String?, fullContentID: String?, bannerTitle: String?, bannerLink: String?) {
    //        self.title = title
    //        self.fullContentID = fullContentID
    //        self.bannerTitle = bannerTitle
    //        self.bannerLink = bannerLink
    //    }
}

struct NMoQTourList: ResponseObjectSerializable {
    var nmoqTourList: [NMoQTour]? = []
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let data = representation as? [[String: Any]] {
            self.nmoqTourList = NMoQTour.collection(response: response, representation: data as AnyObject)
        }
    }
}

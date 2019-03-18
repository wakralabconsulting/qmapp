//
//  Facilities.swift
//  QatarMuseums
//
//  Created by Exalture on 18/03/19.
//  Copyright © 2019 Wakralab. All rights reserved.
//

import Foundation
struct Facilities: ResponseObjectSerializable, ResponseCollectionSerializable {
    var title: String? = nil
    var sortId: String? = nil
    var nid: String? = nil
    var images: [String]? = []
    
    
    var dayDescription: String? = nil
    var subtitle: String? = nil
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
            self.title = representation["Title"] as? String
            self.sortId = representation["sort_id"] as? String
            self.nid = representation["nid"] as? String
            self.images = representation["images "] as? [String]

            self.dayDescription = representation["descriptif_day"] as? String
            self.subtitle = representation["subtitle"] as? String
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
    
    init (title:String?, sortId: String?,nid: String?, images: [String]?) {
        // init (title:String?, sortId: String?,nid: String?, images: [String]?, subtitle: String?,sortId:String?,  eventDate: String?, date: String?, descriptioForModerator: String?, mobileLatitude: String?,moderatorName:String?, longitude: String?, contactEmail: String?, contactPhone: String?) {
        self.title = title
        self.images = images
        self.sortId = sortId
        self.nid = nid
//        self.eventDate = eventDate
//        self.date = date
//        self.descriptioForModerator = descriptioForModerator
//        self.mobileLatitude = mobileLatitude
//        self.moderatorName = moderatorName
//        self.longitude = longitude
//        self.contactEmail = contactEmail
//        self.contactPhone = contactPhone
    }
}

struct FacilitiesData: ResponseObjectSerializable {
    var facilitiesList: [Facilities]? = []
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let data = representation as? [[String: Any]] {
            self.facilitiesList = Facilities.collection(response: response, representation: data as AnyObject)
        }
    }
}


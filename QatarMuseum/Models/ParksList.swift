//
//  ParksList.swift
//  QatarMuseums
//
//  Created by Exalture on 09/08/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Foundation
struct ParksList: ResponseObjectSerializable, ResponseCollectionSerializable {
    var title: String? = nil
    var description: String? = nil
    var sortId: String? = nil
    var image: String? = nil
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.title = representation["Title"] as? String
            self.description = representation["Description"] as? String
            self.sortId = representation["sort_id"] as? String
            self.image = representation["image"] as? String
        }
    }
    init(title:String?, description:String?, sortId: String?, image: String?) {
        self.title = title
        self.description = description
        self.sortId = sortId
        self.image = image
    }
}

struct ParksLists: ResponseObjectSerializable {
    var parkList: [ParksList]? = []
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let data = representation as? [[String: Any]] {
            self.parkList = ParksList.collection(response: response, representation: data as AnyObject)
        }
    }
}
//struct NMoQParksList: ResponseObjectSerializable, ResponseCollectionSerializable {
//    var title: String? = nil
//    var mainDescription: String? = nil
//    var hoursTitle: String? = nil
//    var hoursDesc: String? = nil
//    var nid: String? = nil
//    var longitude: String? = nil
//    var latitude: String? = nil
//    var locationTitle: String? = nil
//    
//    public init?(response: HTTPURLResponse, representation: AnyObject) {
//        if let representation = representation as? [String: Any] {
//            self.title = representation["park_title"] as? String
//            self.mainDescription = representation["Main_description"] as? String
//            self.hoursTitle = representation["park_hours_title"] as? String
//            self.hoursDesc = representation["parks_hours_description"] as? String
//            
//            self.nid = representation["parks_hours_description"] as? String
//            self.longitude = representation["parks_hours_description"] as? String
//            self.latitude = representation["parks_hours_description"] as? String
//            self.locationTitle = representation["parks_hours_description"] as? String
//        }
//    }
//    init(title:String?, description:String?, sortId: String?, image: String?) {
//        self.title = title
//        self.description = description
//        self.sortId = sortId
//        self.image = image
//    }
//}

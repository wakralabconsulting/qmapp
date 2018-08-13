//
//  Exhibition.swift
//  QatarMuseums
//
//  Created by Developer on 24/07/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Foundation

struct Exhibition: ResponseObjectSerializable, ResponseCollectionSerializable {
    var id: String? = nil
    var name: String? = nil
    var image: String? = nil
    var location: String? = nil
    var latitude: String? = nil
    var longitude: String? = nil
    var startDate: String? = nil
    var endDate: String? = nil
    var shortDescription: String? = nil
    var longDescription: String? = nil
    var isFavourite : Bool = false
    var isOpen : Bool = false

    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.id = representation["ID"] as? String
            self.name = representation["name"] as? String
            self.image = representation["latest_image"] as? String
            self.location = representation["Location"] as? String
            self.latitude  = representation["Latitude"] as? String
            self.longitude  = representation["Longitude"] as? String
            self.startDate  = representation["start_Date"] as? String
            self.endDate  = representation["end_Date"] as? String
            self.shortDescription  = representation["Short_description"] as? String
            self.longDescription  = representation["Long_description"] as? String
        }
    }
}

struct Exhibitions: ResponseObjectSerializable {
    var exhibitions: [Exhibition]? = []
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let data = representation as? [[String: Any]] {
            self.exhibitions = Exhibition.collection(response: response, representation: data as AnyObject)
        }
    }
}


//
//  HeritageDetail.swift
//  QatarMuseums
//
//  Created by Exalture on 03/08/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Foundation
struct HeritageDetail: ResponseObjectSerializable, ResponseCollectionSerializable {
    var id: String? = nil
    var name: String? = nil
    var location: String? = nil
    var latitude: String? = nil
    var longitude: String? = nil
    var fielditemid: String? = nil
    var image: String? = nil
    var shortdescription: String? = nil
    var longdescription: String? = nil
    //HeritageListList
    var sortid: String? = nil
    var isFavourite : Bool = false
    
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.id = representation["ID"] as? String
            self.name = representation["name"] as? String
            self.location = representation["Location"] as? String
            self.latitude = representation["Latitude"] as? String
            self.longitude = representation["Longitude"] as? String
            self.fielditemid = representation["field_collection_item_field_data_field_body_elements_item_id"] as? String
            self.image = representation["LATEST_IMAGE"] as? String
            self.shortdescription = representation["short_description"] as? String
            self.longdescription = representation["long_description"] as? String
            //HeritageListList
            self.sortid = representation["SORT_ID"] as? String
            
        }
    }
}

struct HeritageDetails: ResponseObjectSerializable {
    var heritageDetail: [HeritageDetail]? = []
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let data = representation as? [[String: Any]] {
            self.heritageDetail = HeritageDetail.collection(response: response, representation: data as AnyObject)
        }
    }
}


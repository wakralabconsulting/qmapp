//
//  DiningDetail.swift
//  QatarMuseums
//
//  Created by Exalture on 02/08/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Foundation
struct DiningDetail: ResponseObjectSerializable, ResponseCollectionSerializable {
    var id: String? = nil
    var name: String? = nil
    var location: String? = nil
    var description: String? = nil
    var image: String? = nil
    var openingtime: String? = nil
    var closetime: String? = nil
    var sortid: String? = nil
    
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.id = representation["ID"] as? String
            self.name = representation["name"] as? String
            self.location = representation["Location"] as? String
            self.description = representation["Description"] as? String
            self.image = representation["image"] as? String
            self.openingtime = representation["opening time"] as? String
            self.closetime = representation["close time"] as? String
            self.sortid = representation["sort_id"] as? String
            
        }
    }
}

struct DiningDetails: ResponseObjectSerializable {
    var diningDetail: [DiningDetail]? = []
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let data = representation as? [[String: Any]] {
            self.diningDetail = DiningDetail.collection(response: response, representation: data as AnyObject)
        }
    }
}

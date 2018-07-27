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
    var date: String? = nil
    var isFavourite : Bool = false
    var isOpen : Bool = false

    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.id = representation["ID"] as? String
            self.name = representation["name"] as? String
            self.image = representation["LATEST IMAGE"] as? String
            self.location = representation["Location"] as? String
            self.date  = representation["Date"] as? String 
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


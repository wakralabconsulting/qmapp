//
//  Museum.swift
//  QatarMuseums
//
//  Created by Exalture on 22/08/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Foundation
struct Museum: ResponseObjectSerializable, ResponseCollectionSerializable {
    var mid: String? = nil
    var filter: String? = nil
    var title: String? = nil
    var image1: String? = nil
    var image2: String? = nil
    var image3: String? = nil
    
    
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.mid = representation["mid"] as? String
            self.filter = representation["filter"] as? String
            self.title = representation["title"] as? String
            self.image1 = representation["image1"] as? String
            self.image2 = representation["image2"] as? String
            self.image3 = representation["image3"] as? String
            
            
        }
    }
    init(mid:String?, filter: String?,title:String?,icon:String?,image1:String?,image2:String?,image3:String?) {
        self.mid = mid
        self.filter = filter
        self.title = title
        self.image1 = image1
        self.image2 = image2
        self.image3 = image3
    }
}

struct Museums: ResponseObjectSerializable {
    var museum: [Museum]? = []
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let data = representation as? [[String: Any]] {
            self.museum = Museum.collection(response: response, representation: data as AnyObject)
        }
    }
}

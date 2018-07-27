//
//  HeritageList.swift
//  QatarMuseums
//
//  Created by Exalture on 27/07/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Foundation
struct HeritageList: ResponseObjectSerializable, ResponseCollectionSerializable {
    var id: String? = nil
    var name: String? = nil
    var image: String? = nil
    var sortid: String? = nil
    var isFavourite : Bool = false
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.id = representation["ID"] as? String
            self.name = representation["name"] as? String
            self.image = representation["LATEST IMAGE"] as? String
            self.sortid = representation["ORT ID"] as? String
           
        }
    }
}

struct HeritageLists: ResponseObjectSerializable {
    var heritageLists: [HeritageList]? = []
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let data = representation as? [[String: Any]] {
            self.heritageLists = HeritageList.collection(response: response, representation: data as AnyObject)
        }
    }
}

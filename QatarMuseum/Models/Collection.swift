//
//  Collection.swift
//  QatarMuseums
//
//  Created by Developer on 17/08/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Foundation

struct Collection: ResponseObjectSerializable, ResponseCollectionSerializable {
    var name: String? = nil
    var image: String? = nil
    var museumsReference: String? = nil
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.name = representation["Name"] as? String
            self.image = representation["image"] as? String
            self.museumsReference = representation["Museums_reference"] as? String
        }
    }
    init(name:String?,image:String?,museumsReference:String?) {
        self.name = name
        self.image = image
        self.museumsReference = museumsReference
    }
}

struct Collections: ResponseObjectSerializable {
    var collections: [Collection]? = []
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let data = representation as? [[String: Any]] {
            self.collections = Collection.collection(response: response, representation: data as AnyObject)
        }
    }
}

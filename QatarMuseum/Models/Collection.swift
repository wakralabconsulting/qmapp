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
    var category: String? = nil
    var collectionDescription: String? = nil
    var museumId: String? = nil
    //For Detail Page
    var title : String? = nil
    var about : String? = nil
    var imgHighlight : String? = nil
    var imageMain : String? = nil
    var shortDesc : String? = nil
    var highlightDesc : String? = nil
    var longDesc : String? = nil
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.name = representation["Name"] as? String
            self.image = representation["image"] as? String
            self.category = representation["category"] as? String
            self.collectionDescription = representation["collection_description"] as? String
            self.museumId = representation["museum_id"] as? String
            //For Detail Page
            self.title = representation["Title"] as? String
            self.about = representation["about"] as? String
            self.imgHighlight = representation["image_highlight"] as? String
            self.imageMain = representation["image_main"] as? String
            self.shortDesc = representation["short_description"] as? String
            self.highlightDesc = representation["highlight_description"] as? String
            self.longDesc = representation["long_description"] as? String
            
        }
    }
    init(name:String?,image:String?,category:String?,collectionDescription:String?,museumId:String?,title: String?,about: String?,imgHighlight: String?,imageMain: String?,shortDesc: String?,highlightDesc: String?,longDesc: String?) {
        self.name = name
        self.image = image
        self.category = category
        self.collectionDescription = collectionDescription
        self.museumId = museumId
        //For Detail Page
        self.title = title
        self.about = about
        self.imgHighlight = imgHighlight
        self.imageMain = imageMain
        self.shortDesc = shortDesc
        self.highlightDesc = highlightDesc
        self.longDesc = longDesc
        
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

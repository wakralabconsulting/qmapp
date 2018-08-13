//
//  PublicArtsDetail.swift
//  QatarMuseums
//
//  Created by Exalture on 05/08/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Foundation
struct PublicArtsDetail: ResponseObjectSerializable, ResponseCollectionSerializable {
    var id: String? = nil
    var name: String? = nil
    var description: String? = nil
    var shortdescription: String? = nil
    var image: String? = nil
    
    
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.id = representation["ID"] as? String
            self.name = representation["name"] as? String
            self.description = representation["Description"] as? String
            self.shortdescription = representation["short_description"] as? String
            self.image = representation["Teaser_image"] as? String
            
        }
    }
    init(id:String?,name:String?,description:String?,shortdescription:String?,image:String?) {
        self.id = id
        self.name = name
        self.description = description
        self.shortdescription = id
        self.image = image
    }
}

struct PublicArtsDetails: ResponseObjectSerializable {
    var publicArtsDetail: [PublicArtsDetail]? = []
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let data = representation as? [[String: Any]] {
            self.publicArtsDetail = PublicArtsDetail.collection(response: response, representation: data as AnyObject)
        }
    }
}

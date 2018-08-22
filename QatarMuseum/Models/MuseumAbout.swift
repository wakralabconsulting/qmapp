//
//  MuseumAbout.swift
//  QatarMuseums
//
//  Created by Exalture on 22/08/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Foundation
struct MuseumAbout: ResponseObjectSerializable, ResponseCollectionSerializable {
    var mid: String? = nil
    var filter: String? = nil
    var title: String? = nil
    var shortDesc: String? = nil
    var image: String? = nil
    var subTitle: String? = nil
    var longDesc: String? = nil
    var openingTime: String? = nil
    var latitude: String? = nil
    var longitude: String? = nil
    var contact : String? = nil


    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.mid = representation["mid"] as? String
            self.filter = representation["filter"] as? String
            self.title = representation["title"] as? String
            self.shortDesc = representation["short_desc"] as? String
            self.image = representation["image"] as? String
            self.subTitle = representation["subtitle"] as? String
            self.longDesc = representation["long_desc"] as? String
            self.openingTime = representation["opening_time"] as? String
            self.latitude = representation["latitude"] as? String
            self.longitude = representation["longitude"] as? String
            self.contact = representation["contact"] as? String

        }
    }
    init(mid:String?,filter:String?,title:String?,shortDesc:String?,image:String?,subTitle:String?,longDesc:String?,openingTime:String?,latitude:String?,longitude:String?,contact:String?) {
        self.mid = mid
        self.filter = filter
        self.title = title
        self.shortDesc = shortDesc
        self.image = image
        self.subTitle = subTitle
        self.longDesc = longDesc
        self.openingTime = openingTime
        self.latitude = latitude
        self.longitude = longitude
        self.contact = contact

    }
}

struct MuseumAboutDetails: ResponseObjectSerializable {
    var museumAbout: [MuseumAbout]? = []

    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let data = representation as? [[String: Any]] {
            self.museumAbout = MuseumAbout.collection(response: response, representation: data as AnyObject)
        }
    }
}


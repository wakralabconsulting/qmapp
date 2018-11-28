//
//  HomeBanner.swift
//  QatarMuseums
//
//  Created by Exalture on 27/11/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import Foundation
struct HomeBanner: ResponseObjectSerializable, ResponseCollectionSerializable {
    var title: String? = nil
    var fullContentID: String? = nil
    var bannerTitle: String? = nil
    var bannerLink: String? = nil
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.title = representation["Title"] as? String
            self.fullContentID = representation["full_content_ID"] as? String
            self.bannerTitle = representation["Banner_title"] as? String
            self.bannerLink = representation["banner_link"] as? String
        }
    }
    
//    init (title:String?, fullContentID: String?, bannerTitle: String?, bannerLink: String?) {
//        self.title = title
//        self.fullContentID = fullContentID
//        self.bannerTitle = bannerTitle
//        self.bannerLink = bannerLink
//    }
}

struct HomeBannerList: ResponseObjectSerializable {
    var homeBannerList: [HomeBanner]? = []
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let data = representation as? [[String: Any]] {
            self.homeBannerList = HomeBanner.collection(response: response, representation: data as AnyObject)
        }
    }
}

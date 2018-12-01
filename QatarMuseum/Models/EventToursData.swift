//
//  EventToursData.swift
//  QatarMuseums
//
//  Created by Musheer on 11/30/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import Foundation

struct EventToursList: ResponseObjectSerializable, ResponseCollectionSerializable {
    var title: String? = nil
    var description: String? = nil
    var sortId: String? = nil
    var image: String? = nil
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.title = representation["Title"] as? String
            self.description = representation["Description"] as? String
            self.sortId = representation["sort_id"] as? String
            self.image = representation["image"] as? String
        }
    }
    init(title:String?, description:String?, sortId: String?, image: String?) {
        self.title = title
        self.description = description
        self.sortId = sortId
        self.image = image
    }
}

struct EventToursLists: ResponseObjectSerializable {
    var eventToursList: [EventToursList]? = []
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let data = representation as? [[String: Any]] {
            self.eventToursList = EventToursList.collection(response: response, representation: data as AnyObject)
        }
    }
}

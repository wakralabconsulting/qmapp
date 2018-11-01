//
//  Notification.swift
//  QatarMuseums
//
//  Created by Developer on 01/11/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import Foundation
struct Notification: ResponseObjectSerializable, ResponseCollectionSerializable {
    var title: String? = nil
    var sortId: String? = nil
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.title = representation["Title"] as? String
            self.sortId = representation["sort_id"] as? String
        }
    }
    
    init(title:String?, sortId: String?) {
        self.title = title
        self.sortId = sortId
    }
}

struct Notifications: ResponseObjectSerializable {
    var notification: [Notification]? = []
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let data = representation as? [[String: Any]] {
            self.notification = Notification.collection(response: response, representation: data as AnyObject)
        }
    }
}

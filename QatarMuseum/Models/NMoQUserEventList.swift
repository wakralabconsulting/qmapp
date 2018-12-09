//
//  NMoQUserEventList.swift
//  QatarMuseums
//
//  Created by Exalture on 07/12/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import Foundation
struct NMoQUserEventList: ResponseObjectSerializable, ResponseCollectionSerializable {
    var title: String? = nil
    var eventID: String? = nil
    
    
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.title = representation["Title"] as? String
            self.eventID = representation["event_ID"] as? String
            
        }
    }
    
    init (title:String?, eventID: String?) {
        self.title = title
        self.eventID = eventID
        
    }
}

struct NMoQUserEventListValues: ResponseObjectSerializable {
    var eventList: [NMoQUserEventList]? = []
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let data = representation as? [[String: Any]] {
            self.eventList = NMoQUserEventList.collection(response: response, representation: data as AnyObject)
        }
    }
}

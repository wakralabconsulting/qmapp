//
//  LogoutData.swift
//  QatarMuseums
//
//  Created by Exalture on 24/10/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import Foundation
struct LogoutData: ResponseObjectSerializable {
    var uid: String? = nil
    var hostName: String? = nil
    var roles: [String: Any] = [:]
    var cache: String? = nil
    
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.uid = representation["sessid"] as? String
            self.hostName = representation["session_name"] as? String
            self.roles = (representation["roles"] as? [String: Any])!
            self.cache = representation["result"] as? String
            
        }
    }
}

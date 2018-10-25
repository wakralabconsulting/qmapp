//
//  TokenData.swift
//  QatarMuseums
//
//  Created by Exalture on 23/10/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import Foundation
struct TokenData: ResponseObjectSerializable {
    var accessToken: String? = nil
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.accessToken = representation["token"] as? String
            
        }
    }
}

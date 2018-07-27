//
//  QatarMuseumRouter.swift
//  QatarMuseums
//
//  Created by Developer on 24/07/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Foundation
import Alamofire

enum QatarMuseumRouter: URLRequestConvertible {
    case ExhibitionList()
    case HomeList()

    var method: Alamofire.HTTPMethod {
        switch self {
        case .ExhibitionList:
            return .get
        case .HomeList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .ExhibitionList:
            return "/Exhibition_List_Page.json"
        case .HomeList:
            return "/gethomeList.json"
        }
    }
    
    // MARK:- URLRequestConvertible
    public var request: URLRequest {
        let URL = NSURL(string: Config.baseURL + lang() + Config.mobileApiURL)!
        var mutableURLRequest = URLRequest(url: URL.appendingPathComponent(path)!)
        mutableURLRequest.httpMethod = method.rawValue
        if let accessToken = UserDefaults.standard.value(forKey: "accessToken")
            as? String {
            mutableURLRequest.setValue("Bearer " + accessToken,
                                       forHTTPHeaderField: "Authorization")
        }
        switch self {
        case .ExhibitionList():
            return try! Alamofire.JSONEncoding.default.encode(mutableURLRequest)
        case .HomeList():
            return try! Alamofire.JSONEncoding.default.encode(mutableURLRequest)
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        return request
    }
    
    public func lang() -> String {
        return LocalizationLanguage.currentAppleLanguage()
    }
}

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
    case HeritageList()
    case ExhibitionDetail(String)

    var method: Alamofire.HTTPMethod {
        switch self {
        case .ExhibitionList:
            return .get
        case .HomeList:
            return .get
        case .HeritageList:
            return .get
        case .ExhibitionDetail:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .ExhibitionList:
            return "/Exhibition_List_Page.json"
        case .HomeList:
            return "/gethomeList.json"
        case .HeritageList:
            return "/Heritage_List_Page.json"
        case .ExhibitionDetail(let exhibitionId):
            return "/Exhibition_detail_Page.json?nid=\(exhibitionId)"
        }
    }

    // MARK:- URLRequestConvertible
    public var request: URLRequest {
        let baseURLString = Config.baseURL + lang() + Config.mobileApiURL
        let URLString = baseURLString + path
        let urlwithPercent = URLString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        var mutableURLRequest = URLRequest(url: URL(string: urlwithPercent!)!)
//        var mutableURLRequest = URLRequest(url: URL.appendingPathComponent(path))

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
        case .HeritageList():
            return try! Alamofire.JSONEncoding.default.encode(mutableURLRequest)
        case .ExhibitionDetail( _):
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

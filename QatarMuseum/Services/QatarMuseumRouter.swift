//
//  QatarMuseumRouter.swift
//  QatarMuseums
//
//  Created by Developer on 24/07/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Alamofire
import Foundation

enum QatarMuseumRouter: URLRequestConvertible {
    case ExhibitionList()
    case MuseumExhibitionList([String: Any])
    case HomeList()
    case HeritageList()
    case ExhibitionDetail([String: Any])
    case DiningList()
    case PublicArtsList()
    case ParksList()
    case GetDiningDetail([String: Any])
    case HeritageDetail([String: Any])
    case GetPublicArtsDetail([String: Any])
    case CollectionList([String: Any])
    case EducationEvent([String: Any])
    case MuseumAbout([String: Any])
    case LandingPageMuseums([String: Any])
    case MuseumDiningList([String: Any])
    case CollectionDetail([String: Any])
    case MuseumTourGuide([String: Any])
    case CollectionByTourGuide([String: Any])
    case GetToken(String: Any,[String: Any])
    case Login(String: Any, String: Any,[String: Any])
    case Logout(String: Any, String: Any,[String: Any])

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
        case .DiningList:
            return .get
        case .PublicArtsList:
            return .get
        case .ParksList:
            return .get
        case .GetDiningDetail:
            return .get
        case .HeritageDetail:
            return .get
        case .GetPublicArtsDetail:
            return .get
        case .CollectionList:
            return .get
        case .EducationEvent:
            return .get
        case .MuseumAbout:
            return .get
        case .LandingPageMuseums:
            return .get
        case .MuseumDiningList:
            return .get
        case .MuseumExhibitionList:
            return .get
        case .CollectionDetail:
            return .get
        case .MuseumTourGuide:
            return .get
        case .CollectionByTourGuide:
            return .get
        case .GetToken:
            return .post
        case .Login:
            return .post
        case .Logout:
            return .post
        
        }
    }
    
    var path: String {
        switch self {
        case .ExhibitionList:
            return "Exhibition_List_Page.json"
        case .HomeList:
            return "/gethomeList.json"
        case .HeritageList:
            return "/Heritage_List_Page.json"
        case .ExhibitionDetail( _):
            return "/Exhibition_detail_Page.json"
        case .DiningList:
            return "/getDiningList.json"
        case .ParksList:
            return "/park_service_combined.json"
        case .PublicArtsList:
            return "/Public_Arts_List_Page.json"
        case .GetDiningDetail( _):
            return "/getDiningdetail.json"
        case .HeritageDetail( _):
            return "/heritage_detail_Page.json"
        case .GetPublicArtsDetail( _):
            return "/getpublicartdetail.json"
        case .CollectionList( _):
            return "/museum_collection_category.json"
        case .CollectionDetail( _):
            return "/collection_ws.json"
        case .EducationEvent( _):
            return "/new_ws_educations.json"
        case .MuseumAbout( _):
            return "/about.php"
        case .LandingPageMuseums( _):
            return "/museum-detail.json"
        case .MuseumDiningList( _):
            return "/getDiningList.json"
        case .MuseumExhibitionList( _):
            return "Exhibition_List_Page.json"
        case .MuseumTourGuide( _):
            return "tour_guide_list_museums.json"
        case .CollectionByTourGuide( _):
            return "collection_by_tour_guide.json"
        case .GetToken( _,_):
            return "user/token.json"
        case .Login( _,_,_):
            return "user/login.json"
        case .Logout( _,_,_):
            return "user/logout.json"
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
        case .MuseumExhibitionList(let parameters):
            return try! Alamofire.URLEncoding.default.encode(mutableURLRequest, with: parameters)
        case .HomeList():
            return try! Alamofire.JSONEncoding.default.encode(mutableURLRequest)
        case .HeritageList():
            return try! Alamofire.JSONEncoding.default.encode(mutableURLRequest)
        case .ExhibitionDetail(let parameters):
            return try! Alamofire.URLEncoding.default.encode(mutableURLRequest, with: parameters)
        case .DiningList():
            return try! Alamofire.JSONEncoding.default.encode(mutableURLRequest)
        case .MuseumDiningList(let parameters):
            return try! Alamofire.URLEncoding.default.encode(mutableURLRequest, with: parameters)
        case .PublicArtsList():
            return try! Alamofire.JSONEncoding.default.encode(mutableURLRequest)
        case .ParksList():
            return try! Alamofire.JSONEncoding.default.encode(mutableURLRequest)
        case .GetDiningDetail(let parameters):
            return try! Alamofire.URLEncoding.default.encode(mutableURLRequest, with: parameters)
        case .HeritageDetail(let parameters):
            return try! Alamofire.URLEncoding.default.encode(mutableURLRequest, with: parameters)
        case .GetPublicArtsDetail(let parameters):
            return try! Alamofire.URLEncoding.default.encode(mutableURLRequest, with: parameters)
        case .LandingPageMuseums(let parameters):
            return try! Alamofire.URLEncoding.default.encode(mutableURLRequest, with: parameters)
        case .CollectionList(let parameters):
            return try! Alamofire.URLEncoding.default.encode(mutableURLRequest, with: parameters)
        case .CollectionDetail(let parameters):
            return try! Alamofire.URLEncoding.default.encode(mutableURLRequest, with: parameters)
        case .EducationEvent(let parameters):
            return try! Alamofire.URLEncoding.default.encode(mutableURLRequest, with: parameters)
        case .CollectionByTourGuide(let parameters):
            return try! Alamofire.URLEncoding.default.encode(mutableURLRequest, with: parameters)
        case .MuseumAbout(let parameters):
            let aboutURL = NSURL(string: Config.tempBaseIP + lang())!
            var mutableURLReq = URLRequest(url: aboutURL.appendingPathComponent(path)!)
            mutableURLReq.httpMethod = method.rawValue
            return try! Alamofire.URLEncoding.default.encode(mutableURLReq, with: parameters)
        case .MuseumTourGuide(let parameters):
            return try! Alamofire.URLEncoding.default.encode(mutableURLRequest, with: parameters)
        case .GetToken(let contentType,let parameters):
            let tokenURL = NSURL(string: Config.secureBaseURL + lang() + Config.mobileApiURL)!
            var tokenMutableURLReq = URLRequest(url: tokenURL.appendingPathComponent(path)!)
            tokenMutableURLReq.httpMethod = method.rawValue
            tokenMutableURLReq.setValue(contentType as? String, forHTTPHeaderField: "Content-Type")
            return try! Alamofire.JSONEncoding.default.encode(tokenMutableURLReq, with: parameters)
        case .Login(let token, let contentType, let parameters):
            let loginURL = NSURL(string: Config.secureBaseURL + lang() + Config.mobileApiURL)!
            var loginMutableURLReq = URLRequest(url: loginURL.appendingPathComponent(path)!)
            loginMutableURLReq.httpMethod = method.rawValue
            loginMutableURLReq.setValue(token as? String, forHTTPHeaderField: "x-csrf-token")
            loginMutableURLReq.setValue(contentType as? String, forHTTPHeaderField: "Content-Type")
            return try! Alamofire.JSONEncoding.default.encode(loginMutableURLReq, with: parameters)
        case .Logout(let token, let contentType, let parameters):
            let logoutURL = NSURL(string: Config.secureBaseURL + lang() + Config.mobileApiURL)!
            var logoutMutableURLReq = URLRequest(url: logoutURL.appendingPathComponent(path)!)
            logoutMutableURLReq.httpMethod = method.rawValue
            logoutMutableURLReq.setValue(token as? String, forHTTPHeaderField: "x-csrf-token")
            logoutMutableURLReq.setValue(contentType as? String, forHTTPHeaderField: "Content-Type")
            return try! Alamofire.JSONEncoding.default.encode(logoutMutableURLReq, with: parameters)
            
            
        }
        
    }
    
    public func asURLRequest() throws -> URLRequest {
        return request
    }
    
    public func lang() -> String {
        return LocalizationLanguage.currentAppleLanguage()
    }
}

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
    //case EducationEvent(String: Any, String: Any, String : Any, String:Any)
    case EducationEvent([String: Any])
    case MuseumAbout([String: Any])
    case LandingPageMuseums([String: Any])
    case MuseumDiningList([String: Any])
    case CollectionDetail([String: Any])


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
//        case .EducationEvent( _):
//            return "/geturl.php"
        case .EducationEvent( _):
            return "/ws_education.json"
        case .MuseumAbout( _):
            return "/about.php"
//        case .LandingPageMuseums( _):
//            return "/museum_landing.php"
        case .LandingPageMuseums( _):
            return "/museum-detail.json"
        case .MuseumDiningList( _):
            return "/getDiningList.json"
        case .MuseumExhibitionList( _):
            return "Exhibition_List_Page.json"
        
            //Used for Temporary API
//        case .CollectionList( _):
//            return "/museum_collection_category.php"
//        case .CollectionDetail( _):
//            return "/collection_by_category.php"

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
//        case .EducationEvent(let date, let ageGroup, let inst, let prog):
//            let educationURL = NSURL(string: Config.tempBaseIP + lang())!
//            var mutableURLReq = URLRequest(url: educationURL.appendingPathComponent(path)!)
//            mutableURLReq.httpMethod = method.rawValue
//            mutableURLReq.setValue(date as? String, forHTTPHeaderField: "date")
//            mutableURLReq.setValue(inst as? String, forHTTPHeaderField: "inst")
//            mutableURLReq.setValue(ageGroup as? String, forHTTPHeaderField: "age")
//            mutableURLReq.setValue(prog as? String, forHTTPHeaderField: "ptype")
//            if let accessToken = UserDefaults.standard.value(forKey: "accessToken")
//                as? String {
//                mutableURLReq.setValue("Bearer " + accessToken,
//                                           forHTTPHeaderField: "Authorization")
//            }
//            return try! Alamofire.JSONEncoding.default.encode(mutableURLReq)
        case .MuseumAbout(let parameters):
            let aboutURL = NSURL(string: Config.tempBaseIP + lang())!
            var mutableURLReq = URLRequest(url: aboutURL.appendingPathComponent(path)!)
            mutableURLReq.httpMethod = method.rawValue
            return try! Alamofire.URLEncoding.default.encode(mutableURLReq, with: parameters)
//        case .LandingPageMuseums(let parameters):
//            let museumURL = NSURL(string: Config.tempBaseIP + lang())!
//            var mutableURLReq = URLRequest(url: museumURL.appendingPathComponent(path)!)
//            mutableURLReq.httpMethod = method.rawValue
//            return try! Alamofire.URLEncoding.default.encode(mutableURLReq, with: parameters)
//        case .DiningList():
//            let diningURL = NSURL(string: Config.tempBaseIP + lang())!
//            var diningMutableURLReq = URLRequest(url: diningURL.appendingPathComponent(path)!)
//            diningMutableURLReq.httpMethod = method.rawValue
//            return try! Alamofire.JSONEncoding.default.encode(diningMutableURLReq)
//        case .MuseumDiningList(let parameters):
//            let diningURL = NSURL(string: Config.tempBaseIP + lang())!
//            var diningMutableURLReq = URLRequest(url: diningURL.appendingPathComponent(path)!)
//            diningMutableURLReq.httpMethod = method.rawValue
//            return try! Alamofire.URLEncoding.default.encode(diningMutableURLReq, with: parameters)
//            //Temporary API
//        case .CollectionList(let parameters):
//            let collectionURL = NSURL(string: Config.tempBaseIP + lang() + Config.mobileApiURL)!
//            var collectionMutableURLReq = URLRequest(url: collectionURL.appendingPathComponent(path)!)
//            collectionMutableURLReq.httpMethod = method.rawValue
//            return try! Alamofire.URLEncoding.default.encode(collectionMutableURLReq, with: parameters)
//        case .CollectionDetail(let parameters):
//            let collectionURL = NSURL(string: Config.tempBaseIP + lang() + Config.mobileApiURL)!
//            var collectionMutableURLReq = URLRequest(url: collectionURL.appendingPathComponent(path)!)
//            collectionMutableURLReq.httpMethod = method.rawValue
//            return try! Alamofire.URLEncoding.default.encode(collectionMutableURLReq, with: parameters)
        
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        return request
    }
    
    public func lang() -> String {
        return LocalizationLanguage.currentAppleLanguage()
    }
}

//
//  TourGuideFloorMap.swift
//  QatarMuseums
//
//  Created by Exalture on 25/09/18.
//  Copyright © 2018 Wakralab. All rights reserved.
//

import Foundation
struct TourGuideFloorMap: ResponseObjectSerializable, ResponseCollectionSerializable {
    var title: String? = nil
    var accessionNumber: String? = nil
    var nid: String? = nil
    var curatorialDescription: String? = nil
    var diam: String? = nil
    var dimensions: String? = nil
    var mainTitle: String? = nil
    var objectENGSummary: String? = nil
    var objectHistory: String? = nil
    var production: String? = nil
    
    var productionDates: String? = nil
    var image: String? = nil
    var tourGuideId: String? = nil
    var floorLevel: String? = nil
    
    var galleyNumber: String? = nil
    var artistOrCreatorOrAuthor: String? = nil
    var periodOrStyle: String? = nil
    var techniqueAndMaterials : String? = nil
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.title = representation["Title"] as? String
            self.accessionNumber = representation["Accession_Number"] as? String
            self.nid = representation["nid"] as? String
            self.curatorialDescription = representation["Curatorial_Description"] as? String
            self.diam = representation["Diam"] as? String
            self.dimensions = representation["Dimensions"] as? String
            self.mainTitle = representation["Main_Title"] as? String
            self.objectENGSummary = representation["Object_ENG_Summary"] as? String
            self.objectHistory = representation["Object_History"] as? String
            
            self.production = representation["Production"] as? String
            self.productionDates = representation["Production_dates"] as? String
            self.image = representation["Image"] as? String
            self.tourGuideId = representation["tour_guide_id"] as? String
            self.floorLevel = representation["floor_level"] as? String
            self.galleyNumber = representation["galley_Number"] as? String
            self.artistOrCreatorOrAuthor = representation["Artist/Creator/Author"] as? String
            //HeritageListList
            self.periodOrStyle = representation["Period/Style"] as? String
            self.techniqueAndMaterials = representation["Technique_&_Materials"] as? String
            
            
        }
    }
    init(title:String?,accessionNumber:String?,nid:String?,curatorialDescription:String?,diam:String?,dimensions:String?,mainTitle:String?,objectENGSummary:String?,objectHistory:String?      ,production:String?,productionDates:String?,image:String?,tourGuideId:String?,floorLevel:String?     ,galleyNumber:String?,artistOrCreatorOrAuthor:String?,periodOrStyle:String?,techniqueAndMaterials:String?) {
        self.title = title
        self.accessionNumber = accessionNumber
        self.nid = nid
        self.curatorialDescription = curatorialDescription
        self.diam = diam
        self.dimensions = dimensions
        self.mainTitle = mainTitle
        self.objectENGSummary = objectENGSummary
        self.objectHistory = objectHistory
        
        self.production = production
        self.productionDates = productionDates
        self.image = image
        self.tourGuideId = tourGuideId
        self.floorLevel = floorLevel
        self.galleyNumber = galleyNumber
        self.artistOrCreatorOrAuthor = artistOrCreatorOrAuthor
        
        self.periodOrStyle = periodOrStyle
        self.techniqueAndMaterials = techniqueAndMaterials
        
    }
}

struct TourGuideFloorMaps: ResponseObjectSerializable {
    var tourGuideFloorMap: [TourGuideFloorMap]? = []
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let data = representation as? [[String: Any]] {
            self.tourGuideFloorMap = TourGuideFloorMap.collection(response: response, representation: data as AnyObject)
        }
    }
}


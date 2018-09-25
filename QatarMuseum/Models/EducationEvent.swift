//
//  EducationEvent.swift
//  QatarMuseums
//
//  Created by Exalture on 19/08/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Foundation
struct EducationEvent: ResponseObjectSerializable, ResponseCollectionSerializable {
//    var eId: String? = nil
//    var filter: String? = nil
//    var title: String? = nil
//    var shortDesc: String? = nil
//    var longDesc: String? = nil
//
//    var location: String? = nil
//    var institution: String? = nil
//    var startTime: String? = nil
//    var endtime: String? = nil
//    var ageGroup: String? = nil
//    var programType: String? = nil
//    var category: String? = nil
//    var registration: String? = nil
//    var date: String? = nil
//    var maxGroupSize: String? = nil
    
    var itemId: String? = nil
    var introductionText: String? = nil
    var register: String? = nil
    var fieldRepeatDate: [String]? = []
    var mainDescription: [String]? = []
    var title: String? = nil
    var programType: String? = nil
    
    
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
//            self.eId = representation["eid"] as? String
//            self.filter = representation["filter"] as? String
//            self.title = representation["title"] as? String
//            self.shortDesc = representation["short_desc"] as? String
//            self.longDesc = representation["long_desc"] as? String
//            self.location = representation["location"] as? String
//            self.institution = representation["institution"] as? String
//            self.ageGroup = representation["age_group"] as? String
//            self.startTime = representation["start_time"] as? String
//            self.endtime = representation["end_time"] as? String
//            self.programType = representation["program_type"] as? String
//            self.category = representation["category"] as? String
//            self.registration = representation["registration"] as? String
//            self.date = representation["date"] as? String
//            self.maxGroupSize = representation["max_group_size"] as? String
            
            self.itemId = representation["item_id"] as? String
            self.introductionText = representation["Introduction_Text"] as? String
            self.register = representation["Register"] as? String
            self.fieldRepeatDate = representation["field_eduprog_repeat_field_date"] as? [String]
            self.title = representation["title"] as? String
            self.programType = representation["Programme_type"] as? String
            self.mainDescription = representation["main_description"] as? [String]
            
        }
    }
    //10
//    init (eid:String?, filter: String?, title: String?, shortDesc: String?, longDesc: String?,location:String?, institution: String?,startTime:String?, endTime: String?, ageGroup: String?,programType: String?, category: String?, registration: String?, date: String?,maxGroupSize:String?) {
//        self.eId = eid
//        self.filter = filter
//        self.title = title
//        self.shortDesc = shortDesc
//        self.longDesc = longDesc
//
//        self.location = location
//        self.institution = institution
//        self.startTime = startTime
//        self.endtime = endTime
//        self.ageGroup = ageGroup
//        self.programType = programType
//        self.category = category
//        self.registration = registration
//        self.date = date
//        self.maxGroupSize = maxGroupSize
//    }
    
    init (itemId:String?, introductionText: String?, register: String?, fieldRepeatDate: [String]?, title: String?,programType:String?,mainDescription:[String]?) {
        self.itemId = itemId
        self.introductionText = introductionText
        self.register = register
        self.fieldRepeatDate = fieldRepeatDate
        self.title = title
        self.programType = programType
        self.mainDescription = mainDescription
        
    }
}

struct EducationEventList: ResponseObjectSerializable {
    var educationEvent: [EducationEvent]? = []
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let data = representation as? [[String: Any]] {
            self.educationEvent = EducationEvent.collection(response: response, representation: data as AnyObject)
        }
    }
}

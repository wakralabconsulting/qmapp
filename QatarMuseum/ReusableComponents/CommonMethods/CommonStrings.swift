//
//  CommonStrings.swift
//  QatarMuseums
//
//  Created by Exalture on 17/08/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Foundation
var ENG_LANGUAGE = "en"
var AR_LANGUAGE = "ar"
var ALREADY_REGISTERED = "You are already registered for another event at the selected time."
var YES = "Yes"
var NO = "No"
var LOCATION_ERROR = "Unfortunately we cannot open Map.";
var NO_END_TIME = "NO END TIME AVAILABLE"
var OK_MSG = "OK"
var PUBLICARTS_DETAIL = "PublicArtsDetailPage"
var HOME = "HomePage"
var EXHIBITION_DETAIL = "ExhibitionDetailPage"
var EVENT_VC = "EventPage"
var PROFILE_VC = "ProfilePage"
var EXHIBITION_LIST = "ExhibitionsPage"
var HERITAGE_LIST = "HeritageListPage"
var HERITAGE_DETAIL = "HeritageDetailPage"
var PUBLIC_ARTS_LIST = "PublicArtsPage"
var MUSEUM_COLLECTION = "MuseumCollectionsPage"
var MUSEUM_VC = "MuseumsPage"
var DINING_DETAIL = "DiningDetailPage"
var MIA_TOUR_GUIDE = "MiaTourGuidePage"
var MIA_TOURGUIDE_EXPLORE = "MiaTourGuideExplorePage"
var MIA_TOUR_DETAIL = "MiaTourDetailPage"
var NOTIFICATIONS_LIST = "NotificationsPage"
var TOUR_GUIDE_VC = "TourGuidePage"
var EDUCATION_VC = "EducationPage"
var DINING_LIST = "DiningPage"
var PARKS_VC = "ParksPage"
var FILTER_VC = "FilterPage"
var SETTINGS_VC = "SettingsPage"
var COLLECTION_DETAIL = "CollectionDetailPage"
var FLOORMAP_VC = "FloorMapPage"
var OBJECTDETAIL_VC = "ObjectDetailPage"
var ARTIFACT_NUMBER_VC = "ArtifactNumberPadPage"
var CULTUREPASS_VC = "CulturePassPage"
var MUSEUMS_ABOUT_VC = "MuseumAboutPage"
var PREVIEW_CONTENT_VC = "PreviewContentPage"
var PREVIEW_CONTAINER_VC = "PreviewContainerPage"
var CULTUREPASS_CARD_VC = "CulturePassCardPage"
var NMOQ_TOUR_LIST = "NMoQTourListPage"
var NMOQ_ACTIVITY_LIST = "NMoQActivityListPage"
var TRAVEL_ARRANGEMENT_VC = "TravelArrangementsPage"
var NMOQ_TOUR_SECOND_LIST = "NMoQTourPage"
var NMOQ_ACTIVITY_DETAIL = "NMoqPanelDiscussionDetailPage"
var NMOQ_TOUR_DETAIL = "NMoqTourDetailPage"
var NMOQ_FACILITIES_DETAIL = "NMoqFacilitiesDetailPage"
var NMOQ_PARKS_DETAIL = "ParksPage"


//MARK:- Firebase Analytics Events
struct FirebaseAnalyticsEvents {
    static let tapped_museum_item = "home_museum_item_tapped"
    static let tapped_exhibition_item = "home_exhibition_item_tapped"
    static let tapped_button_item = "home_button_item_tapped"
    static let view_did_load = "view_did_load"
    static let tapped_filter_event_item = "tapped_filter_event_item"
    static let tapped_event_popup = "tapped_event_popup"
    static let tapped_add_to_calender_item = "tapped_add_to_calender_item"
    static let tapped_exhibition_detail = "tapped_exhibition_detail"
    static let tapped_heritage_detail = "tapped_heritage_detail"
    static let tapped_publicart_detail = "tapped_publicart_detail"
    static let tapped_collections_detail = "tapped_collections_detail"
    static let tapped_dining_detail = "tapped_dining_detail"
    static let tapped_miatour_detail = "tapped_miatour_detail"
    static let tapped_facilities_second_detail = "tapped_facilities_second_detail"
    static let tapped_miatourlist_detail = "tapped_miatourlist_detail"
    static let tapped_parklist_detail = "tapped_parklist_detail"
    
    
    //Generic
    static let tapped_header_close = "tapped_header_close"
    static let tapped_header_back = "tapped_header_back"
    static let tapped_location_map = "tapped_location_map"
    static let tapped_museum_previous = "tapped_location_map"
    static let tapped_museum_next = "tapped_museum_next"
    
    
    //Museum
    
    static let tapped_museum_about = "tapped_museum_about"
    static let tapped_museum_tourguide = "tapped_museum_tourguide"
    static let tapped_museum_exhibition = "tapped_museum_exhibition"
    static let tapped_museum_collections = "tapped_museum_collections"
    static let tapped_museum_parks = "tapped_museum_parks"
    static let tapped_museum_parksside = "tapped_museum_parksside"
    static let tapped_museum_dining = "tapped_museum_dining"
    static let tapped_museum_facilities = "tapped_museum_facilities"
    static let tapped_museum_event = "tapped_museum_event"
    static let tapped_museum_notifications = "tapped_museum_notifications"
    static let tapped_museum_profile = "tapped_museum_profile"
    
    //Tourguide
    
    static let tapped_tourguide_play = "tapped_tourguide_play"
    static let tapped_tourguide_start = "tapped_tourguide_start"
    
    //Education
    static let tapped_education_play = "tapped_education_play"
    static let tapped_discover_play = "tapped_discover_play"
    
    //Floor Map
    static let tapped_floormap_loadmap = "tapped_floormap_loadmap"
    static let tapped_floormap_loadsecond = "tapped_floormap_loadsecond"
    static let tapped_floormap_loadthird = "tapped_floormap_loadthird"
    static let tapped_floormap_loadfirst = "tapped_floormap_loadfirst"
    static let tapped_floormap_objectclose = "tapped_floormap_objectclose"
    static let tapped_floormap_numbersearch = "tapped_floormap_numbersearch"

    
    static let id = "id"
}

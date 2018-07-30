//
//  QMFont.swift
//  QatarMuseums
//
//  Created by Exalture on 27/07/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Foundation
extension UIFont {
    static var headerFont: UIFont {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            return UIFont.init(name: "DINNextLTPro-Bold", size: 20)!
        }
        else {
            return UIFont.init(name: "DINNextLTArabic-Bold", size: 24)!
        }
    }
    static var heritageTitleFont: UIFont {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            return UIFont.init(name: "DINNextLTPro-Regular", size: 19)!
        }
        else{
            return UIFont.init(name: "DINNextLTArabic-Regular", size:19)!
        }
        
    }
    static var englishTitleFont: UIFont {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            return UIFont.init(name: "DINNextLTPro-Regular", size: 17)!
        }
        else{
            return UIFont.init(name: "DINNextLTArabic-Regular", size:17)!
        }
        
    }
    static var settingsUpdateLabelFont: UIFont {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            return UIFont.init(name: "DINNextLTPro-Regular", size: 18)!
        }
        else{
            return UIFont.init(name: "DINNextLTArabic-Regular", size:18)!
        }
        
    }
    static var settingResetButtonFont: UIFont {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            return UIFont.init(name: "DINNextLTPro-Bold", size: 15)!
        }
        else{
            return UIFont.init(name: "DINNextLTArabic-Bold", size:15)!
        }
        
    }
    static var eventPopupTitleFont: UIFont {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            return UIFont.init(name: "DINNextLTPro-Bold", size: 23)!
        }
        else{
            return UIFont.init(name: "DINNextLTArabic-Bold", size:23)!
        }
        
    }
    static var closeButtonFont: UIFont {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            return UIFont.init(name: "DINNextLTPro-Bold", size: 18)!
        }
        else{
            return UIFont.init(name: "DINNextLTArabic-Bold", size:18)!
        }
        
    }
    static var sideMenuLabelFont: UIFont {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            return UIFont.init(name: "DINNextLTPro-Regular", size: 15)!
        }
        else{
            return UIFont.init(name: "DINNextLTArabic-Regular", size:15)!
        }
        
    }
    static var museumTitleFont: UIFont {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            return UIFont.init(name: "DINNextLTPro-Bold", size: 37)!
        }
        else{
            return UIFont.init(name: "DINNextLTArabic-Bold", size:37)!
        }
        
    }
    static var exhibitionDateLabelFont: UIFont {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            return UIFont.init(name: "DINNextLTPro-Regular", size: 12)!
        }
        else{
            return UIFont.init(name: "DINNextLTArabic-Regular", size:13)!
        }
        
    }
    static var eventCellTitleFont: UIFont {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            return UIFont.init(name: "DINNextLTPro-Regular", size: 13)!
        }
        else{
            return UIFont.init(name: "DINNextLTArabic-Regular", size:14)!
        }
        
    }
    static var clearButtonFont: UIFont {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            return UIFont.init(name: "DINNextLTPro-Bold", size: 14)!
        }
        else{
            return UIFont.init(name: "DINNextLTArabic-Bold", size:14)!
        }
        
    }
}

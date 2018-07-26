//
//  QMUtility.swift
//  QatarMuseums
//
//  Created by Developer on 25/07/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Foundation
import Alamofire

// Utility method for presenting alert without any completion handler
func presentAlert(_ viewController: UIViewController, title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(defaultAction)
    if (viewController.view.window != nil) {
        viewController.present(alertController, animated: true, completion: nil)
    }
}

// Handles common backend errors and returns unhandled internal app errors if any
func handleError(viewController: UIViewController, errorType: BackendError) -> QatarMuseumError? {
    var errorMessage: String? = nil
    var errorTitle: String? = nil
    var unhandledError: QatarMuseumError? = nil
    switch errorType {
    case .Network(let error):
        errorTitle = "Network error"
        errorMessage = error.localizedDescription
        if error._code == -999 {
            return unhandledError
        }
    case .AlamofireError(let error):
        switch error.responseCode! {
        case 400:
            errorTitle = "Bad request"
            errorMessage = "Bad request"
        case 401:
            errorTitle = "Unauthorized"
            errorMessage = "Unauthorized Error"
        case 403:
            errorTitle = "Forbidden"
            errorMessage = "Forbidden request"
        case 404:
            errorTitle = "Not Found"
            errorMessage = "Not Found Error"
        case 500:
            errorTitle = "Failure"
            errorMessage = "Internal Server Error"
        default:
            errorTitle = "Unknown error"
            errorMessage = "Unknown error, please contact system administrator"
        }
    case .JSONSerialization( _):
        errorTitle = "Serialization error"
        errorMessage = "Serialization error, please contact system administrator"
    case .ObjectSerialization( _):
        errorTitle = "Serialization error"
        errorMessage = "Serialization error, please contact system administrator"
    case .Internal(let error):
        unhandledError = error
    }
    if errorMessage != nil && errorTitle != nil {
        presentAlert(viewController, title: errorTitle!, message: errorMessage!)
    }
    return unhandledError
}

func handleAFError(viewController: UIViewController, error: AFError) {
    switch error.responseCode! {
    case 400:
        print("Bad request")
    case 401:
        print("Unauthorized")
    case 403:
        print("Forbidden request")
    case 404:
        print("Not Found")
    case 500:
        print("Internal Server Error")
    default:
        print("Unknown error")
    }
}

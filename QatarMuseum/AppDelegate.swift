//
//  AppDelegate.swift
//  QatarMuseum
//
//  Created by Exalture on 06/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import CoreData
import Firebase
import GoogleMaps
import GooglePlaces
import UIKit
import UserNotifications
import Alamofire
var tokenValue : String? = nil

var languageKey = 1

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    var shouldRotate = false
    let networkReachability = NetworkReachabilityManager()
    var tourGuideId : String? = ""
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       // GMSServices.provideAPIKey("AIzaSyBXEzUfmsi5BidKqR1eY999pj0APP2N0k0")
        GMSServices.provideAPIKey("AIzaSyAbuv0Gx0vwyZdr90LFKeUFmMesorNZHKQ") // QM key
         GMSPlacesClient.provideAPIKey("AIzaSyAbuv0Gx0vwyZdr90LFKeUFmMesorNZHKQ")
        self.apiCalls()
        
           
        
        AppLocalizer.DoTheMagic()
        FirebaseApp.configure()

        registerForPushNotifications()
        
        // Register with APNs
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
        //Launched from push notification
        let remoteNotif = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: Any]
        if remoteNotif != nil {
//            let aps = remoteNotif!["aps"] as? [String:AnyObject]
//            NSLog("\n Custom: \(String(describing: aps))")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let notificationsView = storyboard.instantiateViewController(withIdentifier: "notificationId") as! NotificationsViewController
            notificationsView.fromHome = true
            self.window?.rootViewController = notificationsView
            self.window?.makeKeyAndVisible()
        }
        application.applicationIconBadgeNumber = 0
        
        return true
    }
    
    func apiCalls() {
        if  (networkReachability?.isReachable)! {
            self.getHomeList(lang: ENG_LANGUAGE)
            self.getHomeList(lang: AR_LANGUAGE)
            self.getHeritageDataFromServer(lang: ENG_LANGUAGE)
            self.getHeritageDataFromServer(lang: AR_LANGUAGE)
            self.getFloorMapDataFromServer(tourGuideId: "12471", lang: ENG_LANGUAGE) // for explore and highlight tour English
            self.getFloorMapDataFromServer(tourGuideId: "12216", lang: ENG_LANGUAGE) // for science tour English
            
            self.getFloorMapDataFromServer(tourGuideId: "12916", lang: AR_LANGUAGE) //for explore and highlight tour Arabic
            self.getFloorMapDataFromServer(tourGuideId: "12226", lang: AR_LANGUAGE) // for science tour Arabic
            self.getMiaTourGuideDataFromServer(museumId: "63", lang: ENG_LANGUAGE)
            self.getMiaTourGuideDataFromServer(museumId: "96", lang: AR_LANGUAGE)
            
        }
        
    }
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                print("Permission granted: \(granted)")
                // 1. Check if permission granted
                guard granted else { return }
                // 2. Attempt registration for remote notifications on the main thread
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        // 1. Convert device token to string
//        let tokenParts = deviceToken.map { data -> String in
//            return String(format: "%02.2hhx", data)
//        }
//        let token = tokenParts.joined()
//        // 2. Print device token to use for PNs payloads
//        print("Device Token: \(token)")
//    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 1. Print out error if PNs registration not successful
        print("Failed to register for remote notifications with error: \(error)")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return shouldRotate ? .allButUpsideDown : .portrait
    }
    
    //MARK: Push notification receive delegates
//    func application(_ application: UIApplication,
//                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        application.applicationIconBadgeNumber = 0
//        print("Recived: \(userInfo)")
//        if (application.applicationState == .active) {
//            if let topController = UIApplication.topViewController() {
//                print(topController)
//            }
//            // Do something you want when the app is active
//
//        } else {
//
//            // Do something else when your app is in the background
//
//
//        }
//        completionHandler(.newData)
//
//    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token) ")
        tokenValue = token
        self.sendDeviceTokenToServer(deviceToken: token)
    }
    
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError
//        error: Error) {
//        // Try again later.
//    }
    
    // This method will be called when we click push notifications in background
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        let info = self.extractUserInfo(userInfo: userInfo)
        print(info.title)

        let notificationData = UserDefaults.standard.object(forKey: "pushNotificationList") as? NSData
        if let notificationData = notificationData, let notifications = NSKeyedUnarchiver.unarchiveObject(with: notificationData as Data) as?
            [Notification] {
            var notificationArray = notifications
            notificationArray.insert(Notification(title: info.title, sortId: info.title), at: 0)
            let notificationData = NSKeyedArchiver.archivedData(withRootObject: notificationArray)
            UserDefaults.standard.set(notificationData, forKey: "pushNotificationList")
        } else {
            let notificationData = NSKeyedArchiver.archivedData(withRootObject: [Notification(title: info.title, sortId: info.title)])
            UserDefaults.standard.set(notificationData, forKey: "pushNotificationList")
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let notificationsView = storyboard.instantiateViewController(withIdentifier: "notificationId") as! NotificationsViewController
        notificationsView.fromHome = true
        self.window?.rootViewController = notificationsView
        self.window?.makeKeyAndVisible()
//            NotificationCenter.default.post(name: NSNotification.Name("NotificationIdentifier"), object: nil)
    }
    
    // This method will be called when app received push notifications in foreground
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // Print full message.
        print(userInfo)
        let info = self.extractUserInfo(userInfo: userInfo)
        print(info.title)
        
        if let badgeCount = UserDefaults.standard.value(forKey: "notificationBadgeCount") as?
            Int {
            UserDefaults.standard.setValue(badgeCount + 1, forKey: "notificationBadgeCount")
        } else {
            UserDefaults.standard.setValue(1, forKey: "notificationBadgeCount")
        }
        
        let notificationData = UserDefaults.standard.object(forKey: "pushNotificationList") as? NSData
        if let notificationData = notificationData, let notifications = NSKeyedUnarchiver.unarchiveObject(with: notificationData as Data) as?
            [Notification] {
           var notificationArray = notifications
            notificationArray.insert(Notification(title: info.title, sortId: info.title), at: 0)
            let notificationData = NSKeyedArchiver.archivedData(withRootObject: notificationArray)
            UserDefaults.standard.set(notificationData, forKey: "pushNotificationList")
        } else {
            let notificationData = NSKeyedArchiver.archivedData(withRootObject: [Notification(title: info.title, sortId: info.title)])
            UserDefaults.standard.set(notificationData, forKey: "pushNotificationList")
        }
        if let topController = UIApplication.topViewController() {
            print(topController)
            if topController is HomeViewController {
                (topController as! HomeViewController).updateNotificationBadge()
            } else if topController is MuseumsViewController {
                (topController as! MuseumsViewController).updateNotificationBadge()
            } else if topController is NotificationsViewController {
                (topController as! NotificationsViewController).updateNotificationTableView()
            }
        }
//        completionHandler([.alert, .badge, .sound])
    }
    
    //MARK: WebServiceCall
    func sendDeviceTokenToServer(deviceToken: String) {
        _ = Alamofire.request(QatarMuseumRouter.GetToken(["name":"","pass":""])).responseObject { (response: DataResponse<TokenData>) -> Void in
            switch response.result {
            case .success(let data):
                _ = Alamofire.request(QatarMuseumRouter.SendDeviceToken(data.accessToken!, ["token": deviceToken, "type":"ios"])).responseObject { (response: DataResponse<DeviceToken>) -> Void in
                    switch response.result {
                    case .success( _):
                        print("This token is successfully sent to server")
                    case .failure( _):
                        print("Fail to update device token")
                    }
                }
            case .failure( _):
                print("Failed to generate token ")
            }
        }
    }
    
    func extractUserInfo(userInfo: [AnyHashable : Any]) -> (title: String, body: String) {
        var info = (title: "", body: "")
        guard let aps = userInfo["aps"] as? [String: Any] else { return info }
//        guard let alert = aps["alert"] as? [String: Any] else { return info }
        let title = aps["alert"] as? String ?? ""
        let body = "" //alert["body"] as? String ?? ""
        info = (title: title, body: body)
        return info
    }
    
    // MARK: - Core Data stack
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "QatarMuseums")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    // iOS 9 and below
    lazy var applicationDocumentsDirectory: URL = {
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "coreDataTestForPreOS", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    // MARK: - Core Data Saving support
    
    
    func saveContext () {
        if #available(iOS 10.0, *) {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }else{
            // iOS 9.0 and below - however you were previously handling it
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                    abort()
                }
            }
            
        }
    }
    //MARK: HeritageList WebServiceCall
    func getHeritageDataFromServer(lang: String?) {
        let queue = DispatchQueue(label: "HeritageThread", qos: .background, attributes: .concurrent)
        _ = Alamofire.request(QatarMuseumRouter.HeritageList(lang!)).responseObject(queue: queue) { (response: DataResponse<Heritages>) -> Void in
            switch response.result {
            case .success(let data):
                DispatchQueue.main.async{
                    self.saveOrUpdateHeritageCoredata(heritageListArray: data.heritage, lang: lang)
                }
            case .failure(let error):
               print(error)
            }
        }
    }
    //MARK: Coredata Method
    func saveOrUpdateHeritageCoredata(heritageListArray: [Heritage]?,lang: String?) {
        if ((heritageListArray?.count)! > 0) {
            if #available(iOS 10.0, *) {
                let container = self.persistentContainer
                container.performBackgroundTask() {(managedContext) in
                    self.coreDataInBackgroundThread(managedContext: managedContext, heritageListArray: heritageListArray, lang: lang)
                }
            } else {
                let managedContext = self.managedObjectContext
                managedContext.perform {
                    self.coreDataInBackgroundThread(managedContext : managedContext, heritageListArray: heritageListArray, lang: lang)
                }
            }
        }
    }
    
    func coreDataInBackgroundThread(managedContext: NSManagedObjectContext,heritageListArray: [Heritage]?,lang: String?) {
        if (lang == ENG_LANGUAGE) {
            let fetchData = checkAddedToCoredata(entityName: "HeritageEntity", idKey: "listid", idValue: nil, managedContext: managedContext) as! [HeritageEntity]
            if (fetchData.count > 0) {
                for i in 0 ... (heritageListArray?.count)!-1 {
                    let heritageListDict = heritageListArray![i]
                    let fetchResult = checkAddedToCoredata(entityName: "HeritageEntity", idKey: "listid", idValue: heritageListArray![i].id, managedContext: managedContext)
                    //update
                    if(fetchResult.count != 0) {
                        let heritagedbDict = fetchResult[0] as! HeritageEntity
                        heritagedbDict.listname = heritageListDict.name
                        heritagedbDict.listimage = heritageListDict.image
                        heritagedbDict.listsortid =  heritageListDict.sortid
                        
                        do{
                            try managedContext.save()
                        }
                        catch{
                            print(error)
                        }
                    } else {
                        //save
                        self.saveHeritageListToCoreData(heritageListDict: heritageListDict, managedObjContext: managedContext, lang: lang)
                        
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(heritageListNotification), object: self)
                
            } else {
                for i in 0 ... (heritageListArray?.count)!-1 {
                    let heritageListDict : Heritage?
                    heritageListDict = heritageListArray?[i]
                    self.saveHeritageListToCoreData(heritageListDict: heritageListDict!, managedObjContext: managedContext, lang: lang)
                }
                NotificationCenter.default.post(name: NSNotification.Name(heritageListNotification), object: self)
            }
        } else {
            let fetchData = checkAddedToCoredata(entityName: "HeritageEntityArabic", idKey: "listid", idValue: nil, managedContext: managedContext) as! [HeritageEntityArabic]
            if (fetchData.count > 0) {
                for i in 0 ... (heritageListArray?.count)!-1 {
                    let heritageListDict = heritageListArray![i]
                    let fetchResult = checkAddedToCoredata(entityName: "HeritageEntityArabic", idKey: "listid", idValue: heritageListArray![i].id, managedContext: managedContext)
                    //update
                    if(fetchResult.count != 0) {
                        let heritagedbDict = fetchResult[0] as! HeritageEntityArabic
                        heritagedbDict.listnamearabic = heritageListDict.name
                        heritagedbDict.listimagearabic = heritageListDict.image
                        heritagedbDict.listsortidarabic =  heritageListDict.sortid
                        
                        do{
                            try managedContext.save()
                        }
                        catch{
                            print(error)
                        }
                    }
                    else {
                        //save
                        self.saveHeritageListToCoreData(heritageListDict: heritageListDict, managedObjContext: managedContext, lang: lang)
                        
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(heritageListNotification), object: self)
            }
            else {
                for i in 0 ... (heritageListArray?.count)!-1 {
                    let heritageListDict : Heritage?
                    heritageListDict = heritageListArray?[i]
                    self.saveHeritageListToCoreData(heritageListDict: heritageListDict!, managedObjContext: managedContext, lang: lang)
                    
                }
                NotificationCenter.default.post(name: NSNotification.Name(heritageListNotification), object: self)
            }
        }
    }
    
    func saveHeritageListToCoreData(heritageListDict: Heritage, managedObjContext: NSManagedObjectContext,lang: String?) {
        if (lang == ENG_LANGUAGE) {
            let heritageInfo: HeritageEntity = NSEntityDescription.insertNewObject(forEntityName: "HeritageEntity", into: managedObjContext) as! HeritageEntity
            heritageInfo.listid = heritageListDict.id
            heritageInfo.listname = heritageListDict.name
            
            heritageInfo.listimage = heritageListDict.image
            if(heritageListDict.sortid != nil) {
                heritageInfo.listsortid = heritageListDict.sortid
            }
        } else {
            let heritageInfo: HeritageEntityArabic = NSEntityDescription.insertNewObject(forEntityName: "HeritageEntityArabic", into: managedObjContext) as! HeritageEntityArabic
            heritageInfo.listid = heritageListDict.id
            heritageInfo.listnamearabic = heritageListDict.name
            
            heritageInfo.listimagearabic = heritageListDict.image
            if(heritageListDict.sortid != nil) {
                heritageInfo.listsortidarabic = heritageListDict.sortid
            }
        }
        do {
            try managedObjContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    //MARK: FloorMap WebServiceCall
    func getFloorMapDataFromServer(tourGuideId: String?,lang: String?) {
        let queue = DispatchQueue(label: "FloorMapThread", qos: .background, attributes: .concurrent)
        _ = Alamofire.request(QatarMuseumRouter.CollectionByTourGuide(["tour_guide_id": tourGuideId!])).responseObject(queue: queue) { (response: DataResponse<TourGuideFloorMaps>) -> Void in
            switch response.result {
            case .success(let data):
                //DispatchQueue.main.async{
                self.saveOrUpdateFloormapCoredata(floorMapArray: data.tourGuideFloorMap, lang: lang)
                //}
            case .failure(let error):
                print("error")
                
            }
        }
    }
    //MARK: FloorMap Coredata Method
    func saveOrUpdateFloormapCoredata(floorMapArray: [TourGuideFloorMap]?,lang: String?) {
        if ((floorMapArray?.count)! > 0) {
            if #available(iOS 10.0, *) {
                let container = self.persistentContainer
                container.performBackgroundTask() {(managedContext) in
                    self.floormapCoreDataInBackgroundThread(managedContext: managedContext, floorMapArray: floorMapArray, lang: lang)
                }
            } else {
                let managedContext = self.managedObjectContext
                managedContext.perform {
                    self.floormapCoreDataInBackgroundThread(managedContext : managedContext, floorMapArray: floorMapArray, lang: lang)
                }
            }
        }
    }
    func floormapCoreDataInBackgroundThread(managedContext: NSManagedObjectContext,floorMapArray: [TourGuideFloorMap]?,lang: String?) {
        if ((floorMapArray?.count)! > 0) {
            if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
                let fetchData = checkAddedToCoredata(entityName: "FloorMapTourGuideEntity", idKey: "tourGuideId", idValue: tourGuideId , managedContext: managedContext ) as! [FloorMapTourGuideEntity]
                
                if (fetchData.count > 0) {
                    for i in 0 ... (floorMapArray?.count)!-1 {
                        let managedContext = getContext()
                        let tourGuideDeatilDict = floorMapArray![i]
                        let fetchResult = checkAddedToCoredata(entityName: "FloorMapTourGuideEntity", idKey: "nid", idValue: floorMapArray![i].nid, managedContext: managedContext) as! [FloorMapTourGuideEntity]
                        
                        if(fetchResult.count != 0) {
                            
                            //update
                            let tourguidedbDict = fetchResult[0]
                            tourguidedbDict.title = tourGuideDeatilDict.title
                            tourguidedbDict.accessionNumber = tourGuideDeatilDict.accessionNumber
                            tourguidedbDict.nid =  tourGuideDeatilDict.nid
                            tourguidedbDict.curatorialDescription = tourGuideDeatilDict.curatorialDescription
                            tourguidedbDict.diam = tourGuideDeatilDict.diam
                            
                            tourguidedbDict.dimensions = tourGuideDeatilDict.dimensions
                            tourguidedbDict.mainTitle = tourGuideDeatilDict.mainTitle
                            tourguidedbDict.objectEngSummary =  tourGuideDeatilDict.objectENGSummary
                            tourguidedbDict.objectHistory = tourGuideDeatilDict.objectHistory
                            tourguidedbDict.production = tourGuideDeatilDict.production
                            
                            tourguidedbDict.productionDates = tourGuideDeatilDict.productionDates
                            tourguidedbDict.image = tourGuideDeatilDict.image
                            tourguidedbDict.tourGuideId =  tourGuideDeatilDict.tourGuideId
                            tourguidedbDict.artifactNumber = tourGuideDeatilDict.artifactNumber
                            tourguidedbDict.artifactPosition = tourGuideDeatilDict.artifactPosition
                            
                            tourguidedbDict.audioDescriptif = tourGuideDeatilDict.audioDescriptif
                            tourguidedbDict.audioFile = tourGuideDeatilDict.audioFile
                            tourguidedbDict.floorLevel =  tourGuideDeatilDict.floorLevel
                            tourguidedbDict.galleyNumber = tourGuideDeatilDict.galleyNumber
                            tourguidedbDict.artistOrCreatorOrAuthor = tourGuideDeatilDict.artistOrCreatorOrAuthor
                            tourguidedbDict.periodOrStyle = tourGuideDeatilDict.periodOrStyle
                            tourguidedbDict.techniqueAndMaterials = tourGuideDeatilDict.techniqueAndMaterials
                            if let imageUrl = tourGuideDeatilDict.thumbImage{
                                if(imageUrl != "") {
                                    if let data = try? Data(contentsOf: URL(string: imageUrl)!) {
                                        let image: UIImage = UIImage(data: data)!
                                        tourguidedbDict.artifactImg = UIImagePNGRepresentation(image)
                                    }
                                }
                            }
                            
                            
                            if(tourGuideDeatilDict.images != nil) {
                                if((tourGuideDeatilDict.images?.count)! > 0) {
                                    for i in 0 ... (tourGuideDeatilDict.images?.count)!-1 {
                                        var tourGuideImgEntity: FloorMapImagesEntity!
                                        let tourGuideImg: FloorMapImagesEntity = NSEntityDescription.insertNewObject(forEntityName: "FloorMapImagesEntity", into: managedContext) as! FloorMapImagesEntity
                                        tourGuideImg.image = tourGuideDeatilDict.images?[i]
                                        
                                        tourGuideImgEntity = tourGuideImg
                                        tourguidedbDict.addToImagesRelation(tourGuideImgEntity)
                                        do {
                                            try managedContext.save()
                                            
                                        } catch let error as NSError {
                                            print("Could not save. \(error), \(error.userInfo)")
                                        }
                                        
                                    }
                                }
                            }
                            DispatchQueue.main.async(execute: {
                                do{
                                    try managedContext.save()
                                }
                                catch{
                                    print(error)
                                }
                            })
                        }else {
                            self.saveFloormapToCoreData(tourGuideDetailDict: tourGuideDeatilDict, managedObjContext: managedContext, lang: lang)
                        }
                    }//for
                    NotificationCenter.default.post(name: NSNotification.Name(floormapNotification), object: self)
                }//if
                else {
                    for i in 0 ... (floorMapArray?.count)!-1 {
                        let managedContext = getContext()
                        let tourGuideDetailDict : TourGuideFloorMap?
                        tourGuideDetailDict = floorMapArray?[i]
                        self.saveFloormapToCoreData(tourGuideDetailDict: tourGuideDetailDict!, managedObjContext: managedContext, lang: lang)
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(floormapNotification), object: self)
                }
            }
            else {
                let fetchData = checkAddedToCoredata(entityName: "FloorMapTourGuideEntityAr", idKey:"tourGuideId" , idValue: tourGuideId, managedContext: managedContext) as! [FloorMapTourGuideEntityAr]
                if (fetchData.count > 0) {
                    for i in 0 ... (floorMapArray?.count)!-1 {
                        let managedContext = getContext()
                        let tourGuideDeatilDict = floorMapArray![i]
                        let fetchResult = checkAddedToCoredata(entityName: "FloorMapTourGuideEntityAr", idKey: "nid", idValue: floorMapArray![i].nid, managedContext: managedContext) as! [FloorMapTourGuideEntityAr]
                        //update
                        if(fetchResult.count != 0) {
                            let tourguidedbDict = fetchResult[0]
                            tourguidedbDict.title = tourGuideDeatilDict.title
                            tourguidedbDict.accessionNumber = tourGuideDeatilDict.accessionNumber
                            tourguidedbDict.nid =  tourGuideDeatilDict.nid
                            tourguidedbDict.curatorialDescription = tourGuideDeatilDict.curatorialDescription
                            tourguidedbDict.diam = tourGuideDeatilDict.diam
                            
                            tourguidedbDict.dimensions = tourGuideDeatilDict.dimensions
                            tourguidedbDict.mainTitle = tourGuideDeatilDict.mainTitle
                            tourguidedbDict.objectEngSummary =  tourGuideDeatilDict.objectENGSummary
                            tourguidedbDict.objectHistory = tourGuideDeatilDict.objectHistory
                            tourguidedbDict.production = tourGuideDeatilDict.production
                            
                            tourguidedbDict.productionDates = tourGuideDeatilDict.productionDates
                            tourguidedbDict.image = tourGuideDeatilDict.image
                            tourguidedbDict.tourGuideId =  tourGuideDeatilDict.tourGuideId
                            tourguidedbDict.artifactNumber = tourGuideDeatilDict.artifactNumber
                            tourguidedbDict.artifactPosition = tourGuideDeatilDict.artifactPosition
                            
                            tourguidedbDict.audioDescriptif = tourGuideDeatilDict.audioDescriptif
                            tourguidedbDict.audioFile = tourGuideDeatilDict.audioFile
                            tourguidedbDict.floorLevel =  tourGuideDeatilDict.floorLevel
                            tourguidedbDict.galleyNumber = tourGuideDeatilDict.galleyNumber
                            tourguidedbDict.artistOrCreatorOrAuthor = tourGuideDeatilDict.artistOrCreatorOrAuthor
                            tourguidedbDict.periodOrStyle = tourGuideDeatilDict.periodOrStyle
                            tourguidedbDict.techniqueAndMaterials = tourGuideDeatilDict.techniqueAndMaterials
                            if let imageUrl = tourGuideDeatilDict.thumbImage{
                                if(imageUrl != "") {
                                    if let data = try? Data(contentsOf: URL(string: imageUrl)!) {
                                        let image: UIImage = UIImage(data: data)!
                                        tourguidedbDict.artifactImg = UIImagePNGRepresentation(image)
                                    }
                                }
                                
                            }
                            if(tourGuideDeatilDict.images != nil) {
                                if((tourGuideDeatilDict.images?.count)! > 0) {
                                    for i in 0 ... (tourGuideDeatilDict.images?.count)!-1 {
                                        var tourGuideImgEntity: FloorMapImagesEntityAr!
                                        let tourGuideImg: FloorMapImagesEntityAr = NSEntityDescription.insertNewObject(forEntityName: "FloorMapImagesEntityAr", into: managedContext) as! FloorMapImagesEntityAr
                                        tourGuideImg.image = tourGuideDeatilDict.images?[i]
                                        
                                        tourGuideImgEntity = tourGuideImg
                                        tourguidedbDict.addToImagesRelation(tourGuideImgEntity)
                                        do {
                                            try managedContext.save()
                                            
                                        } catch let error as NSError {
                                            print("Could not save. \(error), \(error.userInfo)")
                                        }
                                        
                                    }
                                }
                            }
                            DispatchQueue.main.async(execute: {
                                do{
                                    try managedContext.save()
                                }
                                catch{
                                    print(error)
                                }
                            })
                        } else {
                            self.saveFloormapToCoreData(tourGuideDetailDict: tourGuideDeatilDict, managedObjContext: managedContext, lang: lang)
                        }
                    }//for
                    NotificationCenter.default.post(name: NSNotification.Name(floormapNotification), object: self)
                } //if
                else {
                    for i in 0 ... (floorMapArray?.count)!-1 {
                        let managedContext = getContext()
                        let tourGuideDetailDict : TourGuideFloorMap?
                        tourGuideDetailDict = floorMapArray?[i]
                        self.saveFloormapToCoreData(tourGuideDetailDict: tourGuideDetailDict!, managedObjContext: managedContext, lang: lang)
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(floormapNotification), object: self)
                }
            }
        }
    }
    func saveFloormapToCoreData(tourGuideDetailDict: TourGuideFloorMap, managedObjContext: NSManagedObjectContext,lang: String?) {
        if (lang == ENG_LANGUAGE) {
            let tourguidedbDict: FloorMapTourGuideEntity = NSEntityDescription.insertNewObject(forEntityName: "FloorMapTourGuideEntity", into: managedObjContext) as! FloorMapTourGuideEntity
            tourguidedbDict.title = tourGuideDetailDict.title
            tourguidedbDict.accessionNumber = tourGuideDetailDict.accessionNumber
            tourguidedbDict.nid =  tourGuideDetailDict.nid
            tourguidedbDict.curatorialDescription = tourGuideDetailDict.curatorialDescription
            tourguidedbDict.diam = tourGuideDetailDict.diam
            
            tourguidedbDict.dimensions = tourGuideDetailDict.dimensions
            tourguidedbDict.mainTitle = tourGuideDetailDict.mainTitle
            tourguidedbDict.objectEngSummary =  tourGuideDetailDict.objectENGSummary
            tourguidedbDict.objectHistory = tourGuideDetailDict.objectHistory
            tourguidedbDict.production = tourGuideDetailDict.production
            
            tourguidedbDict.productionDates = tourGuideDetailDict.productionDates
            tourguidedbDict.image = tourGuideDetailDict.image
            tourguidedbDict.tourGuideId =  tourGuideDetailDict.tourGuideId
            tourguidedbDict.artifactNumber = tourGuideDetailDict.artifactNumber
            tourguidedbDict.artifactPosition = tourGuideDetailDict.artifactPosition
            
            tourguidedbDict.audioDescriptif = tourGuideDetailDict.audioDescriptif
            tourguidedbDict.audioFile = tourGuideDetailDict.audioFile
            tourguidedbDict.floorLevel =  tourGuideDetailDict.floorLevel
            tourguidedbDict.galleyNumber = tourGuideDetailDict.galleyNumber
            tourguidedbDict.artistOrCreatorOrAuthor = tourGuideDetailDict.artistOrCreatorOrAuthor
            tourguidedbDict.periodOrStyle = tourGuideDetailDict.periodOrStyle
            tourguidedbDict.techniqueAndMaterials = tourGuideDetailDict.techniqueAndMaterials
            if let imageUrl = tourGuideDetailDict.thumbImage{
                if(imageUrl != "") {
                    if let data = try? Data(contentsOf: URL(string: imageUrl)!) {
                        let image: UIImage = UIImage(data: data)!
                        tourguidedbDict.artifactImg = UIImagePNGRepresentation(image)
                    }
                }
            }
            if(tourGuideDetailDict.images != nil) {
                if((tourGuideDetailDict.images?.count)! > 0) {
                    for i in 0 ... (tourGuideDetailDict.images?.count)!-1 {
                        var tourGuideImgEntity: FloorMapImagesEntity!
                        let tourGuideImg: FloorMapImagesEntity = NSEntityDescription.insertNewObject(forEntityName: "FloorMapImagesEntity", into: managedObjContext) as! FloorMapImagesEntity
                        tourGuideImg.image = tourGuideDetailDict.images?[i]
                        
                        tourGuideImgEntity = tourGuideImg
                        tourguidedbDict.addToImagesRelation(tourGuideImgEntity)
                        do {
                            try managedObjContext.save()
                            
                        } catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                        
                    }
                }
            }
            
        }
        else {
            let tourguidedbDict: FloorMapTourGuideEntityAr = NSEntityDescription.insertNewObject(forEntityName: "FloorMapTourGuideEntityAr", into: managedObjContext) as! FloorMapTourGuideEntityAr
            tourguidedbDict.title = tourGuideDetailDict.title
            tourguidedbDict.accessionNumber = tourGuideDetailDict.accessionNumber
            tourguidedbDict.nid =  tourGuideDetailDict.nid
            tourguidedbDict.curatorialDescription = tourGuideDetailDict.curatorialDescription
            tourguidedbDict.diam = tourGuideDetailDict.diam
            
            tourguidedbDict.dimensions = tourGuideDetailDict.dimensions
            tourguidedbDict.mainTitle = tourGuideDetailDict.mainTitle
            tourguidedbDict.objectEngSummary =  tourGuideDetailDict.objectENGSummary
            tourguidedbDict.objectHistory = tourGuideDetailDict.objectHistory
            tourguidedbDict.production = tourGuideDetailDict.production
            
            tourguidedbDict.productionDates = tourGuideDetailDict.productionDates
            tourguidedbDict.image = tourGuideDetailDict.image
            tourguidedbDict.tourGuideId =  tourGuideDetailDict.tourGuideId
            tourguidedbDict.artifactNumber = tourGuideDetailDict.artifactNumber
            tourguidedbDict.artifactPosition = tourGuideDetailDict.artifactPosition
            
            tourguidedbDict.audioDescriptif = tourGuideDetailDict.audioDescriptif
            tourguidedbDict.audioFile = tourGuideDetailDict.audioFile
            tourguidedbDict.floorLevel =  tourGuideDetailDict.floorLevel
            tourguidedbDict.galleyNumber = tourGuideDetailDict.galleyNumber
            tourguidedbDict.artistOrCreatorOrAuthor = tourGuideDetailDict.artistOrCreatorOrAuthor
            tourguidedbDict.periodOrStyle = tourGuideDetailDict.periodOrStyle
            tourguidedbDict.techniqueAndMaterials = tourGuideDetailDict.techniqueAndMaterials
            if let imageUrl = tourGuideDetailDict.thumbImage{
                if(imageUrl != "") {
                    if let data = try? Data(contentsOf: URL(string: imageUrl)!) {
                        let image: UIImage = UIImage(data: data)!
                        tourguidedbDict.artifactImg = UIImagePNGRepresentation(image)
                    }
                }
            }
            if(tourGuideDetailDict.images != nil) {
                if((tourGuideDetailDict.images?.count)! > 0) {
                    for i in 0 ... (tourGuideDetailDict.images?.count)!-1 {
                        var tourGuideImgEntity: FloorMapImagesEntityAr!
                        let tourGuideImg: FloorMapImagesEntityAr = NSEntityDescription.insertNewObject(forEntityName: "FloorMapImagesEntityAr", into: managedObjContext) as! FloorMapImagesEntityAr
                        tourGuideImg.image = tourGuideDetailDict.images?[i]
                        
                        tourGuideImgEntity = tourGuideImg
                        tourguidedbDict.addToImagesRelation(tourGuideImgEntity)
                        do {
                            try managedObjContext.save()
                            
                        } catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                        
                    }
                }
            }
        }
        DispatchQueue.main.async(execute: {
        do {
                try managedObjContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        })
    }
    //MARK: Exhibitions Service call
    func getExhibitionDataFromServer() {
        let queue = DispatchQueue(label: "ExhibitionThread", qos: .background, attributes: .concurrent)
        _ = Alamofire.request(QatarMuseumRouter.ExhibitionList()).responseObject(queue: queue) { (response: DataResponse<Exhibitions>) -> Void in
            switch response.result {
            case .success(let data):
                self.saveOrUpdateExhibitionsCoredata(exhibition: data.exhibitions)
            case .failure(let error):
                print("error")
            }
        }
    }
    //MARK: Exhibitions Coredata Method
    func saveOrUpdateExhibitionsCoredata(exhibition: [Exhibition]?) {
        if ((exhibition?.count)! > 0) {
            if #available(iOS 10.0, *) {
                let container = self.persistentContainer
                container.performBackgroundTask() {(managedContext) in
                    self.exhibitionCoreDataInBackgroundThread(managedContext: managedContext, exhibition: exhibition)
                }
            } else {
                let managedContext = self.managedObjectContext
                managedContext.perform {
                    self.exhibitionCoreDataInBackgroundThread(managedContext : managedContext, exhibition: exhibition)
                }
            }
        }
    }
    
    func exhibitionCoreDataInBackgroundThread(managedContext: NSManagedObjectContext,exhibition: [Exhibition]?) {
        if ((LocalizationLanguage.currentAppleLanguage()) == ENG_LANGUAGE) {
            let fetchData = self.checkAddedToCoredata(entityName: "ExhibitionsEntity", idKey: "id", idValue: nil, managedContext: managedContext) as! [ExhibitionsEntity]
            if (fetchData.count > 0) {
                for i in 0 ... (exhibition?.count)!-1 {
                    let exhibitionsListDict = exhibition![i]
                    let fetchResult = self.checkAddedToCoredata(entityName: "ExhibitionsEntity", idKey: "id", idValue: exhibition![i].id, managedContext: managedContext)
                    //update
                    if(fetchResult.count != 0) {
                        let exhibitionsdbDict = fetchResult[0] as! ExhibitionsEntity
                        exhibitionsdbDict.name = exhibitionsListDict.name
                        exhibitionsdbDict.image = exhibitionsListDict.image
                        exhibitionsdbDict.startDate =  exhibitionsListDict.startDate
                        exhibitionsdbDict.endDate = exhibitionsListDict.endDate
                        exhibitionsdbDict.location =  exhibitionsListDict.location
                        exhibitionsdbDict.museumId = exhibitionsListDict.museumId
                        exhibitionsdbDict.status = exhibitionsListDict.status
                        do {
                            try managedContext.save()
                        }
                        catch {
                            print(error)
                        }
                    } else {
                        //save
                        self.saveExhibitionListToCoreData(exhibitionDict: exhibitionsListDict, managedObjContext: managedContext)
                    }
                }//for
            } else {
                for i in 0 ... (exhibition?.count)!-1 {
                    let exhibitionListDict : Exhibition?
                    exhibitionListDict = exhibition?[i]
                    self.saveExhibitionListToCoreData(exhibitionDict: exhibitionListDict!, managedObjContext: managedContext)
                }
            }
        } else {
            let fetchData = self.checkAddedToCoredata(entityName: "ExhibitionsEntityArabic", idKey: "id", idValue: nil, managedContext: managedContext) as! [ExhibitionsEntityArabic]
            if (fetchData.count > 0) {
                for i in 0 ... (exhibition?.count)!-1 {
                    let exhibitionListDict = exhibition![i]
                    let fetchResult = self.checkAddedToCoredata(entityName: "ExhibitionsEntityArabic", idKey: "id", idValue: exhibition![i].id, managedContext: managedContext)
                    //update
                    if(fetchResult.count != 0) {
                        let exhibitiondbDict = fetchResult[0] as! ExhibitionsEntityArabic
                        exhibitiondbDict.nameArabic = exhibitionListDict.name
                        exhibitiondbDict.imageArabic = exhibitionListDict.image
                        exhibitiondbDict.startDateArabic =  exhibitionListDict.startDate
                        exhibitiondbDict.endDateArabic = exhibitionListDict.endDate
                        exhibitiondbDict.locationArabic =  exhibitionListDict.location
                        exhibitiondbDict.museumId =  exhibitionListDict.museumId
                        exhibitiondbDict.status =  exhibitionListDict.status
                        do {
                            try managedContext.save()
                        }
                        catch {
                            print(error)
                        }
                    } else {
                        //save
                        self.saveExhibitionListToCoreData(exhibitionDict: exhibitionListDict, managedObjContext: managedContext)
                    }
                }
            } else {
                for i in 0 ... (exhibition?.count)!-1 {
                    let exhibitionListDict : Exhibition?
                    exhibitionListDict = exhibition?[i]
                    self.saveExhibitionListToCoreData(exhibitionDict: exhibitionListDict!, managedObjContext: managedContext)
                }
            }
        }
    }
    
    func saveExhibitionListToCoreData(exhibitionDict: Exhibition, managedObjContext: NSManagedObjectContext) {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            let exhibitionInfo: ExhibitionsEntity = NSEntityDescription.insertNewObject(forEntityName: "ExhibitionsEntity", into: managedObjContext) as! ExhibitionsEntity
            
            exhibitionInfo.id = exhibitionDict.id
            exhibitionInfo.name = exhibitionDict.name
            exhibitionInfo.image = exhibitionDict.image
            exhibitionInfo.startDate =  exhibitionDict.startDate
            exhibitionInfo.endDate = exhibitionDict.endDate
            exhibitionInfo.location =  exhibitionDict.location
            exhibitionInfo.museumId =  exhibitionDict.museumId
            exhibitionInfo.status =  exhibitionDict.status
        } else {
            let exhibitionInfo: ExhibitionsEntityArabic = NSEntityDescription.insertNewObject(forEntityName: "ExhibitionsEntityArabic", into: managedObjContext) as! ExhibitionsEntityArabic
            exhibitionInfo.id = exhibitionDict.id
            exhibitionInfo.nameArabic = exhibitionDict.name
            exhibitionInfo.imageArabic = exhibitionDict.image
            exhibitionInfo.startDateArabic =  exhibitionDict.startDate
            exhibitionInfo.endDateArabic = exhibitionDict.endDate
            exhibitionInfo.locationArabic =  exhibitionDict.location
            exhibitionInfo.museumId =  exhibitionDict.museumId
            exhibitionInfo.status =  exhibitionDict.status
        }
        do {
            try managedObjContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    //MARK: Home Service call
    func getHomeList(lang: String?) {
        let queue = DispatchQueue(label: "HomeThread", qos: .background, attributes: .concurrent)
        _ = Alamofire.request(QatarMuseumRouter.HomeList(lang!)).responseObject(queue:queue) { (response: DataResponse<HomeList>) -> Void in
            switch response.result {
            case .success(let data):
               // DispatchQueue.main.async{
                self.saveOrUpdateHomeCoredata(homeList: data.homeList, lang: lang)
               // }
            case .failure(let error):
                print("error")
            }
        }
    }
    //MARK: Home Coredata Method
    func saveOrUpdateHomeCoredata(homeList: [Home]?,lang: String?) {
        if ((homeList?.count)! > 0) {
            if #available(iOS 10.0, *) {
                let container = self.persistentContainer
                container.performBackgroundTask() {(managedContext) in
                    self.homeCoreDataInBackgroundThread(managedContext: managedContext, homeList: homeList, lang: lang)
                }
            } else {
                let managedContext = self.managedObjectContext
                managedContext.perform {
                    self.homeCoreDataInBackgroundThread(managedContext : managedContext, homeList: homeList, lang: lang)
                }
            }
        }
    }
    
    func homeCoreDataInBackgroundThread(managedContext: NSManagedObjectContext, homeList: [Home]?,lang: String?) {
        if (lang == ENG_LANGUAGE) {
            let fetchData = checkAddedToCoredata(entityName: "HomeEntity", idKey: "id", idValue: nil, managedContext: managedContext) as! [HomeEntity]
            if (fetchData.count > 0) {
                for i in 0 ... (homeList?.count)!-1 {
                    let homeListDict = homeList![i]
                    let fetchResult = checkAddedToCoredata(entityName: "HomeEntity", idKey: "id", idValue: homeList![i].id, managedContext: managedContext)
                    //update
                    if(fetchResult.count != 0) {
                        let homedbDict = fetchResult[0] as! HomeEntity
                        homedbDict.name = homeListDict.name
                        homedbDict.image = homeListDict.image
                        homedbDict.sortid =  homeListDict.sortId
                        homedbDict.tourguideavailable = homeListDict.isTourguideAvailable
                        
                        do{
                            try managedContext.save()
                        }
                        catch{
                            print(error)
                        }
                    } else {
                        //save
                        self.saveHomeDataToCoreData(homeListDict: homeListDict, managedObjContext: managedContext, lang: lang)
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(homepageNotification), object: self)
            } else {
                for i in 0 ... (homeList?.count)!-1 {
                    let homeListDict : Home?
                    homeListDict = homeList?[i]
                    self.saveHomeDataToCoreData(homeListDict: homeListDict!, managedObjContext: managedContext, lang: lang)
                }
                NotificationCenter.default.post(name: NSNotification.Name(homepageNotification), object: self)
            }
        } else {
            let fetchData = checkAddedToCoredata(entityName: "HomeEntityArabic", idKey: "id", idValue: nil, managedContext: managedContext) as! [HomeEntityArabic]
            if (fetchData.count > 0) {
                for i in 0 ... (homeList?.count)!-1 {
                    let homeListDict = homeList![i]
                    
                    let fetchResult = checkAddedToCoredata(entityName: "HomeEntityArabic", idKey: "id", idValue: homeList![i].id, managedContext: managedContext)
                    //update
                    if(fetchResult.count != 0) {
                        let homedbDict = fetchResult[0] as! HomeEntityArabic
                        homedbDict.arabicname = homeListDict.name
                        homedbDict.arabicimage = homeListDict.image
                        homedbDict.arabicsortid =  homeListDict.sortId
                        homedbDict.arabictourguideavailable = homeListDict.isTourguideAvailable
                        do{
                            try managedContext.save()
                        }
                        catch{
                            print(error)
                        }
                    } else {
                        //save
                        self.saveHomeDataToCoreData(homeListDict: homeListDict, managedObjContext: managedContext, lang: lang)
                        
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(homepageNotification), object: self)
            } else {
                for i in 0 ... (homeList?.count)!-1 {
                    let homeListDict : Home?
                    homeListDict = homeList?[i]
                    self.saveHomeDataToCoreData(homeListDict: homeListDict!, managedObjContext: managedContext, lang: lang)
                    
                }
                NotificationCenter.default.post(name: NSNotification.Name(homepageNotification), object: self)
            }
        }
    }
    
    func saveHomeDataToCoreData(homeListDict: Home, managedObjContext: NSManagedObjectContext,lang: String?) {
        if (lang == ENG_LANGUAGE) {
            let homeInfo: HomeEntity = NSEntityDescription.insertNewObject(forEntityName: "HomeEntity", into: managedObjContext) as! HomeEntity
            homeInfo.id = homeListDict.id
            homeInfo.name = homeListDict.name
            homeInfo.image = homeListDict.image
            homeInfo.tourguideavailable = homeListDict.isTourguideAvailable
            homeInfo.image = homeListDict.image
            homeInfo.sortid = homeListDict.sortId
        } else{
            let homeInfo: HomeEntityArabic = NSEntityDescription.insertNewObject(forEntityName: "HomeEntityArabic", into: managedObjContext) as! HomeEntityArabic
            homeInfo.id = homeListDict.id
            homeInfo.arabicname = homeListDict.name
            homeInfo.arabicimage = homeListDict.image
            homeInfo.arabictourguideavailable = homeListDict.isTourguideAvailable
            homeInfo.arabicsortid = homeListDict.sortId
        }
        do {
            try managedObjContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    //MARK: MIA TourGuide WebServiceCall
    func getMiaTourGuideDataFromServer(museumId:String?,lang:String?) {
        let queue = DispatchQueue(label: "MiaTourThread", qos: .background, attributes: .concurrent)
        _ = Alamofire.request(QatarMuseumRouter.MuseumTourGuide(lang!,["museum_id": museumId!])).responseObject(queue:queue) { (response: DataResponse<TourGuides>) -> Void in
            switch response.result {
            case .success(let data):
                self.saveOrUpdateTourGuideCoredata(miaTourDataFullArray: data.tourGuide, museumId: museumId, lang: lang)
            case .failure(let error):
                print("error")
            }
        }
    }
    //MARK: Coredata Method
    func saveOrUpdateTourGuideCoredata(miaTourDataFullArray:[TourGuide]?,museumId: String?,lang:String?) {
        if ((miaTourDataFullArray?.count)! > 0) {
            if #available(iOS 10.0, *) {
                let container = self.persistentContainer
                container.performBackgroundTask() {(managedContext) in
                    self.miaTourGuideCoreDataInBackgroundThread(managedContext: managedContext, miaTourDataFullArray: miaTourDataFullArray, museumId: museumId, lang: lang)
                }
            } else {
                let managedContext = self.managedObjectContext
                managedContext.perform {
                    self.miaTourGuideCoreDataInBackgroundThread(managedContext : managedContext, miaTourDataFullArray: miaTourDataFullArray, museumId: museumId, lang: lang)
                }
            }
        }
    }
    
    func miaTourGuideCoreDataInBackgroundThread(managedContext: NSManagedObjectContext,miaTourDataFullArray:[TourGuide]?,museumId:String?,lang:String?) {
        if (lang == ENG_LANGUAGE) {
            let fetchData = checkAddedToCoredata(entityName: "TourGuideEntity", idKey: "museumsEntity", idValue: museumId, managedContext: managedContext) as! [TourGuideEntity]
            if (fetchData.count > 0) {
                for i in 0 ... (miaTourDataFullArray?.count)!-1 {
                    let tourGuideListDict = miaTourDataFullArray![i]
                    let fetchResult = checkAddedToCoredata(entityName: "TourGuideEntity", idKey: "nid", idValue: miaTourDataFullArray![i].nid, managedContext: managedContext)
                    //update
                    if(fetchResult.count != 0) {
                        let tourguidedbDict = fetchResult[0] as! TourGuideEntity
                        tourguidedbDict.title = tourGuideListDict.title
                        tourguidedbDict.tourGuideDescription = tourGuideListDict.tourGuideDescription
                        tourguidedbDict.museumsEntity =  tourGuideListDict.museumsEntity
                        tourguidedbDict.nid =  tourGuideListDict.nid
                        
                        if(tourGuideListDict.multimediaFile != nil) {
                            if((tourGuideListDict.multimediaFile?.count)! > 0) {
                                for i in 0 ... (tourGuideListDict.multimediaFile?.count)!-1 {
                                    var multimediaEntity: TourGuideMultimediaEntity!
                                    let multimediaArray: TourGuideMultimediaEntity = NSEntityDescription.insertNewObject(forEntityName: "TourGuideMultimediaEntity", into: managedContext) as! TourGuideMultimediaEntity
                                    multimediaArray.multimediaFile = tourGuideListDict.multimediaFile![i]
                                    
                                    multimediaEntity = multimediaArray
                                    tourguidedbDict.addToTourGuideMultimediaRelation(multimediaEntity)
                                    do {
                                        try managedContext.save()
                                    } catch let error as NSError {
                                        print("Could not save. \(error), \(error.userInfo)")
                                    }
                                    
                                }
                            }
                        }
                        
                        
                        do{
                            try managedContext.save()
                        }
                        catch{
                            print(error)
                        }
                    }
                    else {
                        //save
                        self.saveMiaTourToCoreData(tourguideListDict: tourGuideListDict, managedObjContext: managedContext, lang: lang)
                        
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(miaTourNotification), object: self)
            }
            else {
                for i in 0 ... (miaTourDataFullArray?.count)!-1 {
                    let tourGuideListDict : TourGuide?
                    tourGuideListDict = miaTourDataFullArray?[i]
                    self.saveMiaTourToCoreData(tourguideListDict: tourGuideListDict!, managedObjContext: managedContext, lang: lang)
                    
                }
                NotificationCenter.default.post(name: NSNotification.Name(miaTourNotification), object: self)
            }
        }
        else {
            let fetchData = checkAddedToCoredata(entityName: "TourGuideEntityAr", idKey: "museumsEntity", idValue: museumId, managedContext: managedContext) as! [TourGuideEntityAr]
            if (fetchData.count > 0) {
                for i in 0 ... (miaTourDataFullArray?.count)!-1 {
                    let tourGuideListDict = miaTourDataFullArray![i]
                    let fetchResult = checkAddedToCoredata(entityName: "TourGuideEntityAr", idKey: "nid" , idValue: miaTourDataFullArray![i].nid, managedContext: managedContext)
                    //update
                    if(fetchResult.count != 0) {
                        let tourguidedbDict = fetchResult[0] as! TourGuideEntityAr
                        tourguidedbDict.title = tourGuideListDict.title
                        tourguidedbDict.tourGuideDescription = tourGuideListDict.tourGuideDescription
                        tourguidedbDict.museumsEntity =  tourGuideListDict.museumsEntity
                        tourguidedbDict.nid =  tourGuideListDict.nid
                        
                        if(tourGuideListDict.multimediaFile != nil) {
                            if((tourGuideListDict.multimediaFile?.count)! > 0) {
                                for i in 0 ... (tourGuideListDict.multimediaFile?.count)!-1 {
                                    var multimediaEntity: TourGuideMultimediaEntityAr!
                                    let multimediaArray: TourGuideMultimediaEntityAr = NSEntityDescription.insertNewObject(forEntityName: "TourGuideMultimediaEntityAr", into: managedContext) as! TourGuideMultimediaEntityAr
                                    multimediaArray.multimediaFile = tourGuideListDict.multimediaFile![i]
                                    
                                    multimediaEntity = multimediaArray
                                    tourguidedbDict.addToTourGuideMultimediaRelation(multimediaEntity)
                                    do {
                                        try managedContext.save()
                                    } catch let error as NSError {
                                        print("Could not save. \(error), \(error.userInfo)")
                                    }
                                    
                                }
                            }
                        }
                        do{
                            try managedContext.save()
                        }
                        catch{
                            print(error)
                        }
                    }
                    else {
                        //save
                        self.saveMiaTourToCoreData(tourguideListDict: tourGuideListDict, managedObjContext: managedContext, lang: lang)
                        
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(miaTourNotification), object: self)
            }
            else {
                for i in 0 ... (miaTourDataFullArray?.count)!-1 {
                    let tourGuideListDict : TourGuide?
                    tourGuideListDict = miaTourDataFullArray?[i]
                    self.saveMiaTourToCoreData(tourguideListDict: tourGuideListDict!, managedObjContext: managedContext, lang: lang)
                    
                }
                NotificationCenter.default.post(name: NSNotification.Name(miaTourNotification), object: self)
            }
        }
    }
    
    func saveMiaTourToCoreData(tourguideListDict: TourGuide, managedObjContext: NSManagedObjectContext,lang:String?) {
        if (lang == ENG_LANGUAGE) {
            let tourGuideInfo: TourGuideEntity = NSEntityDescription.insertNewObject(forEntityName: "TourGuideEntity", into: managedObjContext) as! TourGuideEntity
            tourGuideInfo.title = tourguideListDict.title
            tourGuideInfo.tourGuideDescription = tourguideListDict.tourGuideDescription
            tourGuideInfo.museumsEntity = tourguideListDict.museumsEntity
            tourGuideInfo.nid = tourguideListDict.nid
            
            if(tourguideListDict.multimediaFile != nil) {
                if((tourguideListDict.multimediaFile?.count)! > 0) {
                    for i in 0 ... (tourguideListDict.multimediaFile?.count)!-1 {
                        var multimediaEntity: TourGuideMultimediaEntity!
                        let multimediaArray: TourGuideMultimediaEntity = NSEntityDescription.insertNewObject(forEntityName: "TourGuideMultimediaEntity", into: managedObjContext) as! TourGuideMultimediaEntity
                        multimediaArray.multimediaFile = tourguideListDict.multimediaFile![i]
                        
                        multimediaEntity = multimediaArray
                        tourGuideInfo.addToTourGuideMultimediaRelation(multimediaEntity)
                        do {
                            try managedObjContext.save()
                        } catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                        
                    }
                }
            }
        }
        else {
            let tourGuideInfo: TourGuideEntityAr = NSEntityDescription.insertNewObject(forEntityName: "TourGuideEntityAr", into: managedObjContext) as! TourGuideEntityAr
            tourGuideInfo.title = tourguideListDict.title
            tourGuideInfo.tourGuideDescription = tourguideListDict.tourGuideDescription
            tourGuideInfo.museumsEntity = tourguideListDict.museumsEntity
            tourGuideInfo.nid = tourguideListDict.nid
            if(tourguideListDict.multimediaFile != nil) {
                if((tourguideListDict.multimediaFile?.count)! > 0) {
                    for i in 0 ... (tourguideListDict.multimediaFile?.count)!-1 {
                        var multimediaEntity: TourGuideMultimediaEntityAr!
                        let multimediaArray: TourGuideMultimediaEntityAr = NSEntityDescription.insertNewObject(forEntityName: "TourGuideMultimediaEntityAr", into: managedObjContext) as! TourGuideMultimediaEntityAr
                        multimediaArray.multimediaFile = tourguideListDict.multimediaFile![i]
                        
                        multimediaEntity = multimediaArray
                        tourGuideInfo.addToTourGuideMultimediaRelation(multimediaEntity)
                        do {
                            try managedObjContext.save()
                        } catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                        
                    }
                }
            }
        }
        do {
            try managedObjContext.save()
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func checkAddedToCoredata(entityName: String?, idKey:String?, idValue: String?, managedContext: NSManagedObjectContext) -> [NSManagedObject] {
        var fetchResults : [NSManagedObject] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName!)
        if (idValue != nil) {
            fetchRequest.predicate = NSPredicate(format: "\(idKey!) == %@", idValue!)
        }
        fetchResults = try! managedContext.fetch(fetchRequest)
        return fetchResults
    }
    
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}


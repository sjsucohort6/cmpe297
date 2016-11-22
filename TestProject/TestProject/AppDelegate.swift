//
//  AppDelegate.swift
//  TestProject
//
//  Created by swetha muchukota on 11/1/16.
//  Copyright © 2016 swetha muchukota. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate{

    var window: UIWindow?
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    var myTimer: Timer?
    
    var locationManager = CLLocationManager()
    var data = [NSManagedObject]()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(accepted, error) in
            if !accepted {
                print("Notification access denied.")
            }
        }
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyEntity") //NSFetchRequest(entityName: "MyEntity")
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            data = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
            
        return true
    }
    
    func isMultitaskingSupported() -> Bool {
        return UIDevice.current.isMultitaskingSupported
    }
    
    func handleEvent(forRegion region: CLRegion!) {
        print("Geofence triggered!")
    }
    
    
        func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
            if region is CLCircularRegion {
                handleEvent(forRegion: region)
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
            if region is CLCircularRegion {
                handleEvent(forRegion: region)
            }
        }

    
    func timerMethod(sender: Timer) {
        let backgroundTimerRemainig = UIApplication.shared.backgroundTimeRemaining
        
        self.locationManager.startUpdatingLocation()
        
        if backgroundTimerRemainig == DBL_MAX {
            print("test1")
        } else {
            print("test")
            self.locationManager.delegate = self
            self.locationManager.startUpdatingLocation()
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        if !isMultitaskingSupported() {
            return
        }
        
        
        myTimer = Timer.scheduledTimer(timeInterval: 8.0,
                                                         target: self,
                                                         selector: Selector("timerMethod"),
                                                         userInfo: nil,
                                                         repeats: true)
        print("in background")
        
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask {
            () -> Void in
            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        if backgroundTaskIdentifier != UIBackgroundTaskInvalid {
            endBackgroundTask()
        }
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation locations: [AnyObject]) {
        print("Updating location")
        let latValue = String(describing: locationManager.location?.coordinate.latitude)
        let lonValue = String(describing: locationManager.location?.coordinate.longitude)
        
        var latDelta: CLLocationDegrees = (locationManager.location?.coordinate.latitude)!
        var longDelta: CLLocationDegrees = (locationManager.location?.coordinate.longitude)!
        
        
        var mypos: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latDelta,longDelta)
        
        var region = CLCircularRegion(center: mypos, radius: 200, identifier: "@home")
        
        for(Int i=0; i<data.count;i++)
        {
            print(data[i.row].value(forKey: "radius"))
            
            
        }
        
        //add the notification here
        
        var msg: String = "Your location : " + latValue + lonValue
        
        //let notificationSettings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil)
        //UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        scheduleNotification()
        
        
        print("App Delegate locations = \(latValue) \(lonValue)")
    }
    
    
    func scheduleNotification()
    {
        let startdate = NSDate()
        
        let calendar1 = Calendar.current
        let date = calendar1.date(byAdding: .second, value: 10, to: startdate as Date)
        
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date! as Date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        let content = UNMutableNotificationContent()
        content.title = "Tutorial Reminder"
        content.body = "Just a reminder to read your tutorial over at appcoda.com!"
        content.sound = UNNotificationSound.default()
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func endBackgroundTask(){
        let mainQueue = DispatchQueue.main
        
        mainQueue.async() {
            [weak self] in
            if let timer = self!.myTimer {
                timer.invalidate()
                self!.myTimer = nil
                UIApplication.shared.endBackgroundTask(self!.backgroundTaskIdentifier)
                self!.backgroundTaskIdentifier = UIBackgroundTaskInvalid
            }
        }

    }
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TestProject")
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
    
    // MARK: - Core Data Saving support

    func saveContext () {
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
    }
    
    

}


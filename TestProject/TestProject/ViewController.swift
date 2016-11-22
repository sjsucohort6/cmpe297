//
//  ViewController.swift
//  TestProject
//
//  Created by swetha muchukota on 11/1/16.
//  Copyright © 2016 swetha muchukota. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource ,CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    //var locations = [String]()
    //var radius = [Int]()
    
    var myEntity = [NSManagedObject]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"My Planner\""
        tableView.register(UITableViewCell.self, forCellReuseIdentifier:"Cell")
        appDelegate.locationManager.requestAlwaysAuthorization()
        let latValue = String (describing: appDelegate.locationManager.location?.coordinate.latitude)
        let lonValue = String (describing: appDelegate.locationManager.location?.coordinate.longitude)
        print("locations = \(latValue) \(lonValue)")
        var msg: String = "Your location : " + latValue + lonValue
        
        
        //let selectedDate = sender.date
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.scheduleNotification()
        
        //let notificationSettings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil)
        //UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        
        
        /* var notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 5) as Date
        notification.timeZone = NSTimeZone.default
        notification.alertBody = msg
        //notification.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        UIApplication.shared.scheduleLocalNotification(notification)*/
        
        
        //loadAllGeotifications()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == .authorizedAlways)
        {
            
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyEntity") //NSFetchRequest(entityName: "MyEntity")
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            myEntity = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        //return locations.count
        return myEntity.count;
    }
    
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath)
        let row = myEntity[indexPath.row]
        
       // let rad:String = String(describing: radius[indexPath.row])
        
        //cell.textLabel!.text = locations[indexPath.row] + " in " + rad + " miles radius "
        let rad : Int = row.value(forKey: "radius") as! Int
        let txt : String = (row.value(forKey: "location") as! NSString!) as String
        //let txt = row.value(forKey: "location") + " in " + rad + " miles radius "
        cell.textLabel!.text = txt + " in " + String(rad) + " miles radius "
        return cell
    }
    
    

    
    
    @IBAction func onAdd(_ sender: AnyObject) {
        
        let alert1 = UIAlertController(title: "New Geo Fence",
                                      message: "",
                                      preferredStyle: .alert)
        
        //alert1.view setTintColor;:[UIColor copperColor]
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default,
                                       handler: {(action : UIAlertAction) ->  Void in
                                       let textField = alert1.textFields![0]
                                       // textField.textColor = UIPalette.DarkText
                                       let textField1 = alert1.textFields![1]
                                       //self.locations.append((textField.text!))
                                       let text2:Int? = Int(textField1.text!)
                                       //self.radius.append(text2!)
                                       //self.radius.append((Int)textField1.text!)
                                        self.saveName(name: textField.text!,rad: text2!)
                                       self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default) {(action : UIAlertAction) -> Void in
        }
        
        /*alert1.addTextField {
            (textField: UITextField) -> Void in
        }*/
        alert1.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "geoFence Name"
        }
        
        alert1.addTextField { (textField1 : UITextField!) -> Void in
            textField1.placeholder = "Radius in miles"
        }
        
        alert1.addAction(saveAction)
        alert1.addAction(cancelAction)
        
        present(alert1,
                              animated: true,
                              completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveName(name: String, rad: Int)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity =  NSEntityDescription.entity(forEntityName: "MyEntity",
                                                 in:managedContext)
        
        let entity1 = NSManagedObject(entity: entity!,
                                      insertInto: managedContext)
        
        entity1.setValue(name,forKey: "location")

        entity1.setValue(rad,forKey: "radius")
        
        do{
            try managedContext.save()
            myEntity.append(entity1)
            
        }catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete ) {
            // Find the LogItem object the user is trying to delete
            let logItemToDelete = myEntity[indexPath.row]
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let managedContext = appDelegate.persistentContainer.viewContext
            // Delete it from the managedObjectContext
            managedContext.delete(logItemToDelete)
            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            
            // Refresh the table view to indicate that it's deleted
            self.fetchData()
            
            // Tell the table view to animate out that row
            tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
        }
    }
    
    func fetchData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyEntity")
        
        // Create a sort descriptor object that sorts on the "title"
        // property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: "location", ascending: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Set the list of sort descriptors in the fetch request,
        // so it includes the sort descriptor
        
        
        //let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyEntity") //NSFetchRequest(entityName: "MyEntity")
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            myEntity = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }


}


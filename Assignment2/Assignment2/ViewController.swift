//
//  ViewController.swift
//  Assignment2
//
//  Created by swetha muchukota on 11/11/16.
//  Copyright © 2016 swetha muchukota. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sID: UITextField!
    @IBOutlet weak var bgroup: UITextField!
    @IBOutlet weak var allergies: UITextField!
    @IBOutlet weak var medication: UITextField!
    
    var dataFilePath: String?
    let filemgr = FileManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let filemgr = FileManager.default
        let dirPaths =
            NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                .userDomainMask, true)
        
        let docsDir = dirPaths[0] as String!
        dataFilePath = docsDir?.appending("data.archive")
        
        
        /*if filemgr.fileExists(atPath: dataFilePath!) {
            let dataArray =
                NSKeyedUnarchiver.unarchiveObject(withFile: dataFilePath!) 
                    as! [String]
            sID.text = dataArray[0]
            bgroup.text = dataArray[1]
            allergies.text = dataArray[2]
            medication.text = dataArray[3]
            
        }*/
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func acrhivesSave(_ sender: Any) {
        
        var id = self.sID.text
        var blood = self.bgroup.text
        var all = self.allergies.text
        var med = self.medication.text
        
         var healthCardArray = [id, blood, all, med]
        NSKeyedArchiver.archiveRootObject(healthCardArray,
                                          toFile: dataFilePath!)
        
        print("Saved Data")
        
        
        self.sID.text = ""
        self.bgroup.text = ""
        self.allergies.text = ""
        self.medication.text=""
        
    }

    @IBAction func keyedSave(_ sender: Any) {
        
        /*var id = self.sID.text
        var blood = self.bgroup.text
        var all = self.allergies.text
        var med = self.medication.text
        
        var healthCardArray = [id, blood, all, med]
        
        print(dataFilePath)
        NSKeyedArchiver.archiveRootObject(healthCardArray,
                                          toFile: dataFilePath!)*/
        
        if filemgr.fileExists(atPath: dataFilePath!) {
         let dataArray =
         NSKeyedUnarchiver.unarchiveObject(withFile: dataFilePath!)
         as! [String]
         sID.text = dataArray[0]
         bgroup.text = dataArray[1]
         allergies.text = dataArray[2]
         medication.text = dataArray[3]
         
         }
        
        print("retrieved data")

    }
}


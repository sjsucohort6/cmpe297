//
//  ViewController.swift
//  Assignment3
//
//  Created by swetha muchukota on 11/16/16.
//  Copyright © 2016 swetha muchukota. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bookname: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBOutlet weak var author: UITextField!

    @IBOutlet weak var desc: UITextView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func savaFS(_ sender: Any) {
        
       
        var dataFile:String
        var docsDir:String
        var dirPaths:NSArray
        
        let filemgr = FileManager.default
        
       dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String] as NSArray
       docsDir = dirPaths[0]  as! String;
    
        
       dataFile = docsDir.appending("/datafile.dat") as String
        

        print(dataFile)
        
        
        var databuffer = bookname.text?.data(using: String.Encoding.utf8)
        databuffer?.append((author.text?.data(using: String.Encoding.utf8))!)
        databuffer?.append((desc.text?.data(using: String.Encoding.utf8))!)
        
        filemgr.createFile(atPath: dataFile as String, contents: databuffer, attributes: nil)
        
        print("Data Saved to File")
        
        self.author.text = ""
        self.bookname.text = ""
        self.desc.text = ""
    }

    @IBAction func saveArchives(_ sender: Any) {
        
        //let filemgr = FileManager.default
        let dirPaths =
            NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                .userDomainMask, true)
        
        let docsDir = dirPaths[0] as String!
        let dataFilePath = docsDir?.appending("/data.archive")
        
        print(dataFilePath)
        
        let bookdetails = [bookname.text, author.text , desc.text]
        NSKeyedArchiver.archiveRootObject(bookdetails,
                                          toFile: dataFilePath!)
        
        print("Saved Data")
        
        
        self.author.text = ""
        self.bookname.text = ""
        self.desc.text = ""
        
        
    }
}


//
//  ViewController.swift
//  Assignment1
//
//  Created by swetha muchukota on 11/7/16.
//  Copyright © 2016 swetha muchukota. All rights reserved.
//

import UIKit
import Darwin

class ViewController: UIViewController {

    @IBOutlet weak var tempinF: UITextField!
    
    var str:String = ""
    
    @IBAction func onConvert(_ sender: Any) {
        
        if tempinF.text?.isEmpty == true {
          return
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue!, sender: Any?) {
        var temp:Double = Double(tempinF.text!)!
        var value:Double = (temp-32)*5/9
        
        print(value)
        if let destinationVC = segue.destination as? SecondViewController {
            destinationVC.temp1 = Double(value)
          }
    }
    
    
    @IBAction func onCancel(_ sender: Any) {
        exit(0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(str != "")
        {
            tempinF.text = str
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  SecondViewController.swift
//  Assignment1
//
//  Created by swetha muchukota on 11/7/16.
//  Copyright © 2016 swetha muchukota. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var tempinC: UILabel!
    var temp1 = 0.0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if temp1 != nil{
            
            var str:String = String(format: "%f", self.temp1)
            
             print(str)
             self.tempinC.text =  str 
        }
            }
    
    override func prepare(for segue: UIStoryboardSegue!, sender: Any?) {
        
        
        if tempinC.text?.isEmpty != true {
            
            var temp:Float = Float(tempinC.text!)!
            var val:Float = (temp * 9/5) + 32
            var tempF:String = String(format: "%f", val)
        if let destinationVC = segue.destination as?  ViewController {
            destinationVC.str = tempF        }
      }
    }
    
    @IBAction func onBack(_ sender: Any) {
        
        let firstViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        
        if tempinC.text?.isEmpty != true {
            
            var temp:Float = Float(tempinC.text!)!
            var value:Float = (temp * 9/5) + 32
            firstViewController.str = String(value)
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
}

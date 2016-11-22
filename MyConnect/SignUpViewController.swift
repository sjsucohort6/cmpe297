//
//  SignUpViewController.swift
//  
//
//  Created by swetha muchukota on 11/19/16.
//
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var fname: UITextField!
    override func viewDidLoad() {
        @IBOutlet weak var lname: UITextField!
        @IBOutlet weak var lnmae: UITextField!
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

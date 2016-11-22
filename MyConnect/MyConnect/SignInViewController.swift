//
//  SignInViewController.swift
//  MyConnect
//
//  Created by swetha muchukota on 11/18/16.
//  Copyright © 2016 swetha muchukota. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var uname: UITextField!
    
    @IBOutlet weak var pword: UITextField!
    
    let window = UIApplication.shared.windows[0] as UIWindow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = FIRAuth.auth()?.currentUser {
           // self.signedIn(user)
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: Any) {
        let name = uname.text
        let password = pword.text
        
        if(name != "" && password != "")
        {
            FIRAuth.auth()?.signIn(withEmail: name!, password: password!, completion: { (user,error) in
                if( error == nil)
                {
                    
                    print("Log in Successfuly)")
                    
                    //let vc = ThreeViewController(nibName: "ThreeViewController", bundle: nil)
                   // navigationController?.pushViewController(vc, animated: true )
                    
                } else {
                    print(error)
                    let alert =  UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            })
            
            
        } else {
            let alert =  UIAlertController(title: "Error", message: "Enter email and password!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
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

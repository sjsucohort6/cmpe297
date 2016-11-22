//
//  signupViewController.swift
//  MyConnect
//
//  Created by swetha muchukota on 11/19/16.
//  Copyright © 2016 swetha muchukota. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class signupViewController: UIViewController {

    @IBOutlet weak var lastname: UITextField!
    
    @IBOutlet weak var fname: UITextField!
    
    @IBOutlet weak var cpword: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var pword: UITextField!
    
    let usersDB = FIRDatabase.database().reference(withPath: "users")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccount(_ sender: Any) {
        let mail = self.email.text
        let password = self.pword.text
        let cpassword = self.cpword.text
        let lastName = self.lastname.text
        let firstName = self.fname.text
        
        if(mail == "" && password == "" )
        {
            let alert =  UIAlertController(title: "Error", message: "Enter email and password!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        } else if(password != cpassword)
        {
            
            let alert =  UIAlertController(title: "Error", message: "Passwords don't match", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            FIRAuth.auth()?.createUser(withEmail: mail!,password:password!,completion: {(user,error) in
                if (error == nil)
                {
                    // creating the user was successful
                    FIREmailPasswordAuthProvider.credential(withEmail: mail!, password: password!)
                    
                    //add user to DB
                    // create a child reference with email
                    
                    print(self.usersDB)
                    
                    let user = User(firstName: firstName!, lastName: lastName!, email: mail!)
                    
                    let userRef = self.usersDB.child((firstName?.lowercased())!)
                    
                    
                    userRef.setValue(user.toAnyObject())
                    
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    print(error!)
                    let alert =  UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            })
            
            
            
        }
        
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

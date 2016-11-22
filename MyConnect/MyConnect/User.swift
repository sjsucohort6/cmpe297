//
//  User.swift
//  MyConnect
//
//  Created by swetha muchukota on 11/19/16.
//  Copyright © 2016 swetha muchukota. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var firstName : String? = "An animal"
    
    var lastName : String? = "An animal"
    
    var email : String? = "An animal"
    
    init (firstName: String, lastName: String, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
    
    func toAnyObject() -> Any {
        return [
            "email" : email,
            "firstName" : firstName,
            "lastName" : lastName
        ]
    }
}

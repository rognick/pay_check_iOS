//
//  User.swift
//  PayCheckManager
//
//  Created by Rogojan Nicolae on 3/28/15.
//  Copyright (c) 2015 Rogojan Nicolae. All rights reserved.
//

import UIKit

class User: NSObject {
 
    let firstName: String = ""
    let lastName: String = ""
    let email: String = ""
    let birthday: NSDate = NSDate()
    let mobile: Int = 0
    let password: String = ""
    private let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override init() {
        
        if defaults.stringForKey("firstName") != nil {
            self.firstName = defaults.stringForKey("firstName")!}
        if defaults.stringForKey("lastName") != nil {
            self.lastName = defaults.stringForKey("lastName")! }
        if defaults.stringForKey("email") != nil {
            self.email = defaults.stringForKey("email")!}
        if defaults.objectForKey("birthday") != nil {
            self.birthday = defaults.objectForKey("birthday") as NSDate}
        if defaults.integerForKey("mobile") != -1 {
            self.mobile = defaults.integerForKey("mobile")}
        if defaults.stringForKey("password") != nil {
            self.password = defaults.stringForKey("password")!}
    }

}
//
//  APIClient.swift
//  PayCheckManager
//
//  Created by Rogojan Nicolae on 3/29/15.
//  Copyright (c) 2015 Rogojan Nicolae. All rights reserved.
//

import UIKit

class APIClient: NSObject {
    
    func test() -> Bool {
        let user = User()
        var request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:9000/users")!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
//        var params = ["id": 1,"login_name":"test", "password":"paswordTest", "first_name":user.firstName, "last_name":user.lastName, "birthday":"123", "email":user.email, "mobile":String(user.mobile)] as Dictionary<Int, String, String, String, String, Date, String, String>
        
        var params: NSDictionary = ["id" :1,"login_name":"test", "password":"paswordTest","first_name":user.firstName, "last_name":user.lastName, "birthday":1427061600000, "email":user.email, "mobile":String(user.mobile)]
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    var success = parseJSON["success"] as? Int
                    println("Succes: \(success)")
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        
        task.resume()
        return true
    }
   
}

//
//  UserViewController.swift
//  PayCheckManager
//
//  Created by Rogojan Nicolae on 3/28/15.
//  Copyright (c) 2015 Rogojan Nicolae. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var birthday: UITextField!
    @IBOutlet weak var password: UITextField!

    @IBOutlet var scroll: UIScrollView!
    @IBOutlet var contentView: UIView!
    
    var datePicker: UIDatePicker!
    let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.contentSize.height = contentView.bounds.height

        firstName.text = user.firstName
        lastName.text = user.lastName
        email.text = user.email
        mobile.text = String(user.mobile)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        birthday.text = dateFormatter.stringFromDate(user.birthday)
        password.text = user.password
        
        var sec2: Double    = 1427662440.98119
        var secunds: Double = 1427061600000
//        secunds = secunds/1000.00
        
        let dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateStyle = .MediumStyle

        println(dateFormatter2.stringFromDate(NSDate().dateByAddingTimeInterval(sec2/1000)))
        println(dateFormatter2.stringFromDate(NSDate().dateByAddingTimeInterval(secunds)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func qwe(sender: UITextField) {
        println("\nbirthday")
        NSLog("\nbirthday")
    }

    @IBAction func birthday(sender: UITextField) {
        datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePicker
        datePicker.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
//        timeFormatter.timeStyle = .ShortStyle
        birthday.text = dateFormatter.stringFromDate(sender.date)
    }
    
    @IBAction func saveBtn(sender: AnyObject) {
        defaults.setValue(firstName.text, forKey: "firstName")
        defaults.setValue(lastName.text, forKey: "lastName")
        defaults.setValue(email.text, forKey: "email")
        defaults.setInteger(mobile.text.toInt()!, forKey: "mobile")
        defaults.setObject(datePicker.date, forKey: "birthday")
        defaults.setValue(password.text, forKey: "password")
        
//        defaults.setObject(user, forKey: "user")
//          var params: NSDictionary = ["id" :1,"login_name":"test", "password":"paswordTest","first_name":user.firstName, "last_name":user.lastName, "birthday":"123", "email":user.email, "mobile":String(user.mobile)]
//        NSLog("User saved %@ /n %@", params ,APIClient().test())
        

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

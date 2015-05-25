
import UIKit

class User: NSObject {
 
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var birthday: NSDate = NSDate()
    var mobile: Int = 0
    var password: String = ""
    private let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override init() {
        
        if defaults.stringForKey("firstName") != nil {
            self.firstName = defaults.stringForKey("firstName")! }
        if defaults.stringForKey("lastName") != nil {
            self.lastName = defaults.stringForKey("lastName")! }
        if defaults.stringForKey("email") != nil {
            self.email = defaults.stringForKey("email")!}
        if defaults.objectForKey("birthday") != nil {
            self.birthday = defaults.objectForKey("birthday") as! NSDate}
        if defaults.integerForKey("mobile") != -1 {
            self.mobile = defaults.integerForKey("mobile")}
        if defaults.stringForKey("password") != nil {
            self.password = defaults.stringForKey("password")!}
    }

}
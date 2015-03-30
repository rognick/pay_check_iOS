// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var sec2: Double    = 1427662440.98119
var secunds: Double = 1427061600000
//        secunds = secunds/1000.00

let dateFormatter2 = NSDateFormatter()
dateFormatter2.dateStyle = .MediumStyle
NSDate().timeIntervalSince1970

println(dateFormatter2.stringFromDate( NSDate(timeIntervalSince1970:1427061600000/1000)))

var qwe:NSDate = dateFormatter2.dateFromString("Apr 15, 2015")!
println(dateFormatter2.stringFromDate(qwe))
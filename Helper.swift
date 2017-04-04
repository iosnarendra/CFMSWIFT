//
//  Helper.swift
//  CFMSWIFT
//
//  Created by Narendra on 03/04/17.
//  Copyright © 2017 asman. All rights reserved.
//


import UIKit
typealias UnixTime = Int
var chatType: String = ""
var chatPeerObject: [String:AnyObject]?

class Helper: NSObject
{
    class func inToBool(_ parametere: AnyObject) -> Bool
    {
        if let boolValue = parametere["success"] as? Bool
        {
            return boolValue
        }
        return false
    }
    class func inBool(_ parametere: AnyObject) -> Bool
    {
        if let boolValue = parametere["1"] as? Bool
        {
            return boolValue
        }
        return false
    }
    class func extractNumber(fromText text: String) -> String
    {
        let nonDigitCharacterSet = CharacterSet.decimalDigits.inverted
        return (text.components(separatedBy: nonDigitCharacterSet) as NSArray).componentsJoined(by: "")
    }
//    static func toString(_ parameter: Any?, defaultValue: String = " ") -> String
//    {
//        if let stringValue = parameter as? String {
//        
//            var decode :String = " "
//            var decodeString :String = " "
//            decode = stringValue.htmlUnescape()
//            let decodeStr = decode.removingPercentEncoding
//            
//            if decodeStr != nil {
//                decodeString = decodeStr!
//            } else {
//                decodeString = stringValue
//            }
//            return decodeString
//        }
//        return defaultValue
//    }
    static func toDateandTime(_ date: Any, defaultValue: String = "") -> String
    {
        if let DateValue = date as? String
        {
            return DateValue
        }
        return defaultValue
    }
    
    static func toTrimmingCharacters(_ trim: Any) -> String {
        if let trimValue = trim as? String
        {
            let s2 = trimValue.stringsMatchingRegularExpression(expression: "[-+]?\\d+.?\\d+")
            let stringFromArray = s2?.joined(separator: "")
           
            if stringFromArray != nil
            {
                let int = Double(stringFromArray!)! / 1000
                let myMilliseconds: UnixTime = UnixTime(int)
                return myMilliseconds.toDay
            }
            else
            {
                return ""
            }
            
        }
        return ""
    }
    static func toTimeTrimming(_ trim: Any, defaultValue: String = "") -> String {
        if let trimValue = trim as? String
        {
            let s2 = trimValue.stringsMatchingRegularExpression(expression: "[-+]?\\d+.?\\d+")
            let stringFromArray = s2?.joined(separator: "")
            if stringFromArray != nil
            {
                let int = Double(stringFromArray!)! / 1000
                let myMilliseconds: UnixTime = UnixTime(int)
                return myMilliseconds.toHour
            }
            else
            {
                return ""
            }
        }
        return defaultValue
    }
    
    static func toFilterData(_ messageFilter: Any, defaultValue: String = "") -> String
    {
        if let filterMessage = messageFilter as? String
        {
            var stringToColor = ""
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.allSystemTypes.rawValue)
            let matches = detector.matches(in: filterMessage, options: [], range: NSRange(location: 0, length: filterMessage.utf16.count))
            
            for match in matches
            {
                let urlLink = (filterMessage as NSString).substring(with: match.range)
                stringToColor = urlLink as String
            }
            return stringToColor
        }
        return defaultValue
    }
    
    static func togetDateFromUtc(_ dates: Any) -> String
    {
        if let trimValue = dates as? String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
            // change to a readable time format and change to local time zone
            dateFormatter.dateFormat = "MMM dd yyyy"
            dateFormatter.timeZone = NSTimeZone.local
            let dates = dateFormatter.date(from: trimValue)
            let timeStamp = dateFormatter.string(from: dates!)
            return timeStamp
        }
        return ""
    }
    
    //MARK: -convertStringToDictionary
    
    class  func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError
            {
                print(error)
            }
        }
        return nil
    }
    class func datePeriodRelativeToToday(dateStr: String) -> String
    {
        let dateFormatter = DateFormatter()
        let dateString = dateStr
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        let dateObj = dateFormatter.date(from: dateString)
        let calendar = Calendar.autoupdatingCurrent
        if calendar.isDateInYesterday(dateObj!)
        {
            return "Yesterday"
        }
        else if calendar.isDateInToday(dateObj!)
        {
            return "Today"
        }
        else
        {
            dateFormatter.dateFormat = "MMM d"
            return (dateFormatter.string(from: dateObj!))
        }
        
    }
    class func getDateFromUTC(dateStr: String) -> String
    {
        let dateFormatter = DateFormatter()
        let dateString = dateStr
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        let dateObje = dateFormatter.date(from: dateString)
        let calendar = Calendar.autoupdatingCurrent
        
        if calendar.isDateInYesterday(dateObje!)
        {
            return "Yesterday"
        }
        else if calendar.isDateInToday(dateObje!)
        {
            return "Today"
        }
        else
        {
            dateFormatter.dateFormat = "MMM d"
            return (dateFormatter.string(from: dateObje!))
        }
        
    }
    
    class func getTime(timeStr: String) -> String
    {
        let dateFormatter = DateFormatter()
        let dateString = timeStr
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        let dateObject = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = NSTimeZone.local
        return (dateFormatter.string(from: dateObject!))
        
    }
}


extension String {
    
    func stringsMatchingRegularExpression(expression exp:String) -> [String]? {
        var strArray:[String]?
        var rangeArray:[NSRange]?
        let strLength = self.characters.count
        var startOfRange = 0
        do {
            let regexString = try NSRegularExpression(pattern: exp, options: [])
            while startOfRange <= strLength {
                let rangeOfMatch = regexString.rangeOfFirstMatch(in: self, options: [], range: NSMakeRange(startOfRange, strLength-startOfRange))
                if let rArray = rangeArray {
                    rangeArray = rArray + [rangeOfMatch]
                }
                else {
                    rangeArray = [rangeOfMatch]
                }
                startOfRange = rangeOfMatch.location+rangeOfMatch.length
                
                
            }
            if let ranArr = rangeArray {
                for r in ranArr {
                    
                    if !NSEqualRanges(r, NSMakeRange(NSNotFound, 0)) {
                        self.index(startIndex, offsetBy: r.length)
                        
                        let r =  self.index(startIndex, offsetBy:r.location)..<self.index(startIndex, offsetBy:r.location + r.length)
                        
                        // return the value
                        let substringForMatch = self.substring(with: r)
                        if let sArray = strArray {
                            strArray = sArray + [substringForMatch]
                        }
                        else {
                            strArray = [substringForMatch]
                        }
                        
                    }
                    
                }
            }
        }
        catch {
            // catch errors here
        }
        
        return strArray
    }
}

func convertDateFromUNIXTimeStamp(_ timeStamp: Double) -> String {
    let date = Date(timeIntervalSince1970: timeStamp/1000)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MMM-YYYY, hh:mm aa"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    dateFormatter.timeStyle = .short
    dateFormatter.dateStyle = .short
    dateFormatter.locale = Locale.current
    let dateString = dateFormatter.string(from: date)
    return dateString
}


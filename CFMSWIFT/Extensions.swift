//
//  Extensions.swift
//  CFMSWIFT
//
//  Created by Narendra on 03/04/17.
//  Copyright © 2017 asman. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

protocol Utilities {
}

extension NSObject:Utilities {
    
    enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }
    
    var currentReachabilityStatus: ReachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        if flags.contains(.reachable) == false {
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }
}

extension UIView {
    
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}

extension String {
    
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst())
    }
}
extension Array {
    
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

extension UnixTime {
    private func formatType(form: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.dateFormat = form
        return dateFormatter
    }
    var dateFull: NSDate
    {

        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd/MM/yyyy"

        return NSDate(timeIntervalSince1970: Double(self))
    }
    var toHour: String
    {
        return formatType(form: "HH:mm:ss").string(from: dateFull as Date)
    }
    var toDay: String
    {
        return formatType(form: "dd/MM/yyyy").string(from: dateFull as Date)
    }
}

extension  UIViewController {
    
    //Show Alert
    func showAlert(title :String, message: String) -> Void {
      
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Hide Keyboard
    func hideKeyboardWhenTappedOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Device Type
    enum UIUserInterfaceIdiom : Int {
        case Unspecified
        case Phone
        case Pad
    }

    var iDeviceType: UIUserInterfaceIdiom {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .Phone
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            return .Pad
        } else {
            return .Unspecified
        }
    }
}

extension Dictionary {
    
    func updating(_ dict: [Key: Value]) -> [Key: Value] {
        var newDict = self
        
        for (key, value) in dict {
            newDict[key] = value
        }
        
        return newDict
    }
}


extension Dictionary where Key : ExpressibleByStringLiteral {
    
    subscript(ci key : Key) -> Value? {
        get {
            let searchKey = String(describing: key).lowercased()
            
            for k in self.keys {
                let lowerK = String(describing: k).lowercased()
                if searchKey == lowerK
                {
                    return self[k]
                }
            }
            return nil
        }
    }
}

extension Dictionary where Value: Hashable {
    
    func inverting(_ pick: (Key, Key) -> Key = { existingValue, newValue in
        return newValue
        }) -> [Value: Key] {
        var inverseDict: [Value: Key] = [:]
        
        for (key, value) in self {
            if let existing = inverseDict[value] {
                inverseDict[value] = pick(existing, key)
            }
            else {
                inverseDict[value] = key
            }
        }
        
        return inverseDict
    }
}

extension UInt32 {
    var isAlphaNumeric: Bool {
        return self.isNumeral || 0x41...0x5A ~= self || 0x61...0x7A ~= self
    }
    
    var isAmpersand: Bool {
        return self == 0x26
    }
    
    var isASCII: Bool {
        return self < 0x80
    }
    
    
    var isAttributeSyntax: Bool {
        return self == 0x22 || self == 0x27
    }
    
    var isDisallowedReference: Bool {
        
        
        return 0x1...0x8 ~= self || 0xD...0x1F ~= self || 0xFDD0...0xFDEF ~= self || self == 0xB
            || self == 0xFFFE || self == 0xFFFF || self == 0x1FFFE || self == 0x1FFFF
            || self == 0x2FFFE || self == 0x2FFFF || self == 0x3FFFE || self == 0x3FFFF
            || self == 0x4FFFE || self == 0x4FFFF || self == 0x5FFFE || self == 0x5FFFF
            || self == 0x6FFFE || self == 0x6FFFF || self == 0x7FFFE || self == 0x7FFFF
            || self == 0x8FFFE || self == 0x8FFFF || self == 0x9FFFE || self == 0x9FFFF
            || self == 0xAFFFE || self == 0xAFFFF || self == 0xBFFFE || self == 0xBFFFF
            || self == 0xCFFFE || self == 0xCFFFF || self == 0xDFFFE || self == 0xDFFFF
            || self == 0xEFFFE || self == 0xEFFFF || self == 0xFFFFE || self == 0xFFFFF
            || self == 0x10FFFE || self == 0x10FFFF
    }
    
    var isHash: Bool {
        // unicode value of #
        return self == 0x23
    }
    
    var isHexNumeral: Bool {
        // unicode values of [0-9], [A-F], and [a-f]
        return isNumeral || 0x41...0x46 ~= self || 0x61...0x66 ~= self
    }
    
    var isNumeral: Bool {
        // unicode values of [0-9]
        return 0x30...0x39 ~= self
    }
    
    /// https://www.w3.org/TR/html5/syntax.html#tokenizing-character-references
    var isReplacementCharacterEquivalent: Bool {
        return 0xD800...0xDFFF ~= self || 0x10FFFF < self
    }
    
    var isSafeASCII: Bool {
        return self.isASCII && !self.isAttributeSyntax && !self.isTagSyntax
    }
    
    var isSemicolon: Bool {
        return self == 0x3B
    }
    
    var isTagSyntax: Bool {
        return self.isAmpersand || self == 0x3C || self == 0x3E
    }
    
    var isX: Bool {
        return self == 0x58 || self == 0x78
    }
}

enum EntityParseState {
    case Dec
    case Hex
    case Invalid
    case Named
    case Number
    case Unknown
}

extension UIButton {
    
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
}

extension NSRange {
    
    func range(for str: String) -> Range<String.Index>? {
        guard location != NSNotFound else { return nil }
        guard let fromUTFIndex = str.utf16.index(str.utf16.startIndex, offsetBy: location, limitedBy: str.utf16.endIndex) else { return nil }
        guard let toUTFIndex = str.utf16.index(fromUTFIndex, offsetBy: length, limitedBy: str.utf16.endIndex) else { return nil }
        guard let fromIndex = String.Index(fromUTFIndex, within: str) else { return nil }
        guard let toIndex = String.Index(toUTFIndex, within: str) else { return nil }
        
        return fromIndex ..< toIndex
    }
}


extension UITextField {
    
    func modifyClearButtonWithImage(image : UIImage) {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x:0,y:0,width:15,height:15)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action:#selector(UITextField.clear(sender:)) , for: .touchUpInside)
        self.rightView = clearButton
        self.rightViewMode = .whileEditing
    }
    
    func clear(sender : AnyObject) {
        self.text = ""
    }
}

extension UIFont {
    
    class func avenirBlack(_ fontSize : CGFloat) -> UIFont {
        return UIFont(name: "Avenir Black", size: fontSize)!
    }
    
    class func avenirHeavy(_ fontSize : CGFloat) -> UIFont {
        return UIFont(name: "Avenir Heavy", size: fontSize)!
    }
    
    class func avenirMedium(_ fontSize : CGFloat) -> UIFont {
        return UIFont(name: "Avenir Medium", size: fontSize)!
    }
    
    class func avenirLight(_ fontSize : CGFloat) -> UIFont {
        return UIFont(name: "Avenir Light", size: fontSize)!
    }
    
    class func avenir(_ fontSize : CGFloat) -> UIFont {
        return UIFont(name: "Avenir", size: fontSize)!
    }
}

extension UIImage {
    
    func makeImageWithColorAndSize(_ color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func imageWithColor(_ tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()! as CGContext
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension UIImageView {
    
    func downloadImageFrom(link:String, contentMode: UIViewContentMode) {
        
        URLSession.shared.dataTask( with: URL(string:link)!, completionHandler:
            {
                (data, response, error) -> Void in
                DispatchQueue.main.async
                    {
                        self.contentMode =  contentMode
                        if let data = data
                        {
                            self.image = UIImage(data: data)
                        }
                }
        }).resume()
    }
}

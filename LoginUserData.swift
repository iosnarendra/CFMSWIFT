//
//  LoginUserData.swift
//  CFMSWIFT
//
//  Created by Narendar N on 04/04/17.
//  Copyright © 2017 asman. All rights reserved.
//

import UIKit

class LoginUserData: NSObject {
    
    var user_id: String         =   ""
    var role_id: String         =   ""
    var department_id: String   =   ""
    
    init(withDictionary dictionary: [String: Any]) {
        
        self.user_id = dictionary["user_id"] as Any as! String
        self.role_id  = dictionary["role_id "] as Any as! String
        self.department_id = dictionary["department_id"] as Any as! String
        
        debugPrint("self.user_id \(self.user_id) \n self.department_id \(self.department_id) \n self.role_id\(self.role_id)")
        
    }
    

}

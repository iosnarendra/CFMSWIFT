//
//  ApplicationConstants.swift
//  CFMSWIFT
//
//  Created by Narendra on 03/04/17.
//  Copyright © 2017 asman. All rights reserved.
//

import Foundation
import UIKit
//MARK: CONSTANTS
let APPCOLOR: UIColor = UIColor.init(colorLiteralRed: 49.0/255.0, green: 187.0/255.0, blue: 172.0/255.0, alpha:1.0)
let APPNAME : String =  "CFM"
//let baseURL : String =  "http://asmanesri.cloudapp.net/CentralFundsManagement/CFMProvider.svc/"
let baseURL : String =  "http://172.16.16.174/CentralFundsManagement/CFMProvider.svc/"
let interNetError : String = "Please check your Internet connection"


//MARK: DEVICE TYPES
let IDIOM = UI_USER_INTERFACE_IDIOM()
let iPAD = UIUserInterfaceIdiom.pad
let iPhone = UIUserInterfaceIdiom.phone

//MARK: SERVICE URLS
 let LOGIN_URL = String(format: baseURL + "loginauth/?username=%@"+"&password=%@")

//#define LOGIN_URL (BASE_URL @"loginauth/?username=%@&password=%@")
//#define FORGOT_PWD_URL (BASE_URL @"newpassword/?username=%@")
//
//#pragma mark - RCUSER
//
//#define DEPT_SERVICE (BASE_URL @"getdeptwiseissues/?result_limit=%@")
//#define SCHEME_SERVICE (BASE_URL @"getschemewiseissues/?result_limit=%@")
//#define DEPT_ISSUES_LIST (BASE_URL @"getallissuesbydept/?dept_id=%@")
//#define SCHEME_ISSUES_LIST (BASE_URL @"getallissuesbyscheme/?scheme_id=%@")
//#define ISSUE_DETAIL_INFO (BASE_URL @"issuedetailedinfo/?issue_id=%@")
//#define ALL_ISSUES_SERVICE (BASE_URL @"getallissues/")
//#define MONTHLY_ISSUES_SERVICE (BASE_URL @"getmonthlywiseissues/?result_limit=%@")
//#define USER_PROFILE_SERVICE (BASE_URL @"getuserinfo/?user_id=%@")
//#define CHANGE_PWD_SERVICE (BASE_URL @"changepassword")
//		

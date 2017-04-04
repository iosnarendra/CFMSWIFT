//
//  ViewController.swift
//  CFMSWIFT
//
//  Created by Narendra on 03/04/17.
//  Copyright © 2017 asman. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameTF: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTF: SkyFloatingLabelTextField!
    var resutlsDic : Dictionary<String, Any> = [:]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "LOGIN"
 
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
          view.addGestureRecognizer(tap)
     
        debugPrint("test commit")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        super.viewWillAppear(true)
        userNameTF.text = "rcuser"
        passwordTF.text = "asman"

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button Actions
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func loginAction(_ sender: Any) {
        
        if userNameTF.text == nil {
            self.showAlert(title: APPNAME, message: "Username required")
     
        } else if passwordTF.text == nil {
             self.showAlert(title: APPNAME, message: "Password required")
        } else {
          
            let login_URL = String(format: baseURL + "loginauth/?username="+userNameTF.text!+"&password="+passwordTF.text!)
            
            AlamofireAPIWrapper.requestPOSTURL(login_URL, params: nil, headers: ["Content-type" : "application/json"], success:
                {
                    (JSONResponse) -> Void in
                    debugPrint("success JSONResponse : \(JSONResponse as Any)")
                    let resultsDict = (JSONResponse.dictionary)
                    
//                    UserDefaults.standard.set(resultsDict(value(forKeyPath: "loginauthResults.user_id")), forKey: "USER_ID")
                    
            },failure: {
                (error) -> Void in
                debugPrint(error)
                debugPrint("failure")
            })
            
            self.showAlert(title: APPNAME, message: "Login Success")
        }
    }
 
    @IBAction func forgotPWDAction(_ sender: Any) {
        
        let forgotPasswordAlert = UIAlertController(title: APPNAME, message: "Enter your registered user name", preferredStyle: UIAlertControllerStyle.alert)
        
        forgotPasswordAlert .addTextField { (textField : UITextField!) -> Void in
            textField.delegate = self
            textField.returnKeyType = UIReturnKeyType.done
            textField.keyboardType = UIKeyboardType.emailAddress
            textField.placeholder = "User name"
        }
        let submitAction = UIAlertAction(title: "SUBMIT", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
         
            let textField = forgotPasswordAlert.textFields![0] as UITextField

            if textField.text?.characters.count == 0 {
                self.showAlert(title: APPNAME, message: "Please enter valid user name")
            } else {
                let emailText = textField.text
                print("emailText  \(emailText)")
 //                self.forgotPasswordServiceCall(emailText)
            }
        })
       
        forgotPasswordAlert.addAction(submitAction)
        self.present(forgotPasswordAlert, animated: true, completion: nil)

    }

    //MARK: TextFied Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


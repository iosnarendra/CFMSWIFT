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
    var loginResultDict: LoginUserData? = nil
    
    var strLabel = UILabel()
    var bgImage: UIImageView?
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "LOGIN"
 
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        super.viewWillAppear(true)
        
        hideKeyboardWhenTappedOnView()

        userNameTF.text = "rcuser"
        passwordTF.text = "asman"
        
        if  iDeviceType == .Pad {
            debugPrint("pad")
        } else {
            debugPrint("phone")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ActivityIndicator
    func startLoading(msg: String, _indicator: Bool) {
        
        strLabel = UILabel(frame: CGRect(x: ((self.view.frame.size.width)/2)-60, y: (self.view.frame.size.width)/2, width: 150, height: 50))
        strLabel.text = msg
        strLabel.font = UIFont.avenir(18)
        strLabel.textColor = UIColor.lightGray
        
        messageFrame = UIView(frame: CGRect(x: 0, y: 110 , width: view.frame.width, height: (view.frame.height)-162))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor.lightText
         let image: UIImage = UIImage(named: "loading")!  // refreshing
        bgImage = UIImageView(image: image)
        bgImage!.frame = CGRect(x: ((self.view.frame.size.width)/2)-40, y: 140 , width: 40, height: 40)
        
        messageFrame.addSubview(bgImage!)
        self.rotateView(view: bgImage!)
        messageFrame.addSubview(activityIndicator)
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
    }
    
    func stopLoading() {
        
        strLabel.removeFromSuperview()
        bgImage?.removeFromSuperview()
        messageFrame.removeFromSuperview()
    }
    
    func rotateView(view: UIView, duration: Double = 4) {
        
        let kRotationAnimationKey = "com.myapplication.rotationanimationkey"
        if view.layer.animation(forKey: kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float(M_PI * 2.0)
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            view.layer.add(rotationAnimation, forKey: kRotationAnimationKey)
        }
    }
    
    
    //MARK: Button Actions
    
    @IBAction func loginAction(_ sender: Any) {
        
        if currentReachabilityStatus == .notReachable {
            self.showAlert(title: APPNAME, message: "No internet connection.!")
        } else {
            if userNameTF.text == nil {
                self.showAlert(title: APPNAME, message: "Username required")
                
            } else if passwordTF.text == nil {
                self.showAlert(title: APPNAME, message: "Password required")
            } else {
                
                startLoading(msg: "Please wait...", _indicator: true)

                let login_URL = String(format: baseURL + "loginauth/?username="+userNameTF.text!+"&password="+passwordTF.text!)
                
                AlamofireAPIWrapper.requestPOSTURL(login_URL, params: nil, headers: ["Content-type" : "application/json"], success:
                    {
                        (JSONResponse) -> Void in
                        
                        if JSONResponse.dictionaryValue["loginauthResults"]?.dictionaryValue["status"] == "Success" {
                            debugPrint("success")
                        }
                        
//                        debugPrint(JSONResponse["loginauthResults"].dictionary! as Dictionary<String, AnyObject>)
                        
                        //                    debugPrint("loginauthResults.user_id : \(resultsDict(value(forKey: "loginauthResults")) as Any)")
                        //                    UserDefaults.standard.set(resultsDict(value(forKeyPath: "loginauthResults.user_id")), forKey: "USER_ID")
                        
                        self.stopLoading()

                        
                },failure: {
                    (error) -> Void in
                    self.stopLoading()

                    let alert = UIAlertController(title: "CFM", message: "Please enter valid credentials.!", preferredStyle: UIAlertControllerStyle.alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    
                    debugPrint(error)
                    debugPrint("failure")
                    
                 })
            }
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
                let emailString = textField.text
                print("emailText  \(emailString)")
                print("emailText  \(emailString)")
                 self.forgotPasswordServiceCall(emailText: emailString!)
            }
        })
       
        forgotPasswordAlert.addAction(submitAction)
        self.present(forgotPasswordAlert, animated: true, completion: nil)

    }
    
    //MARK: Service Call Methods
    
    func forgotPasswordServiceCall(emailText:String) -> Void {
        debugPrint("forgotpassword service call")
        
        if currentReachabilityStatus == .notReachable {
            self.showAlert(title: APPNAME, message: "No internet connection.!")
        } else {
            
            startLoading(msg: "Please wait...", _indicator: true)
            let forgot_PWD_URL = String(format: baseURL + "newpassword/?username="+emailText)
            
            AlamofireAPIWrapper.requestPOSTURL(forgot_PWD_URL, params: nil, headers: ["Content-type" : "application/json"], success:
                {
                    (JSONResponse) -> Void in
                    debugPrint("success JSONResponse : \(JSONResponse as Any)")
//                    let resultsDict = (JSONResponse.dictionary)
                    self.stopLoading()
    
            },failure: {
                (error) -> Void in
                self.stopLoading()

                
                
                debugPrint(error)
                debugPrint("failure")
            })
            
            //        self.showAlert(title: APPNAME, message: "Login Success")
        }
        
    }


    //MARK: TextFied Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


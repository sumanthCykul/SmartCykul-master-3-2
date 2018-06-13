//
//  LoginViewController.swift
//  SmartCykulApplication
//
//  Created by CYKUL on 17/02/18.
//  Copyright © 2018 Surendra. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SDWebImage
import SVProgressHUD
import Fabric
import Crashlytics
import Firebase

class LoginViewController: UIViewController,UITextFieldDelegate
{
    @IBOutlet weak var mobilenumberTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    var notificationDataSet:[String] = []
    
    var mobileNumber,password,customerID,stationName,login111:String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().enable = true
        mobilenumberTF.delegate = self
        mobilenumberTF.rightViewMode = UITextFieldViewMode.always
        let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image1 = UIImage(named: "m.png")
        imageView1.image = image1
    mobilenumberTF.rightView = imageView1
        mobilenumberTF.keyboardType = .numberPad
        passwordTF.delegate = self
        passwordTF.rightViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "key-7-150x150.png")
        imageView.image = image
        passwordTF.rightView = imageView
    }
    
    func validatePhone(_ phoneNumber: String) -> Bool
    {
        let phoneRegex: String = "^[7-9][0-9]{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
    
    @IBAction func loginbtn(_ sender: Any)
    {
        // let mobileNmbr = mobilenumberTF.text
        //let pwd = passwordTF.text
        
//                let defaults = UserDefaults.standard
//                let mobileNmbrStored = defaults.string(forKey: "MobileNumber")
//                let pwdStored = defaults.string(forKey: "Password")
//
        
        if mobilenumberTF.text == "" || passwordTF.text == ""
        {
            let alert = UIAlertController(title: "Smart Cykul", message:"Please fill the details", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action:
                UIAlertAction) -> Void in
            }))
            self.present(alert, animated: true, completion: nil)
        }
        if !validatePhone(mobilenumberTF.text!)
        {
            
            let error = UIAlertController(title: "Smart Cykul", message: "Enter registered mobile number", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            error.addAction(ok)
            present(error, animated: true,completion: nil)
            
        }
        
        self.json()
        
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier:"svc") as! slideViewController
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
        
        
        //        if(mobileNmbrStored == mobileNmbr && pwdStored == pwd)
        //        {
        //                //login is successfully
        //                let defaults = UserDefaults.standard
        //                defaults.set(true, forKey: "isUserLoggedIn")
        //                defaults.synchronize()
        //
        //                      do
        //                        {
        //                            self.json()
        //
        //                            let vc = self.storyboard?.instantiateViewController(withIdentifier:"svc") as! slideViewController
        //                            self.navigationController?.pushViewController(vc, animated: true)
        //                        }
        //
        //                        print("Valid credentials....")
        //
        //        }
        //        else if(mobileNmbrStored != mobileNmbr || pwdStored != pwd)
        //        {
        //
        //            let alert = UIAlertController(title: "Login Failed", message:"Invalid Credentials", preferredStyle: .alert)
        //            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action:
        //                UIAlertAction) -> Void in
        //            }))
        //            self.present(alert, animated: true, completion: nil)
        //        }
        
        
        
        //        if !validatePhone(mobilenumberTF.text!)
        //        {
        //
        //            let error = UIAlertController(title: "Ooops", message: "Enter the valid mobile number", preferredStyle: .alert)
        //            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        //            error.addAction(ok)
        //            present(error, animated: true,completion: nil)
        //
        //        }
        
        //      do
        //        {
        //            let vc = self.storyboard?.instantiateViewController(withIdentifier:"svc") as! slideViewController
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if (segue.identifier == "Forgot")
        {
            
            let vc = segue.destination as! ForgotPasswordViewController
            vc.mobileNumber = mobilenumberTF.text
            vc.password = passwordTF.text
        }
    }
    
    
    @IBAction func onTapInstructionBtn(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"Instruction") as! InstructionViewController
        self.navigationController?.pushViewController(vc, animated: true)
        //self.performSegue(withIdentifier: "Instruction", sender: nil)
    }
    
    
    @IBAction func onTapContactBtn(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"Contact") as! ContactViewController
        self.navigationController?.pushViewController(vc, animated: true)
        //self.performSegue(withIdentifier: "Contact", sender: nil)
    }
    
    func json()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
            SVProgressHUD.show(withStatus: "Loading...")
            let url = URL(string:"https://www.cykul.com/smartCykul/login.php")
            print("getrequest==>\(String(describing: url))")
            
             let deviceID = UIDevice.current.identifierForVendor!.uuidString
            let body: String = "flagValue=exists&mobileNumber=\(mobilenumberTF.text!)&password=\(passwordTF.text!)&deviceID=\(deviceID)"
            print("login==>==\(mobilenumberTF.text!)&\(passwordTF.text!)")
            let request = NSMutableURLRequest(url:url!)
            request.httpMethod = "POST"
            request.httpBody = body.data(using: String.Encoding.utf8)
            let session = URLSession(configuration:URLSessionConfiguration.default)
            
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil)
                {
                    print(error!)
                }
                else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse!)
                    if let data = data
                    {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:AnyObject]
                            print("yesResponse : ++++>>  ", json)
                            
                            let currentStatus = json["result"] as! String
                            
                            DispatchQueue.main.async()
                                {
                                    SVProgressHUD.dismiss()
                                    if currentStatus == "true"
                                    {
                                       // self.performSegue(withIdentifier: "Login", sender: nil)
                                        let currentCustomerID = json["customerID"] as! String
                                        print(":::::::::::::::::::::::::::")
                                       // print(CMId)
                                        let currentMobileNumber = json["mobileNumber"] as! String
                                        let currentStationName = json["station_name"] as! String

                                       // mbID = currentMobileNumber
                                        let defaults = UserDefaults.standard
                                        defaults.set(currentCustomerID, forKey: "customerIDDefaults")
                                        defaults.set(currentMobileNumber, forKey: "mobileNumberDefaults")
                                        defaults.synchronize()
                                        //defaults.set(currentStationName, forKey: "StationName")
                                       // defaults.set(CMId, forKey: "customerID")
                                        //defaults.synchronize()
                                       
                                        

                                       let vc = self.storyboard?.instantiateViewController(withIdentifier:"SWRevealViewController") as! SWRevealViewController
                                       // self.userdefaults()
                                        self.present(vc, animated: true, completion: nil)
                                      // self.navigationController?.present(vc, animated: true, completion: nil)
                                    }
                                    else
                                    {
                                        let alert = UIAlertController(title: "Smart Cykul", message:"Invalid Credentials", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                        
                                        print("current",currentStatus)
                                    }
                                    
                                    // self.tableView.reloadData()
                                    // SVProgressHUD.dismiss()
                                    
                                    
                            }
                            
                            
                        }
                        catch
                        {
                            print(error)
                            
                        }
                    }
                    
                }
            })
            dataTask.resume()
        }
        else
        {
            let alert = UIAlertController(title: "Smart Cykul", message:"Please check your network connection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            }))
            self.present(alert, animated: true, completion: nil)
            print("There is no internet connection")
        }
    }
    

    
    @IBAction func signupVc(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func NeedHelpContactUs(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Help") as! HelpViewController
        self.present(vc, animated: true, completion: nil)
        
    }
    @IBAction func Item(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        //self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
        
    }
    
}



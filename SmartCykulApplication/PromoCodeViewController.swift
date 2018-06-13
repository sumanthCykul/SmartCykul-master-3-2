//
//  PromoCodeViewController.swift
//  SmartCykul
//
//  Created by CYKUL on 30/01/18.
//  Copyright © 2018 Cykul Cykul. All rights reserved.
//

import UIKit
import SVProgressHUD
import Fabric
import Crashlytics
import Firebase

class PromoCodeViewController: UIViewController,UITextFieldDelegate
{
    
    @IBOutlet weak var bulletlble2: UILabel!
    @IBOutlet weak var bulletlble1: UILabel!
    @IBOutlet weak var availLbl: UILabel!
    @IBOutlet weak var scheme2: UILabel!
    @IBOutlet weak var scheme1: UILabel!
    var customerID,mobileNumber:String!
    @IBOutlet weak var barBtn: UIBarButtonItem!
    
    @IBOutlet weak var promoCodeTF: UITextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.promoCodeTF.autocapitalizationType = .allCharacters
        //promoCodeTF.keyboardType = .alphabet
        self.bulletlble1.isHidden = true
        self.bulletlble2.isHidden = true
        availLbl.isHidden = true
        self.promoCodeTF.delegate = self
        //promoCodeTF.keyboardType = UIKeyboardType.asciiCapable
        
        if revealViewController != nil
            
        {
            
            barBtn.target = revealViewController()
            
            barBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
            
        }
        
        let defaults = UserDefaults.standard
        customerID = defaults.string(forKey: "Customer_ID")
        mobileNumber = defaults.string(forKey: "ForgotMobile")
       

        // Do any additional setup after loading the view.
    }

    @IBAction func onTapApplyCodeBtn(_ sender: Any)
    {
        if promoCodeTF.text == ""
        {
            let alert = UIAlertController(title: "Smart Cykul", message:"Please Enter promocode", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
               
            }))
            self.present(alert, animated: true, completion: nil)
        }
        self.json()
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func json()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
            SVProgressHUD.show(withStatus: "Loading...")
            let url = URL(string:"https://www.cykul.com/smartCykul/applyPromoCode.php")
            let body: String = "customerID=\(CMId )&mobileNumber=\(mbID)&promoCode=\(promoCodeTF.text!)"
          //  print("pwd...\(mobile_Number!)&\(newPwdTF.text!)")
            
            let request = NSMutableURLRequest(url:url!)
            request.httpMethod = "POST"
            request.httpBody = body.data(using: String.Encoding.utf8)
            let session = URLSession(configuration:URLSessionConfiguration.default)
            
            let datatask = session.dataTask(with: request as URLRequest, completionHandler:
            {
                (data,response,error)-> Void in
                if (error != nil)
                    
                {
                    print(error!)
                }
                else
                {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse!)
                    if let data = data
                    {
                        do
                            
                        {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                            print(json)
                            
                            let currentResultStatus = json["result"] as! String
                            print("yesResponse : ++++>>  ",json)
                            
                            DispatchQueue.main.async()
                                {
                                    SVProgressHUD.dismiss()
                                    if currentResultStatus == "true"
                                    {
                                        //let ffm = json["ffm"] as! String
                                       // let rentalPer30min = json["rentalPer30min"] as! String
                                        //let message = json["message"] as! String
                                        let schemeOneMessage = json["schemeOneMessage"] as! String
                                        let schemeTwoMessage = json["schemeTwoMessage"] as! String
                                        self.availLbl.isHidden = false
                                        self.bulletlble1.isHidden = false
                                        self.bulletlble2.isHidden = false
//                                        let defaults = UserDefaults.standard
//                                        defaults.set(currentFirst30Mins, forKey: "SubFirst30Min")
//                                        defaults.set(currentEveryAdd30Mins, forKey: "SubAdditionl30Min")
//                                        defaults.set(currentEvery30Mins, forKey: "PayNGO30Min")
//                                        defaults.synchronize()
                                        
                                        
                                        self.scheme1.text =  schemeOneMessage
                                        self.scheme2.text =  schemeTwoMessage
                                    }
                                    else
                                    {
                                        let alert = UIAlertController(title: "Smart Cykul", message:"Invalid  Promo Code", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                    
                                    // self.tableView.reloadData()
                                    // SVProgressHUD.dismiss()
                                    
                                    
                            }
                        }
                        catch
                        {
                            print(error)
                        }
                        SVProgressHUD.dismiss()
                    }
                }
                
            })
            datatask.resume()
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
    
    
    
    @IBAction func promohomebtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "svc") as! SlideViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
//    func jsonCheck()
//    {
//        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
//        {
//            SVProgressHUD.show(withStatus: "Loading...")
//            let url = URL(string:"https://www.cykul.com/smartCykul/checkCykulPay.php")
//            let body: String = "customerID=\(CMId)&stationName=\(stationName!)"
//            //  print("pwd...\(mobile_Number!)&\(newPwdTF.text!)")
//
//            let request = NSMutableURLRequest(url:url!)
//            request.httpMethod = "POST"
//            request.httpBody = body.data(using: String.Encoding.utf8)
//            let session = URLSession(configuration:URLSessionConfiguration.default)
//
//            let datatask = session.dataTask(with: request as URLRequest, completionHandler:
//            {
//                (data,response,error)-> Void in
//                if (error != nil)
//                {
//                    print(error!)
//                }
//                else
//                {
//                    let httpResponse = response as? HTTPURLResponse
//                    print(httpResponse!)
//                    if let data = data
//                    {
//                        do
//                        {
//                            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
//
//                            print("&&&&&&&&&&&&& json Value nfsc number &&&&&&&&&&&&&&&")
//
//                            print(json)
//
//                            let currentResultStatus = json["result"] as! String
//                            var cycleValue = json["cykulpay"] as! Double
//                            //  let cycleVal = cycleValue as! String
//                            print("__________________")
//                            print(cycleValue)
//                            var subi = "\(cycleValue)"
//                            print(subi)
//                            //                            var s:String = String(format:"%f", (cycleValue as AnyObject).doubleValue) //formats the string to accept double/float
//                            //                            print("+++++++++++++++++++++++++++")
//                            //                            print(s)
//                            // print("yesResponse : ++++>>  ",json)
//
//                            DispatchQueue.main.async()
//                                {
//                                    SVProgressHUD.dismiss()
//
//
//                                    if currentResultStatus == "true"
//                                    {
//                                        print("!!!!!!!!!!!!!!************")
//                                        if cycleValue < 0
//                                        {
//                                            let alert = UIAlertController(title: "Attention", message:"please maintain minimum balance", preferredStyle: .alert)
//                                            self.Rs0Lbl.text = subi
//                                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
//                                            }))
//                                            self.present(alert, animated: true, completion: nil)
//                                        }
//                                        else
//                                        {
//                                            self.Rs0Lbl.text = subi
//                                        }
//                                    }
//
//                                    else
//                                    {
//                                        let alert = UIAlertController(title: "Attention", message:currentResultStatus, preferredStyle: .alert)
//                                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
//                                        }))
//                                        self.present(alert, animated: true, completion: nil)
//                                    }
//
//                                    // self.tableView.reloadData()
//                                    // SVProgressHUD.dismiss()
//
//
//                            }
//                        }
//                        catch
//                        {
//                            print(error)
//                        }
//                        SVProgressHUD.dismiss()
//                    }
//                }
//
//            })
//            datatask.resume()
//        }
//        else
//        {
//            let alert = UIAlertController(title: "Attention", message:"Please check your network connection", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
//            }))
//            self.present(alert, animated: true, completion: nil)
//            print("There is no internet connection")
//        }
//    }
    
}

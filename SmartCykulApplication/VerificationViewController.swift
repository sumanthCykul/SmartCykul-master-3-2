//
//  VerificationViewController.swift
//  SmartCykul
//
//  Created by CYKUL on 30/01/18.
//  Copyright © 2018 Cykul Cykul. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import Fabric
import Crashlytics
import Firebase

class VerificationViewController: UIViewController
{
    @IBOutlet weak var VerifyDocuments: UILabel!
    
    var customerID:String!
    
    @IBOutlet weak var barBtn: UIBarButtonItem!
    @IBOutlet weak var documentVerficationLbl: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        //        verificationStatus(body: "https://www.cykul.com/smartCykul/checkVerificationStatus.php", url: "customerID=\(CMId)")
        
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    //verificationStatus(body:"customerID=\(CMId)", url:  "https://www.cykul.com/smartCykul/checkVerificationStatus.php", vcIdentifier: "")
        verificationStatus(body: "customerID=\(CMId)", urlString: "https://www.cykul.com/smartCykul/checkVerificationStatus.php", vcIdentifier: "")
        
        if revealViewController != nil
            
        {
            
            barBtn.target = revealViewController()
            
            barBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            
            // self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
            
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    func verificationStatus(body:String,urlString: String,vcIdentifier: String)
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
            SVProgressHUD.show(withStatus: "Loading...")
            // "https://www.cykul.com/smartCykul/checkVerificationStatus.php"
            let url = URL(string:urlString)
            //  let body: String = "customerID=\(CMId)"
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
                            let myjson = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                            
                            print("++++++++++++++++++++++++++++")
                            print(myjson)
                            var currentStatus = myjson["result"] as! String
                            //
                            DispatchQueue.main.async()
                                {
                                    
                                    if currentStatus == "true"
                                    {
                                        self.documentVerficationLbl.text = "Documents Verified Successfully"
                                        
                                        let alert = UIAlertController(title: "Smart Cykul", message:"Documents Verified Successfully", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in

                                        }))

                                        self.present(alert, animated: true, completion: nil)
                                        
                                        
                                        //                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "svc") as! SlideViewController
                                        //                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                    else
                                    {
                                        self.documentVerficationLbl.text = "Document Verification"
                                        
                                        var s = String()
                                        if urlString == "https://www.cykul.com/smartCykul/checkDocumentStatus.php"
                                        {
                                        if vcIdentifier != ""
                                        {
                                            let vc = self.storyboard?.instantiateViewController(withIdentifier: vcIdentifier)
                                            self.navigationController?.pushViewController(vc!, animated: true)
                                        }
                                        else
                                        {
                                            var myMessage = myjson["message"] as! String
                                            
                                            let alert = UIAlertController(title: "Smart Cykul", message:myMessage, preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "Ok", style: .default,  handler: {(_ action: UIAlertAction) -> Void in

                                            }))

                                            self.present(alert, animated: true, completion: nil)

                                            }}
                                        else
                                        {
                                            var myMessage = myjson["message"] as! String
                                            
                                            let alert = UIAlertController(title: "Smart Cykul", message:myMessage, preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "Ok", style: .default,  handler: {(_ action: UIAlertAction) -> Void in
                                                
                                            }))
                                            
                                            self.present(alert, animated: true, completion: nil)
                                            
                                        }
                                        
                                        
                                    }
                                    
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
    
    
    @IBAction func onTapCheckVerificationBtn(_ sender: Any)
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
            SVProgressHUD.show(withStatus: "Loading...")
            
            let url = URL(string:"https://www.cykul.com/smartCykul/checkDocumentStatus.php")
            let body: String = "customerID=\(CMId)"
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
                            let myjson = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                            print(myjson)
                            let message = myjson["message"] as! String
                            
                            DispatchQueue.main.async()
                                {
                                    let alertController = UIAlertController(title: "SmartCykul", message: message, preferredStyle: .alert)
                                    
                                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                        
                                        // Code in this block will trigger when OK button tapped.
                                        print("Ok button tapped");
                                        
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier:"SWRevealViewController") as! SWRevealViewController
                                        self.navigationController?.present(vc, animated: true, completion: nil)
                                        
                                    }
                                    
                                    alertController.addAction(OKAction)
                                    
                                    self.present(alertController, animated: true, completion:nil)
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
    
    @IBAction func verificationHomebtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "svc") as! SlideViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func GovernmentIDProofBtn(_ sender: Any)
    {
        //        checkDocumentStatus.php
        //        params.put("customerID",customerID);
        
        verificationStatus(body: "customerID=\(CMId)", urlString: "https://www.cykul.com/smartCykul/checkDocumentStatus.php", vcIdentifier: "GovernmentViewController")
        
        
    }
    
    @IBAction func uploadRecentBTN(_ sender: Any)
    {
        verificationStatus(body: "customerID=\(CMId)", urlString: "https://www.cykul.com/smartCykul/checkDocumentStatus.php", vcIdentifier: "RecentPhotoViewController")
       
    }
    
    
}

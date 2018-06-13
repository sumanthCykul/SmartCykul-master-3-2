//
//  AnotherRiderViewController.swift
//  SmartCykulApplication
//
//  Created by MAC BOOK on 14/05/18.
//  Copyright © 2018 Surendra. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import Firebase


class AnotherRiderViewController: UIViewController,UITextViewDelegate
{

    @IBOutlet weak var textviewRider: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.json()
       
    }


    func json()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
            SVProgressHUD.show(withStatus: "Loading...")
            let url = URL(string:"https://www.cykul.com/smartCykul/finalCheck.php")
            print("getrequest==>\(String(describing: url))")
            print(mybatteryLevel)
            let deviceID = UIDevice.current.identifierForVendor!.uuidString
            let body: String = "lockName=\(kk)&customerID=\(CMId)"
            //  print("login==>==\(mobilenumberTF.text!)&\(passwordTF.text!)")
            let request = NSMutableURLRequest(url:url!)
            request.httpMethod = "POST"
            request.httpBody = body.data(using: String.Encoding.utf8)
            let session = URLSession(configuration:URLSessionConfiguration.default)
            
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
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
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:AnyObject]
                            print(json)
                            print("yesResponse : ++++>>  ", json)
                            
                            
                            let currentStatus = json["result"] as! String
                            
                            DispatchQueue.main.async()
                                {
                                    SVProgressHUD.dismiss()
                                    if currentStatus == "true"
                                    {
                                        //self.createUnlockCommand(responseFound: self.result)
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UnlockViewController") as! UnlockViewController
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                    else
                                    {
                                        let message = json["message"] as! String
                                          self.textviewRider.text =  message
                                        self.textviewRider.font = UIFont(name: (self.textviewRider.font?.fontName)!, size: 35)
                                        self.textviewRider.textAlignment = .center
                                        print("@@@@@@@@@@@@@@@@@@**************")
                                        print(self.textviewRider.text)
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
    
}

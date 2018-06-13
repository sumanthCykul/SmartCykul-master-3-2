//
//  StarReviewViewController.swift
//  
//
//  Created by MAC BOOK on 08/05/18.
//

import UIKit
import IQKeyboardManagerSwift
import SDWebImage
import SVProgressHUD
import Fabric
import Crashlytics
import Firebase


class StarReviewViewController: UIViewController {

  @IBOutlet weak var stars: FiveStarRatingFile!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

       
    }

    @IBAction func submitActn(_ sender: Any)
    {
        print(stars.starsRating)
        json()
    }
    
    
    func json()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
            SVProgressHUD.show(withStatus: "Loading...")
            let url = URL(string:"https://www.cykul.com/smartCykul/rating.php")
            print("getrequest==>\(String(describing: url))")
            let deviceID = UIDevice.current.identifierForVendor!.uuidString
            let body: String = "customerID=\(CMId)&rating=\(stars.starsRating)"
           // print("login==>==\(mobilenumberTF.text!)&\(passwordTF.text!)")
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
                                        
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReturnIssueViewController") as! ReturnIssueViewController
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                    else
                                    {
                                        let alert = UIAlertController(title: "Smart Cykul", message:"Please Go Back and try again", preferredStyle: .alert)
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
}


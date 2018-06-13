//
//  ReturnIssueViewController.swift
//  SmartCykulApplication
//
//  Created by MAC BOOK on 01/05/18.
//  Copyright © 2018 Surendra. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import SVProgressHUD
import CoreLocation
import Fabric
import Crashlytics
import Firebase

class ReturnIssueViewController: UIViewController {
    
    @IBOutlet weak var issueslbls: UILabel!
    
    @IBOutlet weak var LockSelectedLbl: UILabel!
    
    @IBOutlet weak var TimeLBL: UILabel!
    
    @IBOutlet weak var LocationplaceLbl: UILabel!
    
    
    @IBOutlet weak var Farelbl: UILabel!
    
    
    @IBOutlet weak var farelblrupees: UILabel!
    
    var mobileNumber,stationName,customerID,lockName,address,latitude,longitude,batteryLevel: String!
    
    var returnCycle:String!
    
    var latToServer : String = ""
    
    var lonToServer : String = ""
    
    var addressToServer : String = ""
    
    var myNumber = 0
    
    var stationNamee = "CYKUL"
    
    var addressVariable = 0
    
    var addresToServer : String = ""
    
    
   
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad()
    {
        //json()
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
       
        if CLLocationManager.locationServicesEnabled() {
            
            print("delegate called")
            locationManager.delegate = self as! CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        }
        
        
    }

    
    func json()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
            SVProgressHUD.show(withStatus: "Loading...")
            let url = URL(string:"https://www.cykul.com/smartCykul/riderOperation.php")
            print("getrequest==>\(String(describing: url))")
            
            let deviceID = UIDevice.current.identifierForVendor!.uuidString
            let body: String = "mobileNumber=\(mbID)&stationName=\(stationNamee)&customerID=\(CMId)&latitude=\(latToServer)&longitude=\(lonToServer)&address=\(addressToServer)&lockName=\(kk)&batteryLevel=\(batteryLevel)&operation=return"
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
                else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse!)
                    if let data = data
                    {
                        do
                        {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:AnyObject]
                            print(json)
                            print("yesResponse : ++++>>  ", json)
                            
                            
                            
                            
                            
                            
                            let currentStatus = json["result"] as! String
                            let date = json["date"] as! String
                            let balance = json["charge"]! 
                            // let message = json["message"] as! String
                            
                            DispatchQueue.main.async()
                                {
                                    SVProgressHUD.dismiss()
                                    if currentStatus == "true"
                                    {
                                        self.TimeLBL.text = json["date"] as! String
                                        let date = json["date"] as! String
                                        self.TimeLBL.text = date
                                        self.LocationplaceLbl.text = self.addressToServer
                                        self.LockSelectedLbl.text = kk
                                        self.farelblrupees.text = "₹" + " \(balance)"
                                
                                        // self.IssueLbl.text = kk
                                        print("$$$$$$$$$$$$$$$****************")
                                        print(self.addresToServer)
                                        
                                        
                                        //                                        let currentFirst30Mins = json["subFirst30mins"] as! String
                                        //                                        let currentEveryAdd30Mins = json["subAdditional30mins"] as! String
                                        //                                        let currentEvery30Mins = json["payNGo30mins"] as! String
                                        //
                                        //
                                        //                                        self.first30MinValueLbl.text =  currentFirst30Mins
                                        //                                        self.additional30minsValueLbl.text = "₹" + currentEveryAdd30Mins
                                        //                                        self.every30MinValueLbl.text = "₹" + currentEvery30Mins
                                        
                                        //                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "svc" ) as! SlideViewController
                                        //                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                    else
                                    {
                                        let alert = UIAlertController(title: "Smart Cykul", message:"your cycle has an issue", preferredStyle: .alert)
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

extension ReturnIssueViewController : CLLocationManagerDelegate
{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if addressVariable == 0 {
            
            
            if let location = locations.first {
                //print(location.coordinate)
                print(location.coordinate.longitude)
                print(location.coordinate.latitude)
                let newLat = location.coordinate.latitude
                let newLon = location.coordinate.longitude
                
                latToServer = String(newLat)
                lonToServer = String(newLon)
                
                let cityCoords = CLLocation(latitude: newLat, longitude: newLon)
                getAdressName(coords: cityCoords)
                //  cityData(coord: cityCoords)
                
                addressVariable += 1
            }}
    }
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    // Show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "To get your current location",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getAdressName(coords: CLLocation) {
        
        
        CLGeocoder().reverseGeocodeLocation(coords) { (placemark, error) in
            if error != nil {
                
                print("Hay un error")
                
            } else {
                
                let place = placemark! as [CLPlacemark]
                
                if place.count > 0 {
                    let place = placemark![0]
                    
                    var adressString : String = ""
                    
                    if place.thoroughfare != nil {
                        adressString = adressString + place.thoroughfare! + ", "
                    }
                    if place.subThoroughfare != nil {
                        adressString = adressString + place.subThoroughfare! + "\n"
                    }
                    if place.locality != nil {
                        adressString = adressString + place.locality! + " - "
                    }
                    if place.postalCode != nil {
                        adressString = adressString + place.postalCode! + "\n"
                    }
                    if place.subAdministrativeArea != nil {
                        adressString = adressString + place.subAdministrativeArea! + " - "
                    }
                    if place.country != nil {
                        adressString = adressString + place.country!
                    }
                    print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
                    print(placemark?.first?.locality)
                    
                    //print(adressString)
                    
                    self.addressToServer = adressString
                    self.json()
                    // self.lblPlace.text = adressString
                }
                
            }
        }
    }
    
    
    
}


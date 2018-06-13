//
//  IssueSucessfullyViewController.swift
//  SmartCykulApplication
//
//  Created by MAC BOOK on 28/04/18.
//  Copyright © 2018 Surendra. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
import AVKit
import SVProgressHUD



class IssueSucessfullyViewController: UIViewController
{
    
    @IBOutlet weak var Menubtn: UIBarButtonItem!
    
    @IBOutlet weak var issueCyclinglbl: UILabel!
    
    @IBOutlet weak var IssueLbl: UILabel!
    
    @IBOutlet weak var PickUpDetailsLbl: UILabel!
    
    @IBOutlet weak var LockSelectedLbl: UILabel!
    
    @IBOutlet weak var PickupTimeLbl: UILabel!
    
    @IBOutlet weak var LocationLbl: UILabel!
    
    @IBAction func Homebtn(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    var mobileNumber,stationName,customerID,lockName,address,latitude,longitude,batteryLevel: String!
    
    var latToServer : String = ""
    
    var lonToServer : String = ""
    
    var addressToServer : String = ""
    
    var myNumber = 0
    
    var stationNamee = "CYKUL"
    
    var addressVariable = 0
    
    var addresToServer : String = ""
    
    var unlock:String!
    
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("!!!!!!!!!!!!!!!!!!!!!!+++++++++++++++++++++")
        print(latToServer)
        print(lonToServer)
        print(addressToServer)
        print("@@@@@@@@@@@@@@@@@@@@@************************")
        
        if (revealViewController() != nil)
        {
            Menubtn.target = revealViewController()
            
            Menubtn.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            
        }

        
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
    @IBAction func hoembtn(_ sender: Any) {
       // let vc = self.storyboard?.instantiateViewController(withIdentifier: "svc") as! SlideViewController
       // self.navigationController?.pushViewController(vc, animated: true)
        performSegue(withIdentifier: "Home", sender: self)
        print("Home Screen!!!!!!!!!!!!!!!!!!")
    }
    
    func json()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
            SVProgressHUD.show(withStatus: "Loading...")
            let url = URL(string:"https://www.cykul.com/smartCykul/riderOperation.php")
            print("getrequest==>\(String(describing: url))")
            
            //let deviceID = UIDevice.current.identifierForVendor!.uuidString
            let body: String = "mobileNumber=\(mbID)&stationName=\(stationNamee)&customerID=\(CMId)&latitude=\(latToServer)&longitude=\(lonToServer)&address=\(addressToServer)&lockName=\(kk)&batteryLevel=\(batteryLevel)&operation=unlock"
            //  print("login==>==\(mobilenumberTF.text!)&\(passwordTF.text!)")
          //  print("\(latToServer),\(lonToServer),\(addressToServer)")
            print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
            print(latToServer)
            print(lonToServer)
            print(addressToServer)
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
                            // let message = json["message"] as! String
                            
                            DispatchQueue.main.async()
                                {
                                    SVProgressHUD.dismiss()
                                    if currentStatus == "true"
                                    {
                                        self.PickupTimeLbl.text = json["date"] as! String
                                        let date = json["date"] as! String
                                        self.PickupTimeLbl.text = date
                                        self.LocationLbl.text = self.addressToServer
                                        self.LockSelectedLbl.text = kk
                                        self.issueCyclinglbl.text = kk
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
    
    
    
    
    @IBAction func Back(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}



extension IssueSucessfullyViewController : CLLocationManagerDelegate
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
                                                message: "To get your current loation",
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
                    print(self.addressToServer)
                    self.json()
                    // self.lblPlace.text = adressString
                }
                
            }
        }
    }
    
    
    
}



//
//  slidetableViewController.swift
//  SmartCykulApplication
//
//  Created by Surendra on 03/02/18.
//  Copyright © 2018 Surendra. All rights reserved.
//

import UIKit

class slidetableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var slidetable: UITableView!
    @IBOutlet weak var barButton: UIBarButtonItem!
    
    
    let labels = ["Subscription","My Balance","Rental Charges","My Activities","My Transactions","Verification","Promo Code","Report An Issue","Logout","How it works","Contact us","Feedback"]
    
    let images = ["sub.png","money.png","rental.png","activities.png","transaction.png","verification.png","promocode.png","information.png","logout.png","info.png","contact.png","feedback.png"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return labels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell
       // cell.customView.layer.cornerRadius = cell.customView.frame.height/2
        cell.customLabel.text = labels[indexPath.row]
        cell.customImgView.image = UIImage(named: images[indexPath.row])
        //cell.customimages.layer.cornerRadius = cell.customimages.frame.height/2
        
        return cell

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //performSegue(withIdentifier: "Subscription", sender: nil)
        if indexPath.row == 0
        {
            performSegue(withIdentifier: "Subscription", sender: nil)
        }
        if indexPath.row == 1
        {
            performSegue(withIdentifier: "Balance", sender: nil)
        }
        if indexPath.row == 2
        {
            performSegue(withIdentifier: "Rental", sender: nil)
        }
        if indexPath.row == 3
        {
            performSegue(withIdentifier: "Activity", sender: nil)
        }
        if indexPath.row == 4
        {
            performSegue(withIdentifier: "Transaction", sender: nil)
        }
        if indexPath.row == 5
        {
            performSegue(withIdentifier: "Verification", sender: nil)
        }
        if indexPath.row == 6
        {
            performSegue(withIdentifier: "Promo", sender: nil)
        }
        if indexPath.row == 7
        {
           performSegue(withIdentifier: "Report", sender: nil)
         
        }
        if indexPath.row == 8
        {
            let alertController = UIAlertController(title: "Smart Cykul", message: "Are you sure you want to Log Out?", preferredStyle: .alert)
            
            // Create OK button
            let OKAction = UIAlertAction(title: "NO", style: .default) { (action:UIAlertAction!) in
                
                // Code in this block will trigger when OK button tapped.
                print("Ok button tapped");
                
            }
            alertController.addAction(OKAction)
            
            // Create Cancel button
            let cancelAction = UIAlertAction(title: "YES", style: .cancel) { (action:UIAlertAction!) in
                print("Cancel button tapped");
                
                let defaults = UserDefaults.standard
                defaults.set(true, forKey: "customerID")
                let objAppDelegate = (UIApplication.shared.delegate as? AppDelegate)
                objAppDelegate?.getLgoinViewController()
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                //defaults.removeObject(forKey: "Mobile_Number")
                //defaults.removeObject(forKey: "Password")
                defaults.synchronize()
                
            }
            alertController.addAction(cancelAction)
            
            // Present Dialog message
             self.present(alertController, animated: true, completion:nil)
        }
        if indexPath.row == 9
        {
         
             performSegue(withIdentifier: "Instruction", sender: nil)
           
        }
        if indexPath.row == 10
        {
              performSegue(withIdentifier: "Contact", sender: nil)
           
        }
        if indexPath.row == 11
        {
           
            performSegue(withIdentifier: "Feed", sender: nil)
          
        }
        
        if indexPath.row == 12
        {
           // if (revealViewController != nil)
                
          //  {
//
//                barButton.target = revealViewController()
//
//                barButton.action = #selector(SWRevealViewController.revealToggle(_:))
//
//                self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
                
         //   }
            
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//            self.navigationController?.pushViewController(vc, animated: true)
//
        }
        
    }
    
     func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat
    {
        
        return 60
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
}

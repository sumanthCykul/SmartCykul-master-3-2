//
//  ContactViewController.swift
//  SmartCykul
//
//  Created by CYKUL on 03/02/18.
//  Copyright © 2018 Cykul Cykul. All rights reserved.
//

import UIKit
import MessageUI
import Fabric
import Crashlytics
import Firebase


class ContactViewController: UIViewController,UIWebViewDelegate,MFMailComposeViewControllerDelegate
{

    var webview: UIWebView!
    
    @IBOutlet weak var barBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController != nil
        {
            
            barBtn.target = revealViewController()
            
            barBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
            }
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var onTapWebBtn: UIButton!
    
    @IBAction func onTapWebsiteBtn(_ sender: Any)
    {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier:"internet") as! InternetViewController
//
//        self.navigationController?.present(vc, animated: true, completion:
//            {
//               vc.webview.delegate = self
//                let myURL = URL(string: "http://www.cykul.com")
//                let myURLRequest:URLRequest = URLRequest(url: myURL!)
//                vc.webview.loadRequest(myURLRequest)
//
//        })
    }
    
    @IBAction func onTapMailBtn(_ sender: Any)
    {
        let mailComposerViewController = configureMailController()
        if MFMailComposeViewController.canSendMail()
        {
            self.present(mailComposerViewController, animated: true, completion: nil)
        }
        else
        {
            mailError()
        }
    }
    
    func configureMailController() -> MFMailComposeViewController
    {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["info@cykul.com"])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: false)
        return mailComposerVC
        
    }
    
    func mailError()
    {
        let sendMailErrorAlert = UIAlertController(title: "Smart Cykul", message: "your device could not send mail", preferredStyle:.alert)
        let dismiss = UIAlertAction(title: "OK", style:.default, handler:nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapPhoneBtn(_ sender: Any)
    {
//        if let phoneCallURL:URL = URL(string: "tel:\(+91-9100053754)") as! NSURL as URL
//        {
//            let application:UIApplication = UIApplication.shared
//            if (application.canOpenURL(phoneCallURL))
//            {
//                application.openURL(phoneCallURL)
////                let alertController = UIAlertController(title: "Smart Cykul", message: "Are you sure you want to call \n\(9100053754)?", preferredStyle: .alert)
////                let yesPressed = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
////                    application.openURL(phoneCallURL)
////                })
////                let noPressed = UIAlertAction(title: "No", style: .default, handler: { (action) in
////
////                })
////                alertController.addAction(yesPressed)
////                alertController.addAction(noPressed)
////                present(alertController, animated: true, completion: nil)
//            }
//        }
        let url: NSURL = URL(string: "TEL://+91-9100053754") as! NSURL
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func onTapWtspBtn(_ sender: Any)
    {
        let urlWhats = "https://api.whatsapp.com/send?phone=+91-9100053754"
        
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        {
            if let whatsappURL = NSURL(string: urlString)
            {
                if UIApplication.shared.canOpenURL(whatsappURL as URL)
                {
                    UIApplication.shared.openURL(whatsappURL as URL)
                }
                else
                {
                    let error = UIAlertController(title: "Smart Cykul", message: "Please install the wtsapp", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    error.addAction(ok)
                    present(error, animated: true,completion: nil)
                }
            }
        }
    }
    
    @IBAction func onTapFBBtn(_ sender: Any)
    {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier:"internet") as! InternetViewController
//
//
//        self.navigationController?.present(vc, animated: true, completion:
//            {
//                vc.webview.delegate = self
//                let myURL = URL(string: "https://www.facebook.com/cykul/")
//                let myURLRequest:URLRequest = URLRequest(url: myURL!)
//                vc.webview.loadRequest(myURLRequest)
//
//        })
    }
   

    @IBAction func contacthome(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "svc") as! SlideViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

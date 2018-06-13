//
//  HelpFacebookIViewController.swift
//  SmartCykulApplication
//
//  Created by MAC BOOK on 12/05/18.
//  Copyright © 2018 Surendra. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Firebase

class HelpFacebookIViewController: UIViewController,UIWebViewDelegate
{
    @IBOutlet weak var webbbbb: UIWebView!
    
    @IBOutlet weak var accccccc: UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        webbbbb.delegate = self
        let myURL = URL(string: "https://www.facebook.com/cykul/")
        let myURLRequest:URLRequest = URLRequest(url: myURL!)
        webbbbb.loadRequest(myURLRequest)

        // Do any additional setup after loading the view.
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        accccccc.startAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        accccccc.isHidden = true
        accccccc.stopAnimating()
    }

}

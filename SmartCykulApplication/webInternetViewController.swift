//
//  webInternetViewController.swift
//  
//
//  Created by MAC BOOK on 12/05/18.
//

import UIKit
import Fabric
import Crashlytics
import Firebase


class webInternetViewController: UIViewController,UIWebViewDelegate
{
    @IBOutlet weak var web: UIWebView!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        web.delegate = self
        let myURL = URL(string: "http://www.cykul.com")
        let myURLRequest:URLRequest = URLRequest(url: myURL!)
        web.loadRequest(myURLRequest)
        
    }

    func webViewDidStartLoad(_ webView: UIWebView)
    {
        activity.startAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        activity.isHidden = true
        activity.stopAnimating()
    }

}

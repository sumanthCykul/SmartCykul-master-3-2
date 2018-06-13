//
//  AppDelegate.swift
//  SmartCykulApplication
//
//  Created by  Cykul Cykul on 02/02/18.
//  Copyright © 2018  Cykul Cykul. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import SDWebImage
import SVProgressHUD
import CoreBluetooth
import CoreLocation
import Fabric
import Crashlytics
import Firebase
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
import FirebasePerformance

var verCount = 0
var verficationLabelText = ""


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    var window: UIWindow?
    let core = CLLocationManager()
   // let trace = Performance.startTrace(name: "test trace")
  //  let  token = Messaging.messaging().fcmTokenfcmToken
  //  var token = FIRInstanceID.instanceID().token()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        print("added a commit")
       Fabric.with([Crashlytics.self()])
        GMSServices.provideAPIKey("AIzaSyDXzZYfo_tE7odxY2eG2quc1BB8vrcnn-Q")
        let defauts = UserDefaults.standard
        let str = defauts.string(forKey: "customerIDDefaults")
         print("sumanht github code")
        if str == nil
        {

            let viewController = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "lvc") as! LoginViewController
            self.window?.rootViewController = viewController
        }
        else
        {
            let viewController1 =  self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            self.window?.rootViewController = viewController1

        }
        
        
      
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
       print("fabric framework")
        Fabric.sharedSDK().debug == true
        IQKeyboardManager.sharedManager().enable = true
        core.requestWhenInUseAuthorization()
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {(success,error) in
                if error == nil
                {
                    print("authorization ")
                }
            })
        }
        else
        {
            // Fallback on earlier versions
        }
        application.registerForRemoteNotifications()
        NotificationCenter.default.addObserver(self,selector: #selector(self.refreshToken(notification:)),name:NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
        //trace?.incrementMetric("retry", by: 1)
        //trace?.stop()
        self.firebasejson()
        // Override point for customization after application launch.
        return true
    }

    
    func firebasejson()
    {
        let url = URL(string: "https://www.google.com")
        
        guard let metric = HTTPMetric(url: url!, httpMethod: .get) else { return }
        
        metric.start()
        
        guard let kurl = URL(string: "https://www.google.com") else { return }
        let request: URLRequest = URLRequest(url:kurl)
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { (urlData, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                metric.responseCode = httpResponse.statusCode
            }
            metric.stop()
        }
        dataTask.resume()
    }
//
//    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
//        if motion == .motionShake {
//            print("Device shaken")
//        }
//    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func getLgoinViewController()
    {
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let objController = mainStoryboard.instantiateViewController(withIdentifier: "lvc") as? LoginViewController
        let navController = UINavigationController.init()
        let arrayControllers = [objController]
        navController.viewControllers  = arrayControllers as! [UIViewController]
        navController.navigationBar.isHidden = false
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
    
    func getmapviewController()
    {
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let objController = mainStoryboard.instantiateViewController(withIdentifier: "svc") as? SlideViewController
        let navController = UINavigationController.init()
        let arrayControllers = [objController]
        navController.viewControllers  = arrayControllers as! [UIViewController]
        navController.navigationBar.isHidden = false
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
    
    func getVerificationViewController()
    {
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let objController = mainStoryboard.instantiateViewController(withIdentifier: "VerificationViewController") as? VerificationViewController
        let navController = UINavigationController.init()
        let arrayControllers = [objController]
        navController.viewControllers  = arrayControllers as! [UIViewController]
        navController.navigationBar.isHidden = false
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
    
    @objc func refreshToken(notification: NSNotification)
    {
        let refreshToken = InstanceID.instanceID().token()
        print(refreshToken)
        fbHandler()
    }
    
    func fbHandler()
    {
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        if let token = InstanceID.instanceID().token()
        {
            print("\n\n\n\n\n\n\n\n\n\n ====== TOKEN DCS: " + token)
    }
        
        func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String)
        {
            
            print("\n\n\n\n\n ==== FCM Token:  ",fcmToken)
         //   HelperFunction.helper.storeInUserDefaultForKey(name: kFCMToken, val: fcmToken)
            fbHandler()
        }
}
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        Messaging.messaging().subscribe(toTopic: "smartcykul")
        print("subscribed to all topic in didReceiveRegistrationToken")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        Messaging.messaging().subscribe(toTopic: "smartcykul")
        print("subscribed to all topic in notificationSettings")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        print("userInfo -- \(userInfo)")
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print("user info in didReceive response -- \(userInfo)")
        
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("called to foreground app")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Messaging.messaging().subscribe(toTopic: "smartcykul")
        print("subscribed to all topic in didRegisterForRemoteNotificationsWithDeviceToken")
    }
}
//extension UIWindow {
//    open override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
//        if motion == .motionShake {
//            print("Device shaken")
//        }
//    }
//}

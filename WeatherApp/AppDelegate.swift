//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Boris Yue on 3/7/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

let notificationKey = "com.borisyue.WeatherApp"
let notificationKey2 = "com.borisyue.WeatherApp2"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    fileprivate let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestLocation()
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latitude = locations.first!.coordinate.latitude
        let longitude = locations.first!.coordinate.longitude
        Alamofire.request("https://api.darksky.net/forecast/e56988338de8a3b73446d52d27afc322/\(latitude),\(longitude)?exclude=hourly,alerts,flags").responseJSON {
            response in
            if let data = response.result.value {
                let geoCoder = CLGeocoder() //get city
                geoCoder.reverseGeocodeLocation(locations.first!) { (placemarks, error) -> Void in
                    if error != nil {
                        print("Error getting location: \(error)")
                    } else {
                        let placeArray = placemarks as [CLPlacemark]!
                        var placeMark: CLPlacemark!
                        placeMark = placeArray?[0]
                        ViewController.city = placeMark.addressDictionary?["City"]! as! String!
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationKey), object: self, userInfo: data as? [AnyHashable: Any])
                    }
                }
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

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

}

extension AppDelegate: CLLocationManagerDelegate {
    
}


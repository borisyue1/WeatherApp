//
//  ViewController.swift
//  WeatherApp
//
//  Created by Boris Yue on 3/7/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: notificationKey), object: nil, queue: nil, using: displayData)
    }
    
    func displayData(notification: Notification) {
        if let data = notification.userInfo as! [String: AnyObject]? {
            if let currentData = data["currently"] {
                displayTemperature(fromData: currentData)
            }
        }
    }
    
    func displayTemperature(fromData: AnyObject) {
        let temperature = fromData["temperature"] as! Double
        let roundedTemp = Int(round(temperature))
        let label = UILabel(frame: CGRect(x: view.frame.width / 2 - 50, y: view.frame.height / 3, width: 100, height: 50))
        label.text = "\(roundedTemp) degrees"
        view.addSubview(label)
    }

}


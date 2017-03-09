//
//  ViewController.swift
//  WeatherApp
//
//  Created by Boris Yue on 3/7/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var temperatureLabel: UILabel!
    var summaryLabel: UILabel!
    var rainLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: notificationKey), object: nil, queue: nil, using: displayData)
    }
    
    func displayData(notification: Notification) {
        if let data = notification.userInfo as! [String: AnyObject]? {
            if let temperatureData = data["currently"] {
                displayTemperature(fromData: temperatureData)
            }
            if let minuteData = data["minutely"] {
                displaySummary(fromData: minuteData)
                displayRainInfo(fromData: minuteData)
            }
        }
    }
    
    func displayTemperature(fromData: AnyObject) {
        let temperature = fromData["temperature"] as! Double
        let roundedTemp = Int(round(temperature))
        temperatureLabel = UILabel(frame: CGRect(x: view.frame.width / 2 - 50, y: view.frame.height / 3, width: 100, height: 30))
        temperatureLabel.text = "\(roundedTemp) degrees"
        view.addSubview(temperatureLabel)
    }
    
    func displaySummary(fromData: AnyObject) {
        let summary = fromData["summary"] as! String
        summaryLabel = UILabel(frame: CGRect(x: 0, y: temperatureLabel.frame.maxY + 10, width: 50, height: 30))
        summaryLabel.text = summary
        summaryLabel.sizeToFit()
        summaryLabel.frame.origin.x = view.frame.width / 2 - summaryLabel.frame.width / 2
        view.addSubview(summaryLabel)
    }
    
    func displayRainInfo(fromData: AnyObject) {
        rainLabel = UILabel(frame: CGRect(x: 0, y: summaryLabel.frame.maxY + 10, width: 50, height: 30))
        let icon = fromData["icon"] as! String
        if icon != "rain" {
            rainLabel.text = "It will not rain within the hour."
        } else {
            var minutes = 0
            for minuteInfo in (fromData["data"] as! [AnyObject]) { //need to convert to [AnyObject] to iterate
                let rainProbability = minuteInfo["precipProbability"] as! Int
                if rainProbability > 0 {
                    rainLabel.text = "There is a \(rainProbability * 100)% change that it will rain in \(minutes) minutes."
                    break
                }
                minutes += 1
            }
        }
        rainLabel.sizeToFit()
        rainLabel.frame.origin.x = view.frame.width / 2 - rainLabel.frame.width / 2
        view.addSubview(rainLabel)
    }

}


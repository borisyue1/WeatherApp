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
    var circleBlurView: UIView!
    
    var rainGif = [#imageLiteral(resourceName: "rain-1"), #imageLiteral(resourceName: "rain-2"), #imageLiteral(resourceName: "rain-3"), #imageLiteral(resourceName: "rain-4"), #imageLiteral(resourceName: "rain-5")]
    var sunGif = [#imageLiteral(resourceName: "sunny-1"), #imageLiteral(resourceName: "sunny-2"), #imageLiteral(resourceName: "sunny-3"), #imageLiteral(resourceName: "sunny-4"), #imageLiteral(resourceName: "sunny-5")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: notificationKey), object: nil, queue: nil, using: displayData)
    }
    
    func displayData(notification: Notification) {
        displayCircleBlur()
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
    
    func displayCircleBlur() {
        circleBlurView = UIView(frame: CGRect(x: view.frame.width / 2 - 110, y: view.frame.width / 4, width: 220, height: 220))
        circleBlurView.layer.cornerRadius = circleBlurView.frame.width / 2
        circleBlurView.clipsToBounds = true
        circleBlurView.backgroundColor = UIColor.init(white: 1, alpha: 0.25)
        circleBlurView.layer.borderWidth = 0.1
        view.addSubview(circleBlurView)
    }
    
    func displayTemperature(fromData: AnyObject) {
        let temperature = fromData["temperature"] as! Double
        let roundedTemp = Int(round(temperature))
        temperatureLabel = UILabel(frame: CGRect(x: 0, y: view.frame.height / 4.75, width: 100, height: 30))
        temperatureLabel.text = "\(roundedTemp)\u{00B0}"
        temperatureLabel.font = UIFont.systemFont(ofSize: 65)
        temperatureLabel.sizeToFit()
        temperatureLabel.frame.origin.x = view.frame.width / 2 - temperatureLabel.frame.width / 2 + 5
        temperatureLabel.textColor = UIColor.white
        view.addSubview(temperatureLabel)
    }
    
    func displaySummary(fromData: AnyObject) {
        let summary = fromData["summary"] as! String
        summaryLabel = UILabel(frame: CGRect(x: 0, y: temperatureLabel.frame.maxY + 5, width: 50, height: 30))
        summaryLabel.text = summary
        summaryLabel.font = UIFont.systemFont(ofSize: 15)
        summaryLabel.sizeToFit()
        summaryLabel.frame.origin.x = view.frame.width / 2 - summaryLabel.frame.width / 2
        summaryLabel.textColor = UIColor.white
        view.addSubview(summaryLabel)
    }
    
    func displayRainInfo(fromData: AnyObject) {
        rainLabel = UILabel(frame: CGRect(x: 0, y: summaryLabel.frame.maxY + 10, width: 50, height: 30))
        let icon = fromData["icon"] as! String
        if icon != "rain" {
            displaySunGif()
        } else {
            displayRainGif()
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
        rainLabel.textColor = UIColor.white
        view.addSubview(rainLabel)
    }
    
    func displaySunGif() {
        let sunView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        sunView.animationImages = sunGif
        sunView.animationDuration = 1.2
        sunView.startAnimating()
        sunView.layer.zPosition = -5
        view.addSubview(sunView)
    }
    
    func displayRainGif() {
        let rainView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        rainView.animationImages = rainGif
        rainView.animationDuration = 1
        rainView.layer.zPosition = -5
        rainView.startAnimating()
        view.addSubview(rainView)
    }

}


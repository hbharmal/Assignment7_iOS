//
//  WeatherDataSession.swift
//  iWeather
//
//  Created by Hussain Bharmal on 11/5/18.
//  Copyright © 2018 Hussain Bharmal. All rights reserved.
//

import UIKit
import Foundation

protocol WeatherDataProtocol {
    func responseDataHandler(data: NSDictionary)
    func responseError(message: String)
}

class WeatherDataSession {
    private let urlSession = URLSession.shared
    private let urlPathBase = "https://api.worldweatheronline.com/premium/v1/weather.ashx?key=71f187bbe97b495988c165458182610&format=json"
    
    private var dataTask:URLSessionDataTask? = nil
    
    var delegate: WeatherDataProtocol? = nil
    
    init() {}
    
    func getData(city: String, state: String) {
        
        var urlPath = self.urlPathBase
        urlPath = urlPath + "&q=" + city.lowercased() + "," + state.lowercased()
        
        let url: NSURL? = NSURL(string: urlPath)
        
        let dataTask = self.urlSession.dataTask(with: url! as URL) { (data, response, error) -> Void in
            if error != nil {
                self.delegate?.responseError(message: "Current conditions not found")
            } else {
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    if jsonResult != nil {
                        if let data = jsonResult!["data"] as? NSDictionary {
                            if let currentConditions = data["current_condition"] as? NSArray {
                                if let currentConditionsDict = currentConditions[0] as? NSDictionary {
                                    print(currentConditionsDict)
                                    self.delegate?.responseDataHandler(data: currentConditionsDict)
                                }
                            } else {
                                self.delegate?.responseError(message: "Current conditions not found")
                            }
                        }
                    }
                } catch {
                    self.delegate?.responseError(message: "Conditions not found")
                }
            }
        }
        dataTask.resume()
    }
    
}

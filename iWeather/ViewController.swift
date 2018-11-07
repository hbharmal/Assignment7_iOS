//
//  ViewController.swift
//  iWeather
//
//  Created by Hussain Bharmal on 11/2/18.
//  Copyright © 2018 Hussain Bharmal. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WeatherDataProtocol {
    
    var dataSession = WeatherDataSession()

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    
    @IBAction func onCheckConditions(_ sender: Any) {
        // reset all the outlets
        weatherImageView.image = nil
        temperatureLabel.text = ""
        cloudCoverLabel.text = ""
        humidityLabel.text = ""
        pressureLabel.text = ""
        precipitationLabel.text = ""
        windLabel.text = ""
        conditionsNotFoundLabel.text = ""
        let city = cityTextField.text!
        let state = stateTextField.text!
        let cleanedCity = city.replacingOccurrences(of: " ", with: "+")
        let cleanedState = state.replacingOccurrences(of: " ", with: "+")
        self.dataSession.getData(city: cleanedCity, state: cleanedState)
    }
    
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cloudCoverLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    
    @IBOutlet weak var conditionsNotFoundLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSession.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func responseDataHandler(data: NSDictionary) {
        let tempC = data["temp_C"] as! String
        let tempF = data["temp_F"] as! String
        let humidity = data["humidity"] as! String
        let cloudCover = data["cloudcover"] as! String
        let pressure = data["pressure"] as! String
        let precipitation = data["precipMM"] as! String
        let windDirection = data["winddir16Point"] as! String
        let windDirectionDegrees = data["winddirDegree"] as! String
        let windSpeedKmph = data["windspeedKmph"] as! String
        let windSpeedMiles = data["windspeedMiles"] as! String
        let image_arr = data["weatherIconUrl"] as! NSArray
        let image_dict = image_arr[0] as! NSDictionary
        let image_value = image_dict["value"] as! String
        
        DispatchQueue.main.async {
            self.temperatureLabel.text = "\(tempC)°C/\(tempF)°F"
            self.cloudCoverLabel.text = "Cloud Cover: \(cloudCover)%"
            self.humidityLabel.text = "Humidity: \(humidity)%"
            self.pressureLabel.text = "Pressure: \(pressure)mbar"
            self.precipitationLabel.text = "Precipitation: \(precipitation)mm"
            self.windLabel.text = "\(windSpeedKmph)kmph/\(windSpeedMiles) \(windDirection) (\(windDirectionDegrees))"
            
            let url = URL(string: image_value)
            let data = try? Data(contentsOf: url!)
            if let imageData = data {
                self.weatherImageView.image = UIImage(data: imageData)
            }
        }
       
    }
    
    func responseError(message: String) {
        print("triggered")
        DispatchQueue.main.async {
            self.conditionsNotFoundLabel.text = message
        }
    }

}


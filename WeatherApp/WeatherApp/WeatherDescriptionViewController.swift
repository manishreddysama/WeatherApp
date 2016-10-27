//
//  WeatherDescriptionViewController.swift
//  WeatherApp
//
//  Created by Manish Sama on 10/26/16.
//  Copyright © 2016 manish. All rights reserved.
//

import UIKit

class WeatherDescriptionViewController: UIViewController {
    
    @IBOutlet weak var citySunSet: UILabel!
    @IBOutlet weak var citySunRise: UILabel!
    @IBOutlet weak var cityWeatherDescription: UILabel!
    @IBOutlet weak var cityHumidityLevel: UILabel!
    @IBOutlet weak var cityTemperature: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityWindSpeed: UILabel!
    var selectedCity : City?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let userSelectdCity = selectedCity {
            cityName.text = userSelectdCity.cityName
            cityTemperature.text = userSelectdCity.cityWeather
            cityHumidityLevel.text = userSelectdCity.cityHumidity
            cityWindSpeed.text = userSelectdCity.cityWindSpeed
            cityWeatherDescription.text = userSelectdCity.cityWeatherType
            citySunRise.text = userSelectdCity.citySunrise
            citySunSet.text = userSelectdCity.citySunset
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePresentedVC(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }

}

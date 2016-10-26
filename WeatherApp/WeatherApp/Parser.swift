//
//  Parser.swift
//  WeatherApp
//
//  Created by Manish Sama on 10/21/16.
//  Copyright © 2016 manish. All rights reserved.
//

import Foundation
    
func getWeatherForPlaceAfterParsing(city: City,responseObject : Any) -> City {
    
    let responseDict = responseObject as! NSDictionary
    
    if(responseDict["name"] as? String == city.cityName) {
        
        let weatherData = responseDict["main"] as! NSDictionary
        var temperature = weatherData["temp"] as! Double
        temperature -= 273.15
        city.cityWeather = String(format:"%.2f",temperature)
        let weatherType = responseDict["weather"] as! NSArray
        let weatherDescriptionType = weatherType.firstObject as! NSDictionary
        city.cityWeatherType = weatherDescriptionType["description"] as? String
        
    }
    
    return city
    
}




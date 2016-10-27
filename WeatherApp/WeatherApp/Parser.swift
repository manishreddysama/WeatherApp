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
        
        //humidity
        let humidity = weatherData["humidity"] as! Double
        city.cityHumidity = "\(humidity) %"
        
        //pressure
        let pressure = weatherData["pressure"] as! Double
        city.cityPressure = "\(pressure) hpa"
        
        let wind = responseDict["wind"] as? NSDictionary
        if let windDetails = wind  {
            let windSpeed = windDetails["speed"] as? Double
            if let windSpeedDetail = windSpeed {
                city.cityWindSpeed = "\(windSpeedDetail) m/s"
            }
        }
        
        let sunRiseSetDetails = responseDict["sys"] as? NSDictionary
        if let sunRiseSet = sunRiseSetDetails {
            let sunRise = sunRiseSet["sunrise"] as? Double
            if let sunRiseDetails = sunRise {
                let date = NSDate(timeIntervalSince1970: sunRiseDetails)
                city.citySunrise = "\(date)"
            }
            
            let sunSet = sunRiseSet["sunset"] as? Double
            if let sunSetDetails = sunSet {
                let date = NSDate(timeIntervalSince1970: sunSetDetails)
                city.citySunset = "\(date)"
            }
        }
        
        
        
        
        
    }
    
    return city
    
}




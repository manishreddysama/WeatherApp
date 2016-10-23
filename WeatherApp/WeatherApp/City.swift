//
//  City.swift
//  WeatherApp
//
//  Created by Manish Sama on 10/22/16.
//  Copyright © 2016 manish. All rights reserved.
//

import UIKit

class City: NSObject, NSCoding {
    
    var cityName : String?
    var cityState : String?
    var cityCountry : String?
    var cityWeather : String?
    var cityWeatherType : String?

    
    // Memberwise initializer
    init(cityName: String, cityState: String, cityCountry: String) {
        self.cityName = cityName
        self.cityState = cityState
        self.cityCountry = cityCountry
    }
    
    // MARK: NSCoding
    
        required convenience init?(coder decoder: NSCoder) {
            guard let cityName = decoder.decodeObject(forKey: "cityName") as? String,
            let cityState = decoder.decodeObject(forKey: "cityState") as? String,
            let cityCountry = decoder.decodeObject(forKey: "cityCountry") as? String
            else { return nil }
        
        self.init(
            cityName: cityName,
            cityState: cityState,
            cityCountry: cityCountry
        )
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.cityName, forKey: "cityName")
        aCoder.encode(self.cityState, forKey: "cityState")
        aCoder.encode(self.cityCountry, forKey: "cityCountry")
    }
}

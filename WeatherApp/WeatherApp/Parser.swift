//
//  Parser.swift
//  WeatherApp
//
//  Created by Manish Sama on 10/21/16.
//  Copyright © 2016 manish. All rights reserved.
//

import Foundation

func getWeatherForPlace(city : City) -> NSDictionary {
    
    let networkManager = NetworkManager.sharedManager
    let response = NSDictionary()
    
    networkManager.getWeatherForPlace(city: city) { (responseObject) in
        
        
    }
    
    return response
}

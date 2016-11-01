//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Manish Sama on 10/21/16.
//  Copyright © 2016 manish. All rights reserved.
//

import UIKit

typealias completion = (_ success: Bool,_ responseObject : Any) -> ()


class NetworkManager: NSObject {
    
    static let apiServiceURL = "http://api.openweathermap.org/data/2.5/weather?APPID=50580f60b0913f7ebf75043acece5405&q="
    
    class var sharedManager:NetworkManager {
        
        struct Singleton {
            static let sharedManager =  NetworkManager()
        }
        return Singleton.sharedManager
    }
    
    func getWeatherForPlace(city: City, responseObject: @escaping completion){
        
        if Reachability.isConnectedToNetwork() == true {
    
            let cityName = city.cityName! + "," + city.cityCountry!
            let urlString = NetworkManager.apiServiceURL + cityName
            print(urlString)
            let urlStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            guard let url = URL(string: urlStr!) else {
                return
            }
            let urlRequest = URLRequest(url: url)
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
        
            let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print("Error")
                return
            }
            
            guard let responseData = data else {
                print("Error")
                return
            }
            
            do {
                guard let responseJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")
                    return
                }
                print(responseJSON)
                responseObject(true,responseJSON)
                
                } catch  {
                    print("error trying to convert data to JSON")
                    return
                }
            }
        
            task.resume()
            
        }
        else {
            let error = ["error":"Yes","title":"No Internet Connection","message":"Make sure your device is connected to the internet"]
            responseObject(false,error)
        }
    
    }

}

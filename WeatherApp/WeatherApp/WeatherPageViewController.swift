//
//  WeatherPageViewController.swift
//  WeatherApp
//
//  Created by Manish Sama on 10/19/16.
//  Copyright © 2016 manish. All rights reserved.
//

import UIKit
import MapKit

class WeatherPageViewController: UIViewController {

    @IBOutlet weak var placeWeatherTableView: UITableView!
    var userSearchedPlaces = NSMutableArray()
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var showSearchVCButton: UIButton!
    var locationManager = CLLocationManager()
    var currentLocationIsFound = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Weather App
        self.locationManager.requestWhenInUseAuthorization()
        let currentLocationCity = City.init(cityName: "Dallas", cityState: "Texas", cityCountry: "US")
        
        let currentLocationCityTwo = City.init(cityName: "Austin", cityState: "Texas", cityCountry: "US")
        
        self.navigationController?.navigationBar.isHidden = true
        self.userSearchedPlaces.add(currentLocationCity)
        self.userSearchedPlaces.add(currentLocationCityTwo)
        self.userSearchedPlaces.addObjects(from: self.retrieveSavedPlaces())
        self.getUserLocationAndPopulate()
        self.customizeTableView()
        self.customizeShowResultsButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showSearchVC(_ sender: AnyObject) {
        
        let searchresultsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlaceSearchViewController") as! PlaceSearchViewController
        searchresultsVC.delegate = self
        self.navigationController!.present(searchresultsVC, animated: true, completion: nil)
    }
    
    func customizeTableView() {
        self.placeWeatherTableView.register(UINib.init(nibName: "PlaceWeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "placeWeatherCell")
        self.placeWeatherTableView.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0)
        self.placeWeatherTableView.separatorColor = UIColor.black
        let tableViewHeight = self.userSearchedPlaces.count * 80
        self.tableViewHeightConstraint.constant = CGFloat(Double(tableViewHeight))

    }
    
    func customizeShowResultsButton() {
        self.showSearchVCButton.layer.cornerRadius = self.showSearchVCButton.frame.size.width / 2
        self.showSearchVCButton.layer.borderColor = UIColor.white.cgColor
        self.showSearchVCButton.layer.borderWidth = 1.0
    }
    
    func getUserLocationAndPopulate() {
        
        if CLLocationManager.locationServicesEnabled() {

            self.locationManager.delegate = self
            self.locationManager.distanceFilter = kCLDistanceFilterNone
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func saveSearchedPlaces(city : City) {
        
        var places = [City]()
        places = retrieveSavedPlaces()
        places.append(city)
        NSKeyedArchiver.archiveRootObject(places, toFile: getFilePathToSavePlaces().absoluteString)
        let data = NSKeyedArchiver.archivedData(withRootObject: places)
        UserDefaults.standard.setValue(data, forKey: "savedPlaces")
        
    }
    
    func retrieveSavedPlaces() -> [City] {
        
        var savedPlaces = [City]()
        if let data = UserDefaults.standard.value(forKey: "savedPlaces") {
            savedPlaces = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! [City]
        
        }
        return savedPlaces
    }
    
    func getFilePathToSavePlaces() -> URL {
        
         let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
         let archiveURL = documentsDirectory.appendingPathComponent("savedPlaces")
        return archiveURL
    }
}

extension WeatherPageViewController : UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.userSearchedPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeWeatherCell") as! PlaceWeatherTableViewCell
        let city : City = userSearchedPlaces[indexPath.row] as! City
        
        if let name = city.cityName, let state = city.cityState, let country = city.cityCountry {
            cell.cityName.text = name
            cell.cityAddressDescription.text = state + " , " + country
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension WeatherPageViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.last != nil && !self.currentLocationIsFound {
            self.getPlaceMarkForLocation(location: locations.last!)
        }
        
    }
    
    func getPlaceMarkForLocation(location : CLLocation)  {

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error == nil && !self.currentLocationIsFound{
                if placemarks!.count > 0 {
                    
                    let placeMark = placemarks?.first
                    if let name = placeMark?.locality, let state = placeMark?.administrativeArea, let country = placeMark?.isoCountryCode {
                        let city = City.init(cityName: name, cityState: state, cityCountry: country)
                        city.cityName = name
                        city.cityState = state
                        city.cityCountry = country
                        self.currentLocationIsFound = true
                        self.userSearchedPlaces.insert(city, at: 0)
                        self.customizeTableView()
                        self.placeWeatherTableView.reloadData()
                    }
                }
            }
        }
    }
}

extension WeatherPageViewController : PlaceSelectedProtocol {
    
    func placeSelected(place: City) {
        
        self.saveSearchedPlaces(city: place)
        self.userSearchedPlaces.add(place)
        self.customizeTableView()
        self.placeWeatherTableView.reloadData()
    }
}

extension String {
    func stringByAppendingPathComponent(pathComponent: String) -> String {
        return (self as NSString).appendingPathComponent(pathComponent)
    }
}


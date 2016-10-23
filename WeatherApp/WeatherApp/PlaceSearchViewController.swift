//
//  PlaceSearchViewController.swift
//  WeatherApp
//
//  Created by Manish Sama on 10/20/16.
//  Copyright © 2016 manish. All rights reserved.
//

import UIKit
import MapKit

protocol PlaceSelectedProtocol {
    
    func placeSelected(place:City)
}

class PlaceSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var placeSearchResultsTableView: UITableView!
    var searchResults = [MKMapItem]()
    let mapView = MKMapView()
        var delegate : PlaceSelectedProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = false
        self.searchBar.sizeToFit()
        self.searchBar.placeholder = "Enter a city name or zipcode"
        self.definesPresentationContext = true
        
        let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(0.0, 0.0), MKCoordinateSpanMake(180, 360))
        self.mapView.setRegion(region, animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dismissVC(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }

    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }

}

extension PlaceSearchViewController : UITableViewDelegate,UITableViewDataSource {
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeSearchCell")! as UITableViewCell
        let searchResult = self.searchResults[indexPath.row]
        cell.textLabel?.text = searchResult.name
        cell.detailTextLabel?.text = self.parseAddress(selectedItem: searchResult.placemark)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let searchResult = self.searchResults[indexPath.row].placemark
        if let name = searchResult.locality, let state = searchResult.administrativeArea, let country = searchResult.isoCountryCode {
            let city = City.init(cityName: name, cityState: state, cityCountry: country)
            self.delegate?.placeSelected(place: city)
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }

}

extension PlaceSearchViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let searchBarText = self.searchBar.text else {
            return
        }
        let searchRequest = MKLocalSearchRequest()
        searchRequest.region = self.mapView.region
        searchRequest.naturalLanguageQuery = searchBarText
        let localSearch = MKLocalSearch(request: searchRequest)
        localSearch.start { (response, error) in
            guard let response = response else {
                return
            }
            self.searchResults = response.mapItems
            self.placeSearchResultsTableView.reloadData()
        }

    }
    
}

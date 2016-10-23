//
//  PlaceSearchTableViewController.swift
//  WeatherApp
//
//  Created by Manish Sama on 10/20/16.
//  Copyright © 2016 manish. All rights reserved.
//

import UIKit
import MapKit

class PlaceSearchTableViewController: UITableViewController {
    
    var searchResults = [MKMapItem]()
    var searchResultsController : UISearchController? = nil
    let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResultsController = UISearchController(searchResultsController: self)
        self.searchResultsController?.searchResultsUpdater = self
        
        let searchBar = self.searchResultsController!.searchBar
        searchBar.showsCancelButton = false
        searchBar.sizeToFit()
        searchBar.placeholder = "Enter a city name or zipcode"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.titleView = searchBar
        self.setUpRightBarButtonItem()
        self.searchResultsController!.hidesNavigationBarDuringPresentation = false
        self.searchResultsController!.dimsBackgroundDuringPresentation = true
        self.definesPresentationContext = true
        
        let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(0.0, 0.0), MKCoordinateSpanMake(180, 360))
        self.mapView.setRegion(region, animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func setUpRightBarButtonItem() {
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
        self.navigationItem.rightBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blue
    }
    
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension PlaceSearchTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell")! as UITableViewCell
        let searchResult = self.searchResults[indexPath.row]
        cell.textLabel?.text = searchResult.name
        cell.detailTextLabel?.text = self.parseAddress(selectedItem: searchResult.placemark)
        return cell
    }
    
}

extension PlaceSearchTableViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchBarText = self.searchResultsController?.searchBar.text else {
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
            self.tableView.reloadData()            
        }
        
    }
}

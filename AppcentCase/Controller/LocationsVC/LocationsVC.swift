//
//  LocationsVC.swift
//  AppcentCase
//
//  Created by Eren Üstünel on 12.12.2020.
//

import UIKit
import Alamofire
import CoreLocation

class LocationsVC: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var locations: Locations = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserLocation()
    }
    

    private func getUserLocation() {
        self.locationManager.requestAlwaysAuthorization()

        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    func getLocations(lat: Double?, lang: Double?) {
        let url = "https://www.metaweather.com/api/location/search/"
        let lat = "\(lat ?? 0.0),\(lang ?? 0.0)"
        let parameters: [String: String] = ["lattlong": lat]
        AF.request(url, parameters: parameters).validate()
            .responseDecodable(of: Locations.self) { response in
                self.locations = response.value ?? []
                self.tableView.reloadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        getLocations(lat: locValue.latitude, lang: locValue.longitude)
    }

}


extension LocationsVC: UITableViewDataSource {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationsCell", for: indexPath)
        cell.textLabel?.text = self.locations[indexPath.row].title
        return cell
    }
}

extension LocationsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "locationDetail") as! LocationDetailVC
        vc.id = self.locations[indexPath.row].woeid
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

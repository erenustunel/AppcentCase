//
//  LocationDetailVC.swift
//  AppcentCase
//
//  Created by Eren Üstünel on 12.12.2020.
//

import UIKit
import Alamofire

class LocationDetailVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    var id: Int?
    var country: CountryModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLocationDetail(id: String(id ?? 0))
    }
    
    func getLocationDetail(id: String?) {
        let url = "https://www.metaweather.com/api/location/\(id ?? "")"
        AF.request(url).validate()
            .responseDecodable(of: CountryModel.self) { response in
                print(response)
                self.country = response.value
                self.title = self.country?.title
                self.tableView.reloadData()
        }
    }

}

extension LocationDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.country?.consolidatedWeather?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! CountryTableViewCell
        cell.dateLabel.text = self.country?.consolidatedWeather?[indexPath.row].applicableDate
        cell.stateLabel.text = self.country?.consolidatedWeather?[indexPath.row].weatherStateName
        let minTemp = Int(self.country?.consolidatedWeather?[indexPath.row].minTemp ?? 0.0)
        let maxTemp = Int(self.country?.consolidatedWeather?[indexPath.row].maxTemp ?? 0.0)
        cell.tempLabel.text = "Min Temp: \(minTemp) - Max Temp\(maxTemp)"
        return cell
    }
    
    
}

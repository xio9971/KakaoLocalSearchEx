//
//  ViewController.swift
//  KakaoLocalSearchEx
//
//  Created by 민트팟 on 2021/06/30.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var plcaeTableView: UITableView!
    
    
    var placeInfoArray = [PlaceInfo]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgSelectLocation" {
            if let cell = sender as? UITableViewCell, let indexPath = plcaeTableView.indexPath(for: cell) {
                if let vc = segue.destination as? SelectLocationViewController {
                    vc.selectPlaceInfo = placeInfoArray[indexPath.row]
                }
            }
        }
    }
    
    
    @IBAction func didSearch(_ sender: UIButton) {
        
        guard let keyword = searchText.text else {
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization" : "KakaoAK 8acea6445ca27d1c7d988ed38850d701"
        ]
        
        let param: [String: Any] = [
            "query" : keyword
        ]
        
        
        AF.request("https://dapi.kakao.com/v2/local/search/keyword.json", method: .get,
             parameters: param, headers: headers)
            .responseJSON(completionHandler: { [self] response in
                 switch response.result {
                 case .success(let value):
                             
                    //print(JSON(value))
                    placeInfoArray.removeAll()
                    
                      if let detailsPlace = JSON(value)["documents"].array{
                        print(detailsPlace)
                          for item in detailsPlace {
                            let addressName = item["address_name"].string ?? ""
                            let placeName = item["place_name"].string ?? ""
                            let roadAdressName = item["road_address_name"].string ?? ""
                            let longitudeX = Double(item["x"].string ?? "") ?? 0.0
                            let latitudeY = Double(item["y"].string ?? "") ?? 0.0
                            
                            self.placeInfoArray.append(PlaceInfo(addressName: addressName, placeName: placeName, roadAdressName: roadAdressName, longitudeX: longitudeX, latitudeY: latitudeY))
                           }
                                
                        }
                    
                    plcaeTableView.reloadData()

                   case .failure(let error):
                       print(error)
                   }
               })
        
        
    
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placeInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell", for: indexPath) as? PlaceTableViewCell else {
            return UITableViewCell()
        }
        
        cell.placeName.text = self.placeInfoArray[indexPath.row].placeName
        cell.addressName.text = self.placeInfoArray[indexPath.row].addressName
        cell.roadAddressName.text = self.placeInfoArray[indexPath.row].roadAdressName
        return cell
    }
    
}


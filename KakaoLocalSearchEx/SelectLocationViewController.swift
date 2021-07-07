//
//  SelectLocationViewController.swift
//  KakaoLocalSearchEx
//
//  Created by 민트팟 on 2021/07/02.
//

import UIKit
import Then
import SnapKit
import Alamofire
import SwiftyJSON

class SelectLocationViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet var locationSaveBtn: UIButton!
    
    @IBOutlet var vStackView: UIStackView!
    
    @IBOutlet var addressLabel: UILabel!
    
    
    var selectPlaceInfo: PlaceInfo?
    
    let mapView = MTMapView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressLabel.text = selectPlaceInfo?.addressName


        mapView.setMapCenter(.init(geoCoord: .init(latitude: selectPlaceInfo!.latitudeY, longitude: selectPlaceInfo!.longitudeX)), zoomLevel: 9, animated: true)
        mainView.addSubview(mapView)
        
        
        mapView.delegate = self
        mapView.baseMapType = .standard
        mapView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        let po1 = MTMapPOIItem().then{
            $0.markerType = .redPin
            $0.mapPoint = .init(geoCoord: .init(latitude: selectPlaceInfo!.latitudeY, longitude: selectPlaceInfo!.longitudeX))
            $0.showAnimationType = .noAnimation
            $0.tag = 1
            $0.customImageName = "map_pin"
            $0.draggable = true
        }


        mapView.addPOIItems([po1])
        mapView.fitAreaToShowAllPOIItems()
    }
        
    // location 정보를 통해 주소 갖고오기
    func getAddressApi(location: MTMapPoint!) {
        
        let headers: HTTPHeaders = [
            "Authorization" : "KakaoAK 8acea6445ca27d1c7d988ed38850d701"
        ]
        
        let param: [String: Any] = [
            "x" :location.mapPointGeo().longitude ,
            "y" :location.mapPointGeo().latitude
        ]
        
        AF.request("https://dapi.kakao.com/v2/local/geo/coord2address.json", method: .get,
             parameters: param, headers: headers)
            .responseJSON(completionHandler: { [self] response in
                
                switch response.result {
                 case .success(let value):
                    print(JSON(value))
                    if let detailsPlace = JSON(value)["documents"].array{
                        
                        for item in detailsPlace {
                                                        
                            if let address = item["address"].dictionary {
                                addressLabel.text = address["address_name"]?.string ?? ""
                                
                                selectPlaceInfo?.addressName = address["address_name"]?.string ?? ""
                                selectPlaceInfo?.longitudeX = location.mapPointGeo().longitude
                                selectPlaceInfo?.latitudeY = location.mapPointGeo().latitude
                            }
                            
                            if let roadAddress = item["road_address"].dictionary {
                                selectPlaceInfo?.roadAdressName = roadAddress["address_name"]?.string ?? ""
                            }
                        }
                    }

                   case .failure(let error):
                       print(error)
                   }
               })
    }
    
    @IBAction func updateTrackingMode(_ sender: Any) {
        // onWithHeading : 트래킹모드on, 나침반모드 on
        // .off : 트래킹모드off, 나침반모드 off
        mapView.currentLocationTrackingMode = .onWithHeading
    }
    
    @IBAction func saveLocationAC(_ sender: Any) {
        
        guard let plceInfo = selectPlaceInfo else {
            return
        }
        
        DataManager.shared.fetchLocation(plceInfo.addressName)
        
        if DataManager.shared.LocationList.count > 0 {
            AlertUtil.showSimpleAlert(view: self, title: "위치저장", desc: "이미 동일한 주소로 저장된 위치가 있습니다, 선택한 위도경도로 변경하시겠습니까?", buttonText: "확인", handler: { action in self.delInsLocation()}, cancelButtonText: "취소", cancelHandler: nil)
        }else {
            DataManager.shared.addNewLocation(selectPlaceInfo!)
        }
    }

    
    func delInsLocation() {
        DataManager.shared.deleteLocation(DataManager.shared.LocationList[0])
        DataManager.shared.addNewLocation(selectPlaceInfo!)
    }
}

    
extension SelectLocationViewController: MTMapViewDelegate {
    
    // 사용자 현위치 트래킹 기능이 켜진 경우(MTMapCurrentLocationTrackingOnWithoutHeading, MTMapCurrentLocationTrackingOnWithHeading)
    // 단말의 위치에 해당하는 지도 좌표와 위치 정확도가 주기적으로 delegate 객체에 통보된다.
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        
        let currentLocationPointGeo = location.mapPointGeo
        print(currentLocationPointGeo().latitude)
        print(currentLocationPointGeo().longitude)
        
        mapView.showCurrentLocationMarker = false
        mapView.currentLocationTrackingMode = .off
        
        mapView.removeAllPOIItems()
        
        let po1 = MTMapPOIItem().then{
            $0.markerType = .redPin
            $0.mapPoint = .init(geoCoord: .init(latitude: currentLocationPointGeo().latitude, longitude: currentLocationPointGeo().longitude))
            $0.showAnimationType = .noAnimation
            $0.tag = 1
            $0.customImageName = "map_pin"
            $0.draggable = true
        }

        mapView.addPOIItems([po1])
        mapView.fitAreaToShowAllPOIItems()
        
        getAddressApi(location: location)
    }
    
    // draggablePOIItem delegate
    func mapView(_ mapView: MTMapView!, draggablePOIItem poiItem: MTMapPOIItem!, movedToNewMapPoint newMapPoint: MTMapPoint!) {
        print(newMapPoint.mapPointGeo().longitude)
        getAddressApi(location: newMapPoint)
    }
}



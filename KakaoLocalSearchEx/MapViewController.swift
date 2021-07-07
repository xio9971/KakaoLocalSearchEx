//
//  MapViewController.swift
//  KakaoLocalSearchEx
//
//  Created by 민트팟 on 2021/07/06.
//

import UIKit
import SnapKit
import Then

class MapViewController: UIViewController {

    let mapView = MTMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(mapView)
        
        mapView.delegate = self
        mapView.baseMapType = .standard
        mapView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        saveLocationLoad()
    }
    
    /**
     저장된 위치정보 마커, 선 그리기
     */
    func saveLocationLoad() {
        
        DataManager.shared.fetchLocation()
        print(DataManager.shared.MapLocationList)

        if DataManager.shared.MapLocationList.count > 0 {

            var locationArray = [MTMapPOIItem]()
            //var polyLine = [MTMapPolyline]()
            let polyLine = MTMapPolyline.polyLine()
            polyLine?.tag = 2000;
            polyLine?.polylineColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.8)
            
            for idx in 0..<DataManager.shared.MapLocationList.count {
                
                let item = DataManager.shared.MapLocationList[idx]
                
                let po1 = MTMapPOIItem().then{
                    $0.markerType = .redPin
                    $0.mapPoint = .init(geoCoord: .init(latitude: item.latitude, longitude: item.longitude))
                    $0.showAnimationType = .noAnimation
                    $0.tag = idx + 1
                    $0.customImageName = "map_pin"
                    $0.draggable = false
                }
                
                
                polyLine?.add(MTMapPoint(geoCoord: MTMapPointGeo(latitude: item.latitude, longitude: item.longitude)))
                
                locationArray.append(po1)
                print(item.longitude)
                print(item.latitude)
            }

            mapView.addPolyline(polyLine)
            mapView.addPOIItems(locationArray)
            //mapView.fitAreaToShowAllPOIItems()
            mapView.fitAreaToShowAllPolylines()
        }
    }

}

extension MapViewController: MTMapViewDelegate {

}

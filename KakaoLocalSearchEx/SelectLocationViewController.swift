//
//  SelectLocationViewController.swift
//  KakaoLocalSearchEx
//
//  Created by 민트팟 on 2021/07/02.
//

import UIKit
import Then
import SnapKit

class SelectLocationViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet var locationSaveBtn: UIButton!
    
    var selectPlaceInfo: PlaceInfo?
    
    let mapView = MTMapView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationSaveBtn.layer.borderWidth = 1.0
        
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
    
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        
        let currentLocationPointGeo = location.mapPointGeo
        print(currentLocationPointGeo().latitude)
        print(currentLocationPointGeo().longitude)
    }
    
    @IBAction func updateTrackingMode(_ sender: Any) {
        // onWithHeading : 트래킹모드on, 나침반모드 on
        // .off : 트래킹모드off, 나침반모드 off
        //mapView.showsLargeContentViewer = mapView.currentLocationTrackingMode.rawValue == 0 ? true : false
        mapView.currentLocationTrackingMode = mapView.currentLocationTrackingMode.rawValue == 0 ? .onWithHeading : .off
    }
    
    @IBAction func saveLocation(_ sender: Any) {
        
        if let po = mapView.poiItems[0] as? MTMapPOIItem {
            print(po.mapPoint.mapPointGeo().latitude)
            print(po.mapPoint.mapPointGeo().longitude)
        }
        
//        print(mapView.poiItems[0] as? MTMapPOIItem)
    }
    

}

    
extension SelectLocationViewController: MTMapViewDelegate {
    
}



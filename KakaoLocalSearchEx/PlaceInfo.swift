//
//  PlaceInfo.swift
//  KakaoLocalSearchEx
//
//  Created by 민트팟 on 2021/06/30.
//

import Foundation

struct PlaceInfo: Decodable {
    
    let addressName: String
    let placeName: String
    let roadAdressName: String
    let longitudeX: Double
    let latitudeY: Double
}

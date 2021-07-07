//
//  PlaceInfo.swift
//  KakaoLocalSearchEx
//
//  Created by 민트팟 on 2021/06/30.
//

import Foundation

struct PlaceInfo: Decodable {
    
    var addressName: String
    var placeName: String
    var roadAdressName: String
    var longitudeX: Double
    var latitudeY: Double

}


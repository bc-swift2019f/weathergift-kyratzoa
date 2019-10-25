//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by Anastasia on 10/25/19.
//  Copyright © 2019 Anastasia Kyratzoglou. All rights reserved.
//

import Foundation


class WeatherLocation: Codable{
    var name: String
    var coordinates:String
    
    init(name: String, coordinates: String) {
        self.name = name
        self.coordinates = coordinates
    }
}

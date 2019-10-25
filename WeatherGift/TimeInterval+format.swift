//
//  TimeInterval+format.swift
//  WeatherGift
//
//  Created by Anastasia on 10/24/19.
//  Copyright © 2019 Anastasia Kyratzoglou. All rights reserved.
//

import Foundation

extension TimeInterval{
    func format(timeZone: String, dateFormatter: DateFormatter)-> String {
        let usableDate = Date(timeIntervalSince1970: self)
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        let dateString = dateFormatter.string(from: usableDate)
        return dateString
    }
}

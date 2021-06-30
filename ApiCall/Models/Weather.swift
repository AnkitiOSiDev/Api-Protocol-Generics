//
//  Weather.swift
//  ApiCall
//
//  Created by Ankit on 25/06/21.
//  Copyright © 2021 Ankit. All rights reserved.
//

import Foundation


struct Weather: Decodable {
    let location : Location
    let current : Current
    let forecast : Forecast
}

struct Location: Decodable {
    let name: String
}

struct Current:Decodable {
    let isDay : Int
    let condition : Condition
    let tempC : Double
}

struct Condition: Decodable {
    let text : String
    let icon : String
    let code : Int
}

struct Forecast : Decodable {
    let forecastday : [ForecastDay]
}

struct Day: Decodable {
        let maxtempC : Double
        let mintempC : Double
        let condition : Condition
}

struct ForecastDay: Decodable,Hashable {
    static func == (lhs: ForecastDay, rhs: ForecastDay) -> Bool {
        lhs.dateEpoch == rhs.dateEpoch
    }
    
    let dateEpoch : Double
    let day: Day
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(dateEpoch)
    }
    
}

extension ForecastDay {
    var weekDay: String {
        let date = Date.init(timeIntervalSince1970: dateEpoch)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
}


struct WeatherCondition: Decodable {
    let code : Int
    let icon : Int
}

import UIKit
extension WeatherCondition{
    static func iconImage(day:Bool,code:Int) -> UIImage? {
        var icon : Int?
        ModuleManager.manager.getWeatherConditions { (response) in
            switch response {
            case .success(let weatherCondition):
                for (_,condition) in weatherCondition.enumerated() {
                    if condition.code == code {
                        icon = condition.icon
                        break
                    }
                }
                break
            case .failure( _):
                break
            }
        }
        var dayOrNightPath = "day"
        if let icon = icon {
            if day {
                dayOrNightPath = "day"
            }else{
                dayOrNightPath = "night"
            }
            let image = UIImage(named: "weather/64x64/\(dayOrNightPath)/\(icon)")
            return image
        }
        return nil
    }
}

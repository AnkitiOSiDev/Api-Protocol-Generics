//
//  ModuleManager.swift
//  ApiCall
//
//  Created by Ankit on 12/06/21.
//  Copyright © 2021 Ankit. All rights reserved.
//

import Foundation

class ModuleManager {
    static let manager = ModuleManager()
    private var netWordManager : NetWordManager
    private init(){
        netWordManager = NetWordManager.manager
    }
    
    func getWords(term:String,completion:@escaping responseHandler<Words>) {
        let headers : [String:String] = [
            "x-rapidapi-key": API.apiKey,
            "x-rapidapi-host": API.baseURLDictionary
        ]
        let resource = WordApiResourse(headers: headers, httpMethod: .GET, parameters: ["term":term])
        netWordManager.getData(resourse: resource, completion: completion)
    }
    
    func getWeatherForecaset(term:String,completion: @escaping responseHandler<Weather>){
        let headers : [String:String] = [
            "x-rapidapi-key": API.apiKey,
            "x-rapidapi-host": API.baseURLWeather
        ]
        
        let resourse = WeatherForecastApiResoource(parameters: ["q" : term,"days":"7"], headers: headers, httpMethod: .GET)
        netWordManager.getData(resourse: resourse, completion: completion)
        
    }
    
    func getWeatherConditions(completion: responseHandler<[WeatherCondition]>) {
        guard let path = Bundle.main.path(forResource: "WeatherConditions", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let model = try decoder.decode([WeatherCondition].self, from: data)
            completion(.success(model))
        } catch let error {
            completion(.failure(error))
        }
    }
}


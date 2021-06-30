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
    
    func getNews(completion:@escaping responseHandler<TopNews>) {
        let headers : [String:String] = [
            "x-rapidapi-key": API.apiKey,
            "x-rapidapi-host": API.baseURLNews,
            "x-bingapis-sdk": "true"
        ]
        let resource = NewsApiResourse(headers: headers, httpMethod: .GET, parameters: ["textFormat":"Raw","safeSearch":"Strict"])
        netWordManager.getData(resourse: resource, completion: completion)
    }
    
    func getWeatherForecaset(term:String,completion: @escaping responseHandler<Weather>){
        let headers : [String:String] = [
            "x-rapidapi-key": API.apiKey,
            "x-rapidapi-host": API.baseURLWeather
        ]
        
        let resourse = WeatherForecastApiResoource(parameters: ["q" : term,"days":"3"], headers: headers, httpMethod: .GET)
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


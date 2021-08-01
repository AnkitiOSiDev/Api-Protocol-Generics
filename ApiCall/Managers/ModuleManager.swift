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
    private let queueManager: QueueManager
    
    private init(){
        queueManager = QueueManager.sharedInstance
    }
    
    func getNews(completion:@escaping responseHandler<TopNews>) {
        let headers : [String:String] = [
            "x-rapidapi-key": API.apiKey,
            "x-rapidapi-host": API.baseURLNews,
            "x-bingapis-sdk": "true"
        ]
        let resource = NewsApiResourse(headers: headers, httpMethod: .GET, parameters: ["textFormat":"Raw","safeSearch":"Strict"])
        
        let fetch = ApiOperation(apiResource: resource)
        let parse = DecodingOperation<TopNews>()
        
        let adapter = BlockOperation() { [unowned fetch, unowned parse] in
            parse.dataFetched = fetch.dataFetched
            parse.error = fetch.error
        }
        
        adapter.addDependency(fetch)
        parse.addDependency(adapter)
        
        parse.completionHandler = completion
        queueManager.addOperations([fetch, parse, adapter])
    }
    
    func getWeatherForecaset(term:String,completion: @escaping responseHandler<Weather>){
        let headers : [String:String] = [
            "x-rapidapi-key": API.apiKey,
            "x-rapidapi-host": API.baseURLWeather
        ]
        
        let resource = WeatherForecastApiResoource(parameters: ["q" : term,"days":"3"], headers: headers, httpMethod: .GET)
        let fetch = ApiOperation(apiResource: resource)
        let parse = DecodingOperation<Weather>()
        
        let adapter = BlockOperation() { [unowned fetch, unowned parse] in
            parse.dataFetched = fetch.dataFetched
            parse.error = fetch.error
        }
        
        adapter.addDependency(fetch)
        parse.addDependency(adapter)
        
        parse.completionHandler = completion
        queueManager.addOperations([fetch, parse, adapter])
    }
    
    func getWeatherConditions(completion: @escaping responseHandler<[WeatherCondition]>) {
        guard let path = Bundle.main.path(forResource: "WeatherConditions", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        let parse = DecodingOperation<[WeatherCondition]>()
        do {
            let data = try Data(contentsOf: url)
            parse.dataFetched = data
            parse.completionHandler = completion
        } catch let error {
            completion(.failure(error))
        }
        queueManager.addOperations([parse])
    }
}


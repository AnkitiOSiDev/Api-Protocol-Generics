//
//  WeatherViewModel.swift
//  ApiCall
//
//  Created by Ankit on 27/06/21.
//  Copyright © 2021 Ankit. All rights reserved.
//

import Foundation
import UIKit
protocol WeatherViewProtocol: NSObjectProtocol {
    func getSearchText() -> String?
}
class WeatherViewModel: DataProvider {
    var pagination: Paging
    
    var fetchingStatus: FetchingStatus = .idle
    
    var delegate: DataProviderDelegate
    weak var weatherDelegate: WeatherViewProtocol?
    
    var pageNo: Int = 0
        
    var weatherForecast = [ForecastDay]()
    var weather : Weather?
    
    func numberOfItems() -> Int {
        weatherForecast.count
    }
    
    func numberOfHeaders() -> Int {
        return 1
    }
    
    func isNoDataPresent() -> Bool {
        weatherForecast.count == 0
    }
    
    func getData<T>(index: Int) -> T? where T : Hashable {
        weatherForecast[safe: index] as? T
    }
    
    func getData<T>(section: Int) -> T? where T : Hashable {
        nil
    }
    
    func fetchFirstPage() {
        getData()
    }
    
    func fetchNextPage() {
        
    }
    
    private func getData(){
        if fetchingStatus == .idle {
            self.weatherForecast.removeAll()
            fetchingStatus = .fetching
            ModuleManager.manager.getWeatherForecaset(term: weatherDelegate?.getSearchText() ?? "") {[weak self] (response) in
                self?.fetchingStatus = .idle
                guard let self = self else {
                    return
                }
                
                switch response {
                    
                case .success(let weather):
                    self.weather = weather
                    self.weatherForecast.append(contentsOf: weather.forecast.forecastday)
                    self.delegate.requestUpdatedSuccessFully()
                    break
                case .failure(let error):
                    self.delegate.requestFailed(message: error.localizedDescription)
                    break
                }
            }
        }
    }
    
    init(delegate:DataProviderDelegate,pagination:Paging) {
        self.delegate = delegate
        self.pagination = pagination
    }
    
    func getCurrentConditionD() -> String? {
      return  weather?.current.condition.text
    }
    
    func getCurrentIcon() -> UIImage? {
        return WeatherCondition.iconImage(day: Bool(weather?.current.isDay ?? 0), code: weather?.current.condition.code ?? 0)
    }
    
}

extension Bool {
    init<T:BinaryInteger>(_ num: T) {
        self.init(num != 0)
    }
}

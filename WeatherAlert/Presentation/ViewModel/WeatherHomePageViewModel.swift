//
//  WeatherHomePageViewModel.swift
//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import Foundation
import UIKit

class WeatherHomePageViewModel: NSObject
{
    var lastTimeUpdate: Date! = Date()
    var listFavorite: [LocationModel] = []
    private var mapForecastWeatherData: [String: ForecastWeatherDataModel] = [:]
    private var currentLocationWeatherData: LocationWeatherDataModel?
    
    override init() {
        listFavorite = DataManager.shared.getListLocationFavorite()
    }
    
    deinit {
        lastTimeUpdate = nil
    }
}

extension WeatherHomePageViewModel: WeatherHomePageViewModelInput {
    func doUpdateForecaseWeatherData(key: String, data: ForecastWeatherDataModel?) {
        guard let data = data else {
            mapForecastWeatherData[key] = nil
            return
        }
        
        mapForecastWeatherData[key] = data
        lastTimeUpdate = Date()
    }
    
    func doAddFavorite(_ location: LocationModel) {
        let result = listFavorite.filter { (item: LocationModel) in
            return item.id == location.id
        }
        
        if result.isEmpty {
            listFavorite.append(location)
            DataManager.shared.saveListFavoriteLocation(listFavorite)
        }
    }
    
    func doRemoveFavorite(_ location: LocationModel) {
        listFavorite.removeAll { (item: LocationModel) in
            return item.id == location.id
        }
        DataManager.shared.saveListFavoriteLocation(listFavorite)
    }
    
    func doUpdateCurrentLocationWeatherData(data: LocationWeatherDataModel) {
        currentLocationWeatherData = data
        lastTimeUpdate = Date()
    }
    
    func getLocation(index: Int) -> LocationModel? {
        return listFavorite.count > index ? listFavorite[index] : nil
    }
    
    func getLocationForecastData(index: Int) -> ForecastWeatherDataModel? {
        guard let location = getLocation(index: index) else {
            return nil
        }
        return mapForecastWeatherData[location.id]
    }
}

extension WeatherHomePageViewModel: WeatherHomePageViewModelOutput {
    func getTitle() -> String? {
        return "Weather Demo".localized
    }
    
    func getLastTimeStr() -> String? {
        if lastTimeUpdate.isInToday {
            return "Updated".localized + ": " + "Today at".localized + " " + lastTimeUpdate.toStringWithFormat("HH:mm:ss")
        }
        return "Updated".localized + ": " + lastTimeUpdate.toStringWithFormat("HH:mm:ss - dd MMM, YYYY")
    }
    
    func getListLocationCount() -> Int {
        return listFavorite.count
    }
    
    func getCurrentLocationWeatherData() -> LocationWeatherDataModel? {
        return currentLocationWeatherData
    }
    
    func getCurrentLocationForecastWeatherData() -> ForecastWeatherDataModel? {
        return mapForecastWeatherData["current"]
    }
    
    func getFavoriteList() -> [LocationModel] {
        return listFavorite
    }
}

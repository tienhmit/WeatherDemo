//
//  WeatherRepository.swift
//  WeatherAlert
//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import SwiftyJSON

protocol WeatherRepositoryInterface {
    func currentLocation(latitude: String,
                         longitude: String,
                         complete: @escaping((_ data: LocationWeatherDataModel) -> Void),
                         failse: @escaping((_ err: Error) -> Void))
    func anyLocation(latitude: String,
                     longitude: String,
                     complete: @escaping((_ data: ForecastWeatherDataModel) -> Void),
                     failse: @escaping((_ err: Error) -> Void))
}

struct WeatherRepository {
    
    private let provider = APIRequestDataProvider()
    
}

extension WeatherRepository: WeatherRepositoryInterface {
    func currentLocation (latitude: String,
                          longitude: String,
                          complete: @escaping((_ data: LocationWeatherDataModel) -> Void),
                          failse: @escaping((_ err: Error) -> Void)) {
        provider.sendRequest(requestConditions: WeatherRequestConditionsType.currentlocation(latitude, longitude),
                             { (json: JSON) in
                                let res = LocationWeatherDataModel(json)
                                complete(res)},
                             { (err: Error) in
                                DLog("err: \(err)")
                                failse(err) })
    }
    
    func anyLocation(latitude: String,
                      longitude: String,
                      complete: @escaping((_ data: ForecastWeatherDataModel) -> Void),
                      failse: @escaping((_ err: Error) -> Void)) {
        provider.sendRequest(requestConditions: WeatherRequestConditionsType.currentlocation(latitude, longitude),
                             { (json: JSON) in
                                let res = ForecastWeatherDataModel(json)
                                complete(res)},
                             { (err: Error) in
                                DLog("err: \(err)")
                                failse(err) })
    }
}

enum WeatherRequestConditionsType {
    case currentlocation(String, String)
    case anyLocation(String, String)
}

extension WeatherRequestConditionsType: RequestConditions {
    var baseURL: String {
        "http://api.openweathermap.org/data/2.5"
    }
    
    var apiURL: String {
        switch self {
        case .currentlocation:
            return "/weather"
        case .anyLocation:
            return "/onecall"
        }
    }
    
    var params: Dictionary<String, Any> {
        switch self {
        case let .currentlocation(latitude, longitude), let .anyLocation(latitude, longitude):
            return ["lat": latitude,
                    "lon": longitude,
                    "appid": "08869d29f8e15af55cd59f0a6127b31f"]
        }
    }
    
    var method: APIMethod {
        .GET
    }
    
    var bodyDataType: APIBodyDataType {
        .QuerryString
    }
}

//
//  WeatherUseCase.swift
//  WeatherAlert
//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

protocol WeatherUseCaseInterface {
    func currentLocation(latitude: String,
                         longitude: String,
                         complete: @escaping((_ data: LocationWeatherDataModel) -> Void),
                         failse: @escaping((_ err: Error) -> Void))
    func anyLocation(latitude: String,
                     longitude: String,
                     complete: @escaping((_ data: ForecastWeatherDataModel) -> Void),
                     failse: @escaping((_ err: Error) -> Void))
}

final class WeatherUseCase {
    private let weatherRepository: WeatherRepositoryInterface
    
    init(weatherRepository: WeatherRepositoryInterface = WeatherRepository()) {
        self.weatherRepository = weatherRepository
    }
}

extension WeatherUseCase: WeatherUseCaseInterface {
    func currentLocation(latitude: String,
                         longitude: String,
                         complete: @escaping((_ data: LocationWeatherDataModel) -> Void),
                         failse: @escaping((_ err: Error) -> Void)) {
        weatherRepository.currentLocation(latitude: latitude, longitude: longitude, complete: complete, failse: failse)
    }
    
    func anyLocation(latitude: String,
                     longitude: String,
                     complete: @escaping((_ data: ForecastWeatherDataModel) -> Void),
                     failse: @escaping((_ err: Error) -> Void)) {
        weatherRepository.anyLocation(latitude: latitude, longitude: longitude, complete: complete, failse: failse)
    }
}

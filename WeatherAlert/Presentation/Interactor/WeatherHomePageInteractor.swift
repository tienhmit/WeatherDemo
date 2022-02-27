//
//  WeatherHomePageInteractor.swift
//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import UIKit

class WeatherHomePageInteractor: NSObject
{
    weak var presenter: WeatherHomePageInteractorOutput?
    private let weatherUseCase: WeatherUseCaseInterface
    
    init(weatherUseCase: WeatherUseCaseInterface = WeatherUseCase()) {
        self.weatherUseCase = weatherUseCase
    }
}

extension WeatherHomePageInteractor: WeatherHomePageInteractorInput {
    func doGetForecastWeatherData(key: String, _ lat: Double, _ long: Double) {
        weatherUseCase.anyLocation(
            latitude: "\(lat)",
            longitude: "\(long)",
            complete: { [weak self] (data: ForecastWeatherDataModel) in
                self?.presenter?.didGetForecastWeatherData(key: key, data: data)
            },
            failse: {[weak self] (error: Error) in
                self?.presenter?.didRequestFailed(err: error)
        })
    }
    
    func doGetCurrentLocationData(_ lat: Double, _ long: Double) {
        weatherUseCase.currentLocation(
            latitude: "\(lat)",
            longitude: "\(long)",
            complete: { [weak self] (data: LocationWeatherDataModel) in
                self?.presenter?.didCurrentLocationWeatherData(data: data)
            },
            failse: { [weak self] (error: Error) in
                self?.presenter?.didRequestFailed(err: error)
        })
    }
}

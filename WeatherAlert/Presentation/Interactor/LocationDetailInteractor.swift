//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import UIKit

class LocationDetailInteractor: NSObject
{
    weak var presenter: LocationDetailInteractorOutput?
    private let weatherUseCase: WeatherUseCaseInterface
    
    init(weatherUseCase: WeatherUseCaseInterface = WeatherUseCase()) {
        self.weatherUseCase = weatherUseCase
    }
}

extension LocationDetailInteractor: LocationDetailInteractorInput {
    func doGetForecastWeatherData(_ lat: Double, _ long: Double) {
        weatherUseCase.anyLocation(
            latitude: "\(lat)",
            longitude: "\(long)",
            complete: { [weak self] (data: ForecastWeatherDataModel) in
                self?.presenter?.didGetData(data)
            },
            failse: { [weak self] (error: Error) in
                self?.presenter?.didGetFailed(error)
        })
    }
}

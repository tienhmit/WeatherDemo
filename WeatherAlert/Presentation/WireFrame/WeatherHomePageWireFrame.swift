//
//  WeatherHomePageWireFrame.swift
//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import Foundation

class WeatherHomePageWireFrame: NSObject
{
    weak var viewController: WeatherHomePageView!
    weak var presenter: WeatherHomePageWireFrameOutput?
}

extension WeatherHomePageWireFrame: WeatherHomePageWireFrameInput {
    func doOpenSelectLocationScreen(listLocationSelected: [LocationModel]) {
        let ids = listLocationSelected.map { (item: LocationModel) in
            return item.id
        }
        
        SelectLocationViewController.doSelectLocation(from: viewController,
                                                      selectedLocationIds: ids)
        { [weak self] (location: LocationModel) in
            self?.presenter?.didSelectLocation(location)
        }
    }
    
    func doGoDetail(lat _lat: Double,
                    long _long: Double,
                    locationName _locationName: String,
                    isCurrentLocation _isCurrentLocation: Bool,
                    dataDetail: ForecastWeatherDataModel?) {
        let vc = LocationDetailConfigure.viewController(lat: _lat,
                                                        long: _long,
                                                        locationName: _locationName,
                                                        isCurrentLocation: _isCurrentLocation,
                                                        dataDetail: dataDetail)
        vc.modalPresentationStyle = .fullScreen
        viewController.present(vc, animated: true, completion: nil)
    }
}

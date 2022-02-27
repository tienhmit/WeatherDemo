//
//  WeatherHomePageConfigure.swift
//  WeatherAlert
//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import UIKit

class WeatherHomePageConfigure: NSObject {
    class func viewController(_ date: Date) -> WeatherHomePageView {
        let view = WeatherHomePageView.initWithDefaultNib()
        let presenter = WeatherHomePagePresenter()
        let interactor = WeatherHomePageInteractor()
        let wireFrame = WeatherHomePageWireFrame()
        let viewModel = WeatherHomePageViewModel()
        viewModel.lastTimeUpdate = date

        presenter.viewModel = viewModel
        presenter.interactor = interactor
        presenter.wireFrame = wireFrame
        presenter.view = view

        view.presenter = presenter
        view.viewModel = viewModel
        interactor.presenter = presenter
        wireFrame.presenter = presenter
        wireFrame.viewController = view
        return view
    }
}

// MARK: -VIEW
protocol WeatherHomePageViewInput: NSObjectProtocol {
    func doStopLoading()
    func doReloadView()
}

protocol WeatherHomePageViewOutput: NSObjectProtocol {
    func viewDidLoad()
    func viewDidAppear()
    func doPullToRefresh()
    func doSelectLocation()
    func doRemoveLocationFromFavoriteList(_ location: LocationModel)
    func doSelectLocation(_ index: IndexPath)
    func doViewCurrentLocationDetail()
}

// MARK: -VIEW MODEL
protocol WeatherHomePageViewModelInput: NSObjectProtocol {
    func doUpdateForecaseWeatherData(key: String, data: ForecastWeatherDataModel?)
    func doUpdateCurrentLocationWeatherData(data: LocationWeatherDataModel)
    func doAddFavorite(_ location: LocationModel)
    func doRemoveFavorite(_ location: LocationModel)
}

protocol WeatherHomePageViewModelOutput: NSObjectProtocol {
    func getTitle() -> String?
    func getLastTimeStr() -> String?
    func getListLocationCount() -> Int
    func getCurrentLocationWeatherData() -> LocationWeatherDataModel?
    func getCurrentLocationForecastWeatherData() -> ForecastWeatherDataModel?
    func getLocation(index: Int) -> LocationModel?
    func getLocationForecastData(index: Int) -> ForecastWeatherDataModel?
    func getFavoriteList() -> [LocationModel]
}

// MARK: -INTERACTOR
protocol WeatherHomePageInteractorInput: NSObjectProtocol {
    func doGetCurrentLocationData(_ lat: Double, _ long: Double)
    func doGetForecastWeatherData(key: String, _ lat: Double, _ long: Double)
}

protocol WeatherHomePageInteractorOutput: NSObjectProtocol {
    func didGetForecastWeatherData(key: String, data: ForecastWeatherDataModel)
    func didCurrentLocationWeatherData(data: LocationWeatherDataModel)
    func didRequestFailed(err: Error)
}

// MARK: -INTERACTOR
protocol WeatherHomePageWireFrameInput: NSObjectProtocol {
    func doOpenSelectLocationScreen(listLocationSelected: [LocationModel])
    func doGoDetail(lat _lat: Double,
                    long _long: Double,
                    locationName _locationName: String,
                    isCurrentLocation _isCurrentLocation: Bool,
                    dataDetail: ForecastWeatherDataModel?) 
}

protocol WeatherHomePageWireFrameOutput: NSObjectProtocol {
    func didSelectLocation(_ location: LocationModel)
}

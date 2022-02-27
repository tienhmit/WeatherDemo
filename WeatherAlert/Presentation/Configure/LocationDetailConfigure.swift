//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import UIKit

class LocationDetailConfigure: NSObject {

    class func viewController(lat _lat: Double,
                              long _long: Double,
                              locationName _locationName: String,
                              isCurrentLocation _isCurrentLocation: Bool,
                              dataDetail: ForecastWeatherDataModel?) -> LocationDetailView {
        let view = LocationDetailView.initWithDefaultNib()
        let presenter = LocationDetailPresenter()
        let interactor = LocationDetailInteractor()
        let wireFrame = LocationDetailWireFrame()
        let viewModel = LocationDetailViewModel(lat: _lat,
                                                long: _long,
                                                locationName: _locationName,
                                                isCurrentLocation: _isCurrentLocation,
                                                dataDetail: dataDetail)

        presenter.viewModel = viewModel
        presenter.view = view
        presenter.interactor = interactor
        presenter.wireFrame = wireFrame

        view.presenter = presenter
        view.viewModel = viewModel
        interactor.presenter = presenter
        wireFrame.presenter = presenter
        wireFrame.viewController = view
        return view
    }
}

// MARK: -VIEW
protocol LocationDetailViewInput: NSObjectProtocol {
    func doReloadView()
}

protocol LocationDetailViewOutput: NSObjectProtocol {
    func viewDidLoad()
    func viewWillAppear()
    func doClosePressed()
}

// MARK: -VIEW MODEL
protocol LocationDetailViewModelInput: NSObjectProtocol {
    func doUpdateForecastDat(_ data: ForecastWeatherDataModel)
}

protocol LocationDetailViewModelOutput: NSObjectProtocol {
    func getLocationName() -> String?
    func getIsCurrentLocation() -> Bool
    func getForcastWeatherData() -> ForecastWeatherDataModel?
}

// MARK: -INTERACTOR
protocol LocationDetailInteractorInput: NSObjectProtocol {
    func doGetForecastWeatherData(_ lat: Double, _ long: Double)
}

protocol LocationDetailInteractorOutput: NSObjectProtocol {
    func didGetData(_ data: ForecastWeatherDataModel)
    func didGetFailed(_ err: Error)
}

// MARK: -INTERACTOR
protocol LocationDetailWireFrameInput: NSObjectProtocol {
    func doDismissScreen()
}

protocol LocationDetailWireFrameOutput: NSObjectProtocol {

}

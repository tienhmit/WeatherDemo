//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import UIKit

class LocationDetailPresenter: NSObject
{
    weak var view: LocationDetailViewInput?
    var interactor: LocationDetailInteractorInput?
    var wireFrame: LocationDetailWireFrameInput?
    var viewModel: LocationDetailViewModel!
}

// MARK: -VIEW
extension LocationDetailPresenter: LocationDetailViewOutput {
    func viewDidLoad() {
        
    }
    
    func viewWillAppear() {
        interactor?.doGetForecastWeatherData(viewModel.lat, viewModel.long)
    }
    
    func doClosePressed() {
        wireFrame?.doDismissScreen()
    }
}

// MARK: -INTERACTOR
extension LocationDetailPresenter: LocationDetailInteractorOutput {
    func didGetData(_ data: ForecastWeatherDataModel) {
        viewModel.doUpdateForecastDat(data)
        view?.doReloadView()
        DLog("didGetData: \(data)")
    }
    
    func didGetFailed(_ err: Error) {
        
    }
}

// MARK: -WIRE FRAME
extension LocationDetailPresenter: LocationDetailWireFrameOutput {
    
}

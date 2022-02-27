//
// Created by AUTHOR
// Copyright (c) YEAR AUTHOR. All rights reserved.
//

import Foundation

class LocationDetailWireFrame: NSObject
{
    weak var viewController: LocationDetailView?
    weak var presenter: LocationDetailWireFrameOutput?
}

extension LocationDetailWireFrame: LocationDetailWireFrameInput {
    func doDismissScreen() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}

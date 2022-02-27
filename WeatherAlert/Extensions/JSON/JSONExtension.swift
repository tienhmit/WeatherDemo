//
//  JSONExtension.swift
//  WeatherAlert
//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import UIKit
import SwiftyJSON

extension JSON {
    static func getJSONWithPath(_ path: String) -> JSON? {
        if let path = Bundle.main.path(forResource: path, ofType: "json") {
            do {
                guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped),
                    let jsonObj = try? JSON(data: data) else {
                        return nil
                }
                
                return jsonObj
            }
        }
        return nil
    }
}

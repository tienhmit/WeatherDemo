//
//  AppMacro.swift
//  WeatherAlert
//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import Foundation
import UIKit

func DLog(_ message: Any,
          function: String = #function,
          file: NSString = #file,
          line: Int = #line) {
    
    #if DEBUG
    // debug only code
    print("\(file.lastPathComponent) - \(function)[\(line)]: \(message)")
    #else
    // release only code
    #endif
}

func isIphoneApp() -> Bool {
    switch UIDevice.current.userInterfaceIdiom {
    case .phone:
        return true
    case .pad:
        return false
        
    default:
        return false
    }
}

func ALog(_ message: String?,
          function: String = #function,
          file: NSString = #file,
          line: Int = #line) {
    
    #if DEBUG
    // debug only code
    print("\n\(file.lastPathComponent) - \(function)[\(line)]: show alert with "
        + "\nMessage: \(message ?? "")"
        + "\n--------------------------------------------")
    
    let alertView = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
    let dismissAction = UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default)
    
    alertView.addAction(dismissAction)
    
    let viewController = UIApplication.shared.windows.first?.rootViewController
    DispatchQueue.main.async {
        viewController!.present(alertView, animated: true, completion: nil)
    }
    #else
    // release only code
    #endif
}

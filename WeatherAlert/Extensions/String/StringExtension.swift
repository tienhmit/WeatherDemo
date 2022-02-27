//
//  StringExtension.swift
//  WeatherAlert
//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    static func displayMoneyFormat(_ number: Double?)-> String {
        guard let value = number else {
            return "0"
        }
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.groupingSeparator = ","
        currencyFormatter.groupingSize = 3
        currencyFormatter.decimalSeparator = "."
        
        if let priceString = currencyFormatter.string(from: NSNumber(value: value)) {
            return priceString
        }
        return "0"
    }

    func firstCharactor()-> String {
        if self.count > 0 {
            return String(self.prefix(1))
        }
        return ""
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    var searchString: String {
        return self.removeVietnamese.replacingOccurrences(of: " ", with: "").lowercased()
    }
}

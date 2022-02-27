//
//  DataManager.swift
//  WindyDemo2
//
//  Created by Đào Mỹ Đông on 25/02/2022.
//

import UIKit
import SwiftyJSON

class DataManager: NSObject {
    static let shared: DataManager = DataManager()
    private var listAllLocation: [LocationModel] = []
    
    override init() {
        super.init()
    }
    
    func fetchData() {
        let userDefault = UserDefaults.standard
        if let JSONString = userDefault.value(forKey: "listFavoriteLocationID") as? String {
            do {
                let data = JSONString.data(using: String.Encoding.utf8, allowLossyConversion: false)

                if let jsonData = data {
                    let _list = try JSONSerialization.jsonObject(with: jsonData, options: []) as? Array<NSDictionary>
                    if let list = _list {
                        for dict in list {
                            let item = LocationModel(dict: dict)
                            listAllLocation.append(item)
                        }
                    }
                }
            }
            catch {
                DLog("fetchData failed")
            }
        }
    }
    
    func getListLocationFavorite() -> [LocationModel] {
        return listAllLocation
    }
    
    func saveListFavoriteLocation(_ list: [LocationModel]) {
        do {
            let listData = list.map { (item: LocationModel) in
                return item.toDict()
            }
            
            let jsonData = try JSONSerialization.data(withJSONObject: listData, options: JSONSerialization.WritingOptions.prettyPrinted)

            //Convert back to string. Usually only do this for debugging
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                let userDefault = UserDefaults.standard
                userDefault.setValue(JSONString, forKey: "listFavoriteLocationID")
                userDefault.synchronize()
            }
        } catch {
            DLog("saveListFavoriteLocation failed")
        }
    }
}

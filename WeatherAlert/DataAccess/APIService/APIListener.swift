//
//  APINotificationListener.swift
//  WeatherAlert
//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import UIKit

@objc protocol APIListenerDelegate: NSObjectProtocol {
    @objc optional func litener(_ noti: APIListener, didFinishRequest url: String)
    @objc optional func litenerShowLoginScreen(_ noti: APIListener)
}

enum APIRequestNotificationLocalEvent: String {

    case didFinishRequest = "didFinishRequest"
    case showLoginScreen = "showLoginScreen"
    
    var event: NSNotification.Name {
        return NSNotification.Name(rawValue: self.rawValue)
    }
}

extension APIListener {
    class func doPushNotificationDidFinishRequestAPI(_ url: String) {
        NotificationCenter.default.post(name: APIRequestNotificationLocalEvent.didFinishRequest.event, object: url)
    }
    
    class func doPushShowLoginScreen() {
        NotificationCenter.default.post(name: APIRequestNotificationLocalEvent.showLoginScreen.event, object: nil)
    }
}

class APIListener: NSObject {
    weak var delegate: APIListenerDelegate? = nil
    
    override init() {
        super.init()
        setUpNotificationEvent()
    }
    
    private func setUpNotificationEvent() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(notiDidFinishRequest),
                                               name: APIRequestNotificationLocalEvent.didFinishRequest.event,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(notiShowLoginScreen),
                                               name: APIRequestNotificationLocalEvent.showLoginScreen.event,
                                               object: nil)
    }
    
    @objc private func notiDidFinishRequest(_ notif: NSNotification) {
        if let value = notif.object as? String {
            self.delegate?.litener?(self, didFinishRequest: value)
        }
    }
    
    @objc private func notiShowLoginScreen(_ notif: NSNotification) {
        self.delegate?.litenerShowLoginScreen?(self)
    }
    
    deinit {
        let obSebver = NotificationCenter.default
        obSebver.removeObserver(self, name: APIRequestNotificationLocalEvent.didFinishRequest.event, object: nil)
        obSebver.removeObserver(self, name: APIRequestNotificationLocalEvent.showLoginScreen.event, object: nil)
        obSebver.removeObserver(self)
    }
}

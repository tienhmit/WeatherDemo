//
//  APIRequestDataProvider.swift
//  WeatherAlert
//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import SwiftyJSON
import Alamofire

typealias APIRequestSuccessBlock = (_ jsonData: JSON) -> Void
typealias APIRequestFailBlock = (_ error: Error) -> Void

enum REQUEST_STATUS_CODE: Int {
    case UN_AUTHENT = 400
    case ACCESSTOKEN_EXPIRE = 401
    case NO_PERMISSION = 403
}

enum APIMethod: String {
    case POST = "POST"
    case GET = "GET"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

enum APIBodyDataType {
    case FormData
    case JSONData
    case QuerryString
    
    var dataType: ParameterEncoding {
        switch self {
        case .FormData:
            return URLEncoding.httpBody
        case .JSONData:
            return JSONEncoding.default
        case .QuerryString:
            return URLEncoding.queryString
        }
    }
}

class APIRequestDataProvider: NSObject {

    //mark: SINGLETON
    static var shareInstance: APIRequestDataProvider = {
        let instance = APIRequestDataProvider()
        return instance
    }()
    
    //mark: DEFAULT HEADER & REQUEST URL
    var headersJSON: HTTPHeaders {
        get {
            let headers: HTTPHeaders = [
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Transfer-Encoding": "chunked"
            ]

            return headers
        }
    }
    
    var headersFormData: HTTPHeaders {
        get {
            let headers: HTTPHeaders = [
                "Accept": "application/json",
                "Content-Type": "application/x-www-form-urlencoded",
                "Transfer-Encoding": "chunked"
            ]

            return headers
        }
    }
    
    lazy var alamoFireManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 30 // seconds for testing

        let _alamoFireManager = Alamofire.SessionManager(configuration: configuration)
        return _alamoFireManager
    }()
    
    func request(requestConditions: RequestConditions) -> DataRequest {
        let urlString = requestConditions.baseURL.appending(requestConditions.apiURL)
        let map: [APIMethod: HTTPMethod] = [.POST:.post,
                                            .GET: .get,
                                            .DELETE: .delete,
                                            .PUT:.put]
        
        return alamoFireManager.request(urlString,
                                        method: map[requestConditions.method]!,
                                        parameters: requestConditions.params,
                                        encoding: requestConditions.bodyDataType.dataType,
                                        headers: requestConditions.bodyDataType == .FormData ? self.headersFormData : self.headersJSON)
    }
    
    func sendRequest(requestConditions: RequestConditions,
                     _ success: APIRequestSuccessBlock?,
                     _ fail: APIRequestFailBlock?) {
        let dataRequest: DataRequest = request(requestConditions: requestConditions)
        dataRequest
            .validate()
            .responseJSON { (_ response: DataResponse<Any>) in
                switch response.result {
                case .success:
                    let json = JSON(response.result.value!)
                    success?(json)
                    break
                case .failure(let error as NSError):
                    self.dlogErrorAPI(fail: fail, error: error, response: response)
                default:
                    break
                }
        }
    }
    
    func dlogErrorAPI(fail: APIRequestFailBlock?, error: NSError, response: DataResponse<Any>) {
        DLog("=========================================")
        
        var statusCode = response.response?.statusCode
        if let error = response.result.error as? AFError {
            statusCode = error._code // statusCode private
            switch error {
            case .invalidURL(let url):
                DLog("Invalid URL: \(url) - \(error.localizedDescription)")
            case .parameterEncodingFailed(let reason):
                DLog("Parameter encoding failed: \(error.localizedDescription)")
                DLog("Failure Reason: \(reason)")
            case .multipartEncodingFailed(let reason):
                DLog("Multipart encoding failed: \(error.localizedDescription)")
                DLog("Failure Reason: \(reason)")
            case .responseValidationFailed(let reason):
                DLog("Response validation failed: \(error.localizedDescription)")
                DLog("Failure Reason: \(reason)")

                switch reason {
                case .dataFileNil, .dataFileReadFailed:
                    DLog("Downloaded file could not be read")
                case .missingContentType(let acceptableContentTypes):
                    DLog("Content Type Missing: \(acceptableContentTypes)")
                case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                    DLog("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                case .unacceptableStatusCode(let code):
                    DLog("Response status code was unacceptable: \(code)")
                    statusCode = code
                }
            case .responseSerializationFailed(let reason):
                DLog("Response serialization failed: \(error.localizedDescription)")
                DLog("Failure Reason: \(reason)")
                // statusCode = 3840 ???? maybe..
            }

            DLog("Underlying error: \(String(describing: error.underlyingError))")
        } else if let error = response.result.error as? URLError {
            DLog("URLError occurred: \(error)")
        } else {
            DLog("Unknown error: \(String(describing: response.result.error))")
        }
        
        if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorNetworkConnectionLost {
            fail?(NSError(domain: error.domain, code: statusCode ?? error.code, userInfo: nil))
        } else if error.code == NSURLErrorCancelled {
            fail?(NSError(domain: error.domain, code: statusCode ?? error.code, userInfo: nil))
        } else if statusCode == REQUEST_STATUS_CODE.NO_PERMISSION.rawValue {
            let userInfo: [String : Any] = [NSLocalizedDescriptionKey: "No Permission".localized,
                                            NSLocalizedFailureReasonErrorKey: "No Permission".localized]
            let _err = NSError(domain: error.domain, code: statusCode ?? error.code, userInfo: userInfo)
            fail?(_err)
        } else {
            let _err = NSError(domain: error.domain, code: statusCode ?? error.code, userInfo: error.userInfo)
            fail?(_err)
        }
    }
}

protocol RequestConditions {
    var baseURL: String { get }
    var apiURL: String { get }
    var params: Dictionary<String, Any> { get }
    var method: APIMethod { get }
    var bodyDataType: APIBodyDataType { get }
}

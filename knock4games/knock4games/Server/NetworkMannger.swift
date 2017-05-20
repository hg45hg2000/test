//
//  NetworkMannger.swift
//  knock4games
//
//  Created by CHEN HENG Lin on 2017/5/17.
//  Copyright © 2017年 CHEN HENG Lin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let serverUrl = "http://52.197.192.141:3443"

enum serverShortURL : String{
    case Login  =  ""
    case Member =  "/member"
    
}


struct NetWorkRequestParameter {
    
    var shortUrl : serverShortURL
    
    let parameters : [String : Any]?
    
    let httpsMethod : HTTPMethod
    
    var HTTPHeaders : [String: String]?
    
    var sourceView : UIView?
    
    init(shortUrl: serverShortURL,parameter:Dictionary<String, Any>?,httpsMethod : HTTPMethod ,headers :[String: String]?,sourceView : UIView?) {
        self.shortUrl = shortUrl
        self.parameters = parameter
        self.httpsMethod = httpsMethod
        self.HTTPHeaders = headers
        self.sourceView = sourceView
    }
}

enum NetworkRequestResult{
    case success(JSON)
    case failure
}


class NetworkMannger: NSObject {
    typealias RefreshCompletion = (NetworkRequestResult) -> Void
    
    private static var mInstance:NetworkMannger?
    static func sharedInstance() -> NetworkMannger {
        if mInstance == nil {
            mInstance = NetworkMannger()
            
        }
        return mInstance!
    }
    
    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        return SessionManager(configuration: configuration)
    }()
    
    // MARK: - RequestAdapter
    
    open func requestNetwork(requestParameter:NetWorkRequestParameter,completion:@escaping RefreshCompletion){
        
        let url  = serverUrl + (requestParameter.shortUrl.rawValue)
        
        let urlRequest =  checkRequestParameter(url: url, requestParameter: requestParameter)
        
        
        Alamofire.request(urlRequest).responseJSON { response in
                
                if let json = response.result.value as? [String: Any]
                {
                    debugPrint(json)
                    DispatchQueue.main.async {
                        completion(.success(JSON(json)))
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        completion(.failure)
                    }
            }
        }
    }
    private func checkRequestParameter(url:String,requestParameter : NetWorkRequestParameter) ->  URLRequest{
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = requestParameter.httpsMethod.rawValue
        
        if requestParameter.parameters != nil {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestParameter.parameters as Any, options: [])
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                
            }
        }
        
        if requestParameter.HTTPHeaders != nil {
            urlRequest.allHTTPHeaderFields = requestParameter.HTTPHeaders
        }
        return urlRequest
    }
}

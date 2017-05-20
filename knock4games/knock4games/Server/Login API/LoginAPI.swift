//
//  LoginAPI.swift
//  knock4games
//
//  Created by CHEN HENG Lin on 2017/5/17.
//  Copyright © 2017年 CHEN HENG Lin. All rights reserved.
//

import UIKit


class LoginAPI: NSObject {
    typealias LoginResponse = (LoginAPIResponseData) -> Void
    
    let name  : String
    
    let passWord : String
    
    init(name : String , passWord : String) {
        self.name = name
        self.passWord = passWord
    }
    
    var parameter : [String : Any] {
        let parameter = ["name": self.name,
                         "pwd": self.passWord]
        return parameter
    }
    
    open func requestAPI(sourceView:UIView?,completion:@escaping LoginResponse){
        
        NetworkMannger.sharedInstance().requestNetwork(requestParameter: NetWorkRequestParameter(shortUrl: .Login, parameter: self.parameter, httpsMethod: .post, headers: nil, sourceView: sourceView)) { (result) in
            switch result {
            case .success(let response):
                completion(LoginAPIResponseData(response: response))
                break
            case .failure:
                break
            
            }
        }
    }
    
}
import SwiftyJSON

let tokenKey = "tokenKey"

struct LoginAPIResponseData {
    let expTime : Int
    let iatTime : Int
    let name : String
    
    
    public var token : String  {
        set{
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
        get{
           return  LoginAPIResponseData.getToken()
        }
    }
    
    static func getToken() -> String {
        return UserDefaults.standard.object(forKey: tokenKey) as? String ?? ""
    }
    
    static func removeToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
    
    static func isUserLogin() -> Bool{
        return (UserDefaults.standard.object(forKey: tokenKey) != nil)
    }
    
    private let parseToken = "token"
    
    init(response : JSON ){
        let data : JSON = response[parseToken]
        self.expTime = data["exp"].intValue
        self.iatTime = data["iat"].intValue
        self.name = data["name"].stringValue
        self.token = data["token"].stringValue
    }
}

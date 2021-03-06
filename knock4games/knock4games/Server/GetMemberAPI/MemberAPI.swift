//
//  MemberAPI.swift
//  knock4games
//
//  Created by CHEN HENG Lin on 2017/5/18.
//  Copyright © 2017年 CHEN HENG Lin. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire



class MemberAPI: NSObject {
    typealias MemberAPIResponse = (MemberAPIResponseData) -> Void
    typealias ResultAPIResponse = (ResponseResultData) -> Void
    
    
    static open func requestMemberListAPI(sourceView: UIView?,completion:@escaping MemberAPIResponse){
        NetworkMannger.sharedInstance().requestNetwork(requestParameter: NetWorkRequestParameter(shortUrl: .Member, parameter: nil, httpsMethod: .get, headers: self.creatTokenHeader(), sourceView: sourceView)) { (NetworkRequestResult) in
            switch NetworkRequestResult {
            case .success(let response):
                completion(MemberAPIResponseData(json: response))
                break
            case .failure:
                break
                
            }
        }
    }
    static open func requestCreateMemberAPI(parameter:[String : Any]?,sourceView: UIView?,completion:@escaping ResultAPIResponse){
        NetworkMannger.sharedInstance().requestNetwork(requestParameter: NetWorkRequestParameter(shortUrl: .Member, parameter: parameter, httpsMethod: .post, headers: self.creatTokenHeader(), sourceView: sourceView)) { (NetworkRequestResult) in
            switch NetworkRequestResult {
            case .success(let response):
                completion(ResponseResultData(json: response))
                break
            case .failure:
                break
                
            }
        }
    }
    static private func creatTokenHeader() -> HTTPHeaders? {
        return LoginAPIResponseData.isUserLogin()  ?  ["Authorization":LoginAPIResponseData.getToken()] : nil
    }
    
}

struct MemberAPIResponseData {
    
    var MemberDataArray : Array<MemberData> = []
    
    init(json:JSON) {
        let dataArray = json["data"].arrayValue
        
        for memberData in dataArray {
            MemberDataArray.append( MemberData(json: memberData))
        }
        
    }
    
    struct MemberData {
        let id : Int
        let name  : String
        
        init(json:JSON) {
            self.id = json["ID"].intValue
            self.name = json["name"].stringValue
        }
    }
}
class ResponseResultData: NSObject {
    
    var result : String
    
     init(json:JSON) {
        self.result  = json["code"].stringValue
    }
}


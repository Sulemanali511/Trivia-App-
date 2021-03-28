//
//  ApiManager.swift
//  Trivia app
//
//  Created by Suleman Ali on 4/8/20.
//  Copyright © 2020 Suleman Ali. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

enum VoidResult {
    case success(result:JSON)
    case failure(NSError)
}






class ApiManager: NSObject {
    
    class func headers() -> HTTPHeaders {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        if let authToken = UserDefaults.standard.string(forKey: "token") {
            headers["Authorization"] = authToken //+ "42"
        }
        return headers
    }
    
    class func getRequest(with url:String = APPURL.Questionendpoint,parameters: [String:Any]?, completion: @escaping (_ result: VoidResult) -> ())
    {
        print(url)
        if Reachability.isConnectedToNetwork(){
            Functions.showActivity()
            AF.request(url,method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers:ApiManager.headers()).responseJSON { (response:AFDataResponse<Any>) in
                Functions.hideActivity()
                if let jsonObject = response.value
                {
                    let json = JSON(jsonObject)
                    if response.response?.statusCode == 200{
                        completion(.success(result: json))
                    }else{
                        Functions.showToast(message: "Sorry Server Have some problem", type: .failure, duration: 3, position: .center)
                        completion(.failure(NSError(domain: "Server Error", code: 500, userInfo: [NSLocalizedDescriptionKey:"Server Error"])))
                    }
                    
                } else if let error = response.error {
                    Functions.showToast(message: "Sorry Server Have some problem", type: .failure, duration: 3, position: .center)
                    completion(.failure(error as NSError))
                    
                }else{
                    Functions.showToast(message: "Sorry Server Have some problem", type: .failure, duration: 3, position: .center)
                    completion(.failure(NSError(domain: "Server Error", code: 500, userInfo: [NSLocalizedDescriptionKey:"Server Error"])))
                }
                
            }
        }else{
            
            completion(.failure(NSError(domain: "No Internet", code: 500, userInfo: [NSLocalizedDescriptionKey:"No Internet"])))
            Functions.noInternetConnection(status: true)
        }
    }
    
    
    
}






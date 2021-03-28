//
//  ServerResponse.swift
//  Trivia app
//
//  Created by Suleman Ali on 28/03/2021.
//
import Foundation
import SwiftyJSON


struct ServerResponse {
    var questions : [Question]!
    var responseCode : Int!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        questions = [Question]()
        for questionsJson in json["results"].arrayValue{
            questions.append(Question(fromJson: questionsJson))
        }
        responseCode = json["response_code"].intValue
    }
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if questions != nil{
            var dictionaryElements = [[String:Any]]()
            for questionsElement in questions {
                dictionaryElements.append(questionsElement.toDictionary())
            }
            dictionary["questions"] = dictionaryElements
        }
        if responseCode != nil{
            dictionary["response_code"] = responseCode
        }
        return dictionary
    }
    
}

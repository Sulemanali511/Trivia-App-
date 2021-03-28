//
//  Question.swift
//  Trivia app
//
//  Created by Suleman Ali on 28/03/2021.
//
import Foundation
import SwiftyJSON


struct Question {

    var category : String!
    var difficulty : String!
    var question : String!
    var type : String!
    var points:Int!
    var isSolved:Bool = false
    var answers:[Answer] = []
    
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        category = json["category"].stringValue
        difficulty = json["difficulty"].stringValue
        for incorrectAnswersJson in json["incorrect_answers"].arrayValue{
            answers.append(Answer(answer: incorrectAnswersJson.stringValue, isCorrect: false))
        }
        question = json["question"].stringValue
        answers.append(Answer(answer: json["correct_answer"].stringValue, isCorrect: true))
        
        answers.shuffle()
        type = json["type"].stringValue
        if difficulty == "easy"{
            points = DificultyLevel.easy.rawValue
        }
        else if difficulty == "medium"{
            points = DificultyLevel.medium.rawValue
        }
        else if difficulty == "hard" {
            points = DificultyLevel.hard.rawValue
        }
	}
    
    
    init(){
        self.category = ""
        self.difficulty = ""
        self.question  = ""
        self.type = ""
        self.points = 0
        self.isSolved  = false
        self.answers = []
    }
    func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if category != nil{
        	dictionary["category"] = category
        }
        
        if difficulty != nil{
        	dictionary["difficulty"] = difficulty
        }
        if question != nil{
        	dictionary["question"] = question
        }
        if type != nil{
        	dictionary["type"] = type
        }
		return dictionary
	}

}
struct Answer {
    
    var answer:String!
    var isCorrect:Bool = false
    
    
}

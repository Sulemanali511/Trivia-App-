//
//  CDManager.swift
//  Trivia app
//
//  Created by Suleman Ali on 4/12/20.
//  Copyright © 2020 Suleman Ali. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON
import UIKit

class CDManager: NSObject {
    
//    static var usersList:[UsersListModel]?
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    class var context : NSManagedObjectContext {
        return getContext()
    }
    class func fetchUser()-> [GamePlayerSession]{
        let context = getContext()
        let fetchRequest:NSFetchRequest<GamePlay> = GamePlay.fetchRequest()
        var obj:[GamePlayerSession] = []
        do {
            let team = try context.fetch(fetchRequest)
            for session in team {
                var quest:[Question] = []
                var sess = GamePlayerSession(username: session.username ?? "", Mode: session.gamemode ?? "", questions: [])

                if  let DbQuestion = session.questions?.allObjects as? [Questions] {
                    for question in  DbQuestion  {
                        var ques = Question()
                        ques.category = question.category
                        ques.difficulty = question.difficulty
                        ques.question = question.question
                        ques.isSolved = question.isSolved
                        
                        ques.points = Int(question.points)
                        if question.isSolved {
                            sess.points  = sess.points + Int(question.points)
                        }
                        var ans:[Answer] = []
                        if let DbAns = question.answers?.allObjects as? [Answers] {
                            for ansers in DbAns{
                                var anwser = Answer()
                                anwser.answer = ansers.statement
                                anwser.isCorrect = ansers.isCorrect
                                ans.append(anwser)
                            }
                        }
                        ques.answers = ans
                        quest.append(ques)
                    }
                    
                }
                sess.questions = quest
                obj.append(sess)
            }
             obj.sort(by: {
                $0.points < $1.points
            })
            return obj
        }catch {
            return obj
        }
    }
    class func saveUsersListInDB(session:GamePlayerSession){
        
        
        if session.questions.count > 0 {
            let currentUser = GamePlay(context: context)
            currentUser.username = session.username
            currentUser.gamemode = session.Mode
            for quest in session.questions {
                let question = Questions(context: context)
                question.category = quest.category
                question.difficulty = quest.difficulty
                question.points = Int16(quest.points)
                question.question = quest.question
                question.category = quest.category
                question.isSolved = quest.isSolved
                
                for ans in quest.answers {
                    let answers = Answers(context: context)
                    answers.statement = ans.answer
                    answers.isCorrect = ans.isCorrect
                    question.addToAnswers(answers)
                }
                
                currentUser.addToQuestions(question)
            }
            
            
            do {
                try context.save()
                AppManager.shared.Session = GamePlayerSession(username: "", Mode: "", questions: [])
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    /*
    class func fetchUsersList() -> [UsersListModel]? {
        let context = getContext()
        let fetchRequest:NSFetchRequest<UsersList> = UsersList.fetchRequest()
        var obj:[UsersListModel]?
        
        do {
            let team = try context.fetch(fetchRequest)
            
            var arr = [UsersListModel]()
            
            for obj in team{
                arr.append(UsersListModel(managedObject: obj))
            }
            obj = arr
            return obj
            
        }catch {
            return obj
        }
    }
   
   
    
    //MARK: - Clients
    
    class func saveClientsInDB(with json: JSON){
        let clientMangedObj = Clients(context: context)
        
        clientMangedObj.canEditOrDelete = json["canEditOrDelete"].boolValue
        clientMangedObj.createdBy = json["createdBy"].stringValue
        clientMangedObj.website = json["website"].stringValue
        clientMangedObj.createdOn = json["createdOn"].stringValue
        clientMangedObj.latitude = json["latitude"].doubleValue
        clientMangedObj.email = json["email"].stringValue
        clientMangedObj.longitude = json["longitude"].doubleValue
        clientMangedObj.address = json["address"].stringValue
        clientMangedObj.id = json["id"].stringValue
        clientMangedObj.organizationName = json["organizationName"].stringValue
        clientMangedObj.mobileNumber = json["mobileNumber"].stringValue
        clientMangedObj.logoURL = json["logoURL"].stringValue
        
        clientMangedObj.noOfFollowup = json["noOfFollowup"].stringValue
        clientMangedObj.noOfUpcomingMeeting = json["noOfUpcomingMeeting"].stringValue
        clientMangedObj.city = json["city"].stringValue
        
        clientMangedObj.addToCreatorDetails((CDManager.saveCreaterDetails(with: json["creatorDetails"])))
        
        for clientMembersJson in json["members"].arrayValue {
            let membersMangedObj = ClientMembers(context: context)
            membersMangedObj.mobileNumber = clientMembersJson["mobileNumber"].stringValue
            membersMangedObj.firstName = clientMembersJson["firstName"].stringValue
            membersMangedObj.lastName = clientMembersJson["lastName"].stringValue
            membersMangedObj.createdBy = clientMembersJson["createdBy"].stringValue
            membersMangedObj.username = clientMembersJson["username"].stringValue
            membersMangedObj.updatedBy = clientMembersJson["updatedBy"].stringValue
            membersMangedObj.updatedOn = clientMembersJson["updatedOn"].stringValue
            membersMangedObj.clientId = clientMembersJson["clientId"].stringValue
            membersMangedObj.password = clientMembersJson["password"].stringValue
            membersMangedObj.createdOn = clientMembersJson["createdOn"].stringValue
            membersMangedObj.isdeleted = clientMembersJson["isDeleted"].boolValue
            membersMangedObj.email = clientMembersJson["email"].stringValue
            membersMangedObj.id = clientMembersJson["id"].stringValue
            clientMangedObj.addToClientMembers(membersMangedObj)
            
            membersMangedObj.addToCreatorDetails((CDManager.saveCreaterDetails(with: clientMembersJson["userDetails"])))
            
        }
        
        
        do {
            try context.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    class func fetchClients() -> [ClientModel]? {
        let context = getContext()
        let fetchRequest:NSFetchRequest<Clients> = Clients.fetchRequest()
        var arr = [ClientModel]()
        
        do {
            let team = try context.fetch(fetchRequest)
            for obj in team{
                arr.append(ClientModel(managedObject: obj))
            }
            return arr
        }catch {
            return arr
        }
    }
    
    
    
    
    //MARK: - Reset
    class func isDataExistsForEntity(entityName: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        //fetchRequest.includesSubentities = false
        
        var entitiesCount = 0
        
        do {
            entitiesCount = try context.count(for: fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        print(entitiesCount)
        
        return entitiesCount > 0
    }
    
    class func resetAllRecords(in entity : String) // entity = Your_Entity_Name
    {
        /* let context = getContext()
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
         fetchRequest.returnsObjectsAsFaults = false
         
         do
         {
         let results = try context.fetch(fetchRequest)
         for managedObject in results
         {
         let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
         context.delete(managedObjectData)
         }
         } catch let error as NSError {
         print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
         }
         
         let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
         let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
         do
         {
         try context.execute(deleteRequest)
         try context.save()
         }
         catch
         {
         print ("There was an error")
         }*/
        
        let context = getContext()
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            print ("There was an error")
        }
        
        
    }
    
    class func someEntityExists(id: String,entityName:String,requestedId:String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(requestedId) = %@", id)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try context.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.count > 0
    }
    */
}

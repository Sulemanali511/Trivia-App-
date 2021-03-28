//
//  ViewController.swift
//  Trivia app
//
//  Created by Suleman Ali on 28/03/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var MainTableView: UITableView!
    ///Game Question Categoreis
    var Categories:[Category] = []
    ///Game Question Levels
    var Level:[Category] = []
    ///Default Selection of Level
    var selectedLevel:Int = 0
    /// Default selection of Level
    var selectedQuestionType:Int = 0
    /// Default selection of Category
    var selectedCate:Int = 0
    ///Question Types
    var QuestionType:[Category] = []
        
       
    override func viewDidLoad() {
        super.viewDidLoad()
        clearNavigation()
        addNavigationBackButton()
        MainTableView.delegate = self
        MainTableView.dataSource = self
        self.MainTableView.register(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "HeaderTableViewCell")
        self.MainTableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
        self.MainTableView.register(UINib(nibName: "LevelTableViewCell", bundle: nil), forCellReuseIdentifier: "LevelTableViewCell")
        self.MainTableView.register(UINib(nibName: "PlayActionTableViewCell", bundle: nil), forCellReuseIdentifier: "PlayActionTableViewCell")
        
        
        ///Adding Game Question Categories
        Categories.append(Category(id:"9" ,name: "General Knowledge",description: "General Knowledge",imageName: "gk",ColorName: UIColor.random().hexString()))
        Categories.append(Category(id:"17",name: "Science",description: "Nature",imageName: "Nature2",ColorName: UIColor.random().hexString()))
        Categories.append(Category(id:"18",name: "Science",description: "Computers",imageName: "Computers",ColorName: UIColor.random().hexString()))
        Categories.append(Category(id:"19",name: "Science",description: "Mathematics",imageName: "Math",ColorName: UIColor.random().hexString()))
        Categories.append(Category(id:"21",name: "Sports",description: "Sports",imageName: "Sports",ColorName: UIColor.random().hexString()))
        Categories.append(Category(id:"22",name: "Geography",description: "Geography",imageName: "Geography",ColorName: UIColor.random().hexString()))
        Categories.append(Category(id:"25",name: "Art",description: "Art",imageName: "Art",ColorName: UIColor.random().hexString()))
        Categories.append(Category(id:"26",name: "Celebrities",description: "Celebrities",imageName: "Celebrities",ColorName: UIColor.random().hexString()))
        Categories.append(Category(id:"27",name: "Animals",description: "Animals",imageName: "Animals",ColorName: UIColor.random().hexString()))
        Categories.append(Category(id:"28",name: "Vehicles",description: "Vehicles",imageName: "Vehicles",ColorName: UIColor.random().hexString()))
        
        ///Adding Game Question Levels
        Level.append(Category(id:"easy",name: "Easy",description: "Easy",ColorName: "#33FF99FF"))
        Level.append(Category(id:"medium",name: "Medium",description: "Medium",ColorName: "#EEAE02FF"))
        Level.append( Category(id:"hard",name: "Hard",description: "Hard",ColorName: "#420420FF"))
        ///Adding Question Types
        QuestionType = [Category(id: "multiple", name: "Multiple Choice",description: "Multiple Choice" ,imageName: "MultipleChoice",ColorName: "#C9152EFF"),
                        Category(id: "boolean", name: "True False",description: "True False" ,imageName: "truefalse",ColorName: "#8BBEF4FF")]
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            ///Category type cell
            let cell =  self.MainTableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
            cell.CellType = .Cate
            cell.SelectedIndex = self.selectedCate
            cell.Categories = self.Categories
            cell.selectionStyle = .none
            
            cell.didSelectedItem = { (index) in
                self.selectedCate = index
            }
            return cell
        }
        else if indexPath.section == 1 {
            ///levels type cell
            let cell =  self.MainTableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
            cell.SelectedIndex = self.selectedLevel
            cell.CellType = .Level
            cell.Categories = self.Level
            cell.selectionStyle = .none
            cell.didSelectedItem = { (index) in
                self.selectedLevel = index
            }
            return cell
        }
        else if indexPath.section == 2 {
            ///Questions type cell
            let cell =  self.MainTableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
            cell.SelectedIndex = self.selectedQuestionType
            cell.CellType = .QType
            cell.Categories = self.QuestionType
            cell.selectionStyle = .none
            cell.didSelectedItem = { (index) in
                self.selectedQuestionType = index
            }
            return cell
        }
        else {
            ///play cell
        let cell =  self.MainTableView.dequeueReusableCell(withIdentifier: "PlayActionTableViewCell") as! PlayActionTableViewCell
            cell.didTapped  = {
                self.playGame()
            }
        return cell
    }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 || indexPath.section == 2
        {
            return 250
        }
        else if indexPath.section == 1{
            return 180
        }
        else  {
            return 130
        }
    }
    func playGame(){
        print(self.selectedLevel,self.selectedQuestionType,self.selectedCate)
        let params:[String:Any] = ["amount":10,"category":self.Categories[selectedCate].id ?? 0,"difficulty":self.Level[selectedLevel].id ?? 0,"type":QuestionType[selectedQuestionType].id ?? "easy"]
        AppManager.shared.GameParams = params
        AppManager.shared.Session.Mode = "Classic"
        //       let vc = storyboard?.instantiateViewController(withIdentifier: "AllertViewController") as! AllertViewController
        //        vc.DescriptionString = """
        //a.    Easy questions have 1 Point  
        //b.    Medium questions have 2 Points  
        //c.    Hard questions have 3 Points  
        //"""
        //        vc.titleString = "Play Query"
        //        vc.modalTransitionStyle = .crossDissolve
        //        vc.modalPresentationStyle = .overCurrentContext
        //        self.present(vc, animated: true, completion: nil)
        self.performSegue(withIdentifier: "ClassicGame", sender: nil)
        
        //
        ////        amount=10&category=9&difficulty=easy&type=multiple
        //        ApiManager.getRequest(parameters:params, completion: {
        //            result in
        //            print(result)
        //        })
        
    }
}


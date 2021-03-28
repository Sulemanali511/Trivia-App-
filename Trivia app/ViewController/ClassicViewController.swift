//
//  ClassicViewController.swift
//  Trivia app
//
//  Created by Suleman Ali on 28/03/2021.
//

import UIKit

class ClassicViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet weak var lblQuestionStatement: UILabel!
    @IBOutlet weak var QuestionAnswerCV: UICollectionView!
  
    @IBOutlet weak var lblPoints: UILabel!
    
   var live = 1
    var points:Int = 0{
        didSet{
            lblPoints.text = "Points:\(points)"
        }
    }
    var CurrentQuestion:Int = 0 {
        didSet{
           
            if ((CurrentQuestion%8) == 0) && (CurrentQuestion >= 8) {
                loadQuestion()
            }
            if CurrentQuestion < self.Questions.count
            {
                QuestionAnswerCV.isUserInteractionEnabled = true
                isAnswerGiven = false
                lblQuestionStatement.text = self.Questions[CurrentQuestion].question
                QuestionAnswerCV.reloadData()
            }
        }
    }
    var isAnswerGiven:Bool = false
    var Questions:[Question] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        AppManager.shared.Session.Mode = "Classic"
        clearNavigation()
        self.navigationItem.hidesBackButton = true
        loadQuestion()
        setupUI()
        
        
    }
    func setupUI(){
        QuestionAnswerCV.delegate = self
        QuestionAnswerCV.dataSource = self
       lblPoints.text = "Points:\(points)"
        lblQuestionStatement.text = ""
        self.QuestionAnswerCV.register(UINib(nibName: "MultipleAnswerCV", bundle: nil), forCellWithReuseIdentifier: "MultipleAnswerCV")
        self.QuestionAnswerCV.register(UINib(nibName: "BoolAnswerCV", bundle: nil), forCellWithReuseIdentifier: "BoolAnswerCV")
        if self.Questions.count > 0 {
        lblQuestionStatement.text = self.Questions[CurrentQuestion].question
        }
    }
    
    
   func loadQuestion(){
    let params = AppManager.shared.GameParams
    ApiManager.getRequest(parameters: params, completion: {
        result in
        switch (result){
        case .success(let respo):
        for Quest in respo["results"].arrayValue {
            self.Questions.append(Question(fromJson: Quest))
        }
            if respo["results"].arrayValue.count == 0{
                self.GameOver(title: "No More Question", message: "Sorry Questions are ended to Setup for Now")
            }
            
            self.Loaded()
        case .failure(let error):
            self.GameOver(title: "No More Question", message: "Sorry Questions Not Setup for Now")
            
        print(error.localizedDescription)
        }
        
    })
    }
    func Loaded(){
        if self.Questions.count > 0 {
            lblQuestionStatement.text = self.Questions[CurrentQuestion].question
            QuestionAnswerCV.reloadData()
            
        }
        
    }
    func GameOver(title:String =  "Game Over",message:String = "Your game is over you play well but unfortunatly you lose all you lives"){
        
       let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel, handler: {
            _ in
            self.navigationController?.popToRootViewController(animated: true)
        })
        CDManager.saveUsersListInDB(session: AppManager.shared.Session)
        vc.addAction(action)
        self.present(vc, animated: true, completion: nil)
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       if  self.Questions.count > 0 {
            return Questions[CurrentQuestion].answers.count
        }
        else {
            return 0
        }
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if Questions[CurrentQuestion].type == "boolean" {
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "BoolAnswerCV", for: indexPath) as! BoolAnswerCV
            cell.lblAnswer.text = Questions[CurrentQuestion].answers[indexPath.row].answer
            if Questions[CurrentQuestion].answers[indexPath.row].answer == "True"{
                cell.ImageView.image = UIImage(named:"ic_true")!
            }
            else {
                cell.ImageView.image = UIImage(named:"ic_false")!
            }
            cell.bgView.backgroundColor = UIColor(named: "blueAppColor")
            return cell
        }
        else {
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "MultipleAnswerCV", for: indexPath) as! MultipleAnswerCV
            cell.lblAnswer.text = Questions[CurrentQuestion].answers[indexPath.row].answer
            cell.bgView.backgroundColor = UIColor(named: "blueAppColor")
            
            return cell
        }
       
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width  = CGFloat(UIScreen.main.bounds.width)
        var height = CGFloat(200)
       if Questions[CurrentQuestion].type == "boolean"
        {
        
            return CGSize(width: CGFloat(width/2), height: height)
        }
        height = 80
        return CGSize(width: width, height: height);

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        isAnswerGiven = true
        QuestionAnswerCV.isUserInteractionEnabled = false
        if  Questions[CurrentQuestion].answers[indexPath.row].isCorrect {
            if let  cell = collectionView.cellForItem(at: indexPath) as? MultipleAnswerCV{
                cell.bgView.backgroundColor = .green
            }
            else if let  cell = collectionView.cellForItem(at: indexPath) as? BoolAnswerCV{
                cell.bgView.backgroundColor = .green
            }
            
            points = points + Questions[CurrentQuestion].points
            Questions[CurrentQuestion].isSolved = true
            
            
            
        }else {
            if let  cell = collectionView.cellForItem(at: indexPath) as? MultipleAnswerCV{
                cell.bgView.backgroundColor = .red
                live = live - 1
                
            }
            else if let  cell = collectionView.cellForItem(at: indexPath) as? BoolAnswerCV{
                cell.bgView.backgroundColor = .red
                live = live - 1
                
            }
            Questions[CurrentQuestion].isSolved = false
        }
        AppManager.shared.Session.questions.append(self.Questions[self.CurrentQuestion])
        
        if live > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                
                
                self.CurrentQuestion = self.CurrentQuestion + 1
            })
        }else {
            GameOver()
        }
    }
       
    
}

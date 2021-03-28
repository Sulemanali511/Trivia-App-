//
//  QuickModeViewController.swift
//  Trivia app
//
//  Created by Suleman Ali on 28/03/2021.
//

import UIKit

class QuickModeViewController: UIViewController,SelfTimerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
   
    
   
    var isFirst:Bool = true
    @IBOutlet weak var lblQuestionStatement: UILabel!
    @IBOutlet weak var QuestionAnswerCV: UICollectionView!
    @IBOutlet weak var lblLives: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    var Lives:Int = 3{
        didSet{
            lblLives.text = "🧑‍🏫:\(Lives)"
        }
    }
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
                countdownView.start()
            }
        }
    }
    var isAnswerGiven:Bool = false
    @IBOutlet weak var countdownView: SelfTimerView!
    var Questions:[Question] = []
    override func viewDidLoad() {
        AppManager.shared.Session.Mode = "Quick"
        super.viewDidLoad()
        clearNavigation()
        self.navigationItem.hidesBackButton = true
        QuestionAnswerCV.delegate = self
        QuestionAnswerCV.dataSource = self
        loadQuestion()
        setupUI()
        
        
    }
    func setupUI(){
        lblLives.text = "🧑‍🏫:\(Lives)"
        lblPoints.text = "Points:\(points)"
        countdownView.delegate = self
        countdownView.EndText = "00:00"
        countdownView.timeLeft = 5
        countdownView.lineWidth = 5
        countdownView.setupUI()
        countdownView.stop()
        countdownView.lineColor = .yellow
        countdownView.TimerLabelFont = UIFont(name:"MarkerFelt-Wide",size: 32)!
        countdownView.timeLabel.adjustsFontSizeToFitWidth = true
        lblQuestionStatement.text = ""
        self.QuestionAnswerCV.register(UINib(nibName: "MultipleAnswerCV", bundle: nil), forCellWithReuseIdentifier: "MultipleAnswerCV")
        self.QuestionAnswerCV.register(UINib(nibName: "BoolAnswerCV", bundle: nil), forCellWithReuseIdentifier: "BoolAnswerCV")
        if self.Questions.count > 0 {
        lblQuestionStatement.text = self.Questions[CurrentQuestion].question
        }
    }
    
    
   func loadQuestion(){
    let params = ["amount":10]
    ApiManager.getRequest(parameters: params, completion: {
        result in
        switch (result){
        case .success(let respo):
        for Quest in respo["results"].arrayValue {
            self.Questions.append(Question(fromJson: Quest))
        }
            if self.isFirst  && respo["results"].arrayValue.count > 0{
                self.isFirst = false
                
            }
            self.Loaded()
        case .failure(let error):
        print(error.localizedDescription)
        }
        
    })
    }
    func Loaded(){
        if self.Questions.count > 0 {
            lblQuestionStatement.text = self.Questions[CurrentQuestion].question
            countdownView.start()
            QuestionAnswerCV.reloadData()
            
        }
        
    }
    func GameOver(title:String =  "Game Over",message:String = "Your game is over you play well but unfortunatly you lose all you lives"){
        countdownView.stop()
        countdownView.EndText = title
        countdownView.timeLabel.text = title
        CDManager.saveUsersListInDB(session: AppManager.shared.Session)
       let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel, handler: {
            _ in
            self.navigationController?.popToRootViewController(animated: true)
        })
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
        countdownView.stop()
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
            self.Questions[self.CurrentQuestion].isSolved = true
            
        }else {
            if let  cell = collectionView.cellForItem(at: indexPath) as? MultipleAnswerCV{
                cell.bgView.backgroundColor = .red
                Lives = Lives - 1
            }
            else if let  cell = collectionView.cellForItem(at: indexPath) as? BoolAnswerCV{
                cell.bgView.backgroundColor = .red
                Lives = Lives - 1
            }
            self.Questions[self.CurrentQuestion].isSolved = false
        }
        AppManager.shared.Session.questions.append(self.Questions[self.CurrentQuestion])
        if Lives >= 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.CurrentQuestion = self.CurrentQuestion + 1
            })
        }
        else {
            GameOver()
        }
       
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func didStart() {
        print("didStart")
    }
    func didEnd() {
        print("didEnd")
        if !isAnswerGiven {
            Lives = Lives - 1
            QuestionAnswerCV.isUserInteractionEnabled = false
            AppManager.shared.Session.questions.append(self.Questions[self.CurrentQuestion])
        }
        
        if Lives >= 1 {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.CurrentQuestion = self.CurrentQuestion + 1
        })
        }
        else {
            GameOver()
        }
    }
    
    func didPause() {
        print("didPause")
    }
    
    func didUpdate(newValue: TimeInterval) {
        print(newValue)
    }
}

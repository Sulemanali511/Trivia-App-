//
//  HistoryViewController.swift
//  Trivia app
//
//  Created by Suleman Ali on 28/03/2021.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    let UserSession:[GamePlayerSession] = CDManager.fetchUser()
    @IBOutlet weak var HistoryTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        clearNavigation()
        addNavigationBackButton()
        HistoryTable.delegate = self
        HistoryTable.dataSource = self
        HistoryTable.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserSession.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell") as! HistoryTableViewCell
        if indexPath.row > 0 {
            cell.lblMode.text = UserSession[indexPath.row - 1].Mode
            cell.lblName.text = UserSession[indexPath.row - 1].username
            cell.lblScore.text = "\(UserSession[indexPath.row - 1].points)"
            if UserSession[indexPath.row - 1].Mode == "Classic" {
                cell.Category.text = UserSession[indexPath.row - 1].questions.first?.category ?? "Any"
                cell.Category.adjustsFontSizeToFitWidth = true
            }
            else {
                cell.Category.text =  "Any"
            }
        }
        return cell
    }
    
    
}

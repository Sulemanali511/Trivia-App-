//
//  LandingViewController.swift
//  Trivia app
//
//  Created by Suleman Ali on 28/03/2021.
//

import UIKit

class LandingViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var nameView: CustomView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        clearNavigation()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtName.text = ""
    }
    @IBAction func btnActionStart(_ sender: UIButton) {
        
        if (txtName.text ?? "").isEmpty {
            nameView.shake()
            nameView.borderColor = .red
        }else {
            AppManager.shared.Session.username = txtName.text ?? ""
            performSegue(withIdentifier: "PlayAction", sender: self)
        }
        
    }
    
    @IBAction func CheckRecords(_ sender: UIButton) {
        self.performSegue(withIdentifier: "CheckHistory", sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

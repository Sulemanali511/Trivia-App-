//
//  MenuViewController.swift
//  Trivia app
//
//  Created by Suleman Ali on 28/03/2021.
//

import UIKit

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearNavigation()
        addNavigationBackButton()
        // Do any additional setup after loading the view.
    }
    
   
    @IBOutlet weak var QuickModeView: CustomView!
    @IBOutlet weak var ClassicModeView: CustomView!
    @IBAction func btnActionClassicMode(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "ClassicMode", sender: nil)
    }
    @IBAction func btnActionQuickMode(_ sender: UIButton) {
        //        "QuickPlay"
        self.performSegue(withIdentifier: "QuickPlay", sender: nil)
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

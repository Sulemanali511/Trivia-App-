//
//  AllertViewController.swift
//  Trivia app
//
//  Created by Suleman Ali on 28/03/2021.
//

import UIKit

class AllertViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var titleString:String!
    @IBOutlet weak var nextView: UIView!
    @IBOutlet weak var nextButtonIcon: UIImageView!
    var DescriptionString:String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textView.text = DescriptionString
        if DescriptionString.count > 300{
            textView.translatesAutoresizingMaskIntoConstraints = true
            textView.sizeToFit()
            textView.isScrollEnabled = true
        }
        else {
            textView.translatesAutoresizingMaskIntoConstraints = true
            textView.sizeToFit()
            textView.isScrollEnabled = false
        }
        let blurEffect = UIBlurEffect(style: .light)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = view.bounds
        self.view.insertSubview(blurVisualEffectView,at:0)
    }
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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

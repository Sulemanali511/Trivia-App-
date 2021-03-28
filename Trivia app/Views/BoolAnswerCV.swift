//
//  BoolAnswerCV.swift
//  Trivia app
//
//  Created by Suleman Ali on 28/03/2021.
//

import UIKit

class BoolAnswerCV: UICollectionViewCell {

    @IBOutlet weak var cellWidth: NSLayoutConstraint!
    @IBOutlet weak var bgView: CustomView!
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        cellWidth.constant = (UIScreen.main.bounds.width/2 - 20)
        bgView.backgroundColor = UIColor(named: "blueAppColor")
        // Initialization code
    }

}

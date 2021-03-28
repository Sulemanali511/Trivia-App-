//
//  MultipleAnswerCV.swift
//  Trivia app
//
//  Created by Suleman Ali on 28/03/2021.
//

import UIKit

class MultipleAnswerCV: UICollectionViewCell {

    @IBOutlet weak var cellWidth: NSLayoutConstraint!
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var bgView: CustomView!
    override func awakeFromNib() {
        super.awakeFromNib()
        cellWidth.constant = (UIScreen.main.bounds.width - 10)
        bgView.backgroundColor = UIColor(named: "blueAppColor")
        // Initialization code
    }

}

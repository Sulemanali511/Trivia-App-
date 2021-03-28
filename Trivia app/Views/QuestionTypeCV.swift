//
//  QuestionTypeCV.swift
//  Trivia app
//
//  Created by Suleman Ali on 28/03/2021.
//

import UIKit

class QuestionTypeCV: UICollectionViewCell {
    @IBOutlet weak var selectedView: CustomView!
    @IBOutlet weak var cellWidth: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ChoiceImage: UIImageView!
    var QuestioType:Category!{
        didSet{
            lblTitle.text = QuestioType.name
            bgView.backgroundColor = UIColor(hexStr:  QuestioType.ColorName)
            if QuestioType.ColorName == "#C9152EFF" {
                lblTitle.textColor = .white
            }else{
                lblTitle.textColor = .black
            }
            ChoiceImage.image = UIImage(named: QuestioType.imageName)
            cellWidth.constant = UIScreen.main.bounds.width/2
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectedView.isHidden = false
            } else {
                selectedView.isHidden = true
            }
        }
    }
}


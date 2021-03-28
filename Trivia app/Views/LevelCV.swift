//
//  LevelCV.swift
//  Trivia app
//
//  Created by Suleman Ali on 28/03/2021.
//

import UIKit

class LevelCV: UICollectionViewCell {

    
    @IBOutlet weak var Start1IV: UIImageView!
    @IBOutlet weak var Start2IV: UIImageView!
    @IBOutlet weak var Start3IV: UIImageView!
    @IBOutlet weak var DificultStar: UIView!
    @IBOutlet weak var MediumStart: UIView!
    @IBOutlet weak var easyStart: UIView!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var bgView: UIView!
//    @IBOutlet weak var cellwiedth: NSLayoutConstraint!
 
    @IBOutlet weak var levelName: UILabel!
    var category:Category!{
        didSet{
            levelName.text = category.name
            bgView.backgroundColor = UIColor(hexStr: category.ColorName)
            levelName.textColor = .white
           
            if category.ColorName == "#33FF99FF"
            {
                levelName.textColor = .black
            }
            if category.id == "easy"{
                Start1IV.tintColor = .black
                Start2IV.tintColor = .black
                MediumStart.isHidden = true
                DificultStar.isHidden = true
            }
            else if category.id == "medium"{
                Start1IV.tintColor = .black
                Start3IV.tintColor = .black
                MediumStart.isHidden = true
                DificultStar.isHidden = false
                easyStart.isHidden = false

            }
            else {
                Start1IV.tintColor = .systemOrange
                Start2IV.tintColor = .systemOrange
                Start3IV.tintColor = .systemOrange
                easyStart.isHidden = false
                MediumStart.isHidden = false
                DificultStar.isHidden = false
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
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

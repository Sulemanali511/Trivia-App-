//
//  CategoryCollectionViewCell.swift
//  Trivia app
//
//  Created by Suleman Ali on 28/03/2021.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var SelectedView: CustomView!
    @IBOutlet weak var CategoryImage: UIImageView!
    @IBOutlet weak var lblCategoryDesc: UILabel!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var bgView: CustomView!
    
    var category:Category!{
        didSet{
            lblCategoryDesc.text = category.descriptionField
            lblCategoryName.text = category.name
            CategoryImage.image = UIImage(named: category.imageName)
            bgView.backgroundColor = UIColor(hexString:category.ColorName)
            let value = Functions.checkColorBrightness(hexString: category.ColorName)
            if value < 100 {
                lblCategoryDesc.textColor = .white
                lblCategoryName.textColor = .white
            }else{
                lblCategoryDesc.textColor = .black
                lblCategoryName.textColor = .black
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override var isSelected: Bool {
        didSet {
            
            if isSelected {
                SelectedView.isHidden = false
            } else {
                SelectedView.isHidden = true
            }
        }
    }
}

//
//  PlayActionTableViewCell.swift
//  Trivia app
//
//  Created by Suleman Ali on 28/03/2021.
//

import UIKit

class PlayActionTableViewCell: UITableViewCell {
    @IBOutlet weak var bgView: CustomView!
    var didTapped:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        bgView.applyGradient(colours: [UIColor(named: "ThemeColor")!,UIColor(named: "GreenColour")!])
    }

    @IBAction func btnActionPlay(_ sender: UIButton) {
        didTapped?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

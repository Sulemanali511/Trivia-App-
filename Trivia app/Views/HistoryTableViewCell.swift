//
//  HistoryTableViewCell.swift
//  Trivia app
//
//  Created by Suleman Ali on 28/03/2021.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var lblScore: UILabel!
    
    @IBOutlet weak var Category: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMode: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

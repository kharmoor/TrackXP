//
//  BudgetGroupItemTableViewCell.swift
//  CheckNow
//
//  Created by Khari Moore on 3/1/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import UIKit

class BudgetGroupItemTableViewCell: UITableViewCell {

    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var DescriptionText: UITextView!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  BudgetHeaderTableViewCell.swift
//  CheckNow
//
//  Created by Khari Moore on 4/23/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import UIKit

class BudgetHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var DateLabel: UILabel!
    
    @IBOutlet weak var AddTransactionButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}

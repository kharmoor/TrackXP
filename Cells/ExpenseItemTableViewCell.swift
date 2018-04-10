//
//  ExpenseItemTableViewCell.swift
//  CheckNow
//
//  Created by Khari Moore on 11/26/17.
//  Copyright © 2017 Khari Moore. All rights reserved.
//

import UIKit

class ExpenseItemTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var ExpenseNameLabel: UILabel!
    @IBOutlet weak var ExpenseAmountLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

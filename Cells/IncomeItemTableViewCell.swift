//
//  IncomeItemTableViewCell.swift
//  CheckNow
//
//  Created by Khari Moore on 2/14/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import UIKit

class IncomeItemTableViewCell: UITableViewCell {
    @IBOutlet weak var IncomeNameLabel: UILabel!
    @IBOutlet weak var IncomeAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  TransactionItemTableViewCell.swift
//  CheckNow
//
//  Created by Khari Moore on 2/25/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import UIKit

class TransactionItemTableViewCell: UITableViewCell {

  
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

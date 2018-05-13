//
//  BudgetHeaderTableViewCell.swift
//  CheckNow
//
//  Created by Khari Moore on 4/23/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import UIKit

protocol UserHeaderTableViewCellDelegate{
//    func didSelectUserHeaderTableViewCell(selected: Bool, userHeader: BudgetHeaderTableViewCell)
    func didEditUserHeaderTableViewCell(_ editing:Bool, userHeader: BudgetHeaderTableViewCell)
}

class BudgetHeaderTableViewCell: UITableViewCell {
    var delegate: UserHeaderTableViewCellDelegate?
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
    }
    
//    @IBAction func selectedHeader(sender: AnyObject){
//        delegate?.didSelectUserHeaderTableViewCell(selected: true, userHeader: self)
//    }

}

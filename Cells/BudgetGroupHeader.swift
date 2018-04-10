//
//  BudgetGroupHeader.swift
//  CheckNow
//
//  Created by Khari Moore on 2/19/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import UIKit

class BudgetGroupHeader: UIView {

    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var MainLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit()
    {
        contentView = Bundle.main.loadNibNamed("BudgetGroupHeader", owner: self, options: nil)?.first! as! UIView
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

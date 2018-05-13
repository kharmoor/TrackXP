//
//  BudgetSection.swift
//  CheckNow
//
//  Created by Khari Moore on 5/1/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import Foundation
class BudgetSection{
    var BudgetId: Int64
    var StartDate: Date
    
    init(budgetId: Int64, startDate: Date){
        self.BudgetId = budgetId
        self.StartDate = startDate
    }
}

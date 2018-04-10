//
//  Budget.swift
//  CheckNow
//
//  Created by Khari Moore on 3/25/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import Foundation

class Budget{
    var BudgetId: Int64?
    var startDate: Date
    var budgetGroup: BudgetGroup?
    var FinancialTransactions = [FinancialTransaction]()
    
    init(budgetId: Int64?,startDate: Date, budgetGroup: BudgetGroup?) {
        self.BudgetId = budgetId
        self.startDate = startDate
        self.budgetGroup = budgetGroup
    }
}

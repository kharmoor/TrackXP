//
//  BudgetGroupTransaction.swift
//  CheckNow
//
//  Created by Khari Moore on 3/11/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import Foundation
class BudgetGroupTransaction{
    var BudgetGroupId: Int64
    var FinancialTransactionTypeId: Int
    var SourceId: Int64
    
    init(budgetGroupId: Int64, financialTransactionType: Int, sourceId: Int64) {
        self.BudgetGroupId = budgetGroupId
        self.FinancialTransactionTypeId = financialTransactionType
        self.SourceId = sourceId
    }
}

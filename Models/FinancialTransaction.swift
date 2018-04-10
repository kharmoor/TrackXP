//
//  FinancialTransaction.swift
//  NextCheck
//
//  Created by Khari Moore on 6/11/17.
//  Copyright © 2017 Khari Moore. All rights reserved.
//

import Foundation
class FinancialTransaction {
    var FinancialTransactionID : Int64?
    var BudgetId: Int64
    var FinancialTransactionType : FinancialTransactionType
    var Description : String?
    var Amount: Decimal
    var TransactionDate: Date
    var Void: Bool
    var ParentId: Int64?
    init(financialTransactionID : Int64? = nil, budgetId: Int64, financialTransactionType : FinancialTransactionType, description : String?
        ,amount: Decimal, transactionDate: Date, void: Bool, parentId: Int64? = nil) {
        FinancialTransactionID = financialTransactionID
        BudgetId = budgetId
        FinancialTransactionType = financialTransactionType
        Description = description
        Amount = amount
        TransactionDate = transactionDate
        Void = void
        ParentId = parentId
    }
}

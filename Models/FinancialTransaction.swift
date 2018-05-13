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
    var Paid: Bool?
    init(financialTransactionID : Int64? = nil, budgetId: Int64, financialTransactionType : FinancialTransactionType, description : String?
        ,amount: Decimal, transactionDate: Date, void: Bool, paid: Bool? = false) {
        FinancialTransactionID = financialTransactionID
        BudgetId = budgetId
        FinancialTransactionType = financialTransactionType
        Description = description
        Amount = amount
        TransactionDate = transactionDate
        Void = void
        Paid = paid
    }
    
    func getDisplayAmount() -> String{
        if self.FinancialTransactionType == .Expense{
            if let paid = self.Paid, paid == true{
                return "\(self.Amount.asCurrency)"
            }else{
                return "-\(self.Amount.asCurrency)"
            }
        }
        return "+\(self.Amount.asCurrency)"
    }
}

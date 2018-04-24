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
    
    func getBalance() -> Decimal{
        let expenseTotal = self.FinancialTransactions.filter({!$0.Void && !($0.Paid ?? false) && $0.FinancialTransactionType == .Expense}).map({$0.Amount}).reduce(0, +)
        let incomeTotal = self.FinancialTransactions.filter({!$0.Void && $0.FinancialTransactionType == .Income}).map({$0.Amount}).reduce(0, +)
        
        return incomeTotal - expenseTotal
    }
}

//
//  File.swift
//  CheckNow
//
//  Created by Khari Moore on 3/30/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import Foundation
import SQLite

class BudgetRepo: RepoProtocol{

    
    typealias T = Budget
    
    static var db = SQLiteDataStore.sharedInstance.DB
    static let table = Table("Budget")
    
    static let budgetId = Expression<Int64>("BudgetId")
    static let budgetGroupId = Expression<Int64>("BudgetGroupId")
    static let startDate = Expression<Date>("StartDate")
    
    static func insert(item: T) throws -> Int64 {
        let rowid = try db.run(table.insert(startDate <- item.startDate, budgetGroupId <- (item.budgetGroup?.Id)!!))
        
        guard let budgetGroup = item.budgetGroup else{
            return rowid
        }

        for expense in budgetGroup.Expenses{
            let expenseTransaction = FinancialTransaction(budgetId: rowid, financialTransactionType: FinancialTransactionType.Expense, description: expense.Description, amount: expense.Amount, transactionDate: Date(), void: false)
            try TransactionRepo.insert(item: expenseTransaction)
        }
    
        for income in budgetGroup.Incomes{
            let incomeTransaction = FinancialTransaction(budgetId: rowid, financialTransactionType: FinancialTransactionType.Income, description: income.Note, amount: income.Amount, transactionDate: Date(), void: false)
            try TransactionRepo.insert(item: incomeTransaction)
         }
        
        return rowid
    }
    
    static func find(id: Int64) throws -> T? {
        let budget = table.filter(budgetId == id)
        
        guard let row = try db.pluck(budget)else{
            return nil
        }
        
        let bid = row[budgetId]
        let budgetGroupId = row[self.budgetGroupId]
        let startDate = row[self.startDate]
        
        let budgetGroup = try BudgetGroupRepo.find(id: budgetGroupId)
        
        return Budget(budgetId: bid, startDate: startDate, budgetGroup: budgetGroup)
    }
    static func findAll() throws -> [T]? {
        var budgets = [T]()
        
        for row in try db.prepare(table){
            
        let bid = row[budgetId]
        let startDate = row[self.startDate]
        
        var budget = Budget(budgetId: bid, startDate: startDate, budgetGroup: nil)
        
        budgets.append(budget)
            
        }
        
        return budgets
    }
    static func findMostRecent() throws -> [T]{
        var budgets = [T]()
        let today = Date()
        let budgetUpperDate = Calendar.current.date(byAdding: .day, value: 30, to: today)

        let query = table.filter(startDate <= budgetUpperDate!).order(startDate.desc).limit(2)

        for row in try db.prepare(query){
            let bid = row[budgetId]
            let budgetGroupId = row[self.budgetGroupId]
            let startDate = row[self.startDate]

            let budgetGroup = try BudgetGroupRepo.find(id: budgetGroupId)

            let budget = Budget(budgetId: bid, startDate: startDate, budgetGroup: budgetGroup)
            if let transactions = try TransactionRepo.findByBudgetId(id: bid){
                budget.FinancialTransactions += transactions
            }
             budgets.append(budget)
        }
        return budgets
    }
    
    static func delete(item: Budget) throws {
        
    }
    
    static func update(item: Budget) throws {
        
    }
    
    static func createTable() throws {
        do{
            try BudgetRepo.db.run(BudgetRepo.table.create(ifNotExists: true){
                table in
                table.column(BudgetRepo.budgetId, primaryKey: true)
                table.column(BudgetRepo.startDate)
                table.column(BudgetRepo.budgetGroupId)
            })
        }catch{
            print("Unable to create budget table")
            throw error
        }
    }
    
}

//
//  BudgetGroupRepo.swift
//  CheckNow
//
//  Created by Khari Moore on 3/11/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import Foundation
import SQLite
import os.log


class BudgetGroupRepo: RepoProtocol{
    typealias T = BudgetGroup
    
    static let ui_log = OSLog(subsystem: "com.example.NextCheck", category: "UI")
    
    static var db = SQLiteDataStore.sharedInstance.DB
    static let budgetGroupTable = Table("BudgetGroup")
    static let budgetItemTable = Table("BudgetGroupTransactions")
    
    //BudgetGroup
    static let BudgetGroupId = Expression<Int64>("BudgetGroupId")
    static let Name = Expression<String>("Name")
    static let Description = Expression<String?>("Description")
    static let Active = Expression<Bool>("Active")
    //BudgetGroupItem
    static let FinancialTransactionTypeId = Expression<Int>("FinancialTransactionTypeId")
    static let SourceId = Expression<Int64>("SourceId")
    
    static func insert(item: BudgetGroup) throws -> Int64 {
        let rowId = try db.run(budgetGroupTable.insert(Name <- item.Name, Description <- item.Description, Active <- item.Active))
        
        //insert expenses
        for expense in item.Expenses{
            let expenseTransaction = BudgetGroupTransaction(budgetGroupId: rowId, financialTransactionType: FinancialTransactionType.Expense.rawValue, sourceId: expense.ExpenseId!)
           try insertTransactions(item: expenseTransaction)
        }
        
        for income in item.Incomes{
            let incomeTransaction = BudgetGroupTransaction(budgetGroupId: rowId, financialTransactionType: FinancialTransactionType.Income.rawValue, sourceId: income.IncomeId!)
            try insertTransactions(item: incomeTransaction)
        }
        return rowId
    }
    
    static func insertTransactions(item: BudgetGroupTransaction) throws -> Void{
        try db.run(budgetItemTable.insert(BudgetGroupId <- item.BudgetGroupId, FinancialTransactionTypeId <- item.FinancialTransactionTypeId, SourceId <- item.SourceId))
    }
    
    static func update(item: BudgetGroup) throws {
        let query = budgetGroupTable.filter(BudgetGroupId == item.Id!)
        try db.run(query.update([Name <- item.Name,
                                 Description <- item.Description,
                                 Active <- item.Active]))
        for expense in item.Expenses{
            let budgetItemQuery = budgetItemTable.filter(BudgetGroupId == item.Id! && FinancialTransactionTypeId == FinancialTransactionType.Expense.rawValue && SourceId == expense.ExpenseId!)
            let row = try db.pluck(budgetItemQuery)
            if row == nil{
                let expenseTransaction = BudgetGroupTransaction(budgetGroupId: item.Id!, financialTransactionType: FinancialTransactionType.Expense.rawValue, sourceId: expense.ExpenseId!)
                try insertTransactions(item: expenseTransaction)
            }
        }
        for income in item.Incomes{
            let budgetItemQuery = budgetItemTable.filter(BudgetGroupId == item.Id! && FinancialTransactionTypeId == FinancialTransactionType.Income.rawValue && SourceId == income.IncomeId!)
            let row = try db.pluck(budgetItemQuery)
            if row == nil{
                let incomeTransaction = BudgetGroupTransaction(budgetGroupId: item.Id!, financialTransactionType: FinancialTransactionType.Income.rawValue, sourceId: income.IncomeId!)
                try insertTransactions(item: incomeTransaction)
            }
        }
    }
    
    static func delete(item: BudgetGroup) throws {
        
    }
    
    static func deleteBudgetTransaction(budgetGroupId: Int64, financialTransactionTypeId: Int, sourceId: Int64) throws -> Void{
        let query = budgetItemTable.filter(BudgetGroupId == budgetGroupId && FinancialTransactionTypeId == financialTransactionTypeId && SourceId == sourceId)
        
        try db.run(query.delete())
    }
    
    static func find(id: Int64) throws -> BudgetGroup? {
        let budgetGroupQuery = budgetGroupTable.filter(BudgetGroupId == id)
        let budgetItemQuery = budgetItemTable.filter(BudgetGroupId == id)
        
        guard let row = try db.pluck(budgetGroupQuery)else{
            return nil
        }
        
        let bid = row[BudgetGroupId]
        let name = row[Name]
        let active = row[Active]
        let description = row[Description]
        
        
        let budgetGroup = BudgetGroup(id: bid, name: name, active: active, description: description)
        
        for itemRow in try db.prepare(budgetItemQuery){
            let transactionTypeId = itemRow[FinancialTransactionTypeId]
            let sourceId = itemRow[SourceId]
            
            if transactionTypeId == FinancialTransactionType.Expense.rawValue{
                if let expense = try ExpenseRepo.find(id: sourceId)
                {
                    budgetGroup.Expenses.append(expense)
                }
            }else{
                if let income = try IncomeRepo.find(id: sourceId)
                {
                    budgetGroup.Incomes.append(income)
                }
            }
        }
        
        return budgetGroup
        
    }
    
    static func findAll() throws -> [T]? {
        var budgetGroups = [T]()
        for row in try db.prepare(budgetGroupTable){
            let bid = row[BudgetGroupId]
            let name = row[Name]
            let active = row[Active]
            let description = row[Description]
            
            let budgetGroup = BudgetGroup(id: bid, name: name, active: active, description: description)
            
            budgetGroups.append(budgetGroup)
        }
        
        return budgetGroups
    }
    
    static func createTable() throws {
        do {
            //create budget group table
            try BudgetGroupRepo.db.run(BudgetGroupRepo.budgetGroupTable.create(ifNotExists: true){
                 table in
                table.column(BudgetGroupRepo.BudgetGroupId, primaryKey: true)
                table.column(Name)
                table.column(Description)
                table.column(Active)
            })
            
            //create associated budget group transactions table
            try BudgetGroupRepo.db.run(BudgetGroupRepo.budgetItemTable.create(ifNotExists: true){
                table in
                table.column(BudgetGroupId)
                table.column(FinancialTransactionTypeId)
                table.column(SourceId)
            })
        } catch let e as NSError {
             os_log("Unable to create expense table: %@", log: BudgetGroupRepo.ui_log, type: .error,e.localizedDescription)
            throw e
        }
    }

}

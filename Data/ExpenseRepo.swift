//
//  ExpenseRepo.swift
//  CheckNow
//
//  Created by Khari Moore on 12/31/17.
//  Copyright © 2017 Khari Moore. All rights reserved.
//

import Foundation
import SQLite
import os.log

class ExpenseRepo : RepoProtocol{
    typealias T = Expense
    
    static let ui_log = OSLog(subsystem: "com.example.NextCheck", category: "UI")
    
    static var db = SQLiteDataStore.sharedInstance.DB
    static let table = Table("Expense")
    
    static let ExpenseId = Expression<Int64>("ExpenseId")
    static let Name = Expression<String>("Name")
    static let Description = Expression<String?>("Description")
    static let CategoryId = Expression<Int64?>("CategoryId")
    static let Amount = Expression<Int64>("Amount")
    
    
    static func insert(item: Expense) throws -> Int64 {
        let amount = item.Amount.asCurrencyInt64
        let rowid = try db.run(table.insert(Name <- item.Name, Description <- item.Description, CategoryId <- item.CategoryId, Amount <- amount))
        return rowid
    }
    static func update(item: Expense) throws {
        let query = table.filter(ExpenseId == item.ExpenseId!)
        let amount = item.Amount.asCurrencyInt64
        try db.run(query.update([ExpenseId <- item.ExpenseId!, Name <- item.Name, Description <- item.Description, CategoryId <- item.CategoryId, Amount <- amount]))
    }
    static func delete(item: Expense) throws {
        let query = table.filter(ExpenseId == item.ExpenseId!)
        try db.run(query.delete())
    }
    
    static func find(id: Int64) throws -> Expense? {
        //Prepare the query
        let query = table.filter(ExpenseId == id)
        
        //Execute my query in return a Row object
        
        guard let row = try db.pluck(query) else{
            return nil
        }
        
        let eid = row[ExpenseId]
        let name = row[Name]
        let desc = row[Description]
        let amount =  Decimal(row[Amount])/100
        let categoryId = row[CategoryId]
        
        return Expense(expenseId: eid, name: name, description: desc, categoryId: categoryId, amount: amount)
    }
    
    static func findAll() throws -> [T]? {
        var expenses = [T]()
        for row in try db.prepare(table) {
            let eid = row[ExpenseId]
            let name = row[Name]
            let desc = row[Description]
            let amount =  Decimal(row[Amount])/100
            let categoryId = row[CategoryId]

            let expense = Expense(expenseId: eid, name: name, description: desc, categoryId: categoryId, amount: amount)
            expenses.append(expense)
        }
        
        return expenses
    }
    
    static func createTable() throws{
        do{
            try ExpenseRepo.db.run(ExpenseRepo.table.create(ifNotExists: true){
                table in
                table.column(ExpenseRepo.ExpenseId, primaryKey: true)
                table.column(ExpenseRepo.Name)
                table.column(ExpenseRepo.Description)
                table.column(ExpenseRepo.CategoryId)
            })
        }catch let e as NSError{
            os_log("Unable to create expense table: %@", log: ExpenseRepo.ui_log, type: .error,e.localizedDescription)
             throw e
        }
    }
    
   
    
    
}

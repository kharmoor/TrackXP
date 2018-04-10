//
//  IncomeRepo.swift
//  CheckNow
//
//  Created by Khari Moore on 2/13/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import Foundation
import SQLite
import os.log

class IncomeRepo: RepoProtocol{
    typealias T = Income
    static let ui_log = OSLog(subsystem: "com.example.NextCheck", category: "UI")
    
    static var db = SQLiteDataStore.sharedInstance.DB
    static let table = Table("Income")
    
    static let IncomeId = Expression<Int64>("IncomeId")
    static let Name = Expression<String>("Name")
    static let Note = Expression<String?>("Note")
    static let CategoryId = Expression<Int64?>("CategoryId")
    static let Amount = Expression<Int64>("Amount")
    
    static func insert(item: Income) throws -> Int64 {
        let amount = item.Amount.asCurrencyInt64
        let rowid = try db.run(table.insert(Name <- item.Name, Note <- item.Note, CategoryId <- item.CategoryId, Amount <- amount))
        return rowid
    }
    
    static func update(item: Income) throws {
        let query = table.filter(IncomeId == item.IncomeId!)
        let amount = item.Amount.asCurrencyInt64
        try db.run(query.update([IncomeId <- item.IncomeId!, Name <- item.Name, Note <- item.Note, CategoryId <- item.CategoryId, Amount <- amount]))
    }
    
    static func delete(item: Income) throws {
        let query = table.filter(IncomeId == item.IncomeId!)
        let amount = item.Amount.asCurrencyInt64
        try db.run(query.update([IncomeId <- item.IncomeId!, Name <- item.Name, Note <- item.Note, CategoryId <- item.CategoryId, Amount <- amount]))
    }
    
    static func find(id: Int64) throws -> Income? {
        //Prepare the query
        let query = table.filter(IncomeId == id)
        
        //Execute my query in return a Row object
        
        guard let row = try db.pluck(query) else{
            return nil
        }
        
        let id = row[IncomeId]
        let name = row[Name]
        let note = row[Note]
        let amount =  Decimal(row[Amount])/100
        let categoryId = row[CategoryId]
        
        return Income(incomeId: id, name: name, note: note, categoryId: categoryId, amount: amount)
    }
    
    static func findAll() throws -> [Income]? {
        var incomes = [T]()
        for row in try db.prepare(table) {
            let id = row[IncomeId]
            let name = row[Name]
            let note = row[Note]
            let amount =  Decimal(row[Amount])/100
            let categoryId = row[CategoryId]
            
            let income = Income(incomeId: id, name: name, note: note, categoryId: categoryId, amount: amount)
            incomes.append(income)
        }
        
        return incomes
    }
    
    static func createTable() throws {
        do{
            try IncomeRepo.db.run(IncomeRepo.table.create(ifNotExists: true){
                table in
                table.column(IncomeRepo.IncomeId, primaryKey: true)
                table.column(IncomeRepo.Name)
                table.column(IncomeRepo.Amount)
                table.column(IncomeRepo.Note)
                table.column(IncomeRepo.CategoryId)
            })
        }catch let e as NSError{
            os_log("Unable to create income table: %@", log: IncomeRepo.ui_log, type: .error,e.localizedDescription)
            throw e
        }
    }
    
}

//
//  TransactionRepo.swift
//  CheckNow
//
//  Created by Khari Moore on 12/5/17.
//  Copyright © 2017 Khari Moore. All rights reserved.
//

import Foundation
import SQLite

class TransactionRepo : RepoProtocol{
    
    typealias T = FinancialTransaction
    
    static var db = SQLiteDataStore.sharedInstance.DB
    static let table = Table("FinancialTransaction")
    
    static let financialTransactionId = Expression<Int64>("FinancialTransactionId")
    static let budgetId = Expression<Int64>("BudgetId")
    static let financialTransactionTypeId = Expression<Int>("FinancialTransactionTypeId")
    static let financialTransactionDesc = Expression<String?>("Description")
    static let financialTransactionDate = Expression<Date>("TransactionDate")
    static let financialTransactionAmount = Expression<Int64>("Amount")
    static let financialTransactionVoid = Expression<Bool>("Void")
    static let financialTransactionPaid = Expression<Bool?>("Paid")
    
    static func insert(item: T) throws -> Int64 {
        let rowId = try db.run(table.insert(
                                       budgetId <- item.BudgetId,
                                       financialTransactionTypeId <- item.FinancialTransactionType.rawValue,
                                       financialTransactionDesc <- item.Description,
                                       financialTransactionDate <- item.TransactionDate,
                                       financialTransactionAmount <- item.Amount.asCurrencyInt64,
                                       financialTransactionVoid <- item.Void,
                                       financialTransactionPaid <- item.Paid
                                       ))
        return rowId
    }
    
    static func delete(item: T) throws {
        
    }
    static func update(item: FinancialTransaction) throws {
        let query = table.filter(financialTransactionId == item.FinancialTransactionID!)
        
        try db.run(query.update(financialTransactionId <- item.FinancialTransactionID!,
                                budgetId <- item.BudgetId,
                                financialTransactionTypeId <- item.FinancialTransactionType.rawValue,
                                financialTransactionDesc <- item.Description,
                                financialTransactionDate <- item.TransactionDate,
                                financialTransactionAmount <- item.Amount.asCurrencyInt64,
                                financialTransactionVoid <- item.Void,
                                financialTransactionPaid <- item.Paid))
    }
    static func find(id: Int64) throws -> T? {
       
        //Prepare the query
        let query = table.filter(financialTransactionId == id)
        
        //Execute my query in return a Row object
        
        guard let row = try db.pluck(query) else{
            return nil
        }
        
        let tid = row[financialTransactionId]
        let bid = row[budgetId]
        let transType = FinancialTransactionType(rawValue: row[financialTransactionTypeId])!
        let desc = row[financialTransactionDesc]
        let date = row[financialTransactionDate]
        
        let amount =  Decimal(row[financialTransactionAmount]/100)
        let void = row[financialTransactionVoid]
        let paid = row[financialTransactionPaid]
        
        return FinancialTransaction(financialTransactionID: tid, budgetId: bid, financialTransactionType: transType, description: desc, amount: amount, transactionDate: date, void: void, paid: paid)
    
    }
    static func findByBudgetId(id: Int64) throws -> [T]?{
        var transactions = [T]()
        let query = table.filter(budgetId == id)

        for row in try db.prepare(query){
            let tid = row[financialTransactionId]
            let bid = row[budgetId]
            let transType = FinancialTransactionType(rawValue: row[financialTransactionTypeId])!
            let desc = row[financialTransactionDesc]
            let date = row[financialTransactionDate]
            
            let amount =  Decimal(row[financialTransactionAmount]/100)
            let void = row[financialTransactionVoid]
            let paid = row[financialTransactionPaid]
        
            let financialTransaction = FinancialTransaction(financialTransactionID: tid, budgetId: bid, financialTransactionType: transType, description: desc, amount: amount, transactionDate: date, void: void, paid: paid)
            
            transactions.append(financialTransaction)
            }
        
        return transactions
    }
    
    static func findAll() throws -> [T]? {
        var transactions = [T]()
        
        for row in try db.prepare(table){
            let tid = row[financialTransactionId]
            let bid = row[budgetId]
            let transType = FinancialTransactionType(rawValue: row[financialTransactionTypeId])!
            let desc = row[financialTransactionDesc]
            let date = row[financialTransactionDate]
            
            let amount =  Decimal(row[financialTransactionAmount]/100)
            let void = row[financialTransactionVoid]
            let paid = row[financialTransactionPaid]
            
            let financialTransaction = FinancialTransaction(financialTransactionID: tid, budgetId: bid, financialTransactionType: transType, description: desc, amount: amount, transactionDate: date, void: void, paid: paid)
            
            transactions.append(financialTransaction)
        }
        
        return transactions
    }
    
    static func createTable() throws{
        do{
            try TransactionRepo.db.run(TransactionRepo.table.create(ifNotExists: true){
                table in
                table.column(TransactionRepo.financialTransactionId, primaryKey: true)
                table.column(TransactionRepo.budgetId)
                table.column(TransactionRepo.financialTransactionTypeId)
                table.column(TransactionRepo.financialTransactionDesc)
                table.column(TransactionRepo.financialTransactionDate)
                table.column(TransactionRepo.financialTransactionAmount)
                table.column(TransactionRepo.financialTransactionVoid)
                
            })
        }catch{
            print("Unable to create table")
            throw error
        }
    }
}


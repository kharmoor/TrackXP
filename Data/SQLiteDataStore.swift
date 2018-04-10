//
//  SQLiteDataStore.swift
//  CheckNow
//
//  Created by Khari Moore on 12/9/17.
//  Copyright © 2017 Khari Moore. All rights reserved.
//

import Foundation
import SQLite

class SQLiteDataStore {
    static let sharedInstance = SQLiteDataStore()
    
    let DB: Connection
    
    private init() {
        let fileName = "Expense.sqlite3"
        
        let dir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)//Returns a URL object
        let path = dir.appendingPathComponent(fileName).absoluteString  //Returns a URL object. URLs are the preferred way to refer to local files.
        
        DB =  try! Connection(path)
        print(path)
        createTransactionTable()
        createExpenseTable()
    }



    
    func createTransactionTable() {
        do{
            let financialTransactionId = Expression<Int64>("FinancialTransactionId")
            let financialTransactionTypeId = Expression<Int>("FinancialTransactionTypeId")
            let financialTransactionDesc = Expression<String>("Description")
            let financialTransactionDate = Expression<Date>("TransactionDate")
            let financialTransactionAmount = Expression<Int>("Amount")
            let financialTransactionVoid = Expression<Bool>("Void")
            
            try DB.run(TransactionRepo.table.create(ifNotExists: true){
                table in
                table.column(financialTransactionId, primaryKey: true)
                table.column(financialTransactionTypeId)
                table.column(financialTransactionDesc)
                table.column(financialTransactionDate)
                table.column(financialTransactionAmount)
                table.column(financialTransactionVoid)
                
            })
        }catch{
            print("Unable to create financial transaction table")
        }
    }
    
    func createExpenseTable(){
        do {
            let expenseId = Expression<Int64>("ExpenseId")
            let name = Expression<String>("Name")
            let description = Expression<String?>("Description")
            let categoryId = Expression<Int?>("CategoryId")
            let amount = Expression<Int64>("Amount")
            
            try DB.run(ExpenseRepo.table.create(ifNotExists: true){
                table in
                table.column(expenseId, primaryKey: true)
                table.column(name)
                table.column(description)
                table.column(categoryId)
                table.column(amount)
            })
        } catch  {
            print("unable to crate expense table")
        }
    }
}

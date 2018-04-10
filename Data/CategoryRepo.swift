//
//  CategoryRepo.swift
//  CheckNow
//
//  Created by Khari Moore on 2/7/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import Foundation
import SQLite
import os.log

class CategoryRepo : RepoProtocol{
    typealias T = Category
    
    static let ui_log = OSLog(subsystem: "com.example.NextCheck", category: "UI")
    
    static var db = SQLiteDataStore.sharedInstance.DB
    static let table = Table("Category")
    
    static let CategoryId = Expression<Int64>("CategoryId")
    static let Name = Expression<String>("Name")
    
    static func insert(item: Category) throws -> Int64 {
        let rowid = try db.run(table.insert(Name <- item.Name))
        return rowid
    }
    
    static func update(item: Category) throws {
        let query = table.filter(CategoryId == item.CategoryId!)
        try db.run(query.update([CategoryId <- item.CategoryId!, Name <- item.Name]))
    }
    
    static func delete(item: Category) throws {
        let query = table.filter(CategoryId == item.CategoryId!)
        try db.run(query.delete())
    }
    
    static func find(id: Int64) throws -> Category? {
        let query = table.filter(CategoryId == id)
        
        //Execute my query in return a Row object
        
        guard let row = try db.pluck(query) else{
            return nil
        }
        
        let cid = row[CategoryId]
        let name = row[Name]
        
        return Category(categoryId: cid, name: name)
    }
    
    static func findAll() throws -> [Category]? {
        var categories = [T]()
        for row in try db.prepare(table) {
            let cid = row[CategoryId]
            let name = row[Name]
            
            
            let category = Category(categoryId: cid, name: name)
            categories.append(category)
        }
        
        return categories
    }
    
    
    static func createTable() throws {
        do{
            try CategoryRepo.db.run(CategoryRepo.table.create(ifNotExists: true){
                table in
                table.column(CategoryRepo.CategoryId, primaryKey: true)
                table.column(CategoryRepo.Name)
            })
        }catch let e as NSError{
            os_log("Unable to create category table: %@", log: CategoryRepo.ui_log, type: .error,e.localizedDescription)
            throw e
        }
    }
    
    
    
    
}

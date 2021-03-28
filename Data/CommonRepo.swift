//
//  CommonRepo.swift
//  CheckNow
//
//  Created by Khari Moore on 5/13/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import Foundation
import SQLite

class CommonRepo{
static var db = SQLiteDataStore.sharedInstance.DB
static let versionTable = Table("Version")
static let version = Expression<String>("Version")
    
    
    static func findVersion() throws -> String {
        
        guard let row = try db.pluck(versionTable) else{
            return ""
        }
        
        return row[version]
    }
    
    static func insertVersion() throws -> Void{
        if let ver = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            try db.run(versionTable.insert(
                version <- ver
            ))
        }
        
    }
    
    static func createVersionTable() throws{
        do{
            try CommonRepo.db.run(CommonRepo.versionTable.create(ifNotExists: true){
                table in
                table.column(CommonRepo.version)
            })
        }catch{
            print("Unable to create table")
            throw error
        }
    }

}

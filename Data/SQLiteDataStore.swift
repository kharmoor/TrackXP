//
//  SQLiteDataStore.swift
//  CheckNow
//
//  Created by Khari Moore on 12/9/17.
//  Copyright © 2017 Khari Moore. All rights reserved.
//

import Foundation
import SQLite
import os.log


class SQLiteDataStore {
    static let sharedInstance = SQLiteDataStore()
    let DB: Connection
    
    private init() {
        let fileName = "Expense.sqlite3"
        
        let dir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)//Returns a URL object
        let path = dir.appendingPathComponent(fileName).absoluteString  //Returns a URL object. URLs are the preferred way to refer to local files.
        
        DB =  try! Connection(path)
        print(path)
 
    }

}

//
//  Expense.swift
//  CheckNow
//
//  Created by Khari Moore on 12/31/17.
//  Copyright © 2017 Khari Moore. All rights reserved.
//

import Foundation
class Expense{
    var ExpenseId: Int64?
    var Name: String
    var Description: String?
    var CategoryId: Int64?
    var Amount: Decimal
    
    init (expenseId: Int64?, name: String, description: String?,
          categoryId: Int64?, amount: Decimal){
        ExpenseId = expenseId
        Name = name
        Description = description
        CategoryId = categoryId
        Amount = amount
    }
}

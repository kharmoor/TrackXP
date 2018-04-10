//
//  BudgetGroup.swift
//  CheckNow
//
//  Created by Khari Moore on 2/14/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import Foundation

class BudgetGroup{
    var Id: Int64?
    var Name: String
    var Incomes = [Income]()
    var Expenses = [Expense]()
    var Active: Bool
    var Description: String?
    
    init(id: Int64?, name: String, active: Bool, description: String?) {
        self.Id = id
        self.Name = name
        self.Active = active
        self.Description = description
    }
}

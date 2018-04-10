//
//  BudgetViewModel.swift
//  CheckNow
//
//  Created by Khari Moore on 3/25/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import Foundation
extension BudgetViewController{
class ViewModel{
    var budget: Budget
    init(budget: Budget)
    {
        self.budget = budget
    }
    
    var StartDate: Date{
        get{
            return budget.startDate
        }
        set{
            budget.startDate = newValue
        }
    }
    
    var BudgetGroup: BudgetGroup?
    {
        get {
            return self.budget.budgetGroup
            
        }
        set{
            budget.budgetGroup = newValue
        }
    }
    
    }
}

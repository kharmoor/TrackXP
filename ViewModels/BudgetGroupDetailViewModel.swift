//
//  File.swift
//  CheckNow
//
//  Created by Khari Moore on 3/4/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import Foundation
extension BudgetGroupDetailViewController{
    class ViewModel{
        var budgetGroup: BudgetGroup
        init(budgetGroup: BudgetGroup){
            self.budgetGroup = budgetGroup
        }

        var Name: String{
            get{
                return budgetGroup.Name
            }
            set{
                budgetGroup.Name = newValue
            }
        }
        
        var Description: String?{
            get{
                return budgetGroup.Description
            }
            set{
                budgetGroup.Description = newValue
            }
        }
        
        var Incomes: [Income]{
            get{
                return budgetGroup.Incomes
            }
        }
        
        var Expenses: [Expense]{
            get{
                return budgetGroup.Expenses
            }
        }
        
        func AddIncome(income: Income) -> Void{
            budgetGroup.Incomes.append(income)
        }
        
        func AddExpense(expense: Expense) -> Void{
            budgetGroup.Expenses.append(expense)
        }
        
        func RemoveIncome(row: Int){
            budgetGroup.Incomes.remove(at: row)
        }
        
        func RemoveExpense(row: Int){
            budgetGroup.Expenses.remove(at: row)
        }
    }
}



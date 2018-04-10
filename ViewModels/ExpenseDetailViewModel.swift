//
//  ExpenseDetailViewModel.swift
//  CheckNow
//
//  Created by Khari Moore on 1/14/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import Foundation

extension ExpenseDetailViewController{
    class ViewModel{
        // MARK: - Life Cycle
        var expense: Expense
        init(expense: Expense) {
            self.expense = expense
        }
        
        var ExpenseId: Int64? {
            get {
                return expense.ExpenseId
            }
            set {
                expense.ExpenseId = newValue
            }
        }
        var Name: String{
            get {
                return expense.Name
            }
            set{
                expense.Name = newValue
            }
        }
        var Description: String?{
            get{
                return expense.Description
            }
            set{
                expense.Description = newValue
            }
        }
        var CategoryId: Int64?{
            get {
                return expense.CategoryId
            }
            set{
                expense.CategoryId = newValue
            }
        }
        var Amount: Decimal{
            get{
                return expense.Amount
            }
            set{
                expense.Amount = newValue
            }
        }
    }
}

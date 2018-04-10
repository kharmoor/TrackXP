//
//  IncomeDetailViewModel.swift
//  CheckNow
//
//  Created by Khari Moore on 2/14/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import Foundation
extension IncomeDetailViewController{
    class ViewModel{
        var income: Income
        init(income: Income){
            self.income = income
        }
        
        var IncomeId: Int64?{
            get{
                return income.IncomeId
            }
            set{
                income.IncomeId = newValue
            }
        }
        var Name: String{
            get{
                return income.Name
            }
            set{
                income.Name = newValue
            }
        }
        var Amount: Decimal{
            get{
                return income.Amount
            }
            set{
                income.Amount = newValue
            }
        }
        var Note: String?{
            get{
                return income.Note
            }
            set{
                income.Note = newValue
            }
        }
    }
}

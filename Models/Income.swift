//
//  Income.swift
//  CheckNow
//
//  Created by Khari Moore on 2/13/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import Foundation

class Income{
    var IncomeId: Int64?
    var Name: String
    var Note: String?
    var CategoryId: Int64?
    var Amount: Decimal
    
    init (incomeId: Int64?, name: String, note: String?,
          categoryId: Int64?, amount: Decimal){
        IncomeId = incomeId
        Name = name
        Note = note
        CategoryId = categoryId
        Amount = amount
    }}

//
//  Categories.swift
//  CheckNow
//
//  Created by Khari Moore on 2/11/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import Foundation

enum CategoryTypes: Int64 {
    case Expense = 1
    case Income = 2
    
    static let allValues = [Expense, Income]
    
    init?(id : Int) {
        switch id {
        case 1:
            self = .Expense
        case 2:
            self = .Income
        default:
            return nil
        }
    }
    
    var description : String {
        switch self {
        case .Expense: return "Expense"
        case .Income: return "Income"
        }
    }
}

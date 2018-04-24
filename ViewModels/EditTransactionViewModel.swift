//
//  EditTransactionViewModel.swift
//  CheckNow
//
//  Created by Khari Moore on 4/16/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import Foundation
extension EditTransactionViewController{
    class ViewModel{
         var transaction: FinancialTransaction
        init(transaction: FinancialTransaction){
            self.transaction = transaction
        }
        var Description: String?{
            get{
                return transaction.Description
            }
            set{
                transaction.Description = newValue
            }
        }
        var Amount: Decimal{
            get{
                return transaction.Amount
            }
            set{
                self.transaction.Amount = newValue
            }
        }
        var TransactionType: FinancialTransactionType{
            get {
                return transaction.FinancialTransactionType
            }
            set{
                transaction.FinancialTransactionType = newValue
            }
        }
        var Void: Bool{
            get{
                return transaction.Void
            }
            set{
                transaction.Void = newValue
            }
        }
        var Paid: Bool?{
            get{
                return transaction.Paid
            }
            set{
                transaction.Paid = newValue
            }
        }
    }
}

//
//  EditTransactionViewController.swift
//  CheckNow
//
//  Created by Khari Moore on 4/16/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import UIKit
import Eureka
import os.log

class EditTransactionViewController: FormViewController {
    var viewModel: ViewModel!
    var editTransaction: FinancialTransaction!
    var delegate: MainDismissHandler!
    
    static let ui_log = OSLog(subsystem: "com.example.NextCheck", category: "UI")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        self.viewModel = ViewModel(transaction: editTransaction!)
       
        form
            +++ Section()
            <<< LabelRow(){
                $0.title = "Transaction Type"
                $0.value = String(describing: viewModel!.TransactionType)
            }
            <<< LabelRow(){
                $0.title = "Transaction"
                $0.value = viewModel!.Description ?? ""
            }
            <<< DecimalRow(){  //closue (DecimalRow) -> Void Note: This is called in the init function which has a nested Initializer function/closure expression with arg type row
                $0.useFormatterDuringInput = true
                $0.title = "Amount"
                $0.placeholder = "Enter Amount"
                $0.value = NSDecimalNumber(decimal: viewModel!.Amount).doubleValue
                let formatter = CurrencyFormatter()
                formatter.locale = .current
                formatter.numberStyle = .currency
                $0.formatter = formatter
                $0.onChange({[unowned self] row in
                    if let amount = row.value{
                        self.viewModel.Amount = Decimal(amount)
                    }
                })
            
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnDemand
        }
            <<< CheckRow(){
                $0.title = "Void"
                $0.value = viewModel.Void
                $0.onChange({row in
                    if let isVoid = row.value{
                    self.viewModel.Void = isVoid
                    }
                })
        }
            <<< CheckRow(){
                $0.title = "Paid"
                $0.value = viewModel!.Paid ?? false
                $0.hidden = Condition(booleanLiteral: viewModel.TransactionType != .Expense)
                $0.onChange({row in
                    self.viewModel!.Paid = row.value ?? false
                })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SaveTransaction(_ sender: Any) {
        do {
            let validationErrors = form.validate()
            if validationErrors.isEmpty{
             try TransactionRepo.update(item: viewModel.transaction)
                delegate.dismissedEdit(id: 0)
             navigationController?.popViewController(animated: true)
            }else{
                self.showAlertOK("Expense Alert", validationErrors[0].msg)
            }
        } catch {
            os_log("Error occured saving transaction: %@", log: ExpenseDetailViewController.ui_log, type: .error,error.localizedDescription)
            self.showAlertOK("Error", "Error occurred saving transaction!")
        }
       
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

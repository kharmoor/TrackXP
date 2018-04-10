//
//  IncomeDetailViewController.swift
//  CheckNow
//
//  Created by Khari Moore on 2/14/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import UIKit
import os.log
import Eureka

class IncomeDetailViewController: FormViewController {
    var delegate:AppDetailModalHandler?
    var editIncome: Income?
    var viewModel: ViewModel!
    
    static let ui_log = OSLog(subsystem: "com.example.NextCheck", category: "UI")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem?.target = self
        
        os_log("Loading income details", log: IncomeDetailViewController.ui_log, type: .info)
        
        //load view model
        if let income = editIncome{
            self.viewModel = ViewModel(income: income)
        }else{
            let income = Income(incomeId: nil, name: "", note: nil, categoryId: nil, amount: 0 )
            self.viewModel = ViewModel(income: income)
        }
        
        form
            +++ Section()
            <<< TextRow(){
                $0.title = "Name"
                $0.placeholder = "Enter Name"
                $0.value = viewModel!.Name
                let ruleRequiredViaClosure = RuleClosure<String> { rowValue in
                    return (rowValue == nil || rowValue!.isEmpty) ? ValidationError(msg: "Name is required!") : nil
                }
                
                $0.add(rule: ruleRequiredViaClosure)
                $0.validationOptions = .validatesOnDemand
                $0.onChange({[unowned self] row in
                    if let name = row.value{
                        self.viewModel.Name = name
                    }
                })
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
                var ruleSet = RuleSet<Double>()
                let ruleRequiredViaClosure = RuleClosure<Double> { rowValue in
                    return (rowValue == nil || rowValue == 0) ? ValidationError(msg: "Required field!") : nil
                }
                ruleSet.add(rule: ruleRequiredViaClosure)
                $0.add(ruleSet: ruleSet)
//                $0.add(rule: RuleGreaterThan(min: 0))
//                $0.validationOptions = .validatesOnDemand
                $0.onChange({[unowned self] row in
                    if let amount = row.value{
                        self.viewModel.Amount = Decimal(amount)
                    }
                })
            }
            <<< TextAreaRow() {
                $0.title = "Note"
                $0.placeholder = "Note"
                $0.value = self.viewModel.Note
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                $0.onChange({[unowned self] row in
                    if let note = row.value{
                        self.viewModel.Note = note
                    }
                })
                
            }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelIncome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveIncome(_ sender: Any) {
        do
        {
            //throw NSError(domain: "my error description", code: 42, userInfo: ["ui1":12, "ui2":"val2"] )
            let validationErrors = form.validate()
            if validationErrors.isEmpty{
                let amount = viewModel.Amount //Decimal(string: viewModel.Amount) ?? 0
                let name = viewModel.Name
                let note = viewModel.Note
                let incomeId = editIncome == nil ? nil : editIncome?.IncomeId
                
                let income = Income(incomeId: incomeId, name: name, note: note, categoryId: nil, amount: amount)
                let id: Int64
                if editIncome == nil{
                    id = try IncomeRepo.insert(item: income)
                }else{
                    try IncomeRepo.update(item: income)
                    id = editIncome!.IncomeId!
                }
               
                
                dismiss(animated: true) {
                    self.delegate!.modalDismissed(id: id)
                }
            }else{
                self.showAlertOK("Income Alert", validationErrors[0].msg)
            }
        }catch let error as NSError {
            os_log("Error occured saving income: %@", log: IncomeDetailViewController.ui_log, type: .error,error.localizedDescription)
            self.showAlertOK("Error", "Error occurred saving income!")
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

//
//  BudgetGroupDetailViewController.swift
//  CheckNow
//
//  Created by Khari Moore on 3/4/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import UIKit
import os.log
import Eureka

protocol BudgetItemPopHandler{
    func AddExpense(expense: Expense)
    func AddIncome(income: Income)
}

class BudgetGroupDetailViewController: FormViewController, BudgetItemPopHandler  {
    var delegate:AppDetailModalHandler?
    var editBudgetGroup: BudgetGroup?
    var viewModel: ViewModel!
    
    static let ui_log = OSLog(subsystem: "com.example.NextCheck", category: "UI")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //load view model
        if let budgetGroup = editBudgetGroup{
            self.viewModel = ViewModel(budgetGroup: budgetGroup)
        }else{
            let budgetGroup = BudgetGroup(id: nil, name: "", active: false, description: nil)
            self.viewModel = ViewModel(budgetGroup: budgetGroup)
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
            <<< TextAreaRow() {
                $0.title = "Description"
                $0.placeholder = "Description"
                $0.value = self.viewModel.Description
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                $0.onChange({[unowned self] row in
                    if let description = row.value{
                        self.viewModel.Description = description
                    }
                })
                
        }
            <<< ButtonRow("Add Transaction") { (row: ButtonRow) -> Void in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "showBudgetGroupSegue", onDismiss: nil)
            }
        
        
        form.append(Section("Expense"))//1
        form.append(Section("Income"))//2
        
        LoadExpenseRows()
        LoadIncomeRows()
    }
    
    func LoadExpenseRows() -> Void{
        form[1].removeAll()
        if viewModel.Expenses.isEmpty {
            form[1] <<< LabelRow(){ row in
            row.title = "No Expenses"
        }
        }else{
            for expense in viewModel.Expenses{
            form[1]
                <<< LabelRow(){
                    $0.title = expense.Name
                    $0.value = expense.Amount.asCurrency
                    let deleteAction = SwipeAction(
                        style: .destructive,
                        title: "Delete",
                        handler: { (action, row, completionHandler) in
                            //add your code here.
                            let deleteRow = row.indexPath!.row
                            //                                self.showAlertDelete("Remove Income", "Are you sure about removing income from this budget group?",{ () -> Void in
                            //                                })
                            do{
                                let exp = self.viewModel.Expenses[deleteRow]
                                if (self.viewModel.budgetGroup.Id != nil){
                                    try BudgetGroupRepo.deleteBudgetTransaction(budgetGroupId: self.viewModel.budgetGroup.Id!, financialTransactionTypeId: FinancialTransactionType.Expense.rawValue, sourceId: exp.ExpenseId!)
                                }
                                self.viewModel.RemoveExpense(row: deleteRow)
                                
                            }catch{
                                os_log("Error occured deleting income: %@", log: BudgetGroupDetailViewController.ui_log, type: .error,error.localizedDescription)
                                self.showAlertOK("Error", "Error occurred deleting income transaction")
                            }
                            
                            
                            
                            self.LoadExpenseRows()                             //make sure you call the completionHandler once done.
                            completionHandler?(true)
                            
                    })
                    deleteAction.image = UIImage(named: "icon-trash")
                    
                    $0.trailingSwipe.actions = [deleteAction]
                    $0.trailingSwipe.performsFirstActionWithFullSwipe = true
        }

        }
    }
    }
    
    func LoadIncomeRows() -> Void{
        form[2].removeAll()
        
        if viewModel.Incomes.isEmpty{
            form[2]
                <<< LabelRow(){
                    $0.title = "No Income"
            }
        }else{
            for income in viewModel.Incomes{
                form[2]
                    <<< LabelRow(){
                        $0.title = income.Name
                        $0.value = income.Amount.asCurrency
                        let deleteAction = SwipeAction(
                            style: .destructive,
                            title: "Delete",
                            handler: { (action, row, completionHandler) in
                                //add your code here.
                                let deleteRow = row.indexPath!.row
//                                self.showAlertDelete("Remove Income", "Are you sure about removing income from this budget group?",{ () -> Void in
//                                })
                                    do{
                                        let income = self.viewModel.Incomes[deleteRow]
                                        if (self.viewModel.budgetGroup.Id != nil){
                                            try BudgetGroupRepo.deleteBudgetTransaction(budgetGroupId: self.viewModel.budgetGroup.Id!, financialTransactionTypeId: FinancialTransactionType.Income.rawValue, sourceId: income.IncomeId!)
                                        }
                                        self.viewModel.RemoveIncome(row: deleteRow)
                                        
                                    }catch{
                                        os_log("Error occured deleting income: %@", log: BudgetGroupDetailViewController.ui_log, type: .error,error.localizedDescription)
                                        self.showAlertOK("Error", "Error occurred deleting income transaction")
                                    }

                           
                                
                                self.LoadIncomeRows()                                //make sure you call the completionHandler once done.
                                completionHandler?(true)
                               
                        })
                        deleteAction.image = UIImage(named: "icon-trash")

                        $0.trailingSwipe.actions = [deleteAction]
                        $0.trailingSwipe.performsFirstActionWithFullSwipe = true
                    }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
     func AddExpense(expense: Expense) {
        viewModel.AddExpense(expense: expense)
        LoadExpenseRows()
    }
    
     func AddIncome(income: Income) {
       viewModel.AddIncome(income: income)
       LoadIncomeRows()
     }
    
    @IBAction func Save(_ sender: Any){
        do {
            let validationErrors = form.validate()
            if validationErrors.isEmpty{
            let id: Int64
            if editBudgetGroup == nil{
                id = try BudgetGroupRepo.insert(item: viewModel.budgetGroup)
            }else{
                try BudgetGroupRepo.update(item: editBudgetGroup!)
                id = editBudgetGroup!.Id!
            }
            delegate?.modalDismissed(id: id)
            dismiss(animated: true, completion: nil)
            }else{
                self.showAlertOK("Budget Group Alert", validationErrors[0].msg)
            }
           
        } catch  {
            os_log("Error occured saving budget group: %@", log: BudgetGroupDetailViewController.ui_log, type: .error,error.localizedDescription)
            self.showAlertOK("Error", "Error occurred saving budget group!")
        }
       
    }
    
    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "showBudgetGroupSegue"){
            if let destination = segue.destination as? BudgetGroupItemsViewController{
                destination.delegate = self
            }
        }
    }
    

}

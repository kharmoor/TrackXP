//
//  BudgetGroupItemsViewController.swift
//  CheckNow
//
//  Created by Khari Moore on 3/4/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import UIKit
import os.log

class BudgetGroupItemsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var delegate:BudgetItemPopHandler?
    static let ui_log = OSLog(subsystem: "com.example.NextCheck", category: "UI")
    
    @IBOutlet weak var tableView: UITableView!
    
    var financialTransactions = [FinancialTransaction]()
    var expenses = [Expense]()
    var incomes = [Income]()
    var selectedTransactionType: FinancialTransactionType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        
        selectedTransactionType = .Expense
        do {
            try LoadExpenses()
        } catch{
            self.showAlertOK("Error", "Error occured loading Expenses view")
            os_log("Failed loading expense view: %@", log: ExpensesViewController.ui_log, type: .error,error.localizedDescription)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (selectedTransactionType == .Expense){
            return expenses.count
        }else
         {
            return incomes.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cellIdentifier = "ExpenseItemTableViewCell"//name of table cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ExpenseItemTableViewCell
        
        // Configure the cell...
        if (selectedTransactionType == .Expense){
            let expense = expenses[indexPath.row]
            cell.ExpenseNameLabel.text = expense.Name
            cell.ExpenseAmountLabel.text = expense.Amount.asCurrency
        }else{
            let income = incomes[indexPath.row]
            cell.ExpenseNameLabel.text = income.Name
            cell.ExpenseAmountLabel.text = income.Amount.asCurrency
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (selectedTransactionType == .Expense){
            let expense = expenses[indexPath.row]
            delegate?.AddExpense(expense: expense)
        }else{
            let income = incomes[indexPath.row]
            delegate?.AddIncome(income: income)
        }
        
        navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ExpenseButtonClick(_ sender: Any) {
        selectedTransactionType = .Expense
        do {
            let btn = sender as! UIButton
            btn.isSelected = !btn.isSelected
            try LoadExpenses()
            tableView.reloadData()
        } catch{
            self.showAlertOK("Error", "Error occured loading Expenses")
            os_log("Failed loading expense: %@", log: ExpensesViewController.ui_log, type: .error,error.localizedDescription)
        }
    }
    @IBAction func IncomeButtonClick(_ sender: Any) {
        selectedTransactionType = .Income
        do {
            let btn = sender as! UIButton
            btn.isSelected = !btn.isSelected
            try LoadIncome()
            tableView.reloadData()
        } catch{
            self.showAlertOK("Error", "Error occured loading Income")
            os_log("Failed loading income: %@", log: ExpensesViewController.ui_log, type: .error,error.localizedDescription)
        }
    }
    private func LoadExpenses() throws {
        do{
            guard let expenses = try ExpenseRepo.findAll() else{
                return
            }
            self.expenses = expenses
            
        }catch{
            os_log("Error occured loading expenses: %@", log: ExpensesViewController.ui_log, type: .error,error.localizedDescription)
            throw error
        }
    }
    
    private func LoadIncome() throws {
        do{
            guard let incomes = try IncomeRepo.findAll() else{
                return
            }
            self.incomes = incomes
            
        }catch{
            os_log("Error occured loading incomes: %@", log: IncomeViewController.ui_log, type: .error,error.localizedDescription)
            throw error
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

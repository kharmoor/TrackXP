//
//  TransactionsViewController.swift
//  CheckNow
//
//  Created by Khari Moore on 11/26/17.
//  Copyright © 2017 Khari Moore. All rights reserved.
//

import UIKit
import os.log

protocol ExpenseDetailModalHandler {
    func modalDismissed(expenseId: Int64)
}
class ExpensesViewController: UITableViewController, ExpenseDetailModalHandler {
    static let ui_log = OSLog(subsystem: "com.example.NextCheck", category: "UI")
    var expenses = [Expense]() //Initialize an empty array
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
            try LoadExpenses()
        }catch{
            self.showAlertOK("Error", "Error occured loading Expenses view")
            os_log("Failed loading expense view: %@", log: ExpensesViewController.ui_log, type: .error,error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showExpenseDetail" {
            
            if let destinationNavigationController = segue.destination as? UINavigationController, let modalExpenseDetail = destinationNavigationController.topViewController as? ExpenseDetailViewController {
                modalExpenseDetail.delegate = self
            }
        }
    }
    func modalDismissed(expenseId: Int64) {
        //save transaction and add to expense array
        do{
            if let expense = try ExpenseRepo.find(id: expenseId){
            if let idx = expenses.index(where: { $0.ExpenseId == expenseId }) {
                expenses[idx] = expense
            }else{
                expenses.append(expense)
            }
            self.tableView.reloadData()
        }
        }catch{
            self.showAlertOK("Error", "Failed loading expense during modal dismiss")
            os_log("Failed loading expense view after closing details: %@", log: ExpensesViewController.ui_log, type: .error,error.localizedDescription)
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ExpenseItemTableViewCell"//name of table cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ExpenseItemTableViewCell
        
        // Configure the cell...
        let expense = expenses[indexPath.row]
        cell.ExpenseNameLabel.text = expense.Name
        cell.ExpenseAmountLabel.text = expense.Amount.asCurrency//String(format: "$%.02f", expense.Amount as CVarArg)
        return cell
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            // code to email the todo goes here
            self.showAlertDelete("Delete Expense", "Are sure about deleting this expense?", { () -> Void in
                let selectedExpense = self.expenses[indexPath.row]
                do{
                    try ExpenseRepo.delete(item: selectedExpense)
                    self.expenses.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }catch let error as NSError{
                    os_log("Error occured deleting expense: %@", log: ExpensesViewController.ui_log, type: .error,error.localizedDescription)
                    self.showAlertOK("Error", "Error occurred deleting expense!")
                }
            })
        }
        delete.backgroundColor = UIColor.red
        
        let edit = UITableViewRowAction(style: .normal, title: "More") { (action, indexPath) in
            
           let expenseDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "ExpenseDetailViewController") as! ExpenseDetailViewController
            expenseDetailViewController.editExpense = self.expenses[indexPath.row]
            expenseDetailViewController.delegate = self
            let navController = UINavigationController(rootViewController: expenseDetailViewController)
            self.present(navController, animated:true, completion: nil)
            
            //            let expenseDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "ExpenseDetailViewController") as! ExpenseDetailViewController
            //            expenseDetailViewController.editExpense = self.expenses[indexPath.row]
            //            self.navigationController?.pushViewController(expenseDetailViewController, animated: true)
        }
        
        edit.backgroundColor = UIColor.orange
        
        return [edit, delete]
    }
    
    //MARK: Private Methods
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
    
    /*
    
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

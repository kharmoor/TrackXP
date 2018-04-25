//
//  BudgetActionViewController.swift
//  CheckNow
//
//  Created by Khari Moore on 2/25/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import UIKit
import os.log
protocol MainDismissHandler{
    func dismissedEdit(id: Int64)
    func dismissedSearch(filter:[Budget])
}
class MainViewController: UITableViewController, MainDismissHandler {
    var delegate:AppDetailModalHandler?
    static let ui_log = OSLog(subsystem: "com.example.NextCheck", category: "UI")


    var budgets = [Budget]()
    var sections = [Int64:String]()// = ["02/01/2018", "02/15/2018"]
    //var financialTransactions: [FinancialTransaction]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        
        loadBudgets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadBudgets() -> Void{
        do {
            budgets += try BudgetRepo.findMostRecent()
            var index = 0
            budgets.forEach({
               
                sections[$0.BudgetId!] = DateFormatter.localizedString(from: $0.startDate, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.none)
                index+=1
            })
        } catch  {
            self.showAlertOK("Error", "Error occured loading budgets")
            os_log("Failed loading budgets: %@", log: ExpensesViewController.ui_log, type: .error,error.localizedDescription)
        }    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBudgetSeque" {
            
            if let destinationNavigationController = segue.destination as? UINavigationController, let modalBudget = destinationNavigationController.topViewController as? BudgetViewController {
                modalBudget.delegate = self
            }
        }
        
        if segue.identifier == "showEditTransaction"{
            if  let editTransactionViewController = segue.destination as? EditTransactionViewController{
                let section = tableView.indexPathForSelectedRow?.section
                let row = tableView.indexPathForSelectedRow?.row
                
                if section! > 0{
                    let budgetId = Array(sections)[section! - 1].key
                    
                    if let budget = budgets.first(where: {$0.BudgetId! == budgetId}){
                        let transaction = budget.FinancialTransactions[row!]
                        editTransactionViewController.editTransaction = transaction
                        editTransactionViewController.delegate = self
                }
                }
            }
        }
        
        if segue.identifier == "showBudgetSearch"{
            if  let editTransactionViewController = segue.destination as? BudgetSearchViewController{
                editTransactionViewController.delegate = self
            }
        }
    }
    
    func dismissedEdit(id: Int64){
        budgets = [Budget]();
        loadBudgets()
        tableView.reloadData()
    }
    
    func dismissedSearch(filter: [Budget]) {
        self.budgets = filter
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (section > 0)
        {
            let startDate = Array(sections)[section - 1].value//.toDate("MMM d, yyyy")
            if let budget = budgets.first(where: {DateFormatter.localizedString(from: $0.startDate, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.none) == startDate}){
                
            return budget.FinancialTransactions.count
                
            }else{
                
                return 0
            }
        }
        return 2
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
       var cell: UITableViewCell?
       if indexPath.section == 0 {
           cell = tableView.dequeueReusableCell(withIdentifier: "\(indexPath.section),\(indexPath.row)", for: indexPath)
        
        }
        else if indexPath.section > 0 {
            let transactionCell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionItemTableViewCell
            let budgetId = Array(sections)[indexPath.section - 1].key
        
            if let budget = budgets.first(where: {$0.BudgetId! == budgetId}){
                let transaction = budget.FinancialTransactions[indexPath.row]

                if let description = transaction.Description{
                    transactionCell.descriptionLabel.text = description + (transaction.Void ? " (Void)" : "")
                }
                transactionCell.amountLabel.text = transaction.getDisplayAmount()
            }
        return transactionCell
        }

        return cell ?? UITableViewCell()
        
    }
    

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > 0{
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! BudgetHeaderTableViewCell
            headerCell.DateLabel.text = Array(sections)[section - 1].value
            
            headerCell.AddTransactionButton.addTarget(self, action:#selector(MainViewController.addTransactionButton), for: .touchUpInside)
            headerCell.AddTransactionButton.tag = section
            return headerCell
        }
        return super.tableView(tableView, viewForHeaderInSection: section)
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0{
            self.performSegue(withIdentifier: "showBudgetSeque", sender: self)
        }
        
//        if indexPath.section > 0{
//            self.performSegue(withIdentifier: "showEditTransaction", sender: self)
//        }

    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        if section > 0{
        let budgetId = Array(sections)[section - 1].key
        
        if let budget = budgets.first(where: {$0.BudgetId! == budgetId}){
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "FooterCell") as! BalanceTableViewCell
            headerCell.BalanceLabel.text = budget.getBalance().asCurrency
            return headerCell
        }
        }
        
        return super.tableView(tableView, viewForFooterInSection: section)
        
       
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        return 50
    }
    
    @objc func addTransactionButton(sender: UIButton){
        let budgetId = Array(sections)[sender.tag - 1].key
        
        if let budget = budgets.first(where: {$0.BudgetId! == budgetId}){
            let editTransactionViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditTransactionViewController") as! EditTransactionViewController
            editTransactionViewController.editBudget = budget
            editTransactionViewController.delegate = self
            self.show(editTransactionViewController, sender: self)
            
        }
    }
 
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
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

   
    

}

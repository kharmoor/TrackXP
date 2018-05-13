//
//  BudgetsViewController.swift
//  CheckNow
//
//  Created by Khari Moore on 5/7/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import UIKit
import os.log

class BudgetsViewController: UITableViewController {
    var Budgets = [Budget]()
    var SelectedBudgets = [Budget]()
    var delegate: MainDismissHandler!
    
    static let ui_log = OSLog(subsystem: "com.example.NextCheck", category: "UI")
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        do {
             self.Budgets += try BudgetRepo.findAll()!.sorted(by: {(b1, b2) in b1.startDate.timeIntervalSince1970 > b2.startDate.timeIntervalSince1970})
        } catch {
            os_log("Error occured loading budget search: %@", log: BudgetsViewController.ui_log, type: .error,error.localizedDescription)
            self.showAlertOK("Error", "Error occurred loading budgets!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private functions
    
    @objc func filterBudgets(sender: UIButton){
        do{
            if !SelectedBudgets.isEmpty{
        for item in SelectedBudgets{
            if let transactions = try TransactionRepo.findByBudgetId(id: item.BudgetId!){
                item.FinancialTransactions = transactions
            }
        }
        delegate.dismissedSearch(filter: SelectedBudgets)
        navigationController?.popViewController(animated: true)
            }else{
                self.showAlertOK("Show Budgets", "You must select a budget.")
            }
        }catch{
            os_log("Error occured filtering budgets: %@", log: BudgetsViewController.ui_log, type: .error,error.localizedDescription)
            self.showAlertOK("Error", "Error occurred filtering budgets!")
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Budgets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "BudgetCell") as! BudgetHeaderTableViewCell
        let budget = Budgets[indexPath.row]
        
        headerCell.DateLabel.text = budget.startDate.toShortDateString()
        
        if SelectedBudgets.contains(where: {$0.BudgetId == budget.BudgetId}){
            headerCell.accessoryType = .checkmark
        }else{
            headerCell.accessoryType = .none
        }
        
        return headerCell
        
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

            let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! FilterBudgetHeaderTableViewCell
            
            headerCell.filterBudgetButton.addTarget(self, action:#selector(BudgetsViewController.filterBudgets(sender:)), for: .touchUpInside)
            return headerCell

    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do{
            // Delete the row from the data source
            let budget = Budgets[indexPath.row]
            try BudgetRepo.delete(item: budget)
            Budgets.remove(at: indexPath.row)
            
            
            if let idx = SelectedBudgets.index(where: {$0.BudgetId == budget.BudgetId}){
                SelectedBudgets.remove(at: idx)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            }catch{
                os_log("Error occured deleting budget: %@", log: BudgetsViewController.ui_log, type: .error,error.localizedDescription)
                self.showAlertOK("Error", "Error occurred deleting budget!")            }
           
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            let budget = Budgets[indexPath.row]
            if !SelectedBudgets.contains(where: {$0.BudgetId == budget.BudgetId}){
                SelectedBudgets.append(budget)
            }
        }
        
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
            let budget = Budgets[indexPath.row]
            if let idx = SelectedBudgets.index(where: {$0.BudgetId == budget.BudgetId}){
                SelectedBudgets.remove(at: idx)
            }
        }
        
    }
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

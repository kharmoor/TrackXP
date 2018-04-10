//
//  BudgetActionViewController.swift
//  CheckNow
//
//  Created by Khari Moore on 2/25/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import UIKit
import os.log

class MainViewController: UITableViewController, AppDetailModalHandler {
    var delegate:AppDetailModalHandler?
    static let ui_log = OSLog(subsystem: "com.example.NextCheck", category: "UI")


    var budgets = [Budget]()
    var sections = [String]()// = ["02/01/2018", "02/15/2018"]
    //var financialTransactions: [FinancialTransaction]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        do {
            budgets += try BudgetRepo.findMostRecent()
            sections += budgets.map {DateFormatter.localizedString(from: $0.startDate, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.none) }
        } catch  {
            self.showAlertOK("Error", "Error occured loading budgets")
            os_log("Failed loading budgets: %@", log: ExpensesViewController.ui_log, type: .error,error.localizedDescription)
        }
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBudgetSeque" {
            
            if let destinationNavigationController = segue.destination as? UINavigationController, let modalBudget = destinationNavigationController.topViewController as? BudgetViewController {
                modalBudget.delegate = self
            }
        }
    }
    
    func modalDismissed(id: Int64) {
        
//        do{
//            if let income = try IncomeRepo.find(id: id){
//                if let idx = incomes.index(where: { $0.IncomeId == id }) {
//                    incomes[idx] = income
//                }else{
//                    incomes.append(income)
//                }
//                self.tableView.reloadData()
//            }
//        }catch{
//            self.showAlertOK("Error", "Failed loading income view after closing details")
//            os_log("Failed loading income during modal dismiss: %@", log: IncomeViewController.ui_log, type: .error,error.localizedDescription)
//        }
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
            let startDate = sections[section - 1]//.toDate("MMM d, yyyy")
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
        else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
            //cell?.textLabel?.text = theData[indexPath.row]
        }
//        else if indexPath.section == 2 {
//            cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
//        }
        return cell ?? UITableViewCell()
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0)
        {
            return ""
        }
        
        return sections[section - 1]
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0{
            self.performSegue(withIdentifier: "showBudgetSeque", sender: self)
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0{
            self.performSegue(withIdentifier: "showBudgetSeque", sender: self)
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

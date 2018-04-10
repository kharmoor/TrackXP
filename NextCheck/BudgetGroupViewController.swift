//
//  BudgetGroupViewController.swift
//  CheckNow
//
//  Created by Khari Moore on 3/1/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import UIKit
import os.log

class BudgetGroupViewController: UITableViewController, AppDetailModalHandler {
    static let ui_log = OSLog(subsystem: "com.example.NextCheck", category: "UI")
    var budgetGroups = [BudgetGroup]() //Initialize an empty array
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        do {
            try LoadBudgetGroups()
        } catch  {
            self.showAlertOK("Error", "Error occured loading Budget Group view")
            os_log("Failed loading Budget Group view: %@", log: BudgetGroupViewController.ui_log, type: .error,error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBudgetGroupSeque" {
            
            if let destinationNavigationController = segue.destination as? UINavigationController, let modalBudgetGroupDetail = destinationNavigationController.topViewController as? BudgetGroupDetailViewController {
                modalBudgetGroupDetail.delegate = self
            }
        }
    }
    func modalDismissed(id: Int64) {
        //save add budget group to array
        do{
            if let budgetGroup = try BudgetGroupRepo.find(id: id){
                if let idx = budgetGroups.index(where: { $0.Id == id }) {
                    budgetGroups[idx] = budgetGroup
                }else{
                    budgetGroups.append(budgetGroup)
                }
                self.tableView.reloadData()
            }
        }catch{
            self.showAlertOK("Error", "Failed loading budget groups during modal dismiss")
            os_log("Failed loading budget group view after closing details: %@", log: ExpensesViewController.ui_log, type: .error,error.localizedDescription)
        }
    }
    //MARK: - Private functions
    func LoadBudgetGroups() throws -> Void{
        do{
            guard let budgetGroups = try BudgetGroupRepo.findAll() else{
                return
            }
            self.budgetGroups = budgetGroups
            
        }catch{
            os_log("Error occured loading budget groups: %@", log: BudgetGroupViewController.ui_log, type: .error,error.localizedDescription)
            throw error
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return budgetGroups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetGroupItemTableViewCell", for: indexPath) as! BudgetGroupItemTableViewCell

        // Configure the cell...
        let budgetGroup = budgetGroups[indexPath.row]
        cell.NameLabel.text = budgetGroup.Name
        cell.DescriptionText.text = budgetGroup.Description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bgDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "BudgetGroupDetailViewController") as! BudgetGroupDetailViewController
        do {
            let selectedBudgetGroup = self.budgetGroups[indexPath.row]
            if let budgetGroup = try BudgetGroupRepo.find(id: selectedBudgetGroup.Id!){
                bgDetailViewController.editBudgetGroup = budgetGroup
            }
            
        } catch {
            self.showAlertOK("Error", "Error occured loading Budget Group Details view")
            os_log("Failed loading Budget Group Details view: %@", log: BudgetGroupViewController.ui_log, type: .error,error.localizedDescription)
        }
       
        bgDetailViewController.delegate = self
        let navController = UINavigationController(rootViewController: bgDetailViewController)
        self.present(navController, animated:true, completion: nil)
    }
    
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

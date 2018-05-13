//
//  BudgetViewController.swift
//  CheckNow
//
//  Created by Khari Moore on 2/27/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import UIKit
import os.log

protocol BudgetGroupSelectPopHandler{
    func AddBudgetGroup(budgetGroup: BudgetGroup) throws
}
class BudgetViewController: UITableViewController, BudgetGroupSelectPopHandler {
    static let ui_log = OSLog(subsystem: "com.example.NextCheck", category: "UI")
    var delegate: MainDismissHandler!
    @IBOutlet weak var StartDatePicker: UIDatePicker!
    @IBOutlet weak var StartDateLabel: UILabel!
    
    @IBOutlet weak var BudgetGroupNameLabel: UILabel!
    
    @IBOutlet weak var BudgetGroupDescLabel: UITextView!
    
    var editBudget: Budget?
    var viewModel: ViewModel!
    var ShowStartDateVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //load view model
        if let budget = editBudget{
            self.viewModel = ViewModel(budget: budget)
        }else{
            let budget = Budget(budgetId: nil, startDate: Date(),budgetGroup: nil)
            self.viewModel = ViewModel(budget: budget)
        }
        StartDateLabel.text = DateFormatter.localizedString(from: self.viewModel.budget.startDate, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.none)
          self.tableView.register(BudgetGroupItemTableViewCell.self, forCellReuseIdentifier: "BudgetGroupItemTableViewCell")
        
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        StartDatePicker.date = cal.startOfDay(for: date)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        let datePicker = sender as! UIDatePicker
        self.viewModel.budget.startDate = datePicker.date
        StartDateLabel.text = DateFormatter.localizedString(from: self.viewModel.budget.startDate, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.none)
    }
    private func toggleShowDateDatepicker () {
        ShowStartDateVisible = !ShowStartDateVisible
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func AddBudgetGroup(budgetGroup: BudgetGroup) throws{
        self.viewModel.budget.budgetGroup = try BudgetGroupRepo.find(id: budgetGroup.Id!)
        self.BudgetGroupNameLabel.text = budgetGroup.Name
        self.BudgetGroupDescLabel.text = budgetGroup.Description
    }

    @IBAction func SaveBudget(_ sender: Any){
        if self.viewModel.budget.budgetGroup == nil{
            self.showAlertOK("Error", "Please select a budget group!")
            return
        }
        do {
            let bid = try BudgetRepo.insert(item: self.viewModel.budget)
            delegate.dismissedEdit(id: bid)
            dismiss(animated: true, completion: nil)
        } catch  {
            self.showAlertOK("Error", "Error occured saving budget")
            os_log("Failed saving budget: %@", log: ExpensesViewController.ui_log, type: .error,error.localizedDescription)
        }
        
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0
        {
            return 2
        }
            return 1
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  indexPath.section == 0 && indexPath.row == 0 {
            toggleShowDateDatepicker()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !ShowStartDateVisible && indexPath.row == 1 {
            return 0
        }
        else {
            return super.tableView(tableView, heightForRowAt: indexPath) //tableView(tableView, heightForRowAtIndexPath: indexPath)//super.tableView.rowHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //cannot deque static cells, return base function
        //https://stackoverflow.com/questions/11993798/uitableview-with-static-cells-without-cellforrowatindexpath-how-to-set-clear-ba
        return super.tableView(tableView, cellForRowAt: indexPath)
        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? BudgetGroupSelectViewController{
            destination.delegate = self
        }
    }
    

}

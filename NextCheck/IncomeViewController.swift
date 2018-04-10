//
//  IncomeViewController.swift
//  CheckNow
//
//  Created by Khari Moore on 2/3/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import UIKit
import os.log

protocol AppDetailModalHandler{
    func modalDismissed(id: Int64)
}

class IncomeViewController: UITableViewController, AppDetailModalHandler {
    static let ui_log = OSLog(subsystem: "com.example.NextCheck", category: "UI")
    var incomes = [Income]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        do {
            try LoadIncome()
        } catch  {
            self.showAlertOK("Error", "Error occured loading Income view")
            os_log("Failed loading income view: %@", log: IncomeViewController.ui_log, type: .error,error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func modalDismissed(id: Int64) {
        do{
            if let income = try IncomeRepo.find(id: id){
                if let idx = incomes.index(where: { $0.IncomeId == id }) {
                    incomes[idx] = income
                }else{
                    incomes.append(income)
                }
                self.tableView.reloadData()
            }
        }catch{
            self.showAlertOK("Error", "Failed loading income view after closing details")
            os_log("Failed loading income during modal dismiss: %@", log: IncomeViewController.ui_log, type: .error,error.localizedDescription)
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showIncomeDetail" {
            
            if let destinationNavigationController = segue.destination as? UINavigationController, let modalIncomeDetail = destinationNavigationController.topViewController as? IncomeDetailViewController {
                modalIncomeDetail.delegate = self
            }
        }
    }
    //Mark: Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "IncomeItemTableViewCell"//name of table cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! IncomeItemTableViewCell
        
        // Configure the cell...
        let income = incomes[indexPath.row]
        cell.IncomeNameLabel.text = income.Name
        cell.IncomeAmountLabel.text = income.Amount.asCurrency//String(format: "$%.02f", income.Amount as CVarArg)
        return cell
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            // code to email the todo goes here
            self.showAlertDelete("Delete Income", "Are sure about deleting this income?", { () -> Void in
                let selectedIncome = self.incomes[indexPath.row]
                do{
                    try IncomeRepo.delete(item: selectedIncome)
                    self.incomes.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }catch let error as NSError{
                    os_log("Error occured deleting income: %@", log: IncomeViewController.ui_log, type: .error,error.localizedDescription)
                    self.showAlertOK("Error", "Error occurred deleting income!")
                }
            })
        }
        delete.backgroundColor = UIColor.red
        
        let edit = UITableViewRowAction(style: .normal, title: "More") { (action, indexPath) in
            
            let incomeDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "IncomeDetailViewController") as! IncomeDetailViewController
            incomeDetailViewController.editIncome = self.incomes[indexPath.row]
            incomeDetailViewController.delegate = self
            let navController = UINavigationController(rootViewController: incomeDetailViewController)
            self.present(navController, animated:true, completion: nil)
        }
        
        edit.backgroundColor = UIColor.orange
        
        return [edit, delete]
    }
    
    //MARK: Private Methods
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

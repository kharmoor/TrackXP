//
//  CategoryViewController.swift
//  CheckNow
//
//  Created by Khari Moore on 2/7/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import UIKit
import os.log
protocol CategoryDetailModalHandler {
    func modalDismissed(categoryId: Int64)
}
class CategoryViewController: UITableViewController, CategoryDetailModalHandler {
    static let ui_log = OSLog(subsystem: "com.example.NextCheck", category: "UI")
    var categories = [Category]() //Initialize an empty array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
            try LoadCategories()
        }catch {
            os_log("Error occured loading category view: %@", log: CategoryViewController.ui_log, type: .error,error.localizedDescription)
            self.showAlertOK("Error", "Error occured loading Category view")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showExpenseDetail" {
//
//            if let destinationNavigationController = segue.destination as? UINavigationController, let modalExpenseDetail = destinationNavigationController.topViewController as? ExpenseDetailViewController {
//                modalExpenseDetail.delegate = self
//            }
//        }
    }
    func modalDismissed(categoryId: Int64) {
        //save transaction and add to expense array
        do{
            if let category = try CategoryRepo.find(id: categoryId){
                if let idx = categories.index(where: { $0.CategoryId == categoryId }) {
                    categories[idx] = category
                }else{
                    categories.append(category)
                }
                self.tableView.reloadData()
            }
        }catch{
            self.showAlertOK("Error", "Failed loading Category during modal dismiss")
            os_log("Failed loading Category during modal dismiss: %@", log: CategoryViewController.ui_log, type: .error,error.localizedDescription)
        }
    }
    
    // MARK: - Private
    
    func LoadCategories() throws {
        do{
            guard let categories = try CategoryRepo.findAll() else{
                return
            }
            self.categories = categories
            
        }catch let error as NSError{
             os_log("Error occured loading category: %@", log: CategoryViewController.ui_log, type: .error,error.localizedDescription)
            throw error
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CategoryItemTableViewCell"//name of table cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CategoryItemTableViewCell

        // Configure the cell...
        let category = categories[indexPath.row]
        cell.CategoryNameLabel.text = category.Name
       
        return cell
    }

    
     //Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         //Return false if you do not want the specified item to be editable.
        return true
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            // code to email the todo goes here
            self.showAlertDelete("Delete Category", "Are sure about deleting this category?", { () -> Void in
                let selectedCategories = self.categories[indexPath.row]
                do{
                    try CategoryRepo.delete(item: selectedCategories)
                    self.categories.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }catch let error as NSError{
                    os_log("Error occured deleting category: %@", log: ExpensesViewController.ui_log, type: .error,error.localizedDescription)
                    self.showAlertOK("Error", "Error occurred deleting category!")
                }
            })
        }
        delete.backgroundColor = UIColor.red
        
        let edit = UITableViewRowAction(style: .normal, title: "More") { (action, indexPath) in
            
            let categoryDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "CategoryDetailViewController") as! CategoryDetailViewController
            categoryDetailViewController.editCategory = self.categories[indexPath.row]
            categoryDetailViewController.delegate = self
            let navController = UINavigationController(rootViewController: categoryDetailViewController)
            self.present(navController, animated:true, completion: nil)
            
        }
        
        edit.backgroundColor = UIColor.orange
        
        return [edit, delete]
    }

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

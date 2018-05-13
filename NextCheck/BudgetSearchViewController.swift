//
//  BudgetSearchViewController.swift
//  CheckNow
//
//  Created by Khari Moore on 4/21/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import UIKit
import Eureka
import os.lock

class BudgetSearchViewController: FormViewController {
var Budgets = [Budget]()
var SelectedBudgetIDs = [Int64]()
var delegate: MainDismissHandler!
static let ui_log = OSLog(subsystem: "com.example.NextCheck", category: "UI")
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        do {
            
            
//            self.Budgets += try BudgetRepo.findAll()!.sorted(by: {(b1, b2) in b1.startDate.timeIntervalSince1970 > b2.startDate.timeIntervalSince1970})
//            form +++
//                Section() { section in
//                    var header = HeaderFooterView<BudgetSectionView>(.nibFile(name: "BudgetSectionView", bundle: nil))
//
//                    // Will be called every time the header appears on screen
//                    header.onSetupView = { view, _ in
//                        // Commonly used to setup texts inside the view
//                        // Don't change the view hierarchy or size here!
//                    }
//                    section.header = header
//            }
//            SelectableSection<ListCheckRow<Int64>>("Select Budgets", selectionType: .multipleSelection)
//            for budget in Budgets{
//                form.last! <<< ListCheckRow<Int64>{ row in
//                    row.title = DateFormatter.localizedString(from: budget.startDate, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.none)
//                    row.selectableValue = budget.BudgetId!
//
//                }
//            }
            
        } catch  {
            os_log("Error occured loading budget search: %@", log: ExpenseDetailViewController.ui_log, type: .error,error.localizedDescription)
            self.showAlertOK("Error", "Error occurred loading budgets!")
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        do{
       let rows = (form[0] as! SelectableSection<ListCheckRow<Int64>>).selectedRows()
        if !rows.isEmpty{
            SelectedBudgetIDs += rows.map({$0.value!})
            let budgets = self.Budgets.filter({SelectedBudgetIDs.contains($0.BudgetId!)})
            for item in budgets{
                if let transactions = try TransactionRepo.findByBudgetId(id: item.BudgetId!){
                    item.FinancialTransactions = transactions
                }
            }
            delegate.dismissedSearch(filter: budgets)
            navigationController?.popViewController(animated: true)
        }
        }catch{
            os_log("Error occured filtering budgets: %@", log: ExpenseDetailViewController.ui_log, type: .error,error.localizedDescription)
            self.showAlertOK("Error", "Error occurred filtering budgets!")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
        
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

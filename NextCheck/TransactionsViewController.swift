//
//  TransactionsViewController.swift
//  CheckNow
//
//  Created by Khari Moore on 2/3/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import UIKit
import Eureka

class TransactionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        form
//            +++ Section()
//            <<< ButtonRow("Add Budget") { (row: ButtonRow) in
//                row.title = row.tag
//                row.presentationMode = .segueName(segueName: "BudgetViewControllerSegue", onDismiss: nil)
//            }
//
//        +++ Section() { section in
//            var header = HeaderFooterView<BudgetGroupHeader>(.class)
//            header.height = {25}
//            // Will be called every time the header appears on screen
//            header.onSetupView = { view, _ in
//                // Commonly used to setup texts inside the view
//                // Don't change the view hierarchy or size here!
//            }
//            section.header = header
//        }
//            <<< ButtonRow("Add Budget") {
//                $0.title = $0.tag
//                $0.presentationMode = .show(controllerProvider: .callback(builder: {
//                   return UINavigationController(rootViewController: BudgetViewController())// instantiate viewController
//                }), onDismiss:nil)
//    }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    // MARK: - Navigation

   //  In a storyboard-based application, you will often want to do a little preparation before navigation
   // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         Get the new view controller using segue.destinationViewController.
//         Pass the selected object to the new view controller.
        
        
   // }
    
    //TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TransactionItemTableViewCell"//name of table cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TransactionItemTableViewCell
        
        return cell
        
    }

    
}


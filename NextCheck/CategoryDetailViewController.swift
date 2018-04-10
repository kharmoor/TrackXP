//
//  CategoryDetailViewController.swift
//  CheckNow
//
//  Created by Khari Moore on 2/10/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import UIKit
import Eureka

class CategoryDetailViewController: FormViewController {
    var delegate: CategoryDetailModalHandler?
    var editCategory: Category?
    var viewModel: ViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        form
            +++ Section()
            <<< TextRow(){
                $0.title = "Name"
                $0.placeholder = "Enter Name"
                $0.value = viewModel!.Name
                let ruleRequiredViaClosure = RuleClosure<String> { rowValue in
                    return (rowValue == nil || rowValue!.isEmpty) ? ValidationError(msg: "Name is required!") : nil
                }
                
                $0.add(rule: ruleRequiredViaClosure)
                $0.validationOptions = .validatesOnDemand
                $0.onChange({[unowned self] row in
                    if let name = row.value{
                        self.viewModel.Name = name
                    }
                })
            }
            <<< PickerInlineRow<Int64>() {
                $0.title = "Category Type"
                $0.displayValueFor = { (rowValue: Int64?) in
                    //explain option map: 
                    return rowValue.map { _ in CategoryTypes.allValues.first( where: { $0.rawValue == rowValue })!.description}
                }
                $0.options = CategoryTypes.allValues.map {$0.rawValue}
                $0.onChange({[unowned self] row in
                    if let typeId = row.value{
                        self.viewModel.TypeId = Int64(typeId)
                    }
                })
                if let typeId = viewModel.TypeId{
                    $0.value = typeId
                }
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

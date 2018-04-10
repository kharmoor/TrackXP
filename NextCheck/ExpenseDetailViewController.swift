//
//  ExpensesViewController.swift
//  NextCheck
//
//  Created by Khari Moore on 6/11/17.
//  Copyright © 2017 Khari Moore. All rights reserved.
//

import UIKit
import os.log
import Eureka

class ExpenseDetailViewController: FormViewController {
    var delegate:ExpenseDetailModalHandler?
    var editExpense: Expense?
    var viewModel: ViewModel!
    var categories: [Int64:String] = [1 : "Food", 2 : "Entertainment", 3: "Financial", 4: "Utility"]
    
    static let ui_log = OSLog(subsystem: "com.example.NextCheck", category: "UI")
    
    convenience init() {
        self.init()

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem?.target = self
        
        os_log("Loading expense details", log: ExpenseDetailViewController.ui_log, type: .info)
        
        //load view model
        if let expense = editExpense{
            self.viewModel = ViewModel(expense: expense)
        }else{
            let expense = Expense(expenseId: nil, name: "", description: nil, categoryId: nil, amount: 0 )
            self.viewModel = ViewModel(expense: expense)
        }
        
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
            <<< DecimalRow(){  //closue (DecimalRow) -> Void Note: This is called in the init function which has a nested Initializer function/closure expression with arg type row
                        $0.useFormatterDuringInput = true
                        $0.title = "Amount"
                        $0.placeholder = "Enter Amount"
                        $0.value = NSDecimalNumber(decimal: viewModel!.Amount).doubleValue
                        let formatter = CurrencyFormatter()
                        formatter.locale = .current
                        formatter.numberStyle = .currency
                        $0.formatter = formatter
                        $0.onChange({[unowned self] row in
                            if let amount = row.value{
                                self.viewModel.Amount = Decimal(amount)
                            }
                        })
                    }
            <<< PickerInlineRow<Int64>() {
                $0.title = "Category"
                $0.displayValueFor = { (rowValue: Int64?) in
                    return rowValue.map { self.categories[$0]!  }
                }
                $0.options = categories.map {$0.key}
                $0.onChange({[unowned self] row in
                    if let categoryId = row.value{
                        self.viewModel.CategoryId = Int64(categoryId)
                    }
                })
                if let catId = viewModel.CategoryId{
                    $0.value = catId
                }
            }

            <<< TextAreaRow() {
                $0.title = "Description"
                $0.placeholder = "Description"
                $0.value = self.viewModel.Description
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                $0.onChange({[unowned self] row in
                    if let desc = row.value{
                        self.viewModel.Description = desc
                    }
                })
        }
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Actions
    @IBAction func saveExpense(_ sender: Any) {
        do
        {
            //throw NSError(domain: "my error description", code: 42, userInfo: ["ui1":12, "ui2":"val2"] )
            let validationErrors = form.validate()
            if validationErrors.isEmpty{
            let amount = viewModel.Amount //Decimal(string: viewModel.Amount) ?? 0
            let name = viewModel.Name
            let description = viewModel.Description
            let categoryId = viewModel.CategoryId
            let expenseId = editExpense == nil ? nil : editExpense?.ExpenseId
                
            let expense = Expense(expenseId: expenseId, name: name, description: description, categoryId: categoryId, amount: amount)
                let eid: Int64
                if editExpense == nil{
                    eid = try ExpenseRepo.insert(item: expense)
                }else{
                    try ExpenseRepo.update(item: expense)
                    eid = editExpense!.ExpenseId!
                }
            //let eid = Int64(0)
//            let expenseId = Int(truncatingBitPattern: eid)
            
            dismiss(animated: true) {
                self.delegate!.modalDismissed(expenseId: eid)
        }
            }else{
//                let alert = UIAlertController(title: "Expense Alert", message: validationErrors[0].msg, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//                self.present(alert, animated: true)
                self.showAlertOK("Expense Alert", validationErrors[0].msg)
            }
        }catch let error as NSError {
            os_log("Error occured saving expense: %@", log: ExpenseDetailViewController.ui_log, type: .error,error.localizedDescription)
            self.showAlertOK("Error", "Error occurred saving expense!")
        }
    }
    @IBAction func cancelExpense(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //MARK: Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//
////        guard let button = sender as? UIBarButtonItem, button === saveButton else {
////            //Log exception
////            return
////        }
//
//    }
    
    //MARK: Private Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let MAX_DIGITS: Int = 11
        // $999,999,999.99
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        
        var stringMaybeChanged: String = string
        if (stringMaybeChanged.count > 1 ){//remove the dollar sign and commas to make string a number/decimal
            var stringPasted: String = stringMaybeChanged
            
            //subRange: we get subrange to use in the replacingOccurrences function
            if let subRange = Range<String.Index>(NSRange(location: 0, length: stringPasted.count), in: stringPasted) {
                stringPasted = stringPasted.replacingOccurrences(of: numberFormatter.currencySymbol, with: "", options: .literal, range: subRange)
            }
            
            if let subRange = Range<String.Index>(NSRange(location: 0, length: stringPasted.count), in: stringPasted) { stringPasted = stringPasted.replacingOccurrences(of: numberFormatter.groupingSeparator, with: "", options: .literal, range: subRange)
                
            }
            let numberPasted = NSDecimalNumber(string: stringPasted)
            stringMaybeChanged = numberFormatter.string(from: numberPasted) ?? ""
        }
        
        let selectedRange: UITextRange? = textField.selectedTextRange
        let start: UITextPosition? = textField.beginningOfDocument
        let cursorOffset: Int = textField.offset(from: start ?? UITextPosition(), to: selectedRange?.start ?? UITextPosition())
        var textFieldTextStr: String = textField.text ?? ""
        let textFieldTextStrLength: Int = textFieldTextStr.count
        
        if let subRange = Range<String.Index>(range, in: textFieldTextStr) { textFieldTextStr.replaceSubrange(subRange, with: stringMaybeChanged) }
        if let subRange = Range<String.Index>(NSRange(location: 0, length: textFieldTextStr.count), in: textFieldTextStr) { textFieldTextStr = textFieldTextStr.replacingOccurrences(of: numberFormatter.currencySymbol, with: "", options: .literal, range: subRange) }
        if let subRange = Range<String.Index>(NSRange(location: 0, length: textFieldTextStr.count), in: textFieldTextStr) { textFieldTextStr = textFieldTextStr.replacingOccurrences(of: numberFormatter.groupingSeparator, with: "", options: .literal, range: subRange) }
        if let subRange = Range<String.Index>(NSRange(location: 0, length: textFieldTextStr.count), in: textFieldTextStr) { textFieldTextStr = textFieldTextStr.replacingOccurrences(of: numberFormatter.decimalSeparator, with: "", options: .literal, range: subRange) }
        
        if textFieldTextStr.count <= MAX_DIGITS {
            let textFieldTextNum = NSDecimalNumber(string: textFieldTextStr)
            //var divideByNum: NSDecimalNumber? = 10.raising(toPower: numberFormatter.maximumFractionDigits)
            let textFieldTextNewNum = textFieldTextNum.dividing(by: 100)
            let textFieldTextNewStr: String? = numberFormatter.string(from: textFieldTextNewNum)
            
            textField.text = textFieldTextNewStr
            if cursorOffset != textFieldTextStrLength {
                let lengthDelta: Int = textFieldTextNewStr!.count - textFieldTextStrLength
                let newCursorOffset: Int = max(0, min(textFieldTextNewStr!.count, cursorOffset + lengthDelta))
                let newPosition: UITextPosition? = textField.position(from: textField.beginningOfDocument, offset: newCursorOffset)
                let newRange: UITextRange? = textField.textRange(from: newPosition ?? UITextPosition(), to: newPosition ?? UITextPosition())
                textField.selectedTextRange = newRange
            }
        }
        
        return false;
    }
    
   

}


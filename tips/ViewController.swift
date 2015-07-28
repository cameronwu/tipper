//
//  ViewController.swift
//  tipper
//
//  Created by Cameron Wu on 2015-07-15.
//  Copyright (c) 2015 Cameron Wu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel1: UILabel!
    @IBOutlet weak var totalLabel2: UILabel!
    @IBOutlet weak var totalLabel3: UILabel!
    @IBOutlet weak var totalLabel4: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var resultsView: UIView!
    
    var isEmpty = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        tipLabel.text = "$0.00"
        totalLabel1.text = "$0.00"
        totalLabel2.text = "$0.00"
        totalLabel3.text = "$0.00"
        
        billField.becomeFirstResponder()
        billField.center.y = 186
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        self.resultsView.frame.origin.y = screenSize.height
        
        billField.delegate = self;
 
        var numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .CurrencyStyle
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        
        billField.text = numberFormatter.stringFromNumber(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func updateTotals() {
        var tipPercentages = [0.15, 0.18, 0.20]
        var tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        
        var billAmountStr:NSMutableString = NSMutableString(string: billField.text)
        var numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .CurrencyStyle
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        
        billAmountStr.replaceOccurrencesOfString(numberFormatter.currencySymbol!, withString: "", options: .LiteralSearch, range: NSMakeRange(0, billAmountStr.length))
        billAmountStr.replaceOccurrencesOfString(numberFormatter.groupingSeparator!, withString: "", options: .LiteralSearch, range: NSMakeRange(0, billAmountStr.length))
        
        var billAmountNum = (billAmountStr as NSString).doubleValue
        var tip = billAmountNum * tipPercentage
        var total = billAmountNum + tip
        
        tipLabel.text = numberFormatter.stringFromNumber(tip)
        totalLabel1.text = numberFormatter.stringFromNumber(total)
        totalLabel2.text = numberFormatter.stringFromNumber(total/2)
        totalLabel3.text = numberFormatter.stringFromNumber(total/3)
        totalLabel4.text = numberFormatter.stringFromNumber(total/4)
        
        animateOpenOrClosed()
    }
    
    @IBAction func onFocus(sender: AnyObject) {
        animateOpenOrClosed()
    }
    
    @IBAction func onTap(sender: AnyObject) {
        // Only close keyboard if billField is empty
        if (billField.text != "$0.00") {
            view.endEditing(true)
        }
    }
    
    
    // Check if billField is empty
    
    func isBillFieldEmpty() -> Bool {
        if (billField.text != "$0.00") {
            return false
        } else {
            return true
        }
    }
    
    
    // Animate billField and other content if billField is not empty

    func animateOpenOrClosed() {
        if (isBillFieldEmpty()) {
            UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseOut, animations: {
                self.billField.center.y = 186
                let screenSize: CGRect = UIScreen.mainScreen().bounds
                self.resultsView.frame.origin.y = screenSize.height
            }, completion: {
                finished in
                println("Closed!")
            })
        } else {
            UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseOut, animations: {
                self.billField.center.y = 87
                self.resultsView.frame.origin.y = 160
            }, completion: {
                finished in
                println("Opened!")
            })
        }
    }
    
    
    //  FormattedCurrencyInput
    //
    //  Created by Peter Boni on 4/07/13.
    //  Copyright (c) 2013 Peter Boni. All rights reserved.
    //  Adapted to Swift by Cameron Wu on 6/23/15.
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var MAX_DIGITS = 11 // $999,999,999.99
        
        var numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .CurrencyStyle
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        
        var stringMaybeChanged:NSString = NSString(string: string)
        if (stringMaybeChanged.length > 1) {
            var stringPasted:NSMutableString = NSMutableString(string: stringMaybeChanged)
            stringPasted.replaceOccurrencesOfString(numberFormatter.currencySymbol!, withString: "", options: .LiteralSearch, range: NSMakeRange(0, stringPasted.length))
            stringPasted.replaceOccurrencesOfString(numberFormatter.groupingSeparator!, withString: "", options: .LiteralSearch, range: NSMakeRange(0, stringPasted.length))
            var numberPasted = (stringPasted as NSString).floatValue
            stringMaybeChanged = numberFormatter.stringFromNumber(numberPasted)!
        }
        
        var selectedRange:UITextRange = billField.selectedTextRange!
        var start:UITextPosition = billField.beginningOfDocument
        var cursorOffset:Int = billField.offsetFromPosition(start, toPosition: selectedRange.start)
        var textFieldTextStr:NSMutableString = NSMutableString(string: billField.text)
        var textFieldTextStrLength:Int = textFieldTextStr.length
        
        textFieldTextStr.replaceCharactersInRange(range, withString: stringMaybeChanged as String)
        
        textFieldTextStr.replaceOccurrencesOfString(numberFormatter.currencySymbol!, withString: "", options: .LiteralSearch, range: NSMakeRange(0, textFieldTextStr.length))
        textFieldTextStr.replaceOccurrencesOfString(numberFormatter.groupingSeparator!, withString: "", options: .LiteralSearch, range: NSMakeRange(0, textFieldTextStr.length))
        textFieldTextStr.replaceOccurrencesOfString(numberFormatter.decimalSeparator!, withString: "", options: .LiteralSearch, range: NSMakeRange(0, textFieldTextStr.length))
        
        if (textFieldTextStr.length <= MAX_DIGITS) {
            var textFieldTextNum:NSDecimalNumber = NSDecimalNumber(string: textFieldTextStr as String)
            var tempNum:NSDecimalNumber = 10
            var divideByNum:NSDecimalNumber = tempNum.decimalNumberByRaisingToPower(numberFormatter.maximumFractionDigits)
            var textFieldTextNewNum = textFieldTextNum.decimalNumberByDividingBy(divideByNum)
            
            var textFieldTextNewStr:NSString = numberFormatter.stringFromNumber(textFieldTextNewNum)!
            
            textField.text = textFieldTextNewStr as String;
            
            if (cursorOffset != textFieldTextStrLength) {
                var lengthDelta:Int = textFieldTextNewStr.length - textFieldTextStrLength
                var newCurSorOffset = max(0, min(textFieldTextNewStr.length, cursorOffset + lengthDelta))
                var newPosition:UITextPosition = textField.positionFromPosition(textField.beginningOfDocument, offset: newCurSorOffset)!
                var newRange:UITextRange = textField.textRangeFromPosition(newPosition, toPosition: newPosition)
                textField.selectedTextRange = newRange
            }
        }
        
        updateTotals()
        
        return false
    }
}
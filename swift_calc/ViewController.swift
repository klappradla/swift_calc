//
//  ViewController.swift
//  swift_calc
//
//  Created by Max on 12.02.15.
//  Copyright (c) 2015 klappradla. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
        }
    }
    
    var typingNumber = false
    
    var operation: String?
    
    var stack = [Double]()
    
    var knownOperations = ["+", "−", "×", "÷"]

    @IBAction func reset() {
        stack.removeAll()
        displayValue = 0
        operation = nil
    }
    
    @IBAction func addDigit(sender: UIButton) {
        if typingNumber {
            display.text! += sender.currentTitle!
        } else {
            display.text! = sender.currentTitle!
            typingNumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if typingNumber {
            stack.append(displayValue)
            println("add to stack: \(displayValue)")
            println("stacksize: \(stack.count)")
            //evaluate()
            typingNumber = false
        }
        operation = sender.currentTitle!
        println("set operation: \(operation!)")
    }
    
    @IBAction func evaluate() {
        println("evaluate")
        typingNumber = false
        if operation != nil && stack.count > 0 {
            display.text! = "\(performOperation(operation!))"
        }
        println("stack: \(stack.count)")
    }
    
    func performOperation(operation: String) -> Double {
        switch operation {
        case "+":
            return stack.removeLast() + displayValue
        case "−":
            return stack.removeLast() - displayValue
        case "×":
            return stack.removeLast() * displayValue
        case "÷":
            return stack.removeLast() / displayValue
        default:
            return 0
        }
    }
}


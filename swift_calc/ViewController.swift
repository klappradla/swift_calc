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
    
    var motor = Calculator()
    
    var operation: String?

    @IBAction func reset() {
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
            if (operation != nil) {
                println("call evaluate")
                evaluate()
            } else {
                motor.pushOperand(displayValue)
                typingNumber = false
            }
        }
        operation = sender.currentTitle!
        println("set operation: \(operation!)")
    }
    
    @IBAction func evaluate() {
        if typingNumber {
            typingNumber = false
            motor.pushOperand(displayValue)
            if let newValue = motor.performOperation(operation!) {
                operation = nil
                displayValue = newValue
            }
        }
    }
}


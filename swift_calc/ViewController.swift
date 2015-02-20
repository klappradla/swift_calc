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
    
    @IBOutlet weak var history: UILabel!
    
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
        typingNumber = false
        display.text! = "\(0)"
        operation = nil
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        if typingNumber {
            display.text! += sender.currentTitle!
        } else {
            display.text! = sender.currentTitle!
            typingNumber = true
        }
    }
    
    @IBAction func floatPoint(sender: UIButton) {
        if display.text?.rangeOfString(sender.currentTitle!) == nil {
            appendDigit(sender)
        }
    }
    
    @IBAction func useVar(sender: UIButton) {
        if !typingNumber {
            motor.pushOperand(sender.currentTitle!)
            display.text! = sender.currentTitle!
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if typingNumber {
            if (operation != nil) {
                //println("call evaluate")
                evaluate()
                //enter()
            } else {
                motor.pushOperand(displayValue)
                typingNumber = false
            }
        }
        operation = sender.currentTitle!
        println("set operation: \(operation!)")
    }
    
    @IBAction func enter() {
        if let newValue = evaluate() {
            displayValue = newValue
        }
    }
    
    func evaluate() -> Double? {
        println("call eval")
        if typingNumber {
            motor.pushOperand(displayValue)
            typingNumber = false
        }
        let result = motor.performOperation(operation)
        
        history.text! = motor.description
        
        operation = nil
        return result
    }
}


//
//  ViewController.swift
//  swift_calc
//
//  Created by Max on 12.02.15.
//  Copyright (c) 2015 klappradla. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var typing = false
    
    var motor = Calculator()
    
    var operation: String?
    
    var currentNumber = ""
    
    @IBOutlet weak var history: UILabel!

    @IBOutlet weak var display: UILabel!
    
    var currentValue: Double {
        get {
            return NSNumberFormatter().numberFromString(currentNumber)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
        }
    }

    @IBAction func appendDigit(sender: UIButton) {
        if typing {
            //display.text! += sender.currentTitle!
            currentNumber += sender.currentTitle!
        } else {
            // do something
            //display.text! = sender.currentTitle!
            currentNumber = sender.currentTitle!
            typing = true
        }
        appendToDisplay(sender.currentTitle!)
    }
    
    func appendToDisplay(char: String) {
        history.text! += char
    }
    
    @IBAction func floatingPoint(sender: UIButton) {
        if currentNumber.rangeOfString(sender.currentTitle!) == nil {
            appendDigit(sender)
        }
    }
    
    @IBAction func reset() {
        typing = false
        display.text! = "\(0)"
        operation = nil
    }
    
    @IBAction func addVariable(sender: UIButton) {
        if !typing {
            motor.pushOperand(sender.currentTitle!)
            //display.text! = sender.currentTitle!
            appendToDisplay(sender.currentTitle!)
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if typing {
            if (operation != nil) {
                //println("call evaluate")
                evaluate()
                //enter()
            } else {
                motor.pushOperand(currentValue)
                typing = false
            }
        }
        operation = sender.currentTitle!
        appendToDisplay(sender.currentTitle!)
        println("set operation: \(operation!)")
    }
    
    @IBAction func enter(sender: UIButton) {
        appendToDisplay(sender.currentTitle!)
        if let newValue = evaluate() {
            currentValue = newValue
        }
    }
    
    func evaluate() -> Double? {
        println("call eval")
        if typing {
            motor.pushOperand(currentValue)
            typing = false
        }
        let result = motor.performOperation(operation)
        operation = nil
        return result
    }
}


//
//  Calculator.swift
//  swift_calc
//
//  Created by Max on 12.02.15.
//  Copyright (c) 2015 klappradla. All rights reserved.
//

import Foundation

class Calculator {
    
    private enum Op {
        case Operand(Double) // case associated with a double value
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double) // case associated with symbol and function
    }
    
    private var stack = [Op?]()
    
    private var knownOperations = [String:Op]()
    
    init() {
        //println("init calculator")
        knownOperations["+"] = Op.BinaryOperation("+", { $0 + $1})
        knownOperations["−"] = Op.BinaryOperation("−", { $1 - $0})
        knownOperations["×"] = Op.BinaryOperation("×", { $0 * $1})
        knownOperations["÷"] = Op.BinaryOperation("÷", { $1 / $0})
        knownOperations["√"] = Op.UnaryOperation("√", { sqrt($0) })
    }
    
    func pushOperand(value: Double) {
        println("add operand: \(value)")
        stack.append(Op.Operand(value))
    }
    
    func performOperation(type: String) -> Double? {
        if let operation = knownOperations[type] {
            stack.append(operation)
        }
        
        // also evaluate if no operation (just return value...)
        if let result = evaluate() {
            stack.append(Op.Operand(result))
            println("app result to stack: \(result)")
            return result
        }
        return nil
    }
    
    private func evaluate() -> Double? {
        if !stack.isEmpty {
            if let currentOp = stack.removeLast() {
                switch currentOp {
                case .Operand(let value):
                    println("return value: \(value)")
                    return value
                case .UnaryOperation(_, let operation):
                    if let op = evaluate() {
                        return operation(op)
                    }
                case .BinaryOperation(_, let operation):
                    if let op1 = evaluate() {
                        if let op2 = evaluate() {
                            println("return operation")
                            return operation(op1, op2)
                        }
                    }
                }
            }
        }
        return nil
    }
}

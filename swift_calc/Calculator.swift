//
//  Calculator.swift
//  swift_calc
//
//  Created by Max on 12.02.15.
//  Copyright (c) 2015 klappradla. All rights reserved.
//

import Foundation

class Calculator {
    
    private enum Op: Printable { // implements protocol printable
        case Operand(Double) // case associated with a double value
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double) // case associated with symbol and function
        
        // implementation of protocol
        var description: String {
            switch self {
            case .Operand(let value):
                return "\(value)"
            case .UnaryOperation(let symbol, _):
                return symbol
            case .BinaryOperation(let symbol, _):
                return symbol
            }
        }
    }
    
    private var stack = [Op?]()
    
    private var knownOperations = [String:Op]()
    
    private var variables = [String:Op]()
    
    var description: String {
        get {
            return describe(stack).result
        }
    }
    
    private func describe(opStack: [Op?]) -> (result: String, remainingOps: [Op?]) {
        if !opStack.isEmpty {
            var remainingOps = opStack
            if let currentOp = remainingOps.removeLast() {
                switch currentOp {
                case .Operand:
                    return (currentOp.description, remainingOps)
                case .UnaryOperation:
                    let op = describe(remainingOps).result
                    return ("\(currentOp.description)(\(op))", remainingOps)
                case .BinaryOperation:
                    let op1 = describe(remainingOps)
                    let op2 = describe(op1.remainingOps)
                    return ("(\(op2.result)\(currentOp)\(op1.result))", remainingOps)
                }
            }
        }
        return ("?", opStack)
    }
    
    init() {
        // binary operations
        knownOperations["+"] = Op.BinaryOperation("+", { $0 + $1})
        knownOperations["−"] = Op.BinaryOperation("−", { $1 - $0})
        knownOperations["×"] = Op.BinaryOperation("×", { $0 * $1})
        knownOperations["÷"] = Op.BinaryOperation("÷", { $1 / $0})
        
        // unary operations
        knownOperations["√"] = Op.UnaryOperation("√", { sqrt($0) })
        knownOperations["sin"] = Op.UnaryOperation("sin", { sin($0) })
        knownOperations["cos"] = Op.UnaryOperation("cos", { cos($0) })
        
        // variables
        variables["π"] = Op.Operand(M_PI)
    }
    
    func pushOperand(value: Double) {
        println("add operand: \(value)")
        stack.append(Op.Operand(value))
    }
    
    func pushOperand(char: String) {
        if let variable = variables[char] {
            println("add variable: \(char)")
            stack.append(variable)
        }
        
    }
    
    func performOperation(type: String?) -> Double? {
        if let symbol = type {
            if let operation = knownOperations[symbol] {
                println("add operation: \(symbol)")
                stack.append(operation)
                return evaluate()
            }
        }
        return nil
    }
    
    func evaluate() -> Double? {
        // could add result to stack...
        println("stacksize: \(stack.count)")
        return evaluate(stack).result
    }
    
    private func evaluate(opStack: [Op?]) -> (result: Double?, remainingOps: [Op?]) {
        if !opStack.isEmpty {
            var remainingOps = opStack
            if let currentOp = remainingOps.removeLast() {
                switch currentOp {
                case .Operand(let value):
                    println("return value: \(value)")
                    return (value, remainingOps)
                case .UnaryOperation(_, let operation):
                    let eval = evaluate(remainingOps)
                        if let op = eval.result {
                            return (operation(op), eval.remainingOps)
                        }
                case .BinaryOperation(_, let operation):
                    let eval1 = evaluate(remainingOps)
                    if let op1 = eval1.result {
                        let eval2 = evaluate(eval1.remainingOps)
                        if let op2 = eval2.result {
                            println("return operation")
                            return (operation(op1, op2), remainingOps)
                        }
                    }
                }
            }
        }
        return (nil,opStack)
    }
}

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
                stack.append(operation)
            }
            
        }
        
        // also evaluate if no operation (just return value...)
        if let result = evaluate() {
            stack.append(Op.Operand(result))
            println("app result to stack: \(result)")
//            println("print stack:")
//            for op in stack {
//                println(op!.description)
//            }
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

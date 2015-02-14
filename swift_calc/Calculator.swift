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
        case BinaryOperation(String, (Double, Double) -> Double) // case associated with symbol and function
    }
    
    private var stack = [Op]()
    
    private var knownOperations = [String:Op]()
    
    init() {
        println("init calculator")
        knownOperations["+"] = Op.BinaryOperation("+", { $0 + $1})
        knownOperations["−"] = Op.BinaryOperation("−", { $1 - $0})
        knownOperations["×"] = Op.BinaryOperation("×", { $0 * $1})
        knownOperations["÷"] = Op.BinaryOperation("÷", { $1 / $0})
    }
    
    func pushOperand(operand: Double) {
        let newOperand = Op.Operand(operand)
        stack.append(newOperand)
        println("stack push operand: \(stack.last)")
        switch newOperand {
        case .Operand(let value):
            println("new value: \(value)")
        default:
            break
        }
    }
    
    func performOperation(type: String) -> Double {
        if let operation = knownOperations[type] {
            stack.append(operation)
            println("add operation: \(type)")
        }
        return evaluate()
    }
    
    private func evaluate() -> Double {
        var currentOp = stack.removeLast()
        switch currentOp {
        case .Operand(let value):
            println("return value: \(value)")
            return value
        case .BinaryOperation(_, let operation):
            let op1 = evaluate()
            let op2 = evaluate()
            println("return operation")
            return operation(op1, op2)
        }
    }
}

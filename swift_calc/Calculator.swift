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
        knownOperations["+"] = Op.BinaryOperation("+", { $0 + $1})
        knownOperations["−"] = Op.BinaryOperation("−", { $1 - $1})
        knownOperations["×"] = Op.BinaryOperation("×", { $0 * $1})
        knownOperations["÷"] = Op.BinaryOperation("÷", { $1 / $0})
    }
    
    func pushOperand(operand: Double) {
        stack.append(Op.Operand(operand))
    }
}

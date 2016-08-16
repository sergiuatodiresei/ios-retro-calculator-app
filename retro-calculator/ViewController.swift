//
//  ViewController.swift
//  retro-calculator
//
//  Created by Sergiu Atodiresei on 14.08.2016.
//  Copyright © 2016 SergiuApps. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    @IBOutlet weak var outputLbl: UILabel!
    
    var btnSound: AVAudioPlayer!
    
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var currentOperation: Operation = Operation.Empty
    var result = ""
    var comma = false
    var negative = false
    var positive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        
        let soundUrl = NSURL(fileURLWithPath: path!)
        
        do{
              try btnSound = AVAudioPlayer(contentsOfURL: soundUrl)
            btnSound.prepareToPlay()
        } catch  let err as NSError {
            print(err.debugDescription)
        }
      
    }

    @IBAction func numberPressed(btn: UIButton) {
        playSound()
        
        
        if runningNumber != "0" {
            if btn.tag != 10 {
                runningNumber += "\(btn.tag)"
            }
            else if !comma {
                if runningNumber == "" {
                    runningNumber = "0"
                }
                runningNumber += "."
                comma = true
            }
            
        } else if btn.tag != 0  {
            if btn.tag == 10 {
                runningNumber = "0."
                comma = true
            } else {
                runningNumber = "\(btn.tag)"
            }
        }
        outputLbl.text = runningNumber
    }
    
    
    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(Operation.Divide)
    }

    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(Operation.Multiply)
    }
    
    
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(Operation.Subtract)
    }
    
    
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(Operation.Add)
    }
    
    
    @IBAction func onEqualsPressed(sender: AnyObject) {
        processOperation(currentOperation)
    }
    
    func processOperation(op: Operation) {
        playSound()
        
        if currentOperation != Operation.Empty {
            //Run some math
            
            //A user selected an operator, but then selected another operator without first entering a number
            if runningNumber != "" && leftValStr != "" {
                
                rightValStr = runningNumber
                runningNumber = ""
                
                switch currentOperation {
                case Operation.Multiply:
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                case  Operation.Divide:
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                case Operation.Subtract:
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                case Operation.Add:
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                default:
                    print("Operation error")
                }
                
                leftValStr = result
                
                outputLbl.text = result
                comma = false
                negative = false
            
            }
            
            currentOperation = op
            
        } else {
            //This is the first time an operator has been pressed
            if(runningNumber != "") {
                leftValStr = runningNumber
            }
            runningNumber = ""
            currentOperation = op
            comma = false
            negative = false
        }
        
    }
    
    func playSound(){
        if btnSound.playing {
            btnSound.stop()
        }
        btnSound.play()
    }
    
    @IBAction func onClearPressed(sender: AnyObject) {
        
        playSound()
        
        runningNumber = ""
        leftValStr = ""
        rightValStr = ""
        currentOperation = Operation.Empty
        result = ""
        
        outputLbl.text = "0"
        negative = false

    }
    
    @IBAction func onPositiveNegativeBtnPressed(sender: AnyObject) {
        playSound()
        
        if runningNumber != "" && outputLbl.text != "" {
            if !negative {
                outputLbl.text?.insert("-", atIndex: (outputLbl.text?.startIndex)!)
                negative = true
            } else {
                outputLbl.text?.removeAtIndex((outputLbl.text?.startIndex)!)
                negative = false
            }
            runningNumber = outputLbl.text!
        }
        if runningNumber == "" && outputLbl.text != "" && outputLbl.text != "0" {
            let index = outputLbl.text?.startIndex.advancedBy(0)
            if !negative && outputLbl.text![index!] != "-" {
                outputLbl.text?.insert("-", atIndex: (outputLbl.text?.startIndex)!)
                negative = true
            } else {
                outputLbl.text?.removeAtIndex((outputLbl.text?.startIndex)!)
                negative = false
            }
            leftValStr = outputLbl.text!
        }
        

    }
}


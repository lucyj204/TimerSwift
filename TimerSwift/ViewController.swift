//
//  ViewController.swift
//  TimerSwift
//
//  Created by Lucy Joyce on 27/01/2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var timerPicker: UIDatePicker!
    private var timer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func timerValueChanged(_ sender: UIDatePicker) {
        
        
    }
    
    
    @IBAction func startPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        timer.invalidate()
        progressBar.progress = 0.0
        
    }
}


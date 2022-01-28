//
//  ViewController.swift
//  TimerSwift
//
//  Created by Lucy Joyce on 27/01/2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var timerPicker: UIDatePicker!
    private var timer = Timer()
    var duration = 0.0
    var secondsPassed = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func timerValueChanged(_ sender: UIDatePicker) {
        
        
    }
    
    
    @IBAction func startPressed(_ sender: UIButton) {
        
        timer.invalidate()
        progressBar.progress = 0.0
        secondsPassed = 0
        
        duration = timerPicker.countDownDuration
        let formatter = DateComponentsFormatter()
        let formattedDuration = formatter.string(from: duration)
        print(duration)
        print(formattedDuration!)
        
        let completionTime = Calendar.current.date(byAdding: .second, value: Int(duration), to: Date())
        print(completionTime!)
        
    
        
        func cancelPressed(_ sender: UIButton) {
            timer.invalidate()
            
        }
    }
    
}

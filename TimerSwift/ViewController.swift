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
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minuteTextField: UITextField!
    @IBOutlet weak var secondsTextField: UITextField!
    
    
    private var completionTime: Date?
    private var timer = Timer()
    //    private let requestedCalendarComponent : Set<Calendar.Component> = [
    //        Calendar.Component.hour,
    //        Calendar.Component.minute,
    //        Calendar.Component.second
    //    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func timerValueChanged(_ sender: UIDatePicker) {
        
        
    }
    
    
    
    @IBAction func startPressed(_ sender: UIButton) {
        
        let hours = Int(hourTextField.text!) ?? 0
        let hoursToSeconds = hours * 3600
        let minutes = Int(minuteTextField.text!) ?? 0
        let minutesToSeconds = minutes * 60
        let seconds = Int(secondsTextField.text!) ?? 0
        let duration = hoursToSeconds + minutesToSeconds + seconds
        let now = Date()
        self.completionTime = Calendar.current.date(byAdding: .second, value: duration, to: now)
        
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
        timer.fire()
        
    }
    
    
    @objc func updateCountdown() {
        
        let now = Date()
        
        let timeRemaining = calculateTimeDifference(startTime: now, completionTime: completionTime!)
        
        if timeRemaining > 0 {
            timeLabel.text = "\(timeRemaining)"
        } else {
            timeLabel.text = "Timer done"
            timer.invalidate()
        }
        
    }
    
    
    
    func cancelPressed(_ sender: UIButton) {
        
        timer.invalidate()
        
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


func calculateTimeDifference(startTime: Date, completionTime: Date) -> TimeInterval {
    
    return completionTime.timeIntervalSinceNow - startTime.timeIntervalSinceNow
    
}

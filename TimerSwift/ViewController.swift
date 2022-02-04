//
//  ViewController.swift
//  TimerSwift
//
//  Created by Lucy Joyce on 27/01/2022.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minuteTextField: UITextField!
    @IBOutlet weak var secondsTextField: UITextField!
    
    private var completionTime: Date?
    private var timer = Timer()
    private var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
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
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    @objc func updateCountdown() {
        let now = Date()
        let timeRemaining = calculateTimeDifference(startTime: now, completionTime: completionTime!)
        let displayHours = Int(timeRemaining) / 3600
        let displayMinutes = Int(timeRemaining) / 60 % 60
        let displaySeconds = Int(timeRemaining) % 60
        
        if timeRemaining > 0 {
            timeLabel.text = String(format: "%02i:%02i:%02i", displayHours, displayMinutes, displaySeconds)
            hourTextField.text = ""
            minuteTextField.text = ""
            secondsTextField.text = ""
        } else {
            timeLabel.text = "00:00:00"
            playSound()
            timer.invalidate()
        }
    }
    
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        completionTime = Date()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: false)
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        print("tap gesture recognised")
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "kitty", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
}


func calculateTimeDifference(startTime: Date, completionTime: Date) -> TimeInterval {
    return completionTime.timeIntervalSinceNow - startTime.timeIntervalSinceNow
}


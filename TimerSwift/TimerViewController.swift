//
//  ViewController.swift
//  TimerSwift
//
//  Created by Lucy Joyce on 27/01/2022.
//

import UIKit
import AVFoundation

class TimerViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    let defaults = UserDefaults.standard
    let now = Date()
    private var completionTime: Date?
    private var timer = Timer()
    private var player: AVAudioPlayer!
    private var duration: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        completionTime = defaults.value(forKey: "timeRemaining") as? Date
        updateCountdownFollowingAppReOpened()
        print("didLoad \(now)")
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    @IBAction func addTimerButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "setTimer", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setTimer" {
            let timerPicker = segue.destination as! SetTimerViewController
            timerPicker.onSetTime = { (data) in
                self.convertDataToTimeString(data)
                self.duration = data
            }
        }
    }
    
    private func convertDataToTimeString(_ data: Int) -> () {
        let hours = data / 3600
        let minutes = (data / 60) % 60
        let seconds = data % 60
        let timeString = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        timeLabel.text = timeString
    }

    private func updateCountdownFollowingAppReOpened() {
        let now = Date()
        if completionTime! > now {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
            timer.fire()
            print("update countdown if\(now)")
        } else {
            timeLabel.text = "00:00:00"
            defaults.set(self.completionTime, forKey: "timeRemaining")
            print("update countdown else\(now)")
        }
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
        let now = Date()
        completionTime = Calendar.current.date(byAdding: .second, value: duration, to: now)
        defaults.set(self.completionTime, forKey: "timeRemaining")
        
        
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
        } else {
            timeLabel.text = "Meow! Timer finished!"
            playSound()
            timer.invalidate()
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        completionTime = now
        print("cancel pressed \(now)")
        defaults.set(self.completionTime, forKey: "timeRemaining")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func playSound() {
        let url = Bundle.main.url(forResource: "kitty", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
}


func calculateTimeDifference(startTime: Date, completionTime: Date) -> TimeInterval {
    return completionTime.timeIntervalSinceNow - startTime.timeIntervalSinceNow
}


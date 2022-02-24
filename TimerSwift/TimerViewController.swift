//
//  ViewController.swift
//  TimerSwift
//
//  Created by Lucy Joyce on 27/01/2022.
//

import UIKit
import AVFoundation
import UserNotifications

class TimerViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var timerNameLabel: UILabel!
    
    let notificationManager = LocalNotifcationManager()
    private var timer = Timer()
    private var player: AVAudioPlayer!
    
    let now = Date()
    private var completionTime: Date = Date()
    var name: String?
    private var duration: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCountdownFollowingAppReOpened()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    //MARK: - IBActions
    
    @IBAction func addTimerButtonPressed(_ sender: UIBarButtonItem) {
        timeLabel.text = "00:00:00"
        
        let alert = UIAlertController(title: "Message from Kitty", message: "Please stop or reset the current timer in order to add a new one", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        if duration == 0 {
            performSegue(withIdentifier: "setTimer", sender: self)
        } else {
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setTimer" {
            let timerPicker = segue.destination as! SetTimerViewController
            
            timerPicker.onSetTime = { (data, name) in
                self.convertDataToTimeString(data)
                self.timerNameLabel.text = name
                self.duration = data
                self.name = name
            }
        }
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
        let now = Date()
        let name = timerNameLabel.text ?? ""
        completionTime = Calendar.current.date(byAdding: .second, value: duration, to: now)!
        addTimerData(TimerData(name: name, completionTime: completionTime))
        
        notificationManager.notifications = [TimerNotifications(id: "reminder-1", title: "Meowwww, \(name) Timer finished!", timeRemaining: TimeInterval(duration))]
        notificationManager.schedule()
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        timeLabel.text = "00:00:00"
        completionTime = now
        name = "Kitty Timer"
        timerNameLabel.text = name
        updateTimerData(TimerData(name: name!, completionTime: completionTime))
        notificationManager.removeNotification(identifier: "reminder-1")
        duration = 0
        timer.invalidate()
    }
    
    func addTimerData(_ timerData: TimerData) {
        do {
            let data = try JSONEncoder().encode(TimerData(name: timerData.name, completionTime: timerData.completionTime))
            UserDefaults.standard.set(data, forKey: "timerData")
        } catch {
            print("Error encoding data when adding \(error.localizedDescription)")
        }
    }
    
    func updateTimerData(_ timerData: TimerData) {
        do {
            let data = try JSONEncoder().encode(TimerData(name: timerData.name, completionTime: timerData.completionTime))
            UserDefaults.standard.set(data, forKey: "timerData")
        } catch {
            print("Error encoding data when updating \(error.localizedDescription)")
        }
    }
    
    func getTimerData(_ completion: @escaping((TimerData) -> Void)) {
        if let data = UserDefaults.standard.data(forKey: "timerData") {
            do {
                let timerDataObject = try JSONDecoder().decode(TimerData.self, from: data)
                completion(timerDataObject)
            } catch {
                print("Error decoding data \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - Timer Manager
    
    //TODO: timer data needed here - also need to look at how this is implemented as seems strange to put this is viewDidLoad with this name - sometimes the app has not been reopened but this function is still being called.
    func updateCountdownFollowingAppReOpened() {
        getTimerData() { timerData in
            self.completionTime = timerData.completionTime!
            self.name = timerData.name
        }
        
        let now = Date()
        if completionTime > now {
            timerNameLabel.text = name
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
            timer.fire()
        } else {
            timeLabel.text = "00:00:00"
            duration = 0
        }
    }
    
    @objc func updateCountdown()  {
        let now = Date()
        let timeRemaining = calculateTimeDifference(startTime: now, completionTime: completionTime)
        let displayHours = Int(timeRemaining) / 3600
        let displayMinutes = Int(timeRemaining) / 60 % 60
        let displaySeconds = Int(timeRemaining) % 60
        
        if timeRemaining > 0 {
            timeLabel.text = String(format: "%02i:%02i:%02i", displayHours, displayMinutes, displaySeconds)
        } else {
            timeLabel.text = "Meow! Timer finished!"
            playSound()
            duration = 0
            timer.invalidate()
        }
    }
    
    private func convertDataToTimeString(_ data: Int) -> () {
        let hours = data / 3600
        let minutes = (data / 60) % 60
        let seconds = data % 60
        let timeString = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        timeLabel.text = timeString
    }
    
    private func playSound() {
        let url = Bundle.main.url(forResource: "kitty", withExtension: "mp3")
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            player = try! AVAudioPlayer(contentsOf: url!)
            player.play()
        } catch {
            print(error)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

func calculateTimeDifference(startTime: Date, completionTime: Date) -> TimeInterval {
    return completionTime.timeIntervalSinceNow - startTime.timeIntervalSinceNow
}




//
//  SetTimerViewController.swift
//  TimerSwift
//
//  Created by Lucy Joyce on 09/02/2022.
//

import UIKit

class SetTimerViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var timerCreationView: UIView!
    @IBOutlet weak var selectTimerLengthLabel: UILabel!
    @IBOutlet weak var timerPickerView: UIPickerView!
    @IBOutlet weak var setTimerButton: UIButton!
    @IBOutlet weak var cancelTimerButton: UIButton!
    @IBOutlet weak var timerNameTextField: UITextField!
    
    var onSetTime: ((_ data: Int, _ name: String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerPickerView.delegate = self
        timerPickerView.dataSource = self
        timerPickerView.setValue(UIColor.white, forKey: "textColor")
        timerNameTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    func updateTimerLabelInSetTimer() {
        let hourTime = timerPickerView.selectedRow(inComponent: 0)
        let minuteTime = timerPickerView.selectedRow(inComponent: 2)
        let secondTime = timerPickerView.selectedRow(inComponent: 4)
        
        if secondTime == 0 && minuteTime == 0 && hourTime == 0 {
            selectTimerLengthLabel.text = "Select timer length:"
        } else {
            selectTimerLengthLabel.text = String(format: "%02i:%02i:%02i", hourTime, minuteTime, secondTime)
        }
    }
    
    @IBAction func setTimerPressed(_ sender: UIButton) {
        let hourTime = timerPickerView.selectedRow(inComponent: 0)
        let hoursToSecondsTime = hourTime * 3600
        let minuteTime = timerPickerView.selectedRow(inComponent: 2)
        let minutesToSecondsTime = minuteTime * 60
        let secondTime = timerPickerView.selectedRow(inComponent: 4)
        let duration = hoursToSecondsTime + minutesToSecondsTime + secondTime
        let name = timerNameTextField.text!
        
        onSetTime!(duration, name)
    
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension SetTimerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateTimerLabelInSetTimer()
    }
}

extension SetTimerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 1, 3, 5: return 1
        case 0: return 60
        case 2: return 60
        case 4: return 60
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return "\(row)"
        case 1: return "h"
        case 2: return "\(row)"
        case 3: return "m"
        case 4: return "\(row)"
        case 5: return "s"
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 1, 3, 5: return self.view.frame.width * 0.13
        case 0, 2, 4: return self.view.frame.width * 0.13
        default: return 0
        }
    }
}

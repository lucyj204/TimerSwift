//
//  SetTimerViewController.swift
//  TimerSwift
//
//  Created by Lucy Joyce on 09/02/2022.
//

import UIKit

class SetTimerViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var timerCreationView: UIView!
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
    
    @IBAction func setTimerPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Alert", message: "Please select timer duration", preferredStyle: .alert)
        
        let hourTime = timerPickerView.selectedRow(inComponent: 0)
        let hoursToSecondsTime = hourTime * 3600
        let minuteTime = timerPickerView.selectedRow(inComponent: 1)
        let minutesToSecondsTime = minuteTime * 60
        let secondTime = timerPickerView.selectedRow(inComponent: 2)
        let duration = hoursToSecondsTime + minutesToSecondsTime + secondTime
        let name = timerNameTextField.text!
        
        if duration != 0 {
            onSetTime!(duration, name)
        } else {
            present(alert, animated: true, completion: nil)
        }
        
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

extension SetTimerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        updateSelectedTimeLabel()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return 60
        case 1: return 60
        case 2: return 60
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let font = UIFont.systemFont(ofSize: 20.0)
        let fontSize: CGFloat = font.pointSize
        let componentWidth: CGFloat = self.view.frame.width / CGFloat(timerPickerView.numberOfComponents)
        let y = (timerPickerView.frame.size.height / 2) - (fontSize / 2)
        
        let hourLabel = UILabel(frame: CGRect(x: componentWidth * 1.6, y: y, width: componentWidth * 0.5, height: fontSize))
        hourLabel.font = font
        hourLabel.textAlignment = .left
        hourLabel.text = "Hr"
        hourLabel.textColor = UIColor.white
        timerPickerView.addSubview(hourLabel)
        
        let minuteLabel = UILabel(frame: CGRect(x: componentWidth * 2.65, y: y, width: componentWidth * 0.5, height: fontSize))
        minuteLabel.font = font
        minuteLabel.textAlignment = .left
        minuteLabel.text = "Min"
        minuteLabel.textColor = UIColor.white
        timerPickerView.addSubview(minuteLabel)
        
        let secondLabel = UILabel(frame: CGRect(x: componentWidth * 3.7, y: y, width: componentWidth * 0.6, height: fontSize))
        secondLabel.font = font
        secondLabel.textAlignment = .left
        secondLabel.text = "Sec"
        secondLabel.textColor = UIColor.white
        timerPickerView.addSubview(secondLabel)
        
        switch component {
        case 0: return "\(row)"
        case 1: return "\(row)"
        case 2: return "\(row)"
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0, 1, 2: return self.view.frame.width * 0.17
        default: return 0
        }
    }
}



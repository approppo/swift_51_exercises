import UIKit
import AudioToolbox
import AVFoundation

class FormViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var zipField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var favoriteSwitch: FavoriteControl!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var fields: [UITextField]!
    
    var customer: Customer?
    var voiceOverRunning = UIAccessibility.isVoiceOverRunning
    let errorPrefix = "* "
    
    override func viewDidLoad() {
        if let customer = customer {
            self.title = customer.name
            nameField.text = customer.name
            addressField.text = customer.address
            zipField.text = customer.zip
            cityField.text = customer.city
            countryField.text = customer.country
            ageField.text = customer.age.description
            favoriteSwitch.isOn = customer.favorite
        }
        
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(dynamicType),
                           name: UIContentSizeCategory.didChangeNotification,
                           object: nil)
        
        let not = NSNotification.Name(rawValue: UIAccessibilityVoiceOverStatusChanged)
        center.addObserver(self,
                           selector: #selector(voiceOverStatus),
                           name: not,
                           object: nil)
    }
    
    @IBAction func favoriteTouched(_ sender: AnyObject) {
        customer?.favorite = favoriteSwitch.isOn
    }
    
    @IBAction func save(_ sender: AnyObject) {
        validate()
    }
    
    func validate() {
        var counter = 0
        var errors = 0
        for field in fields {
            let label = labels[counter]
            if field.text?.lengthOfBytes(using: .utf8) == 0 {
                showError(for: label)
                errors += 1
            }
            else {
                hideError(for: label)
            }
            counter += 1
        }
        if errors > 0 {
            vibrate()
            if (voiceOverRunning) {
                let text = errorLabel.text!
                speak(text)
            }
            errorLabel.isHidden = false
        }
        else {
            errorLabel.isHidden = true
        }
    }
}

extension FormViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        validate()
    }
}

extension FormViewController {
    @objc func dynamicType(notification: Notification) {
        let font = UIFont.preferredFont(forTextStyle: .body)
        for label in labels {
            label.font = font
        }
        for field in fields {
            field.font = font
        }
        saveButton.titleLabel?.font = font
    }
    
    @objc func voiceOverStatus(notification: Notification) {
        voiceOverRunning = UIAccessibility.isVoiceOverRunning
    }
}

extension FormViewController {
    func showError(for label: UILabel) {
        label.textColor = .red
        
        let font = UIFont.preferredFont(forTextStyle: .body)
        label.font = UIFont.boldSystemFont(ofSize: font.pointSize)
        
        if let text = label.text,
            !text.hasPrefix(errorPrefix) {
            label.text = "\(errorPrefix)\(text)"
        }
    }
    
    func hideError(for label: UILabel) {
        label.textColor = .black
        
        let font = UIFont.preferredFont(forTextStyle: .body)
        label.font = UIFont.systemFont(ofSize: font.pointSize)
        
        if let text = label.text,
            text.hasPrefix(errorPrefix) {
            let index = text.index(text.startIndex, offsetBy: 2)
            label.text = String(text[index..<text.endIndex])
        }
    }
    
    func vibrate() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
    
    func speak(_ text: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
        })
    }
}

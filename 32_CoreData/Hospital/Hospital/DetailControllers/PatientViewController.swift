import UIKit

class PatientViewController: UIViewController {
    
    var patient: Patient?
    
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pat = patient {
            var string = "Patient: \(pat.firstName!) \(pat.lastName!), Age: \(pat.age)\n\n"
            if let doc = pat.doctor {
                string += "Doctor: \(doc)\n\n"
            }
            if let bed = pat.bed {
                string += "Bed: \(bed)"
            }
            textView.text = string
        }
    }
}

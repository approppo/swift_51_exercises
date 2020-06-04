import UIKit

class DoctorViewController: UIViewController {

    var doctor : Doctor?
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let doc = doctor {
            var string = "Doctor: \(doc)\n\n"
            if let patients = doc.patients, patients.count > 0 {
                string += "Patients:\n"
                for pat in patients {
                    let room = (pat as! Patient).bed!
                    string += "\(pat), \(room)\n"
                }
                string += "\n"
            }
            textView.text = string
        }
    }
}

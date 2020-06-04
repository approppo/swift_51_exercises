import UIKit
import SafariServices

class ViewController: UIViewController, SFSafariViewControllerDelegate {

    @IBAction func openSafariController(_ sender: Any) {
        // tag::safari[]
        let approppo = URL(string: "https://www.approppo.ch/")!
        let safari = SFSafariViewController(url: approppo)
        safari.delegate = self
        present(safari, animated: true, completion: nil)
        // end::safari[]
    }

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        // Do something when the Safari component finished loading the page
    }
}

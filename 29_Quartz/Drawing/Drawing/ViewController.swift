import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // tag::use[]
        let sv = SampleView(frame: view.bounds)
        sv.backgroundColor = .white
        view.addSubview(sv)
        // end::use[]
    }
}

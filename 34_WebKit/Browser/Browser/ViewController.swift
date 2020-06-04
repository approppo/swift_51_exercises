import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate {

    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var stopLoadingButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!

    var webView: WKWebView!
    var loading : Bool = false {
        didSet {
            updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: holderView.bounds,
                            configuration: config)
        holderView.addSubview(webView)
        webView.navigationDelegate = self
        constrain(webView, to: holderView)
        go(self)
    }

    @IBAction func go(_ sender: Any) {
        if let text = locationField.text {
            if let url = URL(string: text) {
                let req = URLRequest(url: url)
                webView.load(req)
                loading = true
            }
        }
    }

    @IBAction func back(_ sender: Any) {
        webView.goBack()
        loading = true
    }

    @IBAction func forward(_ sender: Any) {
        webView.goForward()
        loading = true
    }

    @IBAction func stopLoading(_ sender: Any) {
        webView.stopLoading()
        loading = false
    }

    @IBAction func refresh(_ sender: Any) {
        webView.reload()
        loading = true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        go(self)
        textField.resignFirstResponder()
        return true
    }

    func updateUI() {
        if loading {
            goButton.isEnabled = false
            backButton.isEnabled = false
            forwardButton.isEnabled = false
            stopLoadingButton.isEnabled = true
            refreshButton.isEnabled = false
        }
        else {
            goButton.isEnabled = true
            backButton.isEnabled = webView.canGoBack
            forwardButton.isEnabled = webView.canGoForward
            stopLoadingButton.isEnabled = false
            refreshButton.isEnabled = true
        }
        locationField.text = webView.url?.absoluteString
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loading = false
    }

    // Courtesy of
    // http://stackoverflow.com/a/43242864/133764
    func constrain(_ child: UIView, to parent: UIView) {
        child.translatesAutoresizingMaskIntoConstraints = false
        child.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        child.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        child.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
        child.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
    }
}

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    var topWebView: WKWebView!
    var bottomWebView: WKWebView!

    var topWebViewLoading : Bool = false {
        didSet {
            changeColors()
        }
    }

    var bottomWebViewLoading : Bool = false {
        didSet {
            changeColors()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let rect1 = CGRect(x: 16, y: 20, width: 343, height: 300)
        let rect2 = CGRect(x: 16, y: 347, width: 343, height: 300)

        // tag::basic[]
        let config = WKWebViewConfiguration()
        topWebView = WKWebView(frame: rect1,
                               configuration: config)
        topWebView.navigationDelegate = self
        view.addSubview(topWebView)

        let url1 = URL(string: "https://www.approppo.ch/")!
        let req1 = URLRequest(url: url1)
        topWebView.load(req1)
        // end::basic[]

        bottomWebView = WKWebView(frame: rect2,
                                  configuration: config)
        bottomWebView.navigationDelegate = self
        view.addSubview(bottomWebView)

        let url2 = URL(string: "https://akosma.training/")!
        let req2 = URLRequest(url: url2)
        bottomWebView.load(req2)

        topWebViewLoading = true
        bottomWebViewLoading = true
    }

    func changeColors() {
        if topWebViewLoading || bottomWebViewLoading {
            view.backgroundColor = .red
        }
        else {
            view.backgroundColor = .white
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView == topWebView {
            topWebViewLoading = false
        }
        else if webView == bottomWebView {
            bottomWebViewLoading = false
        }
    }
}

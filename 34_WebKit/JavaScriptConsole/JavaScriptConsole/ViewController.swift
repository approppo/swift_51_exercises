// tag::setup[]
import UIKit
import JavaScriptCore

class ViewController: UIViewController {

    @IBOutlet weak var consoleTextView: UITextView!
    @IBOutlet weak var editorTextView: UITextView!

    var vm : JSVirtualMachine
    var context : JSContext
    var console : Console?

    required init?(coder aDecoder: NSCoder) {
        vm = JSVirtualMachine()
        context = JSContext(virtualMachine: vm)
        super.init(coder: aDecoder)
    }
    // end::setup[]

    @IBAction func clear(_ sender: Any) {
        console?.clear()
    }

    @IBAction func executeJS(_ sender: Any) {
        editorTextView.resignFirstResponder()
        // tag::context[]
        let js = editorTextView.text!
        if let value = context.evaluateScript(js) {
            print("JSValue: \(value)")
        }
        // end::context[]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // tag::include[]
        let copyrightKey = "copyright" as NSCopying & NSObjectProtocol
        let authorKey = "author" as NSCopying & NSObjectProtocol
        let consoleKey = "console" as NSCopying & NSObjectProtocol
        let yearKey = "year" as NSCopying & NSObjectProtocol
        let enabledKey = "enabled" as NSCopying & NSObjectProtocol
        let officesKey = "offices" as NSCopying & NSObjectProtocol
        let alertKey = "alert" as NSCopying & NSObjectProtocol

        // The context can hold lots
        // of objects of different types
        context.setObject("Copyright © 2017 approppo & AKOSMA Training – All Rights Reserved",
                          forKeyedSubscript: copyrightKey)
        context.setObject("Adrian Kosmaczewski",
                          forKeyedSubscript: authorKey)
        context.setObject(2017,
                          forKeyedSubscript: yearKey)
        context.setObject(true,
                          forKeyedSubscript: enabledKey)
        context.setObject([ "Bern", "Schaffhausen" ],
                          forKeyedSubscript: officesKey)
        // end::include[]

        // Let's add a console object, just like on a web browser!
        console = Console(with: consoleTextView)
        context.setObject(console!, forKeyedSubscript: consoleKey)


        // tag::alert[]
        // What would be a JavaScript runtime without "alert()"?
        let alert : @convention(block) (String) -> Void = { text in
            let dialog = UIAlertController(title: "JS Alert",
                                           message: text,
                                           preferredStyle: .alert)
            let action = UIAlertAction(title: "OK",
                                       style: .default,
                                       handler: nil)
            dialog.addAction(action)
            self.present(dialog, animated: true)
        }
        context.setObject(alert, forKeyedSubscript: alertKey)
        // end::alert[]

        // tag::error[]
        // Let's add an error handler
        context.exceptionHandler = { context, exception in
            self.console?.log("JS Error: \(exception?.description ?? "unknown error")")
        }
        // end::error[]
    }
}

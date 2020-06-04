import UIKit
import JavaScriptCore

class Console: NSObject, Communication {

    weak var textView : UITextView? = nil

    init(with textView: UITextView) {
        self.textView = textView
    }

    func log(_ value: String) {
        var str = ""
        if let text = textView?.text {
            str = text
        }
        if str.lengthOfBytes(using: .utf8) > 0 {
            str += "\n"
        }
        str += value
        textView?.text = str

        let location = str.lengthOfBytes(using: .utf8) - 2
        let range = NSMakeRange(location, 1)
        textView?.scrollRangeToVisible(range)
    }

    func clear() {
        textView?.text = ""
    }
}

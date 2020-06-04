// tag::protocol[]
import Foundation
import JavaScriptCore

@objc protocol Communication : JSExport {
    func log(_ value: String)
    func clear()
}
// end::protocol[]


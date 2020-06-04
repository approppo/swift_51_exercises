import UIKit

class Circle: Shape {

    override func draw(_ rect: CGRect) {
        let w = rect.size.width
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: w, height: w))
        color.setFill()
        path.fill()
    }
}

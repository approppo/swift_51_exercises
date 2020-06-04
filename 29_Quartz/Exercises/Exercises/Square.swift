import UIKit

class Square: Shape {

    override func draw(_ rect: CGRect) {
        let w = rect.size.width
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: w, height: w))
        color.setFill()
        path.fill()
    }
}

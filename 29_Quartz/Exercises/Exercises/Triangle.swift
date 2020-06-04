import UIKit

class Triangle: Shape {
    
    override func draw(_ rect: CGRect) {
        let w = rect.size.width
        let path = UIBezierPath()
        path.move(to: CGPoint(x: (w / 2), y: 0))
        path.addLine(to: CGPoint(x: w, y: w))
        path.addLine(to: CGPoint(x: 0, y: w))
        path.close()
        color.setFill()
        path.fill()
    }
}

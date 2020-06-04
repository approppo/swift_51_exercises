import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rect = CGRect(x: 50, y: 50, width: 150, height: 150)
        
        let triangle = Triangle(frame: rect)
        triangle.color = .blue
        
        let circle = Circle(frame: rect.offsetBy(dx: 100, dy: 100))
        circle.color = .orange
        
        let square = Square(frame: rect.offsetBy(dx: 150, dy: 150))
        square.color = .purple
        
        let shapes = [triangle, circle, square]
        
        for shape in shapes {
            view.addSubview(shape)
        }
    }
}

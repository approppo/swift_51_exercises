import UIKit

@IBDesignable class FavoriteControl: UIControl {

    @IBInspectable var selectedText : String = "★" {
        didSet {
            refresh()
        }
    }
    
    @IBInspectable var deselectedText : String = "☆" {
        didSet {
            refresh()
        }
    }
    
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    
    @IBInspectable var isOn : Bool = false {
        didSet {
            refresh()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLabel()
        initAccessibility()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initLabel()
        initAccessibility()
    }
    
    private func initLabel() {
        label.text = deselectedText
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40.0)
        label.adjustsFontSizeToFitWidth = true
        addSubview(label)
    }
    
    private func refresh() {
        if isOn {
            label.text = selectedText
            accessibilityValue = "Favorite customer"
        }
        else {
            label.text = deselectedText
            accessibilityValue = "Not favorite customer"
        }
    }
    
    func initAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = UIAccessibilityTraits.button
        accessibilityLabel = "Favorite"
        accessibilityValue = "Not favorite customer"
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isOn = !isOn
        sendActions(for: .valueChanged)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initLabel()
    }
}

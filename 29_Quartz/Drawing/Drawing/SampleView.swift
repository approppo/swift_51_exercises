import UIKit

class SampleView: UIView {

    // tag::context[]
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        // end::context[]

        // tag::colors[]
        let red = UIColor(red: 1.000, green: 0.000, blue: 0.000, alpha: 1.000)
        let blue = UIColor(red: 0.000, green: 0.000, blue: 1.000, alpha: 1.000)
        // end::colors[]

        // tag::oval[]
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 43, y: 64, width: 146, height: 120))
        blue.setFill()
        ovalPath.fill()
        // end::oval[]

        // tag::rect[]
        let rectanglePath = UIBezierPath(rect: CGRect(x: 122.5, y: 122.5, width: 146, height: 101))
        red.setFill()
        rectanglePath.fill()
        UIColor.black.setStroke()
        rectanglePath.lineWidth = 5
        rectanglePath.stroke()
        // end::rect[]

        // tag::text[]
        let textRect = CGRect(x: 142, y: 163, width: 108, height: 21)
        let text = "Hello, Quartz!"
        let style = NSMutableParagraphStyle()
        let font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        style.alignment = .left
        let textFontAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: style
        ]


        let size = CGSize(width: textRect.width, height: CGFloat.infinity)
        let height: CGFloat = text.boundingRect(with: size,
                                                options: .usesLineFragmentOrigin,
                                                attributes: textFontAttributes,
                                                context: nil).height
        context.saveGState()
        context.clip(to: textRect)
        let place = CGRect(x: textRect.minX,
                           y: textRect.minY + (textRect.height - height) / 2,
                           width: textRect.width,
                           height: height)
        text.draw(in: place, withAttributes: textFontAttributes)
        context.restoreGState()
        // end::text[]
    }
}


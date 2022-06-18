import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    @IBInspectable var roundButton: Bool = false{
        didSet{
            if roundButton {
                layer.cornerRadius = frame.height / 2
            }
        }
    }
    
    override func prepareForInterfaceBuilder() {
        if roundButton{
            layer.cornerRadius = frame.height / 2
        }
    }
}

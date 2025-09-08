import SwiftUI

struct TicketShape: InsettableShape {
    private var cornerRadius: CGFloat = 24
    private var notchRadius: CGFloat = 16
    private var insetAmount: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        let rect = rect.insetBy(dx: insetAmount, dy: insetAmount)

        let roundedRect = Path(roundedRect: rect, cornerRadius: cornerRadius)

        let leftCenter = CGPoint(x: rect.minX, y: rect.midY)
        let leftEllipse = Path(ellipseIn: CGRect(x: leftCenter.x - notchRadius,
                                                 y: leftCenter.y - notchRadius,
                                                 width: notchRadius * 2,
                                                 height: notchRadius * 2))

        let result = roundedRect
            .subtracting(leftEllipse)

        return result
    }

    func inset(by amount: CGFloat) -> some InsettableShape {
        var s = self
        s.insetAmount += amount
        return s
    }
}

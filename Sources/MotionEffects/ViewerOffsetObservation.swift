internal import SwiftUI
private import UIKit

struct ViewerOffsetObservation: UIViewRepresentable {
    let updateHandler: (_ viewerOffset: UIOffset) -> Void

    func makeUIView(context: Context) -> OffsetHostView {
        OffsetHostView()
    }

    func updateUIView(_ uiView: OffsetHostView, context: Context) {
        uiView.updateHandler = updateHandler

        // Manage the motion effect based on the accessibility setting.
        // When reduce motion is enabled, remove the effect and reset the offset.
        if context.environment.accessibilityReduceMotion {
            if let effect = uiView.motionEffects.first {
                uiView.removeMotionEffect(effect)
            }
            updateHandler(.zero)
        } else if uiView.motionEffects.isEmpty {
            let effect = ViewerOffsetMotionEffect()
            effect.hostView = uiView
            uiView.addMotionEffect(effect)
        }
    }
}

final class OffsetHostView: UIView {
    var pendingOffset: UIOffset?
    var updateHandler: ((UIOffset) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        isUserInteractionEnabled = false
        accessibilityElementsHidden = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        .zero
    }

    // Disable implicit CALayer animations. NSNull stops the action lookup chain.
    override func action(
        for layer: CALayer,
        forKey event: String
    ) -> (any CAAction)? {
        NSNull()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Process the pending offset in the layout pass, where it is safe to
        // trigger view mutations (including addMotionEffect/removeMotionEffect).
        if let offset = pendingOffset {
            pendingOffset = nil
            updateHandler?(offset)
        }
    }
}

private final class ViewerOffsetMotionEffect: UIMotionEffect {
    weak var hostView: OffsetHostView?

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init() {
        super.init()
    }

    override func keyPathsAndRelativeValues(forViewerOffset viewerOffset: UIOffset) -> [String: Any]? {
        // Defer the callback by writing to the host view and requesting a layout pass.
        // This method is called during _UIMotionEffectEngine's NSHashTable enumeration,
        // so calling the updateHandler synchronously would risk mutating that table.
        hostView?.pendingOffset = viewerOffset
        hostView?.setNeedsLayout()
        return nil
    }
}

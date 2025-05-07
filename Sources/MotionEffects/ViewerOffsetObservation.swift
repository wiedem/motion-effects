import Foundation
import SwiftUI
import UIKit

struct ViewerOffsetObservation: UIViewRepresentable {
    let updateHandler: (_ viewerOffset: UIOffset) -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView()

        if context.environment.accessibilityReduceMotion == false {
            view.addMotionEffect(
                InterpolatingMotionEffectObservation(updateHandler: updateHandler)
            )
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if context.environment.accessibilityReduceMotion {
            guard let effect = uiView.motionEffects.first else {
                return
            }
            uiView.removeMotionEffect(effect)
        } else {
            guard uiView.motionEffects.isEmpty else {
                return
            }
            uiView.addMotionEffect(
                InterpolatingMotionEffectObservation(updateHandler: updateHandler)
            )
        }
    }
}

private final class InterpolatingMotionEffectObservation: UIInterpolatingMotionEffect {
    private let updateHandler: (_ viewerOffset: UIOffset) -> Void

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(updateHandler: @escaping (UIOffset) -> Void) {
        self.updateHandler = updateHandler

        super.init(
            keyPath: "center.x",
            type: .tiltAlongHorizontalAxis
        )
    }

    override func keyPathsAndRelativeValues(forViewerOffset viewerOffset: UIOffset) -> [String: Any]? {
        updateHandler(viewerOffset)
        return nil
    }
}

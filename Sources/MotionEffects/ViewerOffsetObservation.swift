import SwiftUI
import UIKit

struct ViewerOffsetObservation: UIViewControllerRepresentable {
    let updateHandler: (_ viewerOffset: UIOffset) -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        ViewerOffsetObservationController(updateHandler: updateHandler)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

private final class InterpolatingMotionEffectObservation: UIInterpolatingMotionEffect {
    private let updateHandler: (_ viewerOffset: UIOffset) -> Void

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(updateHandler: @escaping (UIOffset) -> Void) {
        self.updateHandler = updateHandler

        super.init(keyPath: "", type: .tiltAlongHorizontalAxis)
    }

    override func keyPathsAndRelativeValues(forViewerOffset viewerOffset: UIOffset) -> [String: Any]? {
        updateHandler(viewerOffset)
        return nil
    }
}

private final class ViewerOffsetObservationController: UIViewController {
    private let updateHandler: (_ viewerOffset: UIOffset) -> Void

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(updateHandler: @escaping (UIOffset) -> Void) {
        self.updateHandler = updateHandler

        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = nil

        let effect = InterpolatingMotionEffectObservation(updateHandler: updateHandler)
        view.addMotionEffect(effect)
    }
}

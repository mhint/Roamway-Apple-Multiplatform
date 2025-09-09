import SwiftUI
import CoreMotion

final class TiltMotionManager: ObservableObject {
    @Published var roll: Double = 0     // radians, ~[-π, π]
    @Published var pitch: Double = 0    // radians

    private let mgr = CMMotionManager()

    func start() {
        guard mgr.isDeviceMotionAvailable else { return }
        mgr.deviceMotionUpdateInterval = 1.0 / 60.0
        mgr.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical, to: .main) { motion, _ in
            guard let m = motion else { return }
            self.roll = m.attitude.roll
            self.pitch = m.attitude.pitch
        }
    }

    func stop() {
        mgr.stopDeviceMotionUpdates()
    }
}
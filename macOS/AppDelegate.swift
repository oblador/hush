import Foundation
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.windows.forEach { (window) in
            window.collectionBehavior = .fullScreenNone;
        }
    }
}

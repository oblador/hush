import XCTest

class HushUITests: XCTestCase {
    var app: XCUIApplication!
    var settingsApp: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        settingsApp = XCUIApplication(bundleIdentifier: "com.apple.Preferences")
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    // Settings uses a virtualized collection view, so off-screen rows are not in
    // the accessibility tree until scrolled into view.
    private func scrollToAndTap(_ label: String) {
        let element = settingsApp.staticTexts[label]
        var attempts = 0
        while !element.isHittable && attempts < 15 {
            settingsApp.swipeUp()
            attempts += 1
        }
        XCTAssertTrue(element.isHittable, "Could not find \"\(label)\" in Settings")
        element.tap()
    }

    private func toggleContentBlockerEnabled(isOn: Bool) throws {
        settingsApp.launch()
        // Settings → Apps → Safari → Extensions → Hush → Allow Extension
        scrollToAndTap("Apps")
        scrollToAndTap("Safari")
        scrollToAndTap("Extensions")
        settingsApp.buttons["se.oblador.Hush.ContentBlocker"].firstMatch.tap()
        let toggle = settingsApp.switches["Allow Extension"].firstMatch
        XCTAssertTrue(toggle.waitForExistence(timeout: 5), "Allow Extension switch not found")
        if toggle.value as? String != (isOn ? "1" : "0") {
            // The switch's accessibility frame spans the whole row, so its centre is
            // over the label. Tap near the trailing edge where the control actually is.
            toggle.coordinate(withNormalizedOffset: CGVector(dx: 0.92, dy: 0.5)).tap()
        }
        settingsApp.terminate()
    }

    // The app only re-queries the content blocker state on foreground, and enabling
    // the blocker can take a moment to settle, so re-foreground until it is shown.
    private func assertAppShows(_ identifier: String, timeout: TimeInterval = 30) {
        let deadline = Date().addingTimeInterval(timeout)
        repeat {
            app.activate()
            if app.staticTexts[identifier].waitForExistence(timeout: 3) {
                return
            }
            XCUIDevice.shared.press(.home)
        } while Date() < deadline
        XCTFail("App did not show \"\(identifier)\" within \(timeout)s")
    }

    func testSettingsIntegration() throws {
        app.launch()
        try toggleContentBlockerEnabled(isOn: false)
        assertAppShows("extension disabled")
        try toggleContentBlockerEnabled(isOn: true)
        assertAppShows("extension enabled")
    }
}

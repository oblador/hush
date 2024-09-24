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
    
    private func toggleContentBlockerEnabled(isOn: Bool) throws {
        settingsApp.launch()
        settingsApp.swipeUp()
        settingsApp.staticTexts["Apps"].tap()
        settingsApp.swipeUp()
        settingsApp.staticTexts["Safari"].tap()
        settingsApp.staticTexts["Extensions"].tap()
        settingsApp.staticTexts["Hush"].tap()
        if settingsApp.switches["Allow Extension"].value as? String != (isOn ? "1" : "0") {
            settingsApp.switches["Allow Extension"].tap()
        }
        settingsApp.terminate()
    }

    func testSettingsIntegration() throws {
        app.launch()
        try toggleContentBlockerEnabled(isOn: false)
        app.activate()
        XCTAssertTrue(app.staticTexts["extension disabled"].exists)
        try toggleContentBlockerEnabled(isOn: true)
        app.activate()
        XCTAssertTrue(app.staticTexts["extension enabled"].exists)
    }
}

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
        settingsApp.tables.cells.staticTexts["Safari"].tap()
        settingsApp.tables.cells.staticTexts["Content Blockers"].firstMatch.tap()
        if settingsApp.switches["Hush"].value as? String != (isOn ? "1" : "0") {
            settingsApp.switches["Hush"].tap()
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

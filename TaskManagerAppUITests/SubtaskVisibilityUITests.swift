import XCTest

final class SubtaskVisibilityUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testEmployeeOnlySeesOwnAssignedSubtasks() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-uiTestReset"]
        app.launch()

        let employeeLoginButton = app.buttons["Demo: Çalışan olarak gir"]
        XCTAssertTrue(employeeLoginButton.waitForExistence(timeout: 5), "Demo çalışan giriş butonu bulunamadı")
        employeeLoginButton.tap()

        let taskTitle = app.staticTexts["Aylık satış raporu"]
        XCTAssertTrue(taskTitle.waitForExistence(timeout: 5), "Test görevi listede bulunamadı")
        taskTitle.tap()

        let ownSubtask = app.buttons["Sunum dosyasını oluştur"]
        XCTAssertTrue(ownSubtask.waitForExistence(timeout: 5), "Çalışana atanan alt görev görünmüyor")
        XCTAssertTrue(app.staticTexts["0/1"].waitForExistence(timeout: 3), "İlerleme sadece kendi alt görevine göre hesaplanmalı")

        XCTAssertFalse(app.buttons["Ham veriyi topla"].exists, "Başka bir çalışana atanan alt görev görünmemeli")
        XCTAssertFalse(app.buttons["Grafik ve tabloları hazırla"].exists, "Başka bir çalışana atanan alt görev görünmemeli")
        XCTAssertFalse(app.buttons["Yöneticiyle gözden geçir"].exists, "Başka bir çalışana atanan alt görev görünmemeli")
        XCTAssertFalse(app.buttons["PDF olarak paylaş"].exists, "Başka bir çalışana atanan alt görev görünmemeli")
    }
}

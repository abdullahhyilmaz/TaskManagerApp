import XCTest

final class ManagerCreateTaskUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testManagerCanLoginAndCreateNewTask() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-uiTestReset"]
        app.launch()

        let managerLoginButton = app.buttons["Demo: Yönetici olarak gir"]
        XCTAssertTrue(managerLoginButton.waitForExistence(timeout: 5), "Demo yönetici giriş butonu bulunamadı")
        managerLoginButton.tap()

        let createButton = app.buttons["createTaskButton"]
        XCTAssertTrue(createButton.waitForExistence(timeout: 5), "Yeni görev oluşturma butonu bulunamadı")
        createButton.tap()

        let titleField = app.textFields["titleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 5), "Başlık alanı bulunamadı")
        titleField.tap()
        let newTaskTitle = "XCUITest ile oluşturulan görev"
        titleField.typeText(newTaskTitle)

        let confirmButton = app.buttons["Oluştur"]
        XCTAssertTrue(confirmButton.isEnabled, "Başlık girildikten sonra Oluştur butonu aktif olmalı")
        confirmButton.tap()

        let newTaskOnBoard = app.staticTexts[newTaskTitle]
        XCTAssertTrue(newTaskOnBoard.waitForExistence(timeout: 5), "Yeni oluşturulan görev panoda görünmüyor")
    }
}

import XCTest

final class TaskPersistenceUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testManuallyCreatedTaskSurvivesRelaunch() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-uiTestReset"]
        app.launch()

        app.buttons["Demo: Yönetici olarak gir"].tap()

        let createButton = app.buttons["createTaskButton"]
        XCTAssertTrue(createButton.waitForExistence(timeout: 5))
        createButton.tap()

        let titleField = app.textFields["titleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 5))
        titleField.tap()
        let newTaskTitle = "Kalıcılık testi görevi"
        titleField.typeText(newTaskTitle)

        app.buttons["Oluştur"].tap()
        XCTAssertTrue(app.staticTexts[newTaskTitle].waitForExistence(timeout: 5), "Görev oluşturma sonrası panoda görünmüyor")

        app.terminate()

        let relaunchedApp = XCUIApplication()
        relaunchedApp.launch()

        relaunchedApp.buttons["Demo: Yönetici olarak gir"].tap()

        XCTAssertTrue(
            relaunchedApp.staticTexts[newTaskTitle].waitForExistence(timeout: 5),
            "Yeniden başlatma sonrası elle eklenen görev kayboldu"
        )
    }

    func testTaskAssignedToEmployeeIsStillVisibleAfterRelaunch() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-uiTestReset"]
        app.launch()

        app.buttons["Demo: Yönetici olarak gir"].tap()

        app.buttons["createTaskButton"].tap()

        let titleField = app.textFields["titleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 5))
        titleField.tap()
        let taskTitle = "Ahmet'e atanan görev"
        titleField.typeText(taskTitle)

        let subtaskTitleField = app.textFields["newSubtaskTitleField"]
        XCTAssertTrue(subtaskTitleField.waitForExistence(timeout: 5))
        subtaskTitleField.tap()
        subtaskTitleField.typeText("Ahmet'in alt görevi")
        app.buttons["addSubtaskButton"].tap()

        app.buttons["Oluştur"].tap()
        XCTAssertTrue(app.staticTexts[taskTitle].waitForExistence(timeout: 5))

        app.buttons["Çıkış"].tap()

        app.buttons["Demo: Çalışan olarak gir"].tap()
        XCTAssertTrue(
            app.staticTexts[taskTitle].waitForExistence(timeout: 5),
            "Yöneticiden çıkış sonrası çalışan görev listesinde görünmedi"
        )

        app.terminate()

        let relaunchedApp = XCUIApplication()
        relaunchedApp.launch()
        relaunchedApp.buttons["Demo: Çalışan olarak gir"].tap()

        XCTAssertTrue(
            relaunchedApp.staticTexts[taskTitle].waitForExistence(timeout: 5),
            "Uygulama kapatılıp açıldıktan sonra çalışana atanan görev listeden kayboldu"
        )
    }
}

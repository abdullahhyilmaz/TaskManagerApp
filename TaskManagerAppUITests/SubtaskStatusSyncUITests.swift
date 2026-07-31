import XCTest

final class SubtaskStatusSyncUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testSubtaskTogglingAutoUpdatesTaskStatus() throws {
        let app = XCUIApplication()
        app.launch()

        let employeeLoginButton = app.buttons["Demo: Çalışan olarak gir"]
        XCTAssertTrue(employeeLoginButton.waitForExistence(timeout: 5), "Demo çalışan giriş butonu bulunamadı")
        employeeLoginButton.tap()

        let taskTitle = app.staticTexts["Yeni müşteri onboarding akışı"]
        XCTAssertTrue(taskTitle.waitForExistence(timeout: 5), "Test görevi listede bulunamadı")
        taskTitle.tap()

        let statusPicker = app.segmentedControls.firstMatch
        XCTAssertTrue(statusPicker.waitForExistence(timeout: 5), "Durum seçici bulunamadı")

        func selectedStatus() -> String {
            statusPicker.buttons.allElementsBoundByIndex
                .first(where: { $0.isSelected })?.label ?? "<seçili yok>"
        }

        XCTAssertEqual(selectedStatus(), "Yapılacak", "Başlangıç durumu 'Yapılacak' olmalı")

        let subtask1 = app.buttons["Kullanıcı akış şeması"]
        let subtask2 = app.buttons["Wireframe tasarımı"]
        let subtask3 = app.buttons["Geliştirici ile teknik inceleme"]

        XCTAssertTrue(subtask1.waitForExistence(timeout: 5))
        subtask1.tap()
        XCTAssertEqual(selectedStatus(), "Devam Ediyor", "1/3 subtask işaretlenince durum 'Devam Ediyor' olmalı")
        XCTAssertTrue(app.staticTexts["1/3"].waitForExistence(timeout: 3))

        subtask2.tap()
        XCTAssertEqual(selectedStatus(), "Devam Ediyor", "2/3 subtask işaretlenince durum hâlâ 'Devam Ediyor' olmalı")
        XCTAssertTrue(app.staticTexts["2/3"].waitForExistence(timeout: 3))

        subtask3.tap()
        XCTAssertEqual(selectedStatus(), "Tamamlandı", "3/3 subtask işaretlenince durum otomatik 'Tamamlandı' olmalı")
        XCTAssertTrue(app.staticTexts["3/3"].waitForExistence(timeout: 3))

        subtask3.tap()
        XCTAssertEqual(selectedStatus(), "Devam Ediyor", "Bir subtask geri işaretsiz yapılınca durum 'Devam Ediyor'a geri düşmeli")
        XCTAssertTrue(app.staticTexts["2/3"].waitForExistence(timeout: 3))
    }
}

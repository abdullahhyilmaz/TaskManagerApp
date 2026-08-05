import Foundation

enum MockData {
    static let manager = AppUser(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
        name: "Elif Kaya",
        email: "elif.kaya@sirket.com",
        role: .manager
    )

    static let employees: [AppUser] = [
        AppUser(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
            name: "Ahmet Yıldız",
            email: "ahmet.yildiz@sirket.com",
            role: .employee
        ),
        AppUser(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
            name: "Zeynep Demir",
            email: "zeynep.demir@sirket.com",
            role: .employee
        ),
        AppUser(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!,
            name: "Mert Şahin",
            email: "mert.sahin@sirket.com",
            role: .employee
        ),
        AppUser(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!,
            name: "Buse Arslan",
            email: "buse.arslan@sirket.com",
            role: .employee
        )
    ]

    static let currentEmployee = employees[0]

    static func daysFromNow(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date()
    }

    static let tasks: [TaskItem] = [
        TaskItem(
            title: "Yeni müşteri onboarding akışı",
            description: "Yeni müşteriler için uygulama içi tanıtım ve hesap kurulum akışını tasarla ve uygula.",
            owner: manager,
            status: .todo,
            dueDate: daysFromNow(5),
            subtasks: [
                Subtask(title: "Kullanıcı akış şeması", assignee: employees[0]),
                Subtask(title: "Wireframe tasarımı", assignee: employees[0]),
                Subtask(title: "Geliştirici ile teknik inceleme", assignee: employees[0])
            ]
        ),
        TaskItem(
            title: "API dokümantasyonunu güncelle",
            description: "Yeni eklenen endpoint'ler için dokümantasyon yazılacak.",
            owner: manager,
            status: .todo,
            dueDate: nil,
            subtasks: [
                Subtask(title: "Endpoint listesini çıkar", assignee: employees[1])
            ]
        ),
        TaskItem(
            title: "Aylık satış raporu",
            description: "Temmuz ayı satış verilerini derleyip yönetim kuruluna sun.",
            owner: manager,
            status: .inProgress,
            dueDate: daysFromNow(2),
            subtasks: [
                Subtask(title: "Ham veriyi topla", assignee: employees[2], isDone: true),
                Subtask(title: "Grafik ve tabloları hazırla", assignee: employees[2], isDone: true),
                Subtask(title: "Sunum dosyasını oluştur", assignee: employees[0]),
                Subtask(title: "Yöneticiyle gözden geçir", assignee: employees[2]),
                Subtask(title: "PDF olarak paylaş", assignee: employees[2])
            ]
        ),
        TaskItem(
            title: "Ofis ağı bakım çalışması",
            description: "Kat 3 ofis ağındaki yavaşlık sorununu tespit et ve gider.",
            owner: manager,
            status: .inProgress,
            dueDate: daysFromNow(1),
            subtasks: [
                Subtask(title: "Ağ trafiğini izle", assignee: employees[3], isDone: true),
                Subtask(title: "Sorunlu switch'i değiştir", assignee: employees[3])
            ]
        ),
        TaskItem(
            title: "Yeni çalışan oryantasyon eğitimi",
            description: "İşe yeni başlayan ekip üyeleri için oryantasyon materyallerini hazırla.",
            owner: manager,
            status: .done,
            dueDate: daysFromNow(-3),
            subtasks: [
                Subtask(title: "Sunum hazırlığı", assignee: employees[0], isDone: true),
                Subtask(title: "Eğitim videosu çek", assignee: employees[0], isDone: true)
            ]
        ),
        TaskItem(
            title: "Web sitesi performans optimizasyonu",
            description: "Ana sayfa yüklenme süresini iyileştir.",
            owner: manager,
            status: .done,
            dueDate: daysFromNow(-1),
            subtasks: [
                Subtask(title: "Görsel boyutlarını küçült", assignee: employees[1], isDone: true)
            ]
        )
    ]
}

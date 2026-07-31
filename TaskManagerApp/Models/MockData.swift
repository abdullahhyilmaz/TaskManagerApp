import Foundation

enum MockData {
    static let manager = AppUser(name: "Elif Kaya", email: "elif.kaya@sirket.com", role: .manager)

    static let employees: [AppUser] = [
        AppUser(name: "Ahmet Yıldız", email: "ahmet.yildiz@sirket.com", role: .employee),
        AppUser(name: "Zeynep Demir", email: "zeynep.demir@sirket.com", role: .employee),
        AppUser(name: "Mert Şahin", email: "mert.sahin@sirket.com", role: .employee),
        AppUser(name: "Buse Arslan", email: "buse.arslan@sirket.com", role: .employee)
    ]

    static let currentEmployee = employees[0]

    static func daysFromNow(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date()
    }

    static let tasks: [TaskItem] = [
        TaskItem(
            title: "Yeni müşteri onboarding akışı",
            description: "Yeni müşteriler için uygulama içi tanıtım ve hesap kurulum akışını tasarla ve uygula.",
            assignee: employees[0],
            status: .todo,
            dueDate: daysFromNow(5),
            subtasks: [
                Subtask(title: "Kullanıcı akış şeması"),
                Subtask(title: "Wireframe tasarımı"),
                Subtask(title: "Geliştirici ile teknik inceleme")
            ]
        ),
        TaskItem(
            title: "API dokümantasyonunu güncelle",
            description: "Yeni eklenen endpoint'ler için dokümantasyon yazılacak.",
            assignee: employees[1],
            status: .todo,
            dueDate: nil,
            subtasks: []
        ),
        TaskItem(
            title: "Aylık satış raporu",
            description: "Temmuz ayı satış verilerini derleyip yönetim kuruluna sun.",
            assignee: employees[2],
            status: .inProgress,
            dueDate: daysFromNow(2),
            subtasks: [
                Subtask(title: "Ham veriyi topla", isDone: true),
                Subtask(title: "Grafik ve tabloları hazırla", isDone: true),
                Subtask(title: "Sunum dosyasını oluştur"),
                Subtask(title: "Yöneticiyle gözden geçir"),
                Subtask(title: "PDF olarak paylaş")
            ]
        ),
        TaskItem(
            title: "Ofis ağı bakım çalışması",
            description: "Kat 3 ofis ağındaki yavaşlık sorununu tespit et ve gider.",
            assignee: employees[3],
            status: .inProgress,
            dueDate: daysFromNow(1),
            subtasks: [
                Subtask(title: "Ağ trafiğini izle", isDone: true),
                Subtask(title: "Sorunlu switch'i değiştir")
            ]
        ),
        TaskItem(
            title: "Yeni çalışan oryantasyon eğitimi",
            description: "İşe yeni başlayan ekip üyeleri için oryantasyon materyallerini hazırla.",
            assignee: employees[0],
            status: .done,
            dueDate: daysFromNow(-3),
            subtasks: [
                Subtask(title: "Sunum hazırlığı", isDone: true),
                Subtask(title: "Eğitim videosu çek", isDone: true)
            ]
        ),
        TaskItem(
            title: "Web sitesi performans optimizasyonu",
            description: "Ana sayfa yüklenme süresini iyileştir.",
            assignee: employees[1],
            status: .done,
            dueDate: daysFromNow(-1),
            subtasks: []
        )
    ]

    static func tasks(for user: AppUser) -> [TaskItem] {
        tasks.filter { $0.assignee.id == user.id }
    }
}

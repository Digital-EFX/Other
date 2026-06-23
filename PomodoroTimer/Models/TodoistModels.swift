import Foundation

struct TodoistTask: Identifiable, Codable {
    let id: String
    let content: String
    let projectId: String
    let sectionId: String?
    let isCompleted: Bool
    let priority: Int
    let dueDate: String?
    let labels: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, content, isCompleted, priority, labels
        case projectId = "project_id"
        case sectionId = "section_id"
        case dueDate = "due"
    }
}

struct TodoistProject: Identifiable, Codable {
    let id: String
    let name: String
    let color: String?
    let isInbox: Bool
    let isFavorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name, color, isFavorite
        case isInbox = "is_inbox_project"
    }
}

struct TodoistSection: Identifiable, Codable {
    let id: String
    let name: String
    let projectId: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case projectId = "project_id"
    }
}

struct DueDate: Codable {
    let date: String
    let isRecurring: Bool
    
    enum CodingKeys: String, CodingKey {
        case date
        case isRecurring = "is_recurring"
    }
}

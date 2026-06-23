import SwiftUI

struct TaskRowView: View {
    let task: TodoistTask
    let isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(task.content)
                .font(.system(size: 13, weight: .semibold))
                .lineLimit(2)
                .foregroundColor(.white)
            
            HStack(spacing: 8) {
                // Priority indicator
                Circle()
                    .fill(priorityColor)
                    .frame(width: 6, height: 6)
                
                if let dueDate = task.dueDate {
                    Text(dueDate)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                if !task.labels.isEmpty {
                    HStack(spacing: 4) {
                        ForEach(task.labels.prefix(2), id: \.self) { label in
                            Text(label)
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundColor(.white.opacity(0.6))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(3)
                        }
                    }
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? Color.blue.opacity(0.3) : Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.blue.opacity(0.5) : Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private var priorityColor: Color {
        switch task.priority {
        case 4:
            return Color(red: 1.0, green: 0.3, blue: 0.3)
        case 3:
            return Color(red: 1.0, green: 0.7, blue: 0.3)
        case 2:
            return Color(red: 0.3, green: 0.7, blue: 1.0)
        default:
            return Color.white.opacity(0.5)
        }
    }
}

#Preview {
    TaskRowView(
        task: TodoistTask(
            id: "1",
            content: "Sample task",
            projectId: "1",
            sectionId: nil,
            isCompleted: false,
            priority: 3,
            dueDate: "2024-06-23",
            labels: ["work", "urgent"]
        ),
        isSelected: false
    )
}

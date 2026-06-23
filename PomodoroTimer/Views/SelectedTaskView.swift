import SwiftUI

struct SelectedTaskView: View {
    @EnvironmentObject var appState: AppState
    let task: TodoistTask
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Current Task")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white.opacity(0.6))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 12) {
                Text(task.content)
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(3)
                    .foregroundColor(.white)
                
                if !task.labels.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(task.labels, id: \.self) { label in
                            Text(label)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(4)
                        }
                    }
                }
                
                // Mark complete button
                Button(action: { appState.completeSelectedTask() }) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Mark Complete")
                    }
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color(red: 0.4, green: 0.8, blue: 0.4).opacity(0.7))
                    .cornerRadius(6)
                }
                .help("Mark this task as complete")
            }
            .padding(12)
            .background(Color.black.opacity(0.3))
            .cornerRadius(8)
        }
    }
}

#Preview {
    SelectedTaskView(
        task: TodoistTask(
            id: "1",
            content: "Complete important project",
            projectId: "1",
            sectionId: nil,
            isCompleted: false,
            priority: 4,
            dueDate: "2024-06-23",
            labels: ["work", "urgent"]
        )
    )
    .environmentObject(AppState())
}

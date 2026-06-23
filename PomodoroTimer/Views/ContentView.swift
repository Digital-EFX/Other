import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var showSettings = false
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.05, green: 0.05, blue: 0.15), Color(red: 0.1, green: 0.1, blue: 0.25)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with settings
                HStack {
                    Text("Pomodoro Timer")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { showSettings.toggle() }) {
                        Image(systemName: "gear")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    }
                    .help("Settings")
                }
                .padding(16)
                .background(Color.black.opacity(0.3))
                
                HStack(spacing: 0) {
                    // Sidebar - Task List
                    VStack(spacing: 0) {
                        // Filter buttons
                        HStack(spacing: 8) {
                            filterButton("Inbox", filter: .inbox)
                            filterButton("Today", filter: .today)
                            filterButton("Projects", filter: .projects)
                        }
                        .padding(12)
                        .background(Color.black.opacity(0.2))
                        
                        // Task list
                        ScrollView {
                            VStack(spacing: 8) {
                                ForEach(filteredTasks) { task in
                                    TaskRowView(task: task, isSelected: appState.selectedTask?.id == task.id)
                                        .onTapGesture {
                                            appState.selectTask(task)
                                        }
                                }
                            }
                            .padding(12)
                        }
                    }
                    .frame(width: 280)
                    .background(Color.black.opacity(0.4))
                    
                    // Divider
                    Divider()
                        .background(Color.white.opacity(0.2))
                    
                    // Main timer view
                    VStack(spacing: 24) {
                        // Timer display
                        TimerDisplayView()
                            .environmentObject(appState)
                        
                        // Controls
                        TimerControlsView()
                            .environmentObject(appState)
                        
                        // Selected task display
                        if let task = appState.selectedTask {
                            SelectedTaskView(task: task)
                                .environmentObject(appState)
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(24)
                }
            }
        }
        .frame(minWidth: 900, minHeight: 600)
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(appState)
        }
        .sheet(isPresented: $appState.showAPITokenPrompt) {
            APITokenPromptView()
                .environmentObject(appState)
        }
    }
    
    private func filterButton(_ label: String, filter: ViewFilter) -> some View {
        Button(action: { appState.setFilter(filter) }) {
            Text(label)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(appState.currentFilter == filter ? Color.blue.opacity(0.7) : Color.white.opacity(0.1))
                .cornerRadius(6)
        }
    }
    
    private var filteredTasks: [TodoistTask] {
        switch appState.currentFilter {
        case .inbox:
            return appState.todoistService.getInboxTasks()
        case .today:
            return appState.todoistService.getTodaysTasks()
        case .projects:
            return appState.todoistService.tasks.filter { task in
                !(appState.todoistService.projects.first { $0.id == task.projectId }?.isInbox ?? false)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}

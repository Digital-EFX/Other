import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Pomodoro Settings")
                    .font(.system(size: 18, weight: .bold))
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                }
            }
            .padding(16)
            .background(Color.gray.opacity(0.2))
            
            ScrollView {
                VStack(spacing: 24) {
                    // Number of sessions
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Number of Sessions", systemImage: "repeat")
                            .font(.system(size: 14, weight: .semibold))
                        
                        HStack {
                            Button(action: { decrementSessions() }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 18))
                            }
                            
                            Spacer()
                            
                            Text("\(appState.pomodoroSession.numberOfSessions)")
                                .font(.system(size: 28, weight: .bold))
                            
                            Spacer()
                            
                            Button(action: { incrementSessions() }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 18))
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Session duration
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Session Duration (minutes)", systemImage: "timer")
                            .font(.system(size: 14, weight: .semibold))
                        
                        Slider(
                            value: Binding(
                                get: { Double(appState.pomodoroSession.sessionDuration / 60) },
                                set: { appState.pomodoroSession.sessionDuration = Int($0) * 60 }
                            ),
                            in: 5...60,
                            step: 1
                        )
                        
                        Text("\(appState.pomodoroSession.sessionDuration / 60) minutes")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Divider()
                    
                    // Short break duration
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Short Break Duration (minutes)", systemImage: "cup.and.saucer")
                            .font(.system(size: 14, weight: .semibold))
                        
                        Slider(
                            value: Binding(
                                get: { Double(appState.pomodoroSession.shortBreakDuration / 60) },
                                set: { appState.pomodoroSession.shortBreakDuration = Int($0) * 60 }
                            ),
                            in: 1...15,
                            step: 1
                        )
                        
                        Text("\(appState.pomodoroSession.shortBreakDuration / 60) minutes")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Divider()
                    
                    // Long break duration
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Long Break Duration (minutes)", systemImage: "moon")
                            .font(.system(size: 14, weight: .semibold))
                        
                        Slider(
                            value: Binding(
                                get: { Double(appState.pomodoroSession.longBreakDuration / 60) },
                                set: { appState.pomodoroSession.longBreakDuration = Int($0) * 60 }
                            ),
                            in: 10...30,
                            step: 1
                        )
                        
                        Text("\(appState.pomodoroSession.longBreakDuration / 60) minutes")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Divider()
                    
                    // API Token section
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Todoist API Token", systemImage: "key")
                            .font(.system(size: 14, weight: .semibold))
                        
                        Button(action: { appState.showAPITokenPrompt = true }) {
                            Text("Update API Token")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.blue.opacity(0.3))
                                .cornerRadius(6)
                        }
                    }
                }
                .padding(16)
            }
        }
        .frame(width: 400, height: 600)
    }
    
    private func incrementSessions() {
        appState.pomodoroSession.numberOfSessions = min(appState.pomodoroSession.numberOfSessions + 1, 10)
    }
    
    private func decrementSessions() {
        appState.pomodoroSession.numberOfSessions = max(appState.pomodoroSession.numberOfSessions - 1, 1)
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
}

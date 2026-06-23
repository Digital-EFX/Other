import SwiftUI

struct TimerDisplayView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 16) {
            // Session counter
            HStack {
                Text("Session")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
                
                Spacer()
                
                Text("\(appState.currentSessionNumber)/\(appState.pomodoroSession.numberOfSessions)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            // Large digital timer
            VStack(spacing: 8) {
                HStack(spacing: 0) {
                    ForEach(timeDigits, id: \.self) { digit in
                        Text(digit)
                            .font(.system(size: 80, weight: .bold, design: .monospaced))
                            .foregroundColor(appState.timerState == .running ? Color(red: 0.2, green: 0.8, blue: 1.0) : .white)
                            .tracking(4)
                    }
                }
                .frame(height: 100)
                
                Text(appState.isWorkSession ? "Work Session" : (appState.currentSessionNumber >= appState.pomodoroSession.numberOfSessions && !appState.isWorkSession ? "Long Break" : "Short Break"))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(appState.isWorkSession ? Color(red: 1.0, green: 0.4, blue: 0.4) : Color(red: 0.4, green: 0.8, blue: 0.4))
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
            
            // Progress indicator
            ProgressView(value: progressValue)
                .tint(appState.isWorkSession ? Color(red: 1.0, green: 0.4, blue: 0.4) : Color(red: 0.4, green: 0.8, blue: 0.4))
        }
    }
    
    private var timeDigits: [String] {
        let minutes = appState.timeRemaining / 60
        let seconds = appState.timeRemaining % 60
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        return timeString.map { String($0) }
    }
    
    private var progressValue: Double {
        let totalDuration = appState.isWorkSession ? appState.pomodoroSession.sessionDuration : (appState.currentSessionNumber >= appState.pomodoroSession.numberOfSessions && !appState.isWorkSession ? appState.pomodoroSession.longBreakDuration : appState.pomodoroSession.shortBreakDuration)
        return Double(totalDuration - appState.timeRemaining) / Double(totalDuration)
    }
}

#Preview {
    TimerDisplayView()
        .environmentObject(AppState())
}

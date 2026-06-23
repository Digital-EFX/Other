import SwiftUI

struct TimerControlsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HStack(spacing: 12) {
            // Start/Pause button
            Button(action: { handleStartPauseAction() }) {
                HStack(spacing: 8) {
                    Image(systemName: appState.timerState == .running ? "pause.fill" : "play.fill")
                    Text(appState.timerState == .running ? "Pause" : (appState.timerState == .paused ? "Resume" : "Start"))
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(red: 0.2, green: 0.6, blue: 1.0), Color(red: 0.1, green: 0.5, blue: 0.9)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(8)
            }
            .help(appState.timerState == .running ? "Pause timer" : "Start timer")
            
            // Skip button
            Button(action: { appState.skipTimer() }) {
                HStack(spacing: 8) {
                    Image(systemName: "forward.fill")
                    Text("Skip")
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.15))
                .cornerRadius(8)
            }
            .help("Skip to next session")
            
            // Reset button
            Button(action: { appState.resetTimer() }) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Reset")
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.15))
                .cornerRadius(8)
            }
            .help("Reset timer")
        }
    }
    
    private func handleStartPauseAction() {
        switch appState.timerState {
        case .idle, .completed:
            appState.startTimer()
        case .running:
            appState.pauseTimer()
        case .paused:
            appState.resumeTimer()
        }
    }
}

#Preview {
    TimerControlsView()
        .environmentObject(AppState())
}

import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var todoistService = TodoistService()
    @Published var pomodoroSession = PomodoroSession()
    @Published var currentFilter: ViewFilter = .inbox
    @Published var selectedTask: TodoistTask?
    @Published var timerState: TimerState = .idle
    @Published var timeRemaining: Int = 0
    @Published var currentSessionNumber: Int = 0
    @Published var isWorkSession: Bool = true
    @Published var showAPITokenPrompt: Bool = false
    @Published var apiTokenInput: String = ""
    
    private var timer: Timer?
    private var timerDuration: Int = 0
    
    init() {
        let token = UserDefaults.standard.string(forKey: "TodoistAPIToken") ?? ""
        if token.isEmpty {
            showAPITokenPrompt = true
        } else {
            todoistService.setAPIToken(token)
            todoistService.fetchTasks()
            todoistService.fetchProjects()
        }
        timeRemaining = pomodoroSession.sessionDuration
    }
    
    func setAPIToken(_ token: String) {
        todoistService.setAPIToken(token)
        showAPITokenPrompt = false
        apiTokenInput = ""
        todoistService.fetchTasks()
        todoistService.fetchProjects()
    }
    
    func startTimer() {
        guard timerState != .running else { return }
        
        timerState = .running
        timerDuration = timeRemaining
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    func pauseTimer() {
        timerState = .paused
        timer?.invalidate()
        timer = nil
    }
    
    func resumeTimer() {
        startTimer()
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        timerState = .idle
        currentSessionNumber = 0
        isWorkSession = true
        timeRemaining = pomodoroSession.sessionDuration
    }
    
    func skipTimer() {
        timer?.invalidate()
        timer = nil
        sessionComplete()
    }
    
    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            timer?.invalidate()
            timer = nil
            sessionComplete()
        }
    }
    
    private func sessionComplete() {
        if isWorkSession {
            currentSessionNumber += 1
            
            if currentSessionNumber >= pomodoroSession.numberOfSessions {
                // Long break after all sessions
                isWorkSession = false
                timeRemaining = pomodoroSession.longBreakDuration
                timerState = .completed
                currentSessionNumber = 0
            } else {
                // Short break
                isWorkSession = false
                timeRemaining = pomodoroSession.shortBreakDuration
                timerState = .completed
            }
        } else {
            // Back to work
            isWorkSession = true
            timeRemaining = pomodoroSession.sessionDuration
            timerState = .completed
        }
    }
    
    func selectTask(_ task: TodoistTask) {
        selectedTask = task
    }
    
    func completeSelectedTask() {
        if let task = selectedTask {
            todoistService.completeTask(task.id)
            selectedTask = nil
        }
    }
    
    func setFilter(_ filter: ViewFilter) {
        currentFilter = filter
    }
}

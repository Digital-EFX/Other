import Foundation

struct PomodoroSession: Codable {
    var numberOfSessions: Int = 4
    var sessionDuration: Int = 25 * 60 // 25 minutes in seconds
    var shortBreakDuration: Int = 5 * 60 // 5 minutes
    var longBreakDuration: Int = 15 * 60 // 15 minutes
}

enum ViewFilter {
    case inbox
    case today
    case projects
}

enum TimerState {
    case idle
    case running
    case paused
    case completed
}

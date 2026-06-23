# Pomodoro Timer for macOS

A sleek, modern Pomodoro timer for macOS Intel that integrates with Todoist to manage your tasks and time.

## Features

✨ **Core Features:**
- Digital countdown timer with customizable work/break intervals
- Multi-session support with short breaks between sessions and long breaks after all sessions complete
- Todoist API integration for task management
- Sleek dark UI optimized for focused work

📋 **Task Management:**
- Auto-fetch tasks from Todoist
- Filter tasks by: Inbox, Today, and Projects
- View task sections within projects and inbox
- Select a task to focus on during work sessions
- Mark tasks complete independently of timer (timer doesn't auto-complete)
- Display task priority and labels

⚙️ **Customization:**
- Set number of Pomodoro sessions (1-10)
- Customize session duration (5-60 minutes)
- Customize short break duration (1-15 minutes)
- Customize long break duration (10-30 minutes)
- Floating window on desktop with prominent timer display

## Prerequisites

- macOS 13.0 or later
- Xcode 14.0 or later
- Todoist account with API token

## Getting Started

### 1. Install/Build

Clone the repository:
```bash
git clone https://github.com/Digital-EFX/Other.git
cd Other
git checkout pomodoro-timer
```

Open the project in Xcode:
```bash
open PomodoroTimer/PomodoroTimer.xcodeproj
```

Build and run (Cmd+R).

### 2. Get Todoist API Token

1. Go to https://todoist.com/app/settings/integrations/developer
2. Copy your API token
3. Paste it into the app when prompted on first launch (or via Settings gear icon)

## Usage

### Main Window

**Left Sidebar:**
- Filter buttons: Inbox, Today, Projects
- Task list showing all available tasks
- Click any task to select it as your focus task

**Center:**
- Large digital timer display
- Session counter (e.g., 2/4)
- Work/Break session indicator
- Progress bar

**Selected Task Panel:**
- Shows the currently focused task
- Displays labels and priority
- "Mark Complete" button (marks task as done in Todoist, independent of timer)

### Controls

- **Start/Pause**: Begin or pause the current session
- **Skip**: Move to the next session (work → break or vice versa)
- **Reset**: Cancel the current session cycle and reset to the beginning

### Settings

Click the ⚙️ gear icon to:
- Adjust number of sessions
- Set session duration
- Set short break duration
- Set long break duration
- Update Todoist API token

## Session Flow

1. **Work Session** (default 25 min) → Focus on your selected task
2. **Short Break** (default 5 min) → Rest and recharge
3. Repeat steps 1-2 for the number of sessions configured
4. **Long Break** (default 15 min) → Extended break after all sessions
5. Cycle repeats

## Architecture

```
PomodoroTimer/
├── PomodoroTimerApp.swift          # App entry point
├── Models/
│   ├── TodoistModels.swift          # Data structures for Todoist API
│   └── PomodoroModels.swift         # Pomodoro session configuration
├── Services/
│   ├── TodoistService.swift         # Todoist API client
│   └── AppState.swift               # Central app state & logic
└── Views/
    ├── ContentView.swift            # Main UI container
    ├── TimerDisplayView.swift       # Timer display & progress
    ├── TimerControlsView.swift      # Start/Pause/Skip/Reset buttons
    ├── TaskRowView.swift            # Individual task in sidebar
    ├── SelectedTaskView.swift       # Focused task display
    ├── SettingsView.swift           # Settings modal
    └── APITokenPromptView.swift     # Token setup dialog
```

## Notes

- Tasks are only marked complete when you explicitly click "Mark Complete"
- The timer and task completion are separate—focus on work, mark tasks done when finished
- All settings are stored locally (except Todoist tasks)
- API token is securely stored in macOS Keychain integration (via UserDefaults)

## Future Enhancements

- Sound notifications when sessions complete
- Statistics tracking (sessions completed, focus time)
- Dark/Light mode preference
- Task creation from the app
- Calendar integration

## License

MIT

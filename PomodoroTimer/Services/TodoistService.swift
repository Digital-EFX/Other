import Foundation

class TodoistService: ObservableObject {
    @Published var tasks: [TodoistTask] = []
    @Published var projects: [TodoistProject] = []
    @Published var sections: [TodoistSection] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "https://api.todoist.com/rest/v1"
    private var apiToken: String = ""
    
    init() {
        loadAPIToken()
    }
    
    func setAPIToken(_ token: String) {
        self.apiToken = token
        UserDefaults.standard.set(token, forKey: "TodoistAPIToken")
    }
    
    private func loadAPIToken() {
        if let token = UserDefaults.standard.string(forKey: "TodoistAPIToken") {
            self.apiToken = token
        }
    }
    
    func fetchTasks() {
        guard !apiToken.isEmpty else {
            errorMessage = "API token not set"
            return
        }
        
        isLoading = true
        var urlComponents = URLComponents(string: "\(baseURL)/tasks")
        
        guard let url = urlComponents?.url else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    let tasks = try JSONDecoder().decode([TodoistTask].self, from: data)
                    self?.tasks = tasks.filter { !$0.isCompleted }
                } catch {
                    self?.errorMessage = "Failed to decode tasks: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    func fetchProjects() {
        guard !apiToken.isEmpty else {
            errorMessage = "API token not set"
            return
        }
        
        isLoading = true
        let url = URL(string: "\(baseURL)/projects")!
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    let projects = try JSONDecoder().decode([TodoistProject].self, from: data)
                    self?.projects = projects
                } catch {
                    self?.errorMessage = "Failed to decode projects: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    func fetchSections(for projectId: String) {
        guard !apiToken.isEmpty else {
            errorMessage = "API token not set"
            return
        }
        
        let url = URL(string: "\(baseURL)/sections?project_id=\(projectId)")!
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    let sections = try JSONDecoder().decode([TodoistSection].self, from: data)
                    self?.sections = sections
                } catch {
                    self?.errorMessage = "Failed to decode sections: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    func completeTask(_ taskId: String) {
        guard !apiToken.isEmpty else {
            errorMessage = "API token not set"
            return
        }
        
        let url = URL(string: "\(baseURL)/tasks/\(taskId)/close")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                // Remove task from local list
                self?.tasks.removeAll { $0.id == taskId }
            }
        }.resume()
    }
    
    func getTodaysTasks() -> [TodoistTask] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        return tasks.filter { task in
            guard let dueDateString = task.dueDate else { return false }
            if let dueDate = parseDateString(dueDateString) {
                return dueDate >= today && dueDate < tomorrow
            }
            return false
        }
    }
    
    func getInboxTasks() -> [TodoistTask] {
        return tasks.filter { task in
            projects.first { $0.id == task.projectId }?.isInbox ?? false
        }
    }
    
    func getTasksForProject(_ projectId: String) -> [TodoistTask] {
        return tasks.filter { $0.projectId == projectId }
    }
    
    func getTasksForSection(_ sectionId: String) -> [TodoistTask] {
        return tasks.filter { $0.sectionId == sectionId }
    }
    
    private func parseDateString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)
    }
}

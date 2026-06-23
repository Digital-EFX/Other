import SwiftUI

struct APITokenPromptView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var showWarning = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Todoist API Token")
                .font(.system(size: 18, weight: .bold))
            
            Text("Enter your Todoist API token to sync your tasks. You can find it at https://todoist.com/app/settings/integrations/developer")
                .font(.system(size: 13))
                .foregroundColor(.gray)
            
            SecureField("API Token", text: $appState.apiTokenInput)
                .textFieldStyle(.roundedBorder)
                .font(.system(size: 13, design: .monospaced))
            
            if showWarning {
                Text("API token cannot be empty")
                    .font(.system(size: 12))
                    .foregroundColor(.red)
            }
            
            HStack(spacing: 12) {
                Button(action: { dismiss() }) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(6)
                }
                
                Button(action: { submitToken() }) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
            }
            
            Spacer()
        }
        .padding(24)
        .frame(width: 400, height: 300)
    }
    
    private func submitToken() {
        guard !appState.apiTokenInput.trimmingCharacters(in: .whitespaces).isEmpty else {
            showWarning = true
            return
        }
        
        appState.setAPIToken(appState.apiTokenInput)
    }
}

#Preview {
    APITokenPromptView()
        .environmentObject(AppState())
}

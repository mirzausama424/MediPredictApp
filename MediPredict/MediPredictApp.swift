import SwiftUI

@main
struct MediPredictApp: App {
    @State private var isSplashScreenActive: Bool = true

    var body: some Scene {
        WindowGroup {
            // Wrap Splash Screen and ContentView transition inside the main app structure
            if isSplashScreenActive {
                // Show Splash Screen first
                SplashScreenView()
                    .onAppear {
                        callAPIOnLaunch()
                    }
                    .onDisappear {
                        // Set to false when SplashScreenView disappears to move to ContentView
                        isSplashScreenActive = false
                    }
            } else {
                // Once splash screen is finished, show ContentView
                ContentView()
            }
        }
    }

    private func callAPIOnLaunch() {
        // Call API on launch to ensure server is up and running
        PredictionAPI.shared.getAPIInfo { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    // Provide feedback to the user if the server is awake
                    print("Server is awake: \(message)")
                case .failure(let error):
                    // Handle failure by showing an alert
                    showAlertForError(error)
                }
            }
        }
    }
    
    private func showAlertForError(_ error: Error) {
        // Here you can trigger an error alert for the user
        // For simplicity, we're printing the error, but you should show an actual UI alert in production
        print("Failed to wake up server: \(error.localizedDescription)")
    }
}

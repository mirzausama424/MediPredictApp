import SwiftUI

struct SplashScreenView: View {
    @State private var isLoading: Bool = true
    @State private var isSuccessful: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var apiMessage: String = ""
    @State private var rotationAngle: Double = 0
    @State private var navigateToContentView = false
    @State private var healthTips: String = ""
    @State private var showDisclaimer: Bool = true // Show disclaimer on first launch
    
    // List of health tips to show randomly
    let healthTipsList = [
        "Stay Healthy. Keep your mind and body active!",
        "Regular exercise helps improve cognitive health.",
        "Drink plenty of water and stay hydrated.",
        "Eating a balanced diet is key to a healthy lifestyle.",
        "Good sleep is crucial for mental and physical well-being.",
        "Don't forget to take breaks and move around throughout the day.",
        "Reduce stress by practicing mindfulness or meditation.",
        "Healthy habits lead to a longer and happier life.",
        "Make time for family and friends, strong social connections are important.",
        "Always listen to your body and seek medical advice when needed."
    ]
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack {
                // App Logo with 3D Rotation Animation
                Image("app_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150) // Scales logo while maintaining aspect ratio
                    .rotationEffect(.degrees(rotationAngle))
                    .onAppear {
                        withAnimation(Animation.linear(duration: 3).repeatForever(autoreverses: false)) {
                            rotationAngle = 360
                        }
                    }
                    .padding(.bottom, 50)
                    .frame(maxWidth: .infinity) // Ensures logo scales well across devices
                
                // Loading Text
                if isLoading {
                    Text("Loading... Please wait")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.top)
                        .multilineTextAlignment(.center)
                }

                // Loader Spinner
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
                    .padding(.top, 20)

                // Display API message if available
                if !apiMessage.isEmpty {
                    Text(apiMessage)
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.top)
                        .multilineTextAlignment(.center)
                }

                // Display health tips after API call succeeds
                if !healthTips.isEmpty {
                    Text(healthTips)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top)
                        .transition(.opacity)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .onAppear {
                // Call the getAPIInfo function when the SplashScreen appears
                PredictionAPI.shared.getAPIInfo { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let message):
                            apiMessage = message // Display the message from the API
                            isLoading = false
                            isSuccessful = true
                            // Wait a bit before transitioning to ContentView to show health tips
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                // Randomly select a health tip from the list
                                healthTips = healthTipsList.randomElement() ?? "Stay Healthy. Keep your mind and body active!"
                            }
                        case .failure(let error):
                            errorMessage = "Error: \(error.localizedDescription)"
                            showError = true
                        }
                    }
                }
            }

            // Error Alert if something goes wrong
            if showError {
                Color.black.opacity(0.7).ignoresSafeArea()
                VStack {
                    Text("Error: \(errorMessage)")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()
                    Button(action: {
                        showError = false
                    }) {
                        Text("Dismiss")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                }
            }
            
            // Disclaimer Overlay
            if showDisclaimer {
                Color.black.opacity(0.7).ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Disclaimer")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("By continuing, you acknowledge that this app provides predictions for  disease based on the input data and does not substitute for professional medical advice.")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button(action: {
                        // User accepts the disclaimer
                        withAnimation {
                            showDisclaimer = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            navigateToContentView = true
                        }
                    }) {
                        Text("I Agree")
                            .fontWeight(.bold)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $navigateToContentView) {
            ContentView() // Navigate to the main content view after splash screen
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
            .previewLayout(.device)
            .previewDevice("iPhone 12")
            .previewDevice("iPhone SE (2nd generation)")
            .previewDevice("iPad Pro (12.9-inch)")
    }
}

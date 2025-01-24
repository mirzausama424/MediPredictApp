import SwiftUI

// Define a more type-safe model for disease navigation
enum DiseaseType {
    case heartDisease, diabetes, parkinson
    
    @ViewBuilder
    func destination() -> some View {
        switch self {
        case .heartDisease:
            HeartDiseaseScreen()
        case .diabetes:
            DiabetesScreen()
        case .parkinson:
            ParkinsonScreenView()
        }
    }
}

struct Disease: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let type: DiseaseType // Use DiseaseType instead of AnyView
}

class ContentViewModel: ObservableObject {
    @Published var diseases: [Disease] = []
    
    func fetchData() {
        // API call simulation
        PredictionAPI.shared.getAPIInfo { result in
            switch result {
            case .success:
                print("Server is awake")
                // Example of updating disease data from API or local storage
                self.diseases = [
                    Disease(name: "Heart Disease Model", imageName: "heart", type: .heartDisease),
                    Disease(name: "Diabetes Model", imageName: "diabetes", type: .diabetes),
                    Disease(name: "Parkinson Disease Model", imageName: "parkison_disease", type: .parkinson)
                ]
            case .failure(let error):
                print("Failed to wake up server: \(error.localizedDescription)")
            }
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        NavigationView {  // Use NavigationView instead of NavigationStack
            ZStack {
                // Background Gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                // Ensure the ScrollView is scrollable and items are visible
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) { // Reduced spacing for better visibility
                        ForEach(viewModel.diseases) { disease in
                            GeometryReader { geometry in
                                NavigationLink(destination: disease.type.destination()) {
                                    DiseaseCell(disease: disease)
                                        .frame(width: 250, height: 350) // Adjust size for responsiveness
                                        .rotation3DEffect(
                                            .degrees(Double(geometry.frame(in: .global).minX) / -15),
                                            axis: (x: 0.0, y: 1.0, z: 0.0)
                                        )
                                        .animation(.easeInOut(duration: 0.3), value: geometry.frame(in: .global).minX)
                                }
                            }
                            .frame(width: 250, height: 350) // Ensure that the frames are set properly
                        }
                    }
                    .padding(.horizontal)
                    .frame(height: 400) // Ensure the content fits within the available space
                }

                VStack {
                    Spacer()
                    // Privacy Policy Navigation Button
                    NavigationLink(destination: PolicyView()) {
                        Text("Privacy Policy & Terms")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Disease Prediction Models")
            .onAppear {
                viewModel.fetchData()
            }
        }
    }
}

struct DiseaseCell: View {
    let disease: Disease

    var body: some View {
        VStack {
            Image(disease.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .cornerRadius(20)
                .accessibilityLabel(Text(disease.name)) // Accessibility label for image

            Text(disease.name)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top)
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]),
                                   startPoint: .top,
                                   endPoint: .bottom))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

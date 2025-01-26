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
    let type: DiseaseType
}

class ContentViewModel: ObservableObject {
    @Published var diseases: [Disease] = [
        Disease(name: "Heart Disease Model", imageName: "heart", type: .heartDisease),
        Disease(name: "Diabetes Model", imageName: "diabetes", type: .diabetes),
        Disease(name: "Parkinson Disease Model", imageName: "parkison_disease", type: .parkinson)
    ]
    
    init() {
        wakeUpServer()
    }
    
    private func wakeUpServer() {
        PredictionAPI.shared.getAPIInfo { result in
            switch result {
            case .success:
                print("Server is awake")
            case .failure(let error):
                print("Failed to wake up server: \(error.localizedDescription)")
            }
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                // Scrollable collection of diseases
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(viewModel.diseases) { disease in
                            GeometryReader { geometry in
                                NavigationLink(destination: disease.type.destination()) {
                                    DiseaseCell(disease: disease)
                                        .frame(width: 250, height: 350)
                                        .rotation3DEffect(
                                            .degrees(Double(geometry.frame(in: .global).minX) / -15),
                                            axis: (x: 0.0, y: 1.0, z: 0.0)
                                        )
                                }
                            }
                            .frame(width: 250, height: 350)
                        }
                    }
                    .padding(.horizontal)
                    .frame(height: 400)
                }

                // Privacy Policy Button
                VStack {
                    Spacer()
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

                // Custom Navigation Title Placement
                GeometryReader { geometry in
                    VStack {
                        Text("Disease Prediction Models")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.clear)
                            .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.red, Color.orange]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                .mask(
                                    Text("Disease Prediction Models")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                )
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10) // Left and right spacing
                            .frame(
                                maxWidth: geometry.size.width - 20, // Width adjusted for padding
                                alignment: .center
                            )
                            .offset(x: 0, y: geometry.safeAreaInsets.top + 70) // Offset from top safe area (50 points)
                    }
                }
                .ignoresSafeArea(edges: .top)
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
                .accessibilityLabel(Text(disease.name))

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


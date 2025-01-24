import SwiftUI
import PDFKit
import UIKit // Required for UIActivityViewController

// Wrapper struct to make Data Identifiable
struct ShareableData: Identifiable {
    let id = UUID()
    let data: Data
}

struct ParkinsonScreenView: View {
    @Environment(\.presentationMode) var presentationMode // To handle back navigation

    // TextField Bindings
    @State private var mdvpFO: String = ""
    @State private var mdvpFhi: String = ""
    @State private var mdvpFlo: String = ""
    @State private var mdvpJitter: String = ""
    @State private var mdvpJitterAbs: String = ""
    @State private var mdvpRap: String = ""
    @State private var mdvpPPq: String = ""
    @State private var jitterDdp: String = ""
    @State private var mdvpShimmer: String = ""
    @State private var mdvpShimmerDb: String = ""
    @State private var shimmerApq3: String = ""
    @State private var shimmerApq5: String = ""
    @State private var mdvpApq: String = ""
    @State private var shimmerDda: String = ""
    @State private var nhr: String = ""
    @State private var hnr: String = ""
    @State private var ripde: String = ""
    @State private var dfa: String = ""
    @State private var spread1: String = ""
    @State private var spread2: String = ""
    @State private var d2: String = ""
    @State private var ppe: String = ""

    // Result and Loader
    @State private var resultText: String = ""
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isPredictionEnabled: Bool = true
    @State private var shareablePDF: ShareableData?

    // Disclaimer Text
    private let disclaimerText = """
    Disclaimer: This application is for informational purposes only and should not be used as a substitute for professional medical advice. Predictions provided by this app are based on the data entered and are not guaranteed to be accurate. Please consult a healthcare professional for diagnosis and treatment.
    """

    // Check if all fields are filled
    private var isFormValid: Bool {
        return !mdvpFO.isEmpty && !mdvpFhi.isEmpty && !mdvpFlo.isEmpty && !mdvpJitter.isEmpty && !mdvpJitterAbs.isEmpty && !mdvpRap.isEmpty && !mdvpPPq.isEmpty && !jitterDdp.isEmpty && !mdvpShimmer.isEmpty && !mdvpShimmerDb.isEmpty && !shimmerApq3.isEmpty && !shimmerApq5.isEmpty && !mdvpApq.isEmpty && !shimmerDda.isEmpty && !nhr.isEmpty && !hnr.isEmpty && !ripde.isEmpty && !dfa.isEmpty && !spread1.isEmpty && !spread2.isEmpty && !d2.isEmpty && !ppe.isEmpty
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.8)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 15) {
                    Text("Parkinson's Prediction")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                        .padding(.top, 20)

                    ScrollView {
                        VStack(spacing: 20) {
                            Group {
                                customInputField(title: "MDVP:Fo(Hz)", text: $mdvpFO)
                                customInputField(title: "MDVP:Fhi(Hz)", text: $mdvpFhi)
                                customInputField(title: "MDVP:Flo(Hz)", text: $mdvpFlo)
                                customInputField(title: "MDVP:Jitter(%)", text: $mdvpJitter)
                                customInputField(title: "MDVP:Jitter(Abs)", text: $mdvpJitterAbs)
                                customInputField(title: "MDVP:RAP", text: $mdvpRap)
                                customInputField(title: "MDVP:PPQ", text: $mdvpPPq)
                                customInputField(title: "Jitter:DDP", text: $jitterDdp)
                                customInputField(title: "MDVP:Shimmer", text: $mdvpShimmer)
                                customInputField(title: "MDVP:Shimmer(dB)", text: $mdvpShimmerDb)
                            }
                            Group {
                                customInputField(title: "Shimmer:APQ3", text: $shimmerApq3)
                                customInputField(title: "Shimmer:APQ5", text: $shimmerApq5)
                                customInputField(title: "MDVP:APQ", text: $mdvpApq)
                                customInputField(title: "Shimmer:DDA", text: $shimmerDda)
                                customInputField(title: "NHR", text: $nhr)
                                customInputField(title: "HNR", text: $hnr)
                                customInputField(title: "RPDE", text: $ripde)
                                customInputField(title: "DFA", text: $dfa)
                                customInputField(title: "Spread1", text: $spread1)
                                customInputField(title: "Spread2", text: $spread2)
                            }
                            customInputField(title: "D2", text: $d2)
                            customInputField(title: "PPE", text: $ppe)
                        }
                    }

                    Button(action: predictAction) {
                        Text("Predict")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.orange]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.4), radius: 10, x: 5, y: 5)
                    }
                    .disabled(!isFormValid || isLoading)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)

                    // Result Section
                    if !resultText.isEmpty {
                        Text(resultText)
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(15)
                            .shadow(radius: 10)
                            .padding(.horizontal)

                        // Disclaimer
                        Text(disclaimerText)
                            .font(.footnote)
                            .foregroundColor(.white)
                            .padding(.top, 10)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)

                        // Share Button
                        Button(action: shareResult) {
                            Text("Share Result")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .shadow(color: Color.black.opacity(0.4), radius: 10, x: 5, y: 5)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }

                    Spacer()
                }

                // Loader
                if isLoading {
                    VStack {
                        ProgressView("Getting Results...")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(15)
                            .shadow(radius: 10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5))
                    .ignoresSafeArea()
                }
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
        .sheet(item: $shareablePDF) { shareableData in
            // Sharing the result as PDF using ActivityView
            ActivityView(activityItems: [shareableData.data])
        }
    }

    private func customInputField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)

            TextField("Enter \(title)", text: text)
                .keyboardType(.decimalPad)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.2), Color.gray.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(10)
                .shadow(radius: 5)
        }
        .padding(.horizontal)
    }
    
    private func predictAction() {
        guard !isLoading else { return } // Prevent multiple predictions
        isLoading = true
        resultText = "" // Clear the previous result

        // Breaking down the feature assignments
        let feature1 = Double(mdvpFO) ?? 0.0
        let feature2 = Double(mdvpFhi) ?? 0.0
        let feature3 = Double(mdvpFlo) ?? 0.0
        let feature4 = Double(mdvpJitter) ?? 0.0
        let feature5 = Double(mdvpJitterAbs) ?? 0.0
        let feature6 = Double(mdvpRap) ?? 0.0
        let feature7 = Double(mdvpPPq) ?? 0.0
        let feature8 = Double(jitterDdp) ?? 0.0
        let feature9 = Double(mdvpShimmer) ?? 0.0
        let feature10 = Double(mdvpShimmerDb) ?? 0.0
        let feature11 = Double(shimmerApq3) ?? 0.0
        let feature12 = Double(shimmerApq5) ?? 0.0
        let feature13 = Double(mdvpApq) ?? 0.0
        let feature14 = Double(shimmerDda) ?? 0.0
        let feature15 = Double(nhr) ?? 0.0
        let feature16 = Double(hnr) ?? 0.0
        let feature17 = Double(ripde) ?? 0.0
        let feature18 = Double(dfa) ?? 0.0
        let feature19 = Double(spread1) ?? 0.0
        let feature20 = Double(spread2) ?? 0.0
        let feature21 = Double(d2) ?? 0.0
        let feature22 = Double(ppe) ?? 0.0

        // Combine features into an array
        let features = [
            feature1, feature2, feature3, feature4, feature5, feature6, feature7, feature8,
            feature9, feature10, feature11, feature12, feature13, feature14, feature15, feature16,
            feature17, feature18, feature19, feature20, feature21, feature22
        ]

        // Example API call using PredictionAPI
        PredictionAPI.shared.sendPredictionRequest(modelName: "parkinsons", features: features) { result in
            DispatchQueue.main.async {
                isLoading = false // Stop loader
                switch result {
                case .success(let response):
                    resultText = """
                    Model: \(response.model_name)
                    Prediction: \(response.prediction.first ?? 0)
                    Confidence Level: \(response.confidence_level * 100)%
                    """
                case .failure(let error):
                    errorMessage = "Prediction Failed: \(error.localizedDescription)"
                    showError = true
                }
            }
        }
    }

    private func shareResult() {
        let shareText = """
        Parkinson's Disease Prediction Result:
        
        \(resultText)
        """
        let pdfContent = createPDF(content: shareText)
        shareablePDF = ShareableData(data: pdfContent) // Wrap PDF data in ShareableData
    }

    private func createPDF(content: String) -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "Parkinson App",
            kCGPDFContextAuthor: "Parkinson Prediction"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 595.0
        let pageHeight = 842.0
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)

        return renderer.pdfData { context in
            context.beginPage()
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
            content.draw(in: CGRect(x: 20, y: 20, width: pageWidth - 40, height: pageHeight - 40), withAttributes: attributes)
            // Add Disclaimer
            let disclaimerAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
            disclaimerText.draw(in: CGRect(x: 20, y: pageHeight - 120, width: pageWidth - 40, height: 100), withAttributes: disclaimerAttributes)
        }
    }
}

// ActivityView for sharing content
struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

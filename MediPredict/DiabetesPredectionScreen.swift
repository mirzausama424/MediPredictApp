import SwiftUI
import PDFKit
import UIKit

// MARK: - ShareActivityViewController
struct ShareActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No need to update the UIActivityViewController, since it's a static modal
    }
}

// MARK: - Disclaimer View
struct DisclaimerView: View {
    var body: some View {
        VStack {
            Text("Disclaimer: This application is for informational purposes only and should not be used as a substitute for professional medical advice. Predictions provided by this app are based on the data entered and are not guaranteed to be accurate. Please consult a healthcare professional for diagnosis and treatment.")
                .font(.body)
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(10)
                .padding(.top, 10)
        }
    }
}

// MARK: - DiabetesScreen View
struct DiabetesScreen: View {
    @State private var pregnancies: String = ""
    @State private var glucose: String = ""
    @State private var bloodPressure: String = ""
    @State private var skinThickness: String = ""
    @State private var insulin: String = ""
    @State private var bmi: String = ""
    @State private var diabetesPedigreeFunction: String = ""
    @State private var age: String = ""
    @State private var resultText: String = ""
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var showShareSlider: Bool = false
    @State private var selectedShareOption: String = "Email"
    @State private var isSharing: Bool = false // Flag to control share sheet presentation
    @State private var showDisclaimer: Bool = false // Flag to control disclaimer visibility

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.7)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 30) {
                    Text("Diabetes Prediction")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .padding(.top, 90)

                    VStack(spacing: 20) {
                        labeledTextField(label: "Pregnancies", placeholder: "Enter number of pregnancies", text: $pregnancies)
                        labeledTextField(label: "Glucose", placeholder: "Enter glucose level", text: $glucose)
                        labeledTextField(label: "Blood Pressure", placeholder: "Enter blood pressure", text: $bloodPressure)
                        labeledTextField(label: "Skin Thickness", placeholder: "Enter skin thickness", text: $skinThickness)
                        labeledTextField(label: "Insulin", placeholder: "Enter insulin level", text: $insulin)
                        labeledTextField(label: "BMI", placeholder: "Enter BMI", text: $bmi)
                        labeledTextField(label: "Diabetes Pedigree Function", placeholder: "Enter diabetes pedigree function", text: $diabetesPedigreeFunction)
                        labeledTextField(label: "Age", placeholder: "Enter age", text: $age)
                    }
                    .padding(.horizontal)

                    Button(action: predictDiabetes) {
                        Text("Predict")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(
                                gradient: Gradient(colors: [Color.green, Color.blue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .disabled(isLoading)
                    .padding(.horizontal)

                    if !resultText.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Prediction Result")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text(resultText)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                        }
                        .padding(.horizontal)
                    }

                    if !resultText.isEmpty {
                        Button(action: {
                            withAnimation { showShareSlider.toggle() }
                        }) {
                            Text("Share Result")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                        }
                        .padding(.horizontal)
                    }

                    if showShareSlider {
                        VStack {
                            Picker("Share via", selection: $selectedShareOption) {
                                Text("Email").tag("Email")
                                Text("WhatsApp").tag("WhatsApp")
                                Text("Messages").tag("Messages")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()

                            Button(action: shareResult) {
                                Text("Share via \(selectedShareOption)")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(LinearGradient(
                                        gradient: Gradient(colors: [Color.orange, Color.red]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                            }
                        }
                        .transition(.slide)
                        .padding()
                    }

                    // Show disclaimer only after prediction result
                    if showDisclaimer {
                        DisclaimerView()
                            .padding(.top, 20)
                    }
                }
                .padding(.vertical, 20)
            }

            if isLoading {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                ProgressView("Getting the result...")
                    .padding()
                    .background(Color.gray.opacity(0.9))
                    .cornerRadius(12)
            }

            if isSharing {
                // Display ShareActivityViewController when sharing is triggered
                ShareActivityViewController(activityItems: [createPDF()])
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func labeledTextField(label: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(label)
                .foregroundColor(.white)
                .font(.headline)
            TextField(placeholder, text: text)
                .keyboardType(.decimalPad)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.white)
        }
    }

    private func predictDiabetes() {
        // Ensure all inputs are valid numbers
        guard let pregnanciesValue = Double(pregnancies),
              let glucoseValue = Double(glucose),
              let bloodPressureValue = Double(bloodPressure),
              let skinThicknessValue = Double(skinThickness),
              let insulinValue = Double(insulin),
              let bmiValue = Double(bmi),
              let diabetesPedigreeFunctionValue = Double(diabetesPedigreeFunction),
              let ageValue = Double(age) else {
            errorMessage = "Please enter valid numeric values for all fields."
            showError = true
            return
        }

        // Prepare feature array
        let features: [Double] = [
            pregnanciesValue,
            glucoseValue,
            bloodPressureValue,
            skinThicknessValue,
            insulinValue,
            bmiValue,
            diabetesPedigreeFunctionValue,
            ageValue
        ]

        isLoading = true
        resultText = ""

        // Make API call
        PredictionAPI.shared.sendPredictionRequest(modelName: "diabetes", features: features) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    let predictionResult = response.prediction.first == 1 ? "Positive" : "Negative"
                    self.resultText = """
                    Prediction: \(predictionResult)
                    Model Name: \(response.model_name)
                    Confidence Level: \(String(format: "%.2f%%", response.confidence_level * 100))
                    """
                    self.showDisclaimer = true // Show disclaimer after prediction
                case .failure(let error):
                    self.errorMessage = "Failed to get prediction: \(error.localizedDescription)"
                    self.showError = true
                }
            }
        }
    }

    private func shareResult() {
        // Step 1: Generate the PDF document
        let pdfData = createPDF()

        // Step 2: Save the PDF to a temporary file
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent("DiabetesPredictionResult.pdf")

        do {
            try pdfData.write(to: fileURL)
            isSharing = true // Trigger the share sheet

            // Step 3: Print path to file (for debugging purposes)
            print("PDF file path: \(fileURL.path)")

        } catch {
            print("Failed to save PDF: \(error.localizedDescription)")
        }
    }

    private func createPDF() -> Data {
        let pdfDocument = PDFDocument()

        // Step 1.1: Create the content for the PDF
        let resultContent = """
        Prediction Result:

        \(resultText)

        ---

        Data Entered:
        Pregnancies: \(pregnancies)
        Glucose: \(glucose)
        Blood Pressure: \(bloodPressure)
        Skin Thickness: \(skinThickness)
        Insulin: \(insulin)
        BMI: \(bmi)
        Diabetes Pedigree Function: \(diabetesPedigreeFunction)
        Age: \(age)

        Disclaimer: This application is for informational purposes only and should not be used as a substitute for professional medical advice. Predictions provided by this app are based on the data entered and are not guaranteed to be accurate. Please consult a healthcare professional for diagnosis and treatment.
        """

        // Step 1.2: Create a page with the result content
        let pageRect = CGRect(x: 0, y: 0, width: 595, height: 842) // A4 paper size

        // Create an NSMutableData object to hold the PDF data
        let pdfData = NSMutableData()

        // Use UIGraphics to generate the PDF content.
        UIGraphicsBeginPDFContextToData(pdfData, pageRect, nil)
        UIGraphicsBeginPDFPageWithInfo(pageRect, nil)

        let context = UIGraphicsGetCurrentContext()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left

        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .paragraphStyle: paragraphStyle
        ]

        resultContent.draw(in: pageRect.insetBy(dx: 20, dy: 20), withAttributes: textAttributes)

        UIGraphicsEndPDFContext()

        // Return the PDF data as a result
        return pdfData as Data
    }
}

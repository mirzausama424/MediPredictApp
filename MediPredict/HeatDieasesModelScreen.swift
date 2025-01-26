//import SwiftUI
//import UIKit
//import PDFKit
//
//struct HeartDiseaseScreen: View {
//    // Form State Variables
//    @State private var age: String = ""
//    @State private var sex: Bool = true // true = Male, false = Female
//    @State private var cp: Int = 0
//    @State private var trestbps: String = ""
//    @State private var chol: String = ""
//    @State private var fbs: Int = 0
//    @State private var restecg: Int = 0
//    @State private var thalach: String = ""
//    @State private var exang: Int = 0
//    @State private var oldpeak: String = ""
//    @State private var slope: Int = 0
//    @State private var ca: Int = 0
//    @State private var thal: Int = 0
//
//    // Result Variables
//    @State private var isLoading: Bool = false
//    @State private var resultText: String = ""
//    @State private var errorMessage: String = ""
//    @State private var showAlert: Bool = false
//    @State private var confidenceLevel: Double = 0.0
//
//    var body: some View {
//        ZStack {
//            // Background Gradient
//            LinearGradient(
//                gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.8)]),
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//            .ignoresSafeArea()
//
//            ScrollView {
//                VStack(alignment: .leading, spacing: 20) {
//                    // Title
//                    Text("Heart Disease Prediction")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .padding(.top)
//
//                    // Form Inputs
//                    Group {
//                        labeledTextField(label: "Age", placeholder: "Enter your age", text: $age)
//                        VStack(alignment: .leading, spacing: 10) {
//                            Text("Sex")
//                                .font(.headline)
//                                .foregroundColor(.white)
//                            HStack(spacing: 20) {
//                                genderRadioButton(title: "Male", isSelected: sex) { sex = true }
//                                genderRadioButton(title: "Female", isSelected: !sex) { sex = false }
//                            }
//                        }
//                    }
//
//                    Group {
//                        labeledCounter(label: "CP", value: $cp, range: 0...3)
//                        labeledTextField(label: "Trestbps", placeholder: "Enter resting blood pressure", text: $trestbps)
//                        labeledTextField(label: "Chol", placeholder: "Enter cholesterol level", text: $chol)
//                    }
//
//                    Group {
//                        labeledCounter(label: "FBS", value: $fbs, range: 0...1)
//                        labeledCounter(label: "Restecg", value: $restecg, range: 0...2)
//                        labeledTextField(label: "Thalach", placeholder: "Enter maximum heart rate", text: $thalach)
//                    }
//
//                    Group {
//                        labeledCounter(label: "Exang", value: $exang, range: 0...1)
//                        labeledTextField(label: "Old Peak", placeholder: "Enter ST depression", text: $oldpeak)
//                        labeledCounter(label: "Slope", value: $slope, range: 0...2)
//                    }
//
//                    Group {
//                        labeledCounter(label: "Ca", value: $ca, range: 0...4)
//                        labeledCounter(label: "Thal", value: $thal, range: 0...3)
//                    }
//
//                    // Predict Button
//                    Button(action: predictHeartDisease) {
//                        Text("Predict")
//                            .font(.headline)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.green)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                            .shadow(radius: 10)
//                    }
//                    .disabled(!areFieldsFilled()) // Disable button until all fields are filled
//                    .padding([.horizontal, .bottom])
//
//                    // Result Section
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("Prediction Result")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                        Text(resultText)
//                            .foregroundColor(.white)
//                            .padding()
//                            .background(Color.white.opacity(0.2))
//                            .cornerRadius(10)
//                            .lineLimit(nil) // Allow multiple lines
//                            .multilineTextAlignment(.leading) // Align text to the left
//
//                        // Disclaimer
//                        Text("Disclaimer: The results of this prediction are based on the data you provided. They are not 100% accurate, and you should consult a healthcare provider for a proper diagnosis and check-up.")
//                            .font(.footnote)
//                            .foregroundColor(.white)
//                            .padding(.top, 10)
//                            .lineLimit(nil)
//                            .multilineTextAlignment(.leading)
//                    }
//                    .padding(.horizontal)
//
//                    // Share Button (Updated to use PDF sharing)
//                    Button(action: shareResult) {
//                        Text("Share Result")
//                            .font(.headline)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                            .shadow(radius: 10)
//                    }
//                    .padding([.horizontal, .bottom])
//                }
//                .padding(.vertical)
//            }
//
//            // Loading Overlay
//            if isLoading {
//                Color.black.opacity(0.5).ignoresSafeArea()
//                VStack(spacing: 20) {
//                    ProgressView("Loading...")
//                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                        .padding()
//                        .background(Color.gray.opacity(0.8))
//                        .cornerRadius(10)
//                    Text("Predicting... Please wait")
//                        .foregroundColor(.white)
//                        .font(.headline) // Make the text slightly bolder for emphasis
//                }
//            }
//        }
//        .alert(isPresented: $showAlert) {
//            Alert(
//                title: Text("Error"),
//                message: Text(errorMessage),
//                dismissButton: .default(Text("OK"))
//            )
//        }
//    }
//
//    // MARK: - Components
//
//    private func labeledTextField(label: String, placeholder: String, text: Binding<String>) -> some View {
//        VStack(alignment: .leading, spacing: 5) {
//            Text(label)
//                .font(.headline)
//                .foregroundColor(.white)
//            TextField(placeholder, text: Binding(
//                get: { text.wrappedValue },
//                set: { newValue in
//                    let filtered = newValue.filter { "0123456789.".contains($0) }
//                    if filtered.filter({ $0 == "." }).count <= 1 {
//                        text.wrappedValue = filtered
//                    }
//                }
//            ))
//            .keyboardType(.decimalPad)
//            .padding()
//            .background(Color.white.opacity(0.2))
//            .cornerRadius(10)
//            .foregroundColor(.white)
//        }
//    }
//
//    private func labeledCounter(label: String, value: Binding<Int>, range: ClosedRange<Int>) -> some View {
//        VStack(alignment: .leading, spacing: 5) {
//            Text(label)
//                .font(.headline)
//                .foregroundColor(.white)
//            HStack {
//                Text("\(value.wrappedValue)")
//                    .foregroundColor(.white)
//                    .fontWeight(.bold)
//                Spacer()
//                Button(action: { if value.wrappedValue > range.lowerBound { value.wrappedValue -= 1 } }) {
//                    Text("-")
//                        .padding()
//                        .background(Color.red)
//                        .foregroundColor(.white)
//                        .clipShape(Circle())
//                }
//                Button(action: { if value.wrappedValue < range.upperBound { value.wrappedValue += 1 } }) {
//                    Text("+")
//                        .padding()
//                        .background(Color.green)
//                        .foregroundColor(.white)
//                        .clipShape(Circle())
//                }
//            }
//        }
//    }
//
//    private func genderRadioButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
//        Button(action: action) {
//            HStack {
//                Circle()
//                    .stroke(isSelected ? Color.blue : Color.white, lineWidth: 2)
//                    .frame(width: 20, height: 20)
//                    .overlay(Circle().fill(isSelected ? Color.blue : Color.clear))
//                Text(title)
//                    .foregroundColor(.white)
//            }
//        }
//    }
//
//    // MARK: - API Call
//
//    private func predictHeartDisease() {
//        guard !age.isEmpty, !trestbps.isEmpty, !chol.isEmpty, !thalach.isEmpty, !oldpeak.isEmpty else {
//            errorMessage = "Please fill in all required fields."
//            showAlert = true
//            return
//        }
//
//        isLoading = true
//
//        let features: [Double] = [
//            Double(age) ?? 0,
//            sex ? 1.0 : 0.0,
//            Double(cp),
//            Double(trestbps) ?? 0,
//            Double(chol) ?? 0,
//            Double(fbs),
//            Double(restecg),
//            Double(thalach) ?? 0,
//            Double(exang),
//            Double(oldpeak) ?? 0,
//            Double(slope),
//            Double(ca),
//            Double(thal)
//        ]
//
//        PredictionAPI.shared.sendPredictionRequest(modelName: "heart_disease", features: features) { result in
//            DispatchQueue.main.async {
//                self.isLoading = false
//                switch result {
//                case .success(let predictionResponse):
//                    if predictionResponse.prediction.first == 1 {
//                        resultText = "You have Heart Disease!"
//                    } else {
//                        resultText = "You don't have Heart Disease."
//                    }
//                    confidenceLevel = predictionResponse.confidence_level
//                    resultText += "\nConfidence Level: \(Int(confidenceLevel * 100))%"
//                case .failure(let error):
//                    errorMessage = "Error: \(error.localizedDescription)"
//                    showAlert = true
//                }
//            }
//        }
//    }
//
//    private func areFieldsFilled() -> Bool {
//        !age.isEmpty && !trestbps.isEmpty && !chol.isEmpty && !thalach.isEmpty && !oldpeak.isEmpty
//    }
//
//    // MARK: - Share PDF Result
//
//    private func shareResult() {
//        // Step 1: Generate PDF document
//        let pdfData = createPDF()
//
//        // Step 2: Save the PDF to a temporary file
//        let tempDirectory = FileManager.default.temporaryDirectory
//        let fileURL = tempDirectory.appendingPathComponent("HeartDiseasePredictionResult.pdf")
//
//        do {
//            try pdfData.write(to: fileURL)
//
//            if FileManager.default.fileExists(atPath: fileURL.path) {
//                print("PDF exists at path: \(fileURL.path)")
//            } else {
//                print("PDF file not created")
//                return
//            }
//
//            // Step 3: Share the generated PDF using UIActivityViewController
//            let activityController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
//
//            if let popoverController = activityController.popoverPresentationController {
//                popoverController.sourceView = UIApplication.shared.windows.first?.rootViewController?.view
//                popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 0, height: 0)
//                popoverController.permittedArrowDirections = []
//            }
//
//            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//               let rootVC = windowScene.windows.first?.rootViewController {
//                var presentedVC = rootVC
//                while let nextVC = presentedVC.presentedViewController {
//                    presentedVC = nextVC
//                }
//                presentedVC.present(activityController, animated: true, completion: nil)
//            }
//
//        } catch {
//            print("Failed to save PDF: \(error.localizedDescription)")
//        }
//    }
//
//
//    // Step 1: Create the PDF document
//    private func createPDF() -> Data {
//        let pdfDocument = PDFDocument()
//
//        // Step 1.1: Create the content for the PDF
//        let resultContent = """
//        Prediction Result:
//
//        \(resultText)
//
//        ---
//
//        Data Entered:
//        Age: \(age)
//        Gender: \(sex ? "Male" : "Female")
//        CP: \(cp)
//        Trestbps: \(trestbps)
//        Chol: \(chol)
//        FBS: \(fbs)
//        Restecg: \(restecg)
//        Thalach: \(thalach)
//        Exang: \(exang)
//        Old Peak: \(oldpeak)
//        Slope: \(slope)
//        Ca: \(ca)
//        Thal: \(thal)
//
//            Disclaimer: This application is for informational purposes only and should not be used as a substitute for professional medical advice. Predictions provided by this app are based on the data entered and are not guaranteed to be accurate. Please consult a healthcare professional for diagnosis and treatment.
//        """
//
//        // Step 1.2: Create a page with the result content
//        let pageRect = CGRect(x: 0, y: 0, width: 595, height: 842) // A4 paper size
//
//        // Create an NSMutableData object to hold the PDF data
//        let pdfData = NSMutableData()
//
//        // Use UIGraphics to generate the PDF content.
//        UIGraphicsBeginPDFContextToData(pdfData, pageRect, nil)
//        UIGraphicsBeginPDFPageWithInfo(pageRect, nil)
//
//        let context = UIGraphicsGetCurrentContext()
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .left
//
//        let textAttributes: [NSAttributedString.Key: Any] = [
//            .font: UIFont.systemFont(ofSize: 12),
//            .paragraphStyle: paragraphStyle
//        ]
//
//        resultContent.draw(in: pageRect.insetBy(dx: 20, dy: 20), withAttributes: textAttributes)
//
//        UIGraphicsEndPDFContext()
//
//        // Return the PDF data as Data (converting NSMutableData to Data)
//        return pdfData as Data
//    }
//
//}

import SwiftUI
import UIKit
import PDFKit

// UIApplication extension to dismiss keyboard
extension UIApplication {
    func endEditing(_ force: Bool) {
        windows.filter { $0.isKeyWindow }.first?.endEditing(force)
    }
}

struct HeartDiseaseScreen: View {
    // Form State Variables
    @State private var age: String = ""
    @State private var sex: Bool = true // true = Male, false = Female
    @State private var cp: Int = 0
    @State private var trestbps: String = ""
    @State private var chol: String = ""
    @State private var fbs: Int = 0
    @State private var restecg: Int = 0
    @State private var thalach: String = ""
    @State private var exang: Int = 0
    @State private var oldpeak: String = ""
    @State private var slope: Int = 0
    @State private var ca: Int = 0
    @State private var thal: Int = 0

    // Result Variables
    @State private var isLoading: Bool = false
    @State private var resultText: String = ""
    @State private var errorMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var confidenceLevel: Double = 0.0

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Title
                    Text("Heart Disease Prediction")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top)

                    // Form Inputs
                    Group {
                        labeledTextField(label: "Age", placeholder: "Enter your age", text: $age)
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Sex")
                                .font(.headline)
                                .foregroundColor(.white)
                            HStack(spacing: 20) {
                                genderRadioButton(title: "Male", isSelected: sex) { sex = true }
                                genderRadioButton(title: "Female", isSelected: !sex) { sex = false }
                            }
                        }
                    }

                    Group {
                        labeledCounter(label: "CP", value: $cp, range: 0...3)
                        labeledTextField(label: "Trestbps", placeholder: "Enter resting blood pressure", text: $trestbps)
                        labeledTextField(label: "Chol", placeholder: "Enter cholesterol level", text: $chol)
                    }

                    Group {
                        labeledCounter(label: "FBS", value: $fbs, range: 0...1)
                        labeledCounter(label: "Restecg", value: $restecg, range: 0...2)
                        labeledTextField(label: "Thalach", placeholder: "Enter maximum heart rate", text: $thalach)
                    }

                    Group {
                        labeledCounter(label: "Exang", value: $exang, range: 0...1)
                        labeledTextField(label: "Old Peak", placeholder: "Enter ST depression", text: $oldpeak)
                        labeledCounter(label: "Slope", value: $slope, range: 0...2)
                    }

                    Group {
                        labeledCounter(label: "Ca", value: $ca, range: 0...4)
                        labeledCounter(label: "Thal", value: $thal, range: 0...3)
                    }

                    // Predict Button
                    Button(action: predictHeartDisease) {
                        Text("Predict")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                    .disabled(!areFieldsFilled()) // Disable button until all fields are filled
                    .padding([.horizontal, .bottom])

                    // Result Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Prediction Result")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(resultText)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                            .lineLimit(nil) // Allow multiple lines
                            .multilineTextAlignment(.leading) // Align text to the left

                        // Disclaimer
                        Text("Disclaimer: The results of this prediction are based on the data you provided. They are not 100% accurate, and you should consult a healthcare provider for a proper diagnosis and check-up.")
                            .font(.footnote)
                            .foregroundColor(.white)
                            .padding(.top, 10)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                    }
                    .padding([.horizontal, .leading]) // 20 padding for both left and right

                    // Share Button (Updated to use PDF sharing)
                    Button(action: shareResult) {
                        Text("Share Result")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                    .padding([.horizontal, .bottom])
                }
                .padding([.vertical])
                .padding(.leading, 20) // Add 20 padding from left side
                .padding(.trailing, 20) // Add 20 padding from right side
                .onTapGesture {
                    // Dismiss keyboard when tapping outside of text fields
                    UIApplication.shared.endEditing(true)
                }
            }

            // Loading Overlay
            if isLoading {
                Color.black.opacity(0.5).ignoresSafeArea()
                VStack(spacing: 20) {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                        .background(Color.gray.opacity(0.8))
                        .cornerRadius(10)
                    Text("Predicting... Please wait")
                        .foregroundColor(.white)
                        .font(.headline) // Make the text slightly bolder for emphasis
                }
            }
        }
        // The Alert should be placed here, within the ZStack but after all views are placed.
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    // MARK: - Components

    private func labeledTextField(label: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.headline)
                .foregroundColor(.white)
            TextField(placeholder, text: Binding(
                get: { text.wrappedValue },
                set: { newValue in
                    let filtered = newValue.filter { "0123456789.".contains($0) }
                    if filtered.filter({ $0 == "." }).count <= 1 {
                        text.wrappedValue = filtered
                    }
                }
            ))
            .keyboardType(.decimalPad)
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(10)
            .foregroundColor(.white)
        }
    }

    private func labeledCounter(label: String, value: Binding<Int>, range: ClosedRange<Int>) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.headline)
                .foregroundColor(.white)
            HStack {
                Text("\(value.wrappedValue)")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                Spacer()
                Button(action: { if value.wrappedValue > range.lowerBound { value.wrappedValue -= 1 } }) {
                    Text("-")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                Button(action: { if value.wrappedValue < range.upperBound { value.wrappedValue += 1 } }) {
                    Text("+")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
        }
    }

    private func genderRadioButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Circle()
                    .stroke(isSelected ? Color.blue : Color.white, lineWidth: 2)
                    .frame(width: 20, height: 20)
                    .overlay(Circle().fill(isSelected ? Color.blue : Color.clear))
                Text(title)
                    .foregroundColor(.white)
            }
        }
    }

    // MARK: - API Call

    private func predictHeartDisease() {
        guard !age.isEmpty, !trestbps.isEmpty, !chol.isEmpty, !thalach.isEmpty, !oldpeak.isEmpty else {
            errorMessage = "Please fill in all required fields."
            showAlert = true
            return
        }

        isLoading = true

        let features: [Double] = [
            Double(age) ?? 0,
            sex ? 1.0 : 0.0,
            Double(cp),
            Double(trestbps) ?? 0,
            Double(chol) ?? 0,
            Double(fbs),
            Double(restecg),
            Double(thalach) ?? 0,
            Double(exang),
            Double(oldpeak) ?? 0,
            Double(slope),
            Double(ca),
            Double(thal)
        ]

        PredictionAPI.shared.sendPredictionRequest(modelName: "heart_disease", features: features) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let predictionResponse):
                    if predictionResponse.prediction.first == 1 {
                        resultText = "You have Heart Disease!"
                    } else {
                        resultText = "You don't have Heart Disease."
                    }
                    confidenceLevel = predictionResponse.confidence_level
                    resultText += "\nConfidence Level: \(Int(confidenceLevel * 100))%"
                case .failure(let error):
                    errorMessage = "Error: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }

    private func areFieldsFilled() -> Bool {
        !age.isEmpty && !trestbps.isEmpty && !chol.isEmpty && !thalach.isEmpty && !oldpeak.isEmpty
    }

    // MARK: - Share PDF Result

    private func shareResult() {
        // Step 1: Generate PDF document
        let pdfData = createPDF()

        // Step 2: Save the PDF to a temporary file
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent("HeartDiseasePredictionResult.pdf")

        do {
            try pdfData.write(to: fileURL)

            if FileManager.default.fileExists(atPath: fileURL.path) {
                print("PDF exists at path: \(fileURL.path)")
            } else {
                print("PDF file not created")
                return
            }

            // Step 3: Share the generated PDF using UIActivityViewController
            let activityController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)

            if let popoverController = activityController.popoverPresentationController {
                popoverController.sourceView = UIApplication.shared.windows.first?.rootViewController?.view
                popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController {
                var presentedVC = rootVC
                while let nextVC = presentedVC.presentedViewController {
                    presentedVC = nextVC
                }
                presentedVC.present(activityController, animated: true, completion: nil)
            }

        } catch {
            print("Failed to save PDF: \(error)")
        }
    }

    private func createPDF() -> Data {
        let pdfMetaData: [String: Any] = [
            kCGPDFContextCreator as String: "Heart Disease Prediction App",
            kCGPDFContextAuthor as String: "Your Name",
            kCGPDFContextTitle as String: "Heart Disease Prediction Result"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData

        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 595, height: 842), format: format)

        let data = renderer.pdfData { context in
            context.beginPage()

            let titleAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24)]
            let bodyAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]

            // Title
            let title = "Heart Disease Prediction Result"
            title.draw(at: CGPoint(x: 40, y: 40), withAttributes: titleAttributes)

            // Prediction result and confidence level
            let resultText = self.resultText
            resultText.draw(at: CGPoint(x: 40, y: 80), withAttributes: bodyAttributes)

            // Disclaimer
            let disclaimerText = "Disclaimer: The results are based on the data provided and are not guaranteed to be accurate. Please consult a healthcare provider."
            disclaimerText.draw(at: CGPoint(x: 40, y: 180), withAttributes: bodyAttributes)
        }

        return data
    }
}

struct HeartDiseaseScreen_Previews: PreviewProvider {
    static var previews: some View {
        HeartDiseaseScreen()
    }
}

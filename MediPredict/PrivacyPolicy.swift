import SwiftUI

struct PolicyView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Privacy Policy & Disclaimer")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                        .padding(.horizontal)

                    Group {
                        // Privacy Policy Section
                        Text("Privacy Policy")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top, 10)
                            .padding(.horizontal)

                        Text("""
                            Effective Date: January 25, 2025
                            
                            Medipredict ("we", "our", "us") respects your privacy and is committed to protecting your personal information. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our app Medipredict ("the App"). Please read this privacy policy carefully. By using the App, you agree to the terms and conditions described in this policy.

                            1. Information Collection
                            We may collect the following types of information when you use the App:

                            - Personal Information: When you register or sign in to the App, we may collect personal details such as name, email, or other identifiers.
                            - Health Data: You may voluntarily provide health-related data such as medical symptoms, conditions, or test results.
                            - Usage Data: This includes data about your usage of the app, such as your interactions with the features, pages you visit, and the time spent within the App.

                            2. Use of Information
                            We use the information we collect to:
                            - Provide you with personalized health predictions based on the data you input.
                            - Improve the performance and functionality of the App.
                            - Contact you with notifications regarding your results or new features.

                            3. Data Security
                            We implement industry-standard security measures to protect your personal information from unauthorized access, alteration, disclosure, or destruction. However, no method of electronic transmission or storage is 100% secure, and we cannot guarantee absolute security.

                            4. Data Sharing
                            We do not share your personal or health data with third parties unless required by law or as necessary to provide the services of the App (for example, sharing data with healthcare professionals if you request it).

                            5. Third-Party Services
                            The App may contain links to third-party services or websites. We do not control these services and are not responsible for their privacy practices or content.
                        """)
                            .font(.body)
                            .padding(.horizontal)

                        Divider()

                        // Disclaimer Section
                        Text("Disclaimer")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top, 10)
                            .padding(.horizontal)

                        Text("""
                            Medipredict is an AI-powered health prediction app designed to provide knowledge and insights based on the data you input. The app uses machine learning models to predict the likelihood of various diseases based on symptoms and other input data.

                            1. For Informational Purposes Only
                            The predictions made by Medipredict are based on statistical analysis and machine learning algorithms. These predictions are intended solely for informational and educational purposes. The results provided by the App should not be used as a substitute for professional medical advice, diagnosis, or treatment.

                            2. Consult a Healthcare Professional
                            Always seek the advice of your doctor or other qualified health provider with any questions you may have regarding a medical condition. Never disregard professional medical advice or delay in seeking it because of something you have read in the App.

                            3. Accuracy and Reliability
                            While we strive to provide accurate and reliable predictions, Medipredict cannot guarantee the accuracy, completeness, or reliability of the results. The app's predictions are based on the data entered by the user and the AI model's training. The app does not account for the full range of medical factors that may affect a diagnosis.

                            4. No Guarantees of Diagnosis
                            Medipredict does not provide a definitive diagnosis for any health condition. The predictions are probabilistic in nature and should only be used as a tool for guiding further investigation. A healthcare professional will provide the most accurate diagnosis through medical exams, tests, and consultations.

                            5. Liability Limitations
                            To the maximum extent permitted by law, Medipredict, its affiliates, and its employees shall not be held liable for any damages, losses, or costs arising from the use or inability to use the App, including but not limited to reliance on the results provided by the App.

                            6. Changes to Disclaimer
                            We reserve the right to modify or update this disclaimer at any time without prior notice. Changes will take effect immediately upon posting the updated disclaimer in the App. It is your responsibility to review this policy periodically to stay informed about how we protect your information.
                        """)
                            .font(.body)
                            .padding(.horizontal)

                        Divider()

                        // Terms of Use Section
                        Text("Terms of Use")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top, 10)
                            .padding(.horizontal)

                        Text("""
                            By using Medipredict, you agree to abide by the following terms and conditions:

                            1. Eligibility
                            You must be at least 18 years old to use the App. If you are under 18, you must have the permission of a parent or legal guardian.

                            2. Account Responsibility
                            You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.

                            3. App Usage
                            You agree to use the App only for lawful purposes and in accordance with our terms. You are prohibited from using the App in any way that could harm, disable, or impair the App's functionality.

                            4. Termination of Access
                            We may suspend or terminate your access to the App at any time, with or without notice, for conduct that violates these Terms of Use or for any other reason.

                            5. Governing Law
                            These Terms of Use are governed by and construed in accordance with the laws of the jurisdiction where the App is used. Any disputes will be resolved in the appropriate courts within that jurisdiction.
                        """)
                            .font(.body)
                            .padding(.horizontal)

                        Divider()

//                        // Contact Information Section
//                        Text("Contact Us")
//                            .font(.title2)
//                            .fontWeight(.semibold)
//                            .padding(.top, 10)
//                            .padding(.horizontal)
//
//                        Text("""
//                            If you have any questions about this Privacy Policy, Disclaimer, or Terms of Use, please contact us at:
//
//                            Medipredict Support
//                            Email: support@medipredict.com
//                            Phone: 123-456-7890
//                            Address: 123 Health Ave, City, Country
//                        """)
//                            .font(.body)
//                            .padding(.horizontal)
//                    }

                    Spacer()
                }
            }
            .navigationTitle("Policy & Disclaimer")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PolicyView()
    }
}
}

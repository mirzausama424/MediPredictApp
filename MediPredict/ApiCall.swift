import Foundation

class PredictionAPI: ObservableObject {
    static let shared = PredictionAPI()
    private init() {}
    
    private let baseURL = "https://multiple-dieases-model.onrender.com"
    
    // Function to send POST request for prediction
    func sendPredictionRequest(modelName: String, features: [Double], completion: @escaping (Result<PredictionResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/prediction/predict") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        let requestBody: [String: Any] = [
            "model_name": modelName,
            "features": features
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(.failure(NSError(domain: "Invalid JSON Data", code: 400, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Invalid Response", code: 500, userInfo: nil)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data Received", code: 500, userInfo: nil)))
                return
            }
            
            do {
                let predictionResponse = try JSONDecoder().decode(PredictionResponse.self, from: data)
                completion(.success(predictionResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    // Function to send GET request for basic API info
    func getAPIInfo(completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Invalid Response", code: 500, userInfo: nil)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data Received", code: 500, userInfo: nil)))
                return
            }
            
            do {
                let message = try JSONDecoder().decode([String: String].self, from: data)
                if let responseMessage = message["message"] {
                    completion(.success(responseMessage))
                } else {
                    completion(.failure(NSError(domain: "Message Missing", code: 500, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

import Foundation

// Prediction request model
class Prediction {
    var model_name: String
    var features: [Double]
    
    init(modelName: String, features: [Double]) {
        self.model_name = modelName
        self.features = features
    }
}

// Prediction response model
struct PredictionResponse: Codable {
    let model_name: String
    let prediction: [Int]
    let confidence_level: Double
}

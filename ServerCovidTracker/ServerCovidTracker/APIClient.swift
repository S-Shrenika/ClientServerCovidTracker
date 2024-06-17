import Foundation

struct CovidData: Codable {
    let date: Int
    let positive: Int?
    let negative: Int?
}

class APIClient {
    static let shared = APIClient()
    
    private let baseURL = "http://127.0.0.1:5000/api"
    
    func fetchArizonaData(completion: @escaping ([CovidData]?) -> Void) {
        let url = URL(string: "\(baseURL)/arizona")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            let decoder = JSONDecoder()
            let result = try? decoder.decode([CovidData].self, from: data)
            completion(result)
        }
        task.resume()
    }
    
    func fetchStateData(state: String, startDate: String, endDate: String, completion: @escaping ([CovidData]?) -> Void) {
        let url = URL(string: "\(baseURL)/state")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["state": state, "start_date": startDate, "end_date": endDate]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            let decoder = JSONDecoder()
            let result = try? decoder.decode([CovidData].self, from: data)
            completion(result)
        }
        task.resume()
    }
}

//
//  NetworkHelper.swift
//  SwipeAssessment
//
//  Created by Akepati Karthikeya Reddy on 03/02/25.
//

import UIKit

class NetworkHelper {
    
    private init() { }
    static var shared: NetworkHelper = .init()
    
    /// Sends a GET request to the specified URL and decodes the response into the given `Decodable` type.
    /// - Parameters:
    ///   - urlString: The URL string for the request.
    ///   - completion: A completion handler with a decoded object of type `T` or an error message.
    func dataRequest<T: Decodable>(withUrl urlString: String, completion: @escaping (T?, String?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print(urlRequest)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                if let error {
                    completion(nil, error.localizedDescription)
                } else if let data {
                    let json = try? JSONSerialization.jsonObject(with: data)
                    print(json ?? "")
                    let decodedResponse: T? = GlobalUtility.decodeData(from: data)
                    print(decodedResponse ?? "")
                    completion(decodedResponse, nil)
                } else {
                    completion(nil, nil)
                }
            }
        }
        dataTask.resume()
    }

    /// Uploads form data including optional images to a server via a POST request.
    /// - Parameters:
    ///   - urlString: The URL string where the data will be uploaded.
    ///   - params: A dictionary containing form parameters.
    ///   - images: An array of `UIImage` objects to be uploaded.
    ///   - imageParamName: The parameter name for the uploaded images.
    ///   - completion: A completion handler with a decoded response of type `T` or an error message.
    func uploadFormData<T: Decodable>(
        to urlString: String,
        params: [String: AnyHashable],
        images: [UIImage],
        imageParamName: String?,
        completion: @escaping (T?, String?) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(nil, "Invalid URL")
            return
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Append text parameters to the request body
        for (key, value) in params {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Append images if provided
        if let imageParamName {
            for image in images {
                if let imageData = image.jpegData(compressionQuality: 0.8) {
                    let filename = "\(UUID().uuidString).jpg"
                    let mimeType = "image/jpeg"
                    
                    body.append("--\(boundary)\r\n".data(using: .utf8)!)
                    body.append("Content-Disposition: form-data; name=\"\(imageParamName)[]\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
                    body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
                    body.append(imageData)
                    body.append("\r\n".data(using: .utf8)!)
                }
            }
        }
        
        // Close the request body
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error {
                    completion(nil, error.localizedDescription)
                } else if let data {
                    let json = String(data: data, encoding: .utf8)
                    print(json ?? "")
                    let decodedResponse: T? = GlobalUtility.decodeData(from: data)
                    print(decodedResponse ?? "")
                    completion(decodedResponse, nil)
                } else {
                    completion(nil, nil)
                }
            }
        }
        task.resume()
    }
}

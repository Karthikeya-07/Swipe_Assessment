//
//  Helpers.swift
//  SwipeAssessment
//
//  Created by Akepati Karthikeya Reddy on 04/02/25.
//

import Foundation

class GlobalUtility {
    
    /// Decodes JSON data into a specified `Decodable` type.
    ///
    /// - Parameter data: The `Data` object containing JSON.
    /// - Returns: A decoded object of type `T` if successful, otherwise `nil`.
    static func decodeData<T: Decodable>(from data: Data?) -> T? {
        guard let data else { return nil }
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch let error {
            print("Decoding error: \(error.localizedDescription)")
            return nil
        }
    }
}

//
//  Helpers.swift
//  SwipeAssessment
//
//  Created by Akepati Karthikeya Reddy on 04/02/25.
//

import Foundation

class GlobalUtility {
    private init() { }
    static var shared: GlobalUtility = .init()

    static func decodeData<T:Decodable>(from data: Data?) -> T? {
        guard let data else { return nil }
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}

//
//  MockData.swift
//  MoviesTests
//
//  Created by Cristian Chertes on 06.02.2023.
//

import Foundation

class MockData {
    static func getMoviesJSON() -> Data {
        return serializationJSON(readJSONFromFile(fileName: "movieslist"))!
    }
    
    private static func readJSONFromFile(fileName: String) -> Any? {
        var json: Any?
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                json = try? JSONSerialization.jsonObject(with: data)
            } catch {
                // H
            }
        }
        return json
    }
    
    private static func serializationJSON(_ json: Any?) -> Data? {
        guard let json = json else { return nil }
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            return nil
        }
    }
}

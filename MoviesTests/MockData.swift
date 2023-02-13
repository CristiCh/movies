//
//  MockData.swift
//  MoviesTests
//
//  Created by Cristian Chertes on 06.02.2023.
//

import Foundation

class MockData {
    static func getMoviesJSON() -> Data {
        return readJSONFromFile(fileName: "movieslist")!
    }
    
    static func getMovieDetailsJSON() -> Data {
        return readJSONFromFile(fileName: "moviedetail")!
    }
    
    private static func readJSONFromFile(fileName: String) -> Data? {
//        var json: Any?
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
//                json = try? JSONSerialization.jsonObject(with: data)
                return data
            } catch {
                // H
            }
        }
        return nil
    }
    
//    private static func serializationJSON(_ json: Any?) -> Data? {
//        guard let json = json else { return nil }
//        do {
//            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
//        } catch {
//            return nil
//        }
//    }
}

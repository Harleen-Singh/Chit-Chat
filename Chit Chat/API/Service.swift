//
//  Service.swift
//  Chit Chat
//
//  Created by Harleen Singh on 25/12/20.
//

import Foundation

struct Service {
    static func readJson(offset: Int) -> [Message] {
        // Get url for file
        
        let fileName = K.fileName + "-" + String(offset)
        print(fileName)
        guard let fileUrl = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("File could not be located at the given url")
            return [Message]()
        }

        do {
            // Get data from file
            
            let data = try Data(contentsOf: fileUrl)

            // Decode data to a Dictionary<String, Any> object
            let response = try JSONDecoder().decode(MessageResponse.self, from: data)
            return response.response
//            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
//                print("Could not cast JSON content as a Dictionary<String, Any>")
//                return
//            }

            // Print result
            //print(dictionary)
        } catch {
            // Print error if something went wrong
            print("Error: \(error)")
        }
        return [Message]()
    }
}

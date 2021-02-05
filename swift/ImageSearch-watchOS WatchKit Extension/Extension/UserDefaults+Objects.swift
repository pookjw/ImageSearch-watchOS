//
//  UserDefaults+Objects.swift
//  ImageSearch-watchOS WatchKit Extension
//
//  Created by Jinwoo Kim on 2/6/21.
//

import Foundation

extension UserDefaults {
    func setObjects<T>(_ object: [T], forKey: String) where T: Encodable {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(object)
        set(data, forKey: forKey)
    }
    
    func getObjects<T>(forKey: String) -> [T] where T: Decodable {
        guard let data = data(forKey: forKey) else { return [] }
        let decoder = JSONDecoder()
        let object = try! decoder.decode([T].self, from: data)
        return object
    }
}

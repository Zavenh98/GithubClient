//
//  DefaultsStorageManager.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 18.01.26.
//

import Foundation

final class DefaultsStorageManager: DefaultsStorageManagerInput {

    private let defaults: UserDefaults
    private let encoder: JSONEncoder = JSONEncoder()
    private let decoder: JSONDecoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    // MARK: - Primitives
    func set(_ value: Bool, for key: DefaultsStorageKey) {
        defaults.set(value, forKey: key.rawValue)
    }

    func bool(for key: DefaultsStorageKey) -> Bool {
        defaults.bool(forKey: key.rawValue)
    }

    func set(_ value: Int, for key: DefaultsStorageKey) {
        defaults.set(value, forKey: key.rawValue)
    }

    func int(for key: DefaultsStorageKey) -> Int {
        defaults.integer(forKey: key.rawValue)
    }

    func set(_ value: String?, for key: DefaultsStorageKey) {
        defaults.set(value, forKey: key.rawValue)
    }

    func string(for key: DefaultsStorageKey) -> String? {
        defaults.string(forKey: key.rawValue)
    }

    // MARK: - Codable
    func setObject<T: Codable>(_ value: T?, for key: DefaultsStorageKey) throws {
        guard let value else {
            remove(key)
            return
        }
        let data = try encoder.encode(value)
        defaults.set(data, forKey: key.rawValue)
    }

    func getObject<T: Codable>(_ type: T.Type, for key: DefaultsStorageKey) throws -> T? {
        guard let data = defaults.data(forKey: key.rawValue) else { return nil }
        return try decoder.decode(type, from: data)
    }

    // MARK: - Remove
    func remove(_ key: DefaultsStorageKey) {
        defaults.removeObject(forKey: key.rawValue)
    }

    func clear() {
        DefaultsStorageKey.allCases.forEach {
            defaults.removeObject(forKey: $0.rawValue)
        }
    }
}

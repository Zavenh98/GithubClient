//
//  DefaultsStorageManagerInput.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 18.01.26.
//

import Foundation

protocol DefaultsStorageManagerInput {
    // MARK: - Primitives
    func set(_ value: Bool, for key: DefaultsStorageKey)
    func bool(for key: DefaultsStorageKey) -> Bool

    func set(_ value: Int, for key: DefaultsStorageKey)
    func int(for key: DefaultsStorageKey) -> Int

    func set(_ value: String?, for key: DefaultsStorageKey)
    func string(for key: DefaultsStorageKey) -> String?

    // MARK: - Codable
    func setObject<T: Codable>(_ value: T?, for key: DefaultsStorageKey) throws
    func getObject<T: Codable>(_ type: T.Type, for key: DefaultsStorageKey) throws -> T?

    // MARK: - Remove
    func remove(_ key: DefaultsStorageKey)
    func clear()
}

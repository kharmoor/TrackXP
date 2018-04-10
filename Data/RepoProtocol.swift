//
//  RepoProtocol.swift
//  CheckNow
//
//  Created by Khari Moore on 12/5/17.
//  Copyright © 2017 Khari Moore. All rights reserved.
//

import Foundation

protocol RepoProtocol {
    associatedtype T
    static func insert(item: T) throws -> Int64
    static func update(item: T) throws -> Void
    static func delete(item: T) throws -> Void
    static func find(id: Int64) throws -> T?
    static func findAll() throws -> [T]?
    static func createTable()throws-> Void
}

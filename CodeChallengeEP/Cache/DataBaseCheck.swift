//
//  DataBaseCheck.swift
//  CodeChallengeEP
//
//  Created by Sammy Alonso Calle Torres on 3/14/24.
//

import Foundation
import SQLite3

extension DatabaseManager {
    static func isSitesTableEmpty() -> Bool {
        guard let db = openDatabaseConnection() else {
            return true
        }
        
        let query = "SELECT id FROM Sites LIMIT 1;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            defer {
                sqlite3_finalize(statement)
            }
            
            if sqlite3_step(statement) == SQLITE_ROW {
                // If a row is fetched, the table is not empty
                return true
            }
        }
        closeDatabaseConnection(db: db)
        return false
    }
    
    static func isChargersTableEmpty() -> Bool {
        guard let db = openDatabaseConnection() else {
            return true
        }
        let query = "SELECT id FROM Chargers LIMIT 1;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            defer {
                sqlite3_finalize(statement)
            }
            
            if sqlite3_step(statement) == SQLITE_ROW {
                // If a row is fetched, the table is not empty
                return true
            }
        }
        closeDatabaseConnection(db: db)
        return false
    }
}


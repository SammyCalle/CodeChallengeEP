//
//  SaveChargers.swift
//  CodeChallengeEP
//
//  Created by Sammy Alonso Calle Torres on 3/15/24.
//

import Foundation

import SQLite3

extension DatabaseManager {
    static func saveChargersToDatabase(chargers: [ChargerEntity]) {
        guard let db = openDatabaseConnection() else {
            fatalError("Unable to open database connection")
        }
        
        defer {
            sqlite3_close(db)
        }
        
        // Begin transaction
        if sqlite3_exec(db, "BEGIN TRANSACTION;", nil, nil, nil) != SQLITE_OK {
            fatalError("Failed to begin transaction")
        }
        
        // Prepare insert statement
        let insertSQL = "INSERT INTO Sites (siteID, chargerID, name) VALUES (?, ?, ?);"
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, insertSQL, -1, &statement, nil) == SQLITE_OK else {
            fatalError("Failed to prepare insert statement")
        }
        
        defer {
            sqlite3_finalize(statement)
        }
        
        // Bind parameters and execute insert statement for each site
        for charger in chargers {
            let siteID = Int32(charger.siteID)
            let chargerID = charger.chargerID as NSString
            let name = charger.name as NSString
            
            guard sqlite3_bind_int(statement, 1, siteID) == SQLITE_OK &&
                    sqlite3_bind_text(statement, 2, chargerID.utf8String, -1, nil) == SQLITE_OK &&
                    sqlite3_bind_text(statement, 3, name.utf8String, -1, nil) == SQLITE_OK  else {
                fatalError("Failed to bind parameters")
            }
            
            guard sqlite3_step(statement) == SQLITE_DONE else {
                fatalError("Failed to execute insert statement")
            }
            
            sqlite3_reset(statement)
        }
        
        // Commit transaction
        if sqlite3_exec(db, "COMMIT TRANSACTION;", nil, nil, nil) != SQLITE_OK {
            fatalError("Failed to commit transaction")
        }
        closeDatabaseConnection(db: db)
    }
}

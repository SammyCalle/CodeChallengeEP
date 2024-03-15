//
//  SaveEvses.swift
//  CodeChallengeEP
//
//  Created by Sammy Alonso Calle Torres on 3/15/24.
//

import Foundation
import SQLite3

extension DatabaseManager {
    static func saveEvsesToDatabase(evses: [EvsesEntity]) {
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
        let insertSQL = "INSERT INTO Evses (id, chargerID, code) VALUES (?, ?, ?);"
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, insertSQL, -1, &statement, nil) == SQLITE_OK else {
            fatalError("Failed to prepare insert statement")
        }
        
        defer {
            sqlite3_finalize(statement)
        }
        
        // Bind parameters and execute insert statement for each site
        for evse in evses {
            let id = Int32(evse.id)
            let chargerID = Int32(evse.chargerID)
            let code = evse.code as NSString
            
            guard sqlite3_bind_int(statement, 1, id) == SQLITE_OK &&
                    sqlite3_bind_int(statement, 2, chargerID) == SQLITE_OK &&
                    sqlite3_bind_text(statement, 3, code.utf8String, -1, nil) == SQLITE_OK  else {
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

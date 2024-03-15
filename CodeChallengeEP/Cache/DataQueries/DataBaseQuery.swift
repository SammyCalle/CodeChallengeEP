//
//  DataBaseQuery.swift
//  CodeChallengeEP
//
//  Created by Sammy Alonso Calle Torres on 3/14/24.
//

import Foundation
import SQLite3

extension DatabaseManager {
    static func getAllSites() -> [SiteDomain] {
        var sites: [SiteDomain] = []
        
        guard let db = openDatabaseConnection() else {
            fatalError("Unable to open database connection")
        }
        
        defer {
            sqlite3_close(db)
        }
        
        let query = "SELECT id, siteID ,name, details, lat, lon FROM Sites;"
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            fatalError("Failed to prepare select statement")
        }
        
        defer {
            sqlite3_finalize(statement)
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = sqlite3_column_int(statement, 0)
            let siteID = String(cString: sqlite3_column_text(statement, 1))
            let name = String(cString: sqlite3_column_text(statement, 2))
            let details = String(cString: sqlite3_column_text(statement, 3))
            let lat = sqlite3_column_double(statement, 4)
            let lon = sqlite3_column_double(statement, 5)
            
            let site = SiteDomain(id: Int(id), siteID :siteID ,name: name, details: details, lat: lat, lon: lon)
            sites.append(site)
        }
        closeDatabaseConnection(db: db)
        return sites
    }
}


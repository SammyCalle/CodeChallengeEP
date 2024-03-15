//
//  DataBaseManager.swift
//  CodeChallengeEP
//
//  Created by Sammy Alonso Calle Torres on 3/14/24.
//

import Foundation
import SQLite3

class DatabaseManager {
    static let databaseName = "challengeEPDataBase.sqlite"
    
    static func getDatabaseURL() -> URL {
        guard let applicationSupportDirectoryURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            fatalError("Unable to access application support directory.")
        }
        
        return applicationSupportDirectoryURL.appendingPathExtension(databaseName)
    }
    
    static func createDatabaseIfNeeded() {
        let databaseURL = getDatabaseURL()
        
        if !FileManager.default.fileExists(atPath: databaseURL.path) {
            var db: OpaquePointer? = nil
            let openResult = sqlite3_open(databaseURL.path, &db)
            
            if openResult != SQLITE_OK {
                if let errorPointer = sqlite3_errmsg(db) {
                    let errorMessage = String(cString: errorPointer)
                    fatalError("Unable to open database. Error: \(errorMessage)")
                } else {
                    fatalError("Unable to open database. Error code: \(openResult)")
                }
            }
            
            createTables(db: db!)
            sqlite3_close(db)
        }
    }


    static func openDatabaseConnection() -> OpaquePointer? {
        let databaseURL = getDatabaseURL()
        var db: OpaquePointer? = nil
        
        if sqlite3_open(databaseURL.path, &db) != SQLITE_OK {
            fatalError("Unable to open database.")
        }
        
        return db
    }

    
    static func closeDatabaseConnection(db: OpaquePointer?) {
        if let db = db {
            sqlite3_close(db)
        }
    }
    
    
    static func createTables(db : OpaquePointer) {
        
        // Check and create tables if needed
        // Check if the Sites table exists
        if !tableExists(tableName: "Sites", in: db) {
            createSitesTable(in: db)
        }
        
        // Check if the Chargers table exists
        if !tableExists(tableName: "Chargers", in: db) {
            createChargersTable(in: db)
        }
        
        // Check if the Evses table exists
        if !tableExists(tableName: "Evses", in: db) {
            createEvsesTable(in: db)
        }
        
        // Check if the Connectors table exists
        if !tableExists(tableName: "Connectors", in: db) {
            createConnectorsTable(in: db)
        }
        
        // Close the database connection
        sqlite3_close(db)
    }
    
    static func tableExists(tableName: String, in db: OpaquePointer) -> Bool {
        let query = "SELECT count(*) FROM sqlite_master WHERE type='table' AND name=?;"
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            return false
        }
        defer {
            sqlite3_finalize(statement)
        }
        
        guard sqlite3_bind_text(statement, 1, tableName, -1, nil) == SQLITE_OK else {
            return false
        }
        
        guard sqlite3_step(statement) == SQLITE_ROW else {
            return false
        }
        
        return sqlite3_column_int(statement, 0) != 0
    }
    
    static func createSitesTable(in db: OpaquePointer) {
        let createTableSQL = """
        CREATE TABLE IF NOT EXISTS Sites (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            siteID TEXT,
            name TEXT,
            details TEXT,
            lat REAL,
            lon REAL
        );
        """
        
        if sqlite3_exec(db, createTableSQL, nil, nil, nil) != SQLITE_OK {
            fatalError("Unable to create Sites table.")
        }
    }
    
    static func createChargersTable(in db: OpaquePointer) {
        let createTableSQL = """
        CREATE TABLE IF NOT EXISTS Chargers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            siteID INTEGER,
            chargerID TEXT,
            name TEXT,
            FOREIGN KEY (siteID) REFERENCES Sites(id)
        );
        """
        
        if sqlite3_exec(db, createTableSQL, nil, nil, nil) != SQLITE_OK {
            fatalError("Unable to create Chargers table.")
        }
    }
    
    static func createEvsesTable(in db: OpaquePointer) {
        let createTableSQL = """
        CREATE TABLE IF NOT EXISTS Evses (
            id INTEGER PRIMARY KEY,
            chargerID INTEGER,
            code TEXT,
            FOREIGN KEY (chargerID) REFERENCES Chargers(id)
        );
        """
        
        if sqlite3_exec(db, createTableSQL, nil, nil, nil) != SQLITE_OK {
            fatalError("Unable to create Evses table.")
        }
    }
    
    static func createConnectorsTable(in db: OpaquePointer) {
        let createTableSQL = """
        CREATE TABLE IF NOT EXISTS Connectors (
            id INTEGER PRIMARY KEY,
            evseID INTEGER,
            status INTEGER,
            power INTEGER,
            FOREIGN KEY (evseID) REFERENCES Evses(id)
        );
        """
        
        if sqlite3_exec(db, createTableSQL, nil, nil, nil) != SQLITE_OK {
            fatalError("Unable to create Connectors table.")
        }
    }
}

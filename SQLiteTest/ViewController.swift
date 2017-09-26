//
//  ViewController.swift
//  SQLiteTest
//
//  Created by Lukas Mohs on 26.09.17.
//  Copyright © 2017 Lukas Mohs. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    
    let dbPath: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = openDatabase()
        
        let createTableString = " CREATE TABLE Information( Id INTEGER PRIMARY KEY AUTOINCREMENT, Title CHAR(255), Details CHAR(255));"
        createTable(db: db, createTableString: createTableString)
        
        let insertStatementString = "INSERT INTO Information (Title, Details) VALUES (?, ?);"
        insert(db: db, insertStatementString: insertStatementString)
        
        let queryStatementString = "SELECT * FROM Information;"
        query(db: db, queryStatementString: queryStatementString)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
        } else {
            print("Unable to open database.")
        }
        return db
    }
    
func createTable(db: OpaquePointer?, createTableString: String) {
    var createTableStatement: OpaquePointer? = nil
    if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK && sqlite3_step(createTableStatement) == SQLITE_DONE {
        print("Contact table created.")
    } else {
        print("CREATE TABLE statement could not be executed.")
    }
    sqlite3_finalize(createTableStatement)
}
    
    func insert(db: OpaquePointer?, insertStatementString: String ) {
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            let title: NSString = "TUM"
            let details: NSString = "all the way up"
            sqlite3_bind_text(insertStatement, 1,  title.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, details.utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func query(db: OpaquePointer?, queryStatementString:String) {
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let title = String(cString: queryResultCol1!)
                let queryResultCol2 = sqlite3_column_text(queryStatement, 2)
                let details = String(cString: queryResultCol2!)
                print("Query Result:")
                print("\(title) | \(details)")
            } else {
                print("Query returned no results")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
    }
}


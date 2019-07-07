//
//  FileNotebook.swift
//  Notes
//
//  Created by bagrusss on 30/06/2019.
//  Copyright © 2019 bagrusss. All rights reserved.
//

import Foundation

public class FileNotebook {
    
    private let NOTES_DIR = "notes"
    private let NOTES_FILE = "notes.json"
    
    private(set) public var notes: [String:Note]
    
    init() {
        notes = [String:Note]()
    }
    
    public func add(_ note: Note) {
        if notes[note.uid] == nil {
            notes[note.uid] = note
        }
    }
    
    public func remove(with uid: String) {
        notes[uid] = nil
    }
    
    public func saveToFile() {
        let fileManager = FileManager.default
        let path = filePath(fileManager)

        var isDir: ObjCBool = false
        if !fileManager.fileExists(atPath: path.path, isDirectory: &isDir) {
            fileManager.createFile(atPath: path.path, contents: nil, attributes: nil)
        }
        
        
        let jsonNotes = notes.map { $1.json }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonNotes, options: .prettyPrinted)
            try jsonData.write(to: path)
        } catch {
            print("Ooops, something went wring")
        }
    }
    
    public func loadFromFile() {
        let fileManager = FileManager.default
        let path = filePath(fileManager)
        guard fileManager.fileExists(atPath: path.path) else {
            notes = [String:Note]()
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path.path), options: .mappedIfSafe)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let dicts = json as? [[String:Any]] ?? [[String:Any]]()
            notes = [String:Note]()
            dicts.forEach {
                if let note = Note.parse(json: $0) {
                    notes[note.uid] = note
                }
            }
        } catch {
            print("Ooops, something went wring")
        }
    }
    
    private func filePath(_ fileManager: FileManager) -> URL {
        var path = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        path.appendPathComponent(NOTES_DIR, isDirectory: true)
        path.appendPathComponent(NOTES_FILE)
        return path
    }
    
}

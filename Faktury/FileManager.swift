////  FileManager.swift
//  Faktury
//
//  Created by Pawel Stachurski on 6/2/20.
//  Copyright © 2020 DKSH . All rights reserved.
//

import UIKit

extension FileManager {
    class func getDocumentDirectoryFileURL(with filename: String) -> URL? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        let destFileURL = documentsURL.appendingPathComponent(filename)
        return destFileURL
    }
    
    class func doesFileExist(at path: String) -> Bool {
        var updatedPath = path.replacingOccurrences(of: "file://", with: "")
        return FileManager.default.fileExists(atPath: updatedPath)
    }
}

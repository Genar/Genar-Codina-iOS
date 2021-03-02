//
//  StringExtension.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 20/2/21.
//

import Foundation

extension String {

    func slice(from: String, to: String) -> String? {

        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

extension String {

    var localized: String {
        
        return NSLocalizedString(self, comment: "\(self)_comment")
    }

    func localized(_ args: CVarArg...) -> String {
        
        return String(format: localized, args)
    }
}

extension String {
    
    func numberOfOccurrencesOf(string: String) -> Int {
        
        return self.components(separatedBy:string).count - 1
    }
}

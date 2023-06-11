//
//  IntExtensions.swift
//  NASA Image Searcher
//
//  Created by Adam Zuspan on 6/8/23.
//

import Foundation

extension Int {
    func maxPageCount() -> Int {
        return Int(ceil(Double(self) / 100.0))
    }
}

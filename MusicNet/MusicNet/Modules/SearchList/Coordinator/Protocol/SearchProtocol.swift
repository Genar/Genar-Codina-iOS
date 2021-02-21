//
//  DetailProtocol.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 20/2/21.
//

import Foundation

protocol SearchProtocol: AnyObject {
    
    func showDetail(itemIdx: Int)
    
    func setAccessTokenIfNecessary()
}

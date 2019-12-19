//
//  GridViewModel.swift
//  Instagrid
//
//  Created by axel leydier on 04/09/2019.
//  Copyright © 2019 axelleydier. All rights reserved.
//

import Foundation

protocol GridDelegate: class {
    func didSelect(spot: Spot)
}

enum Spot: Int, CaseIterable {
    case top = 0
    case topLeft = 1
    case topRight = 2
    case bottomLeft = 3
    case bottomRight = 4
    case bottom = 5
}

final class GridViewModel {
    
    // MARK: - Outputs
    
    var selectedSpot: ((Spot) -> Void)?
    
    // MARK: - Intputs
    
    func didSelectSpot(at index: Int) {
        guard let spot = Spot(rawValue: index) else {return}
        selectedSpot?(spot)
    }
}

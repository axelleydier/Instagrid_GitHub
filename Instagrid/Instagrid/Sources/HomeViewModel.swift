//
//  HomeViewModel.swift
//  Instagrid
//
//  Created by axel leydier on 26/08/2019.
//  Copyright © 2019 axelleydier. All rights reserved.
//

import Foundation

final class HomeViewModel {

    enum GridConfiguration {
        case firstGrid
        case secondGrid
        case thirdGrid
    }
    
    // MARK: - Outputs

    var titleText: ((String) -> Void)?
    
    var directionText: ((String) -> Void)?
    
    var swipeText: ((String) -> Void)?
    
    var selectedConfiguration: ((GridConfiguration) -> Void)?

    // MARK: - Inputs

    func viewDidLoad() {
        titleText?("Instagrid")
        directionText?("^")
        swipeText?("Swipe up to share")
        selectedConfiguration?(.firstGrid)
    }

    func didPressFirstGrid() {
        selectedConfiguration?(.firstGrid)
        
    }
    
    func didPressSecondGrid() {
        selectedConfiguration?(.secondGrid)
    }
    
    func didPressThirdGrid() {
        selectedConfiguration?(.thirdGrid)
    }

    func didChangeToCompact() {
        directionText?("^")
        swipeText?("Swipe up to share")
    }

    func didChangeToRegular() {
        directionText?("<")
        swipeText?("Swipe left to share")
    }
}

//
//  ThirdGrid.swift
//  Instagrid
//
//  Created by axel leydier on 03/09/2019.
//  Copyright © 2019 axelleydier. All rights reserved.
//

import UIKit

final class ThirdGrid: UIView, GridType {
    
    // MARK: - Outlets

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topLeftView: UIView!
    @IBOutlet weak var topLeftButton: UIButton!
    @IBOutlet weak var topRightView: UIView!
    @IBOutlet weak var topRightButton: UIButton!
    @IBOutlet weak var bottomLeftView: UIView!
    @IBOutlet weak var bottomLeftButton: UIButton!
    @IBOutlet weak var bottomRightView: UIView!
    @IBOutlet weak var bottomRightButton: UIButton!
    
    // MARK: - Private properties
    
    private var viewModel: GridViewModel!
    private weak var delegate: GridDelegate?
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        Bundle(for: type(of: self)).loadNibNamed(String(describing: ThirdGrid.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func configure(with viewModel: GridViewModel, delegate: GridDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        // ici gérer le delegate
        bind(to: self.viewModel)
    }
    
    func set(image: UIImage, for spot: Spot) {
        let imageView = UIImageView(image: image)
        switch spot {
        case .topLeft:
            topLeftView.subviews.forEach { view in
                if let _ = view as? UIButton {
                    return
                }
                view.removeFromSuperview()
            }
            imageView.frame = topLeftView.bounds
            topLeftView.addSubview(imageView)
        case .topRight:
            topRightView.subviews.forEach { view2 in
                if let _ = view2 as? UIButton {
                    return
                }
                view2.removeFromSuperview()
            }
            imageView.frame = topRightView.bounds
            topRightView.addSubview(imageView)
        case .bottomLeft:
            bottomLeftView.subviews.forEach { view3 in
                if let _ = view3 as? UIButton {
                    return
                }
                view3.removeFromSuperview()
            }
            imageView.frame = bottomLeftView.bounds
            bottomLeftView.addSubview(imageView)
        case .bottomRight:
            bottomRightView.subviews.forEach { view4 in
                if let _ = view4 as? UIButton {
                    return
                }
                view4.removeFromSuperview()
            }
            imageView.frame = bottomRightView.bounds
            bottomRightView.addSubview(imageView)
        default:
            break
        }
    }
    
    private func bind(to viewModel: GridViewModel) {
        viewModel.selectedSpot = { [weak self] spot in
            self?.delegate?.didSelect(spot: spot)
        }
    }
    @IBAction func selectedSpot(_ sender: UIButton) {
        viewModel.didSelectSpot(at: sender.tag)
    }
}

//
//  HomeViewController.swift
//  Instagrid
//
//  Created by axel leydier on 23/08/2019.
//  Copyright © 2019 axelleydier. All rights reserved.
//

import UIKit

protocol GridType: class {
    func set(image: UIImage, for spot: Spot)
    func configure(with viewModelType: GridViewModel, delegate: GridDelegate)
}

final class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var swipeArrowLabel: UILabel!
    @IBOutlet weak var swipeTextLabel: UILabel!
    
    @IBOutlet private weak var firstGridButton: UIButton!
    @IBOutlet private weak var secondGridButton: UIButton!
    @IBOutlet private weak var thirdGridButton: UIButton!
    
    private lazy var leftSwipeGestureRecognizer: UISwipeGestureRecognizer = {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(executeSwipeAction(_:)))
        swipeGesture.direction = .left
        return swipeGesture
    }()
    
    private lazy var upSwipeGestureRecognizer: UISwipeGestureRecognizer = {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(executeSwipeAction(_:)))
        swipeGesture.direction = .up
        return swipeGesture
    }()
    
    @objc func executeSwipeAction(_ sender: UISwipeGestureRecognizer) {
        
        UIView.transition(with: contentView,
                          duration: 1,
                          options: sender.direction == .left ? [.transitionFlipFromLeft] : [.transitionCurlUp],
                          animations: {},
                          completion: { _ in
                            self.sharePicture()
        })
    }
    
    func sharePicture() {
        UIGraphicsBeginImageContext(contentView.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        contentView.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let _image = image else { return }
        let activityViewController = UIActivityViewController(activityItems: [_image], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {_, isDismissed, _, _ in
            if isDismissed {
                print("Coucou Axel")
            }
        }
        
        DispatchQueue.main.async {
            self.show(activityViewController, sender: nil)
        }
    }
    
    private let viewModel = HomeViewModel()
    
    private lazy var pickerController: UIImagePickerController = {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = false
        return pickerController
    }()
    
    private var currentGrid: GridType? {
        didSet {
            let viewModel = GridViewModel()
            self.currentGrid?.configure(with: viewModel, delegate: self)
        }
    }
    
    private var currentSpot: Spot?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    private func bind(to viewModel: HomeViewModel) {
        viewModel.titleText = { [weak self] text in
            self?.titleLabel.text = text
        }
        
        viewModel.directionText = { [weak self] text in
            self?.swipeArrowLabel.text = text
        }
        
        viewModel.swipeText = { [weak self] text in
            self?.swipeTextLabel.text = text
        }
        
        viewModel.selectedConfiguration = { [weak self] choice in
            guard let self = self else {return}
            switch choice {
            case .firstGrid:
                let grid = FirstGrid()
                self.configureContainer(for: grid)
            case .secondGrid:
                let grid2 = SecondGrid()
                self.configureContainer(for: grid2)
            case .thirdGrid:
                let grid3 = ThirdGrid()
                self.configureContainer(for: grid3)
            }
        }
    }
    
    private func configureContainer(for grid: GridType) {
        self.currentGrid = grid
        guard let gridView = grid as? UIView else { return }
        self.contentView.subviews.forEach { $0.removeFromSuperview() }
        self.contentView.layoutIfNeeded()
        self.contentView.addSubview(gridView)
        self.makeConstraints(for: gridView, with: contentView)
    }
    
    private func makeConstraints(for view1: UIView, with view2: UIView) {
        view1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view1.topAnchor.constraint(equalTo: view2.topAnchor),
            view1.bottomAnchor.constraint(equalTo: view2.bottomAnchor),
            view1.leftAnchor.constraint(equalTo: view2.leftAnchor),
            view1.rightAnchor.constraint(equalTo: view2.rightAnchor)
        ])
    }
    @IBAction func didPressFirstGridButton(_ sender: UIButton) {
        viewModel.didPressFirstGrid()
    }
    
    @IBAction func didPressSecondGridButton(_ sender: UIButton) {
        viewModel.didPressSecondGrid()
    }
    
    @IBAction func didPressThirdGridButton(_ sender: UIButton) {
        viewModel.didPressThirdGrid()
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        contentView.gestureRecognizers?.removeAll()
        if traitCollection.horizontalSizeClass == .compact {
            contentView.addGestureRecognizer(upSwipeGestureRecognizer)
            viewModel.didChangeToCompact()
        } else {
            contentView.addGestureRecognizer(leftSwipeGestureRecognizer)
            viewModel.didChangeToRegular()
        }
    }
}

// MARK: - GridDelagate
extension HomeViewController: GridDelegate {
    func didSelect(spot: Spot) {
        currentSpot = spot
        DispatchQueue.main.async {
            self.show(self.pickerController, sender: nil)
        }
    }
}
extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // ICI
    
    // Indice, dans la methode tu devras donc appeler
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let spot = self.currentSpot {
                self.currentGrid?.set(image: image, for: spot)
            }
        })
    }
}

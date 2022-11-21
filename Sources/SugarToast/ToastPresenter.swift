//
//  ToastPresenter.swift
//  
//  MIT License
//
//  Copyright (c) 2022 Tigran Gishyan
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

enum ToastPosition {
    case top
    case bottom
}

class ToastPresenter: UIViewController {
    
    var toastContainerView: UIView!
    var presentingView: ToastPresentable!
    
    var toastViewConstraint: NSLayoutConstraint!
    var updateToastViewWorkItem: DispatchWorkItem?
    
    public var position: ToastPosition = .bottom
    public var autohideDuration: Double = 3
    public var verticalPaddings: CGFloat = 8
    public var horizontalPaddings: CGFloat = 16
    var closeAction: (() -> Void)?
    
    init(with view: ToastPresentable & UIView) {
        super.init(nibName: nil, bundle: nil)
        
        presentingView = view
        view.toastPresenter = self
        
        commonInit()
    }
    
    init(with viewController: ToastPresentable & UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.presentingView = viewController
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        initToastContaineriew()
        constraintHierarchy()
        activateConstraints()
        showToastView()
        
        updateToastViewWorkItem?.cancel()
        updateToastViewWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            
            self.dismiss(animated: true)
        }
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + autohideDuration,
            execute: updateToastViewWorkItem!
        )
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        view.addGestureRecognizer(tap)
    }
    
    @objc
    private func didTapBackground() {
        guard presentingView.shouldDismissOnTap() else { return }
        
        self.view.endEditing(true)
        self.dismiss(animated: true)
    }
    
    func showToastView() {
        
        switch position {
        case .top:
            toastViewConstraint = presentingView.view.topAnchor.constraint(equalTo: view.topAnchor)
            toastViewConstraint.isActive = true
            view.layoutIfNeeded()
            
            toastViewConstraint.constant = -presentingView.view.bounds.height
            view.layoutIfNeeded()
            
            toastViewConstraint.constant = view.safeAreaInsets.top + verticalPaddings
        case .bottom:
            toastViewConstraint = presentingView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            toastViewConstraint.isActive = true
            view.layoutIfNeeded()
            
            toastViewConstraint.constant = presentingView.view.bounds.height
            view.layoutIfNeeded()
            
            toastViewConstraint.constant = view.safeAreaInsets.bottom - verticalPaddings
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.7) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        switch position {
        case .top:
            toastViewConstraint.constant = -presentingView.view.bounds.height
        case .bottom:
            toastViewConstraint.constant = presentingView.view.bounds.height
        }
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.7,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0
        ) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            super.dismiss(animated: false, completion: completion)
            self.closeAction?()
        }
    }
}
// MARK: - Layout
private extension ToastPresenter {
    func initToastContaineriew() {
        toastContainerView = UIView()
        toastContainerView.translatesAutoresizingMaskIntoConstraints = false
        presentingView.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constraintHierarchy() {
        view.addSubview(toastContainerView)
        toastContainerView.addSubview(presentingView.view)
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            presentingView.view.topAnchor.constraint(equalTo: toastContainerView.topAnchor),
            presentingView.view.leadingAnchor.constraint(equalTo: toastContainerView.leadingAnchor),
            presentingView.view.trailingAnchor.constraint(equalTo: toastContainerView.trailingAnchor),
            presentingView.view.bottomAnchor.constraint(equalTo: toastContainerView.bottomAnchor),
            
            toastContainerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: horizontalPaddings
            ),
            toastContainerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -horizontalPaddings
            )
        ])
    }
}

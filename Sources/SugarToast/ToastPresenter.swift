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

public enum ToastPosition {
    case top
    case bottom
}

/// View Controller that shows toast
public class ToastPresenter: UIViewController {
    
    var customView: TouchDelegatingView!
    var toastContainerView: UIView!
    var presentingView: ToastPresentable!
    
    var toastViewConstraint: NSLayoutConstraint!
    var updateToastViewWorkItem: DispatchWorkItem?
    
    public var closeAction: (() -> Void)?
    
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
        self.modalTransitionStyle = .crossDissolve
    }
    
    public override func loadView() {
        customView = TouchDelegatingView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height
            )
        )
        self.view = customView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
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
            deadline: .now() + presentingView.autohideDuration,
            execute: updateToastViewWorkItem!
        )
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let delegatingView = view as? TouchDelegatingView {
            delegatingView.touchDelegate = presentingViewController?.view
        }
    }
    
    @objc
    private func didTapBackground() {
        guard presentingView.shouldDismissOnTap() else { return }
        
        self.view.endEditing(true)
        self.dismiss(animated: true)
    }
    
    func showToastView() {
        
        switch presentingView.position {
        case .top:
            toastViewConstraint = presentingView.view.topAnchor.constraint(equalTo: view.topAnchor)
            toastViewConstraint.isActive = true
            view.layoutIfNeeded()
            
            toastViewConstraint.constant = -presentingView.view.bounds.height
            view.layoutIfNeeded()
            
            toastViewConstraint.constant = view.safeAreaInsets.top + presentingView.verticalPaddings
        case .bottom:
            toastViewConstraint = presentingView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            toastViewConstraint.isActive = true
            view.layoutIfNeeded()
            
            toastViewConstraint.constant = presentingView.view.bounds.height
            view.layoutIfNeeded()
            
            toastViewConstraint.constant = view.safeAreaInsets.bottom - presentingView.verticalPaddings
        }
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.0
        ) {
            self.view.layoutIfNeeded()
        }
    }
    
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        switch presentingView.position {
        case .top:
            toastViewConstraint.constant = -presentingView.view.bounds.height
        case .bottom:
            toastViewConstraint.constant = presentingView.view.bounds.height
        }
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.0
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
                constant: presentingView.horizontalPaddings
            ),
            toastContainerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -presentingView.horizontalPaddings
            )
            
        ])
    }
}

extension ToastPresenter: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        return true
    }
}

class TouchDelegatingView: UIView {
    weak var touchDelegate: UIView? = nil
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            return touchDelegate?.hitTest(point, with: event)
        } else {
            return hitView
        }
    }
}

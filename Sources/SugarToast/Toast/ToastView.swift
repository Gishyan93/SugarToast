//
//  ToastView.swift
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

struct ToastViewContentSettings: ToastConfigurable {
    // Skeleton Properties
    var type: ToastType = .leadingPinnedImage
    var cornerRadius: CGFloat = 20
    var backgroundColor: UIColor = .systemBlue
    var shouldDismissOnTap: Bool = true
    var horizontalSpacing: CGFloat = 20
    var verticalSpacing: CGFloat = 4
    
    // Content Properties
    var titleFont: UIFont = .systemFont(ofSize: 16, weight: .medium)
    var titleColor: UIColor = .white
    var titleTextAlignment: NSTextAlignment = .left
    
    var subtitleFont: UIFont = .systemFont(ofSize: 12, weight: .regular)
    var subtitleColor: UIColor = .white
    var subtitleTextAlignment: NSTextAlignment = .left
    
    var verticalInsets: CGFloat = 32
    var horizontalInsets: CGFloat = 24
}

struct ToastViewData: ToastDataPassable {
    var image: UIImage?
    var title: String?
    var subtitle: String?
    var customView: UIView?
    
    init(image: UIImage, title: String, subtitle: String) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
    }
}

class ToastView: UIView, ToastPresentable {
    weak var toastPresenter: ToastPresenter?
    
    var mainStackView: UIStackView!
    var messagesStackView: UIStackView!
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var topConstraint: NSLayoutConstraint!
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
    
    private var _shouldDismissOnTap: Bool = true
    private(set) var _settings = ToastViewContentSettings() {
        didSet {
            initToastSkeleton()
        }
    }
    
    func shouldDismissOnTap() -> Bool { _shouldDismissOnTap }
    
    func set(data: ToastDataPassable) {
        guard
            let data = data as? ToastViewData
        else { fatalError("Couldn't cast to appropriate format") }
                
        if let image = data.image {
            imageView.image = image
        }
        
        if let title = data.title {
            titleLabel.text = title
        }
        
        if let subtitle = data.subtitle {
            subtitleLabel.text = subtitle
        }
    }
    
    func update(settings: ToastConfigurable) {
        guard
            let settings = settings as? ToastViewContentSettings
        else { fatalError("Couldn't cast to appropriate format") }
        _settings = settings
    }
    
}
// MARK: - Layout
private extension ToastView {
    func initToastSkeleton() {
        
        mainStackView = UIStackView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        messagesStackView = UIStackView()
        imageView = UIImageView()
        imageView.contentMode = .center
        titleLabel = UILabel()
        subtitleLabel = UILabel()
        
        mainStackView.axis = .horizontal
        messagesStackView.axis = .vertical
        
        constructHierarchy()
        activateConstraints()
        
        switch _settings.type {
        case .leadingPinnedImage:
            mainStackView.addArrangedSubview(imageView)
            mainStackView.addArrangedSubview(messagesStackView)
            messagesStackView.addArrangedSubview(titleLabel)
            messagesStackView.addArrangedSubview(subtitleLabel)
        case .centeredImage:
            mainStackView.addArrangedSubview(messagesStackView)
            messagesStackView.addArrangedSubview(imageView)
            messagesStackView.addArrangedSubview(titleLabel)
            messagesStackView.addArrangedSubview(subtitleLabel)
        case .trailingPinnedImage:
            mainStackView.addArrangedSubview(messagesStackView)
            mainStackView.addArrangedSubview(imageView)
            messagesStackView.addArrangedSubview(titleLabel)
            messagesStackView.addArrangedSubview(subtitleLabel)
        }
        
        clipsToBounds = true
        layer.cornerRadius = _settings.cornerRadius
        backgroundColor = _settings.backgroundColor
        
        mainStackView.spacing = _settings.horizontalSpacing
        messagesStackView.spacing = _settings.verticalSpacing
        
        topConstraint.constant = _settings.verticalInsets
        bottomConstraint.constant = -(_settings.verticalInsets)
        trailingConstraint.constant = -(_settings.horizontalInsets)
        leadingConstraint.constant = _settings.horizontalInsets
        
        titleLabel.textAlignment = _settings.titleTextAlignment
        titleLabel.font = _settings.titleFont
        titleLabel.textColor = _settings.titleColor
        
        subtitleLabel.textAlignment = _settings.subtitleTextAlignment
        subtitleLabel.font = _settings.subtitleFont
        subtitleLabel.textColor = _settings.subtitleColor
        
        _shouldDismissOnTap = _settings.shouldDismissOnTap
    }
    
    func constructHierarchy() {
        addSubview(mainStackView)
    }
    
    func activateConstraints() {
        topConstraint = mainStackView.topAnchor.constraint(equalTo: topAnchor)
        leadingConstraint = mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        trailingConstraint = mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        bottomConstraint = mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        NSLayoutConstraint.activate([topConstraint,
                                     leadingConstraint,
                                     trailingConstraint,
                                     bottomConstraint])
        
        imageView.setContentHuggingPriority(.init(800), for: .horizontal)
        imageView.setContentCompressionResistancePriority(.init(800), for: .horizontal)
    }
}

extension ToastView {
    static func presenter(
        forAlertWithData data: ToastDataPassable,
        with settings: ToastConfigurable
    ) -> ToastPresenter {
        let toastView = ToastView()
        toastView.update(settings: settings)
        toastView.set(data: data)
        return toastView.presenter
    }
    
    static func presenter(
        forAlertWithData data: ToastDataPassable
    ) -> ToastPresenter {
        let toastView = ToastView()
        toastView.set(data: data)
        return toastView.presenter
    }
}

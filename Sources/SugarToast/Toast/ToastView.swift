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

public struct ToastAppearance: ToastAppearanceConfigurable {
    public var position: ToastPosition
    public var autohideDuration: Double
    public var verticalPaddings: CGFloat
    public var horizontalPaddings: CGFloat
    
    public init() {
        self.position = .bottom
        self.autohideDuration = 3.0
        self.verticalPaddings = 8.0
        self.horizontalPaddings = 16.0
    }
}

public struct ToastSettings: ToastConfigurable {
    
    // Skeleton Properties
    public var type: ToastType
    public var cornerRadius: CGFloat
    public var backgroundColor: UIColor
    public var shouldDismissOnTap: Bool
    public var horizontalSpacing: CGFloat
    public var verticalSpacing: CGFloat
    
    // Content Properties
    public var titleFont: UIFont
    public var titleColor: UIColor
    public var titleTextAlignment: NSTextAlignment
    
    public var subtitleFont: UIFont
    public var subtitleColor: UIColor
    public var subtitleTextAlignment: NSTextAlignment
    
    public var verticalInsets: CGFloat
    public var horizontalInsets: CGFloat
    
    public init() {
        self.type = .leadingPinnedImage
        self.cornerRadius = 20.0
        self.backgroundColor = .systemBlue
        self.shouldDismissOnTap = true
        self.horizontalSpacing = 20.0
        self.verticalSpacing = 4.0
        self.titleFont = .systemFont(ofSize: 16, weight: .medium)
        self.titleColor = .white
        self.titleTextAlignment = .left
        self.subtitleFont = .systemFont(ofSize: 12, weight: .regular)
        self.subtitleColor = .white
        self.subtitleTextAlignment = .left
        self.verticalInsets = 32.0
        self.horizontalInsets = 24.0
    }
}

public struct ToastViewData: ToastDataPassable {
    public var image: UIImage?
    public var title: String?
    public var subtitle: String?
    public var customView: UIView?
    
    public init(image: UIImage, title: String, subtitle: String) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
    }
    
    public init(image: UIImage, title: String) {
        self.image = image
        self.title = title
    }
    
    public init(title: String) {
        self.title = title
    }
    
    public init() {
        self.image = nil
        self.title = nil
        self.subtitle = nil
    }
}

public final class ToastView: UIView, ToastPresentable {
    
    weak public var toastPresenter: ToastPresenter?
    public var position: ToastPosition = .bottom
    public var autohideDuration: Double = 3.0
    public var verticalPaddings: CGFloat = 8.0
    public var horizontalPaddings: CGFloat = 16.0
    
    var mainStackView: UIStackView!
    var messagesStackView: UIStackView!
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var topConstraint: NSLayoutConstraint!
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
    var isSkeletorSet: Bool = false
        
    private var _shouldDismissOnTap: Bool = true
    private var _position: ToastPosition = .bottom
    private(set) var _settings = ToastSettings() {
        didSet {
            initToastSkeleton()
        }
    }
    private(set) var _appearance = ToastAppearance() {
        didSet {
            initAppearanca()
        }
    }
    private(set) var _data = ToastViewData() {
        didSet {
            if !isSkeletorSet {
                initToastSkeleton()
                isSkeletorSet = true
            }
            
            if let image = _data.image {
                imageView.image = image
            }
            
            if let title = _data.title {
                titleLabel.text = title
            }
            
            if let subtitle = _data.subtitle {
                subtitleLabel.text = subtitle
            }
        }
    }
    
    public func shouldDismissOnTap() -> Bool { _shouldDismissOnTap }
    
    func set(data: ToastDataPassable) {
        guard
            let data = data as? ToastViewData
        else { fatalError("Couldn't cast to appropriate format") }
                
        _data = data
    }
    
    func update(settings: ToastConfigurable) {
        guard
            let settings = settings as? ToastSettings
        else { fatalError("Couldn't cast to ToastSettings") }
        _settings = settings
    }
    
    func update(appearance: ToastAppearanceConfigurable) {
        guard
            let appearance = appearance as? ToastAppearance
        else { fatalError("Couldn't cast to ToastAppearance") }
        _appearance = appearance
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
    
    func initAppearanca() {
        position = _appearance.position
        autohideDuration = _appearance.autohideDuration
        horizontalPaddings = _appearance.horizontalPaddings
        verticalPaddings = _appearance.verticalPaddings
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
    public static func presenter(
        forAlertWithData data: ToastDataPassable
    ) -> ToastPresenter {
        let toastView = ToastView()
        let settings = ToastSettings()
        toastView.update(settings: settings)
        toastView.set(data: data)
        return toastView.presenter
    }
    
    public static func presenter(
        forAlertWithData data: ToastDataPassable,
        settings: ToastConfigurable
    ) -> ToastPresenter {
        let toastView = ToastView()
        toastView.update(settings: settings)
        toastView.set(data: data)
        return toastView.presenter
    }
    
    public static func presenter(
        forAlertWithData data: ToastDataPassable,
        appearance: ToastAppearanceConfigurable
    ) -> ToastPresenter {
        let toastView = ToastView()
        toastView.update(appearance: appearance)
        toastView.set(data: data)
        return toastView.presenter
    }
    
    public static func presenter(
        forAlertWithData data: ToastDataPassable,
        settings: ToastConfigurable,
        appearance: ToastAppearanceConfigurable
    ) -> ToastPresenter {
        let toastView = ToastView()
        toastView.update(settings: settings)
        toastView.update(appearance: appearance)
        toastView.set(data: data)
        return toastView.presenter
    }
}

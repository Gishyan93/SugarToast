//
//  ToastConfigurable.swift
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

public enum ToastType {
    case leadingPinnedImage
    case trailingPinnedImage
    case centeredImage
}

public protocol ToastSkeletonConfigurable {
    var type: ToastType { get set }
    var cornerRadius: CGFloat { get set }
    var backgroundColor: UIColor { get set }
    var horizontalSpacing: CGFloat { get set }
    var verticalSpacing: CGFloat { get set }
    var shouldDismissOnTap: Bool { get set }
}

public protocol ToastContentConfigurable {
    var titleFont: UIFont { get set }
    var titleColor: UIColor { get set }
    var titleTextAlignment: NSTextAlignment { get set }
    
    var subtitleFont: UIFont { get set }
    var subtitleColor: UIColor { get set }
    var subtitleTextAlignment: NSTextAlignment { get set }
        
    var verticalInsets: CGFloat { get set }
    var horizontalInsets: CGFloat { get set }
}

typealias ToastConfigurable = ToastSkeletonConfigurable & ToastContentConfigurable

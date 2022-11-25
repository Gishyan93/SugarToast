//
//  ViewController.swift
//  SampleApp
//
//  Created by Tigran Gishyan on 24.11.22.
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
import SugarToast

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataSource = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Examples"
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        
        dataSource.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }


    func createToast(with option: Option) {
        switch option {
        case .simple:
            createSimpleToast()
        case .duration:
            createToastWithLongDuration()
        case .title:
            createToastWithCustomTitle()
        case .centeredImage:
            createToastWithCenteredImage()
        case .completion:
            createToastWithCompletion()
        case .custom:
            createCustomizedToast()
        }
    }
    
    func createSimpleToast() {
        let data = ToastViewData(image: UIImage(named: "info")!,
                                 title: "Sugar Title",
                                 subtitle: "Sugar Subtitle")
                    
        let presenter = ToastView.presenter(forAlertWithData: data)
        present(presenter, animated: true)
    }
    
    func createToastWithLongDuration() {
        let data = ToastViewData(image: UIImage(named: "info")!,
                                 title: "Sugar Title",
                                 subtitle: "Sugar Subtitle")
                    
        let presenter = ToastView.presenter(forAlertWithData: data)
        presenter.autohideDuration = 10
        present(presenter, animated: true)
    }
    
    func createToastWithCustomTitle() {
        let data = ToastViewData(image: UIImage(named: "info")!,
                                 title: "Sugar Title")
                    
        var config = ToastSettings()
        config.titleFont = .systemFont(ofSize: 24, weight: .heavy)
        let presenter = ToastView.presenter(forAlertWithData: data, with: config)
        present(presenter, animated: true)
    }
    
    func createToastWithCenteredImage() {
        let data = ToastViewData(image: UIImage(named: "info")!,
                                 title: "Sugar Title")
                    
        var config = ToastSettings()
        config.type = .centeredImage
        config.titleTextAlignment = .center
        let presenter = ToastView.presenter(forAlertWithData: data, with: config)
        present(presenter, animated: true)
    }
    
    func createToastWithCompletion() {
        let data = ToastViewData(image: UIImage(named: "info")!,
                                 title: "Sugar Title")
                    
        let presenter = ToastView.presenter(forAlertWithData: data)
        presenter.closeAction = { [weak self] in
            print("Your business flow here...")
        }
        present(presenter, animated: true)
    }
    
    func createCustomizedToast() {
        let data = ToastViewData(image: UIImage(named: "info")!,
                                 title: "Sugar Title",
                                 subtitle: "Sugar Subtitle")
        
        var config = ToastSettings()
        config.type = .trailingPinnedImage
        config.titleTextAlignment = .center
        config.subtitleTextAlignment = .center
        config.backgroundColor = .systemGreen
        config.verticalSpacing = 30
        config.horizontalSpacing = 15
        config.cornerRadius = 0
        
        let presenter = ToastView.presenter(forAlertWithData: data, with: config)
        presenter.position = .top
        presenter.autohideDuration = 5
        presenter.verticalPaddings = 0
        presenter.horizontalPaddings = 0
        
        present(presenter, animated: true)
    }
}


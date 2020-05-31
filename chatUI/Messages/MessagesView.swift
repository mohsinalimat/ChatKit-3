//
//  MessagesView.swift
//  chatUI
//
//  Created Faris Albalawi on 4/17/20.
//  Copyright © 2020 Faris Albalawi. All rights reserved.


import UIKit


class MessagesView: UIViewController {
    
    private var ui = MessagesUI()
    var viewModel = MessagesViewModel()

    override func viewWillDisappear(_ animated: Bool) {
        view.layoutIfNeeded()
    }
    override func viewWillAppear(_ animated: Bool) {
        view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
       
    }
    
    override func loadView() {
        ui.parentViewController = self
        view = ui
        setNavigationBar()
    }
    

    

    func setNavigationBar() {
        navigationItem.title = "Messages"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.tintColor = .systemBackground
    }
    
}



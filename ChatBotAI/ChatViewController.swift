//
//  ViewController.swift
//  ChatBotAI
//
//  Created by Mahmudul Hasan on 14/12/22.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    private let inputField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type here..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .link
        textField.textColor = .white
        textField.returnKeyType = .done
        return textField
    }()
    private let table : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    private var models = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(inputField)
        view.addSubview(table)
        inputField.delegate = self
        table.delegate = self
        table.dataSource = self
        NSLayoutConstraint.activate([
            //text Field
            inputField.heightAnchor.constraint(equalToConstant: 50),
            inputField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            inputField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            inputField.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            
            //Table
            table.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            table.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.bottomAnchor.constraint(equalTo: inputField.topAnchor)
        ])
       
    }
    

    //TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell" , for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text , !text.isEmpty {
            models.append(text)
            APICaller.shared.getResponse(input: text) {[weak self] result in
                switch result {
                case .success(let output):
                    self?.models.append(output)
                    DispatchQueue.main.async {
                        self?.table.reloadData()
                        self?.inputField.text = nil
    
                    }
                case .failure:
                    print("Failed")
                }
            }
        }
        return true
    }
    
}




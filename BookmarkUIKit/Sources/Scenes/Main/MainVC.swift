//
//  MainViewController.swift
//  BookmarkUIKit
//
//  Created by Bekzat Batyrkhanov on 15.02.2024.
//

import UIKit

class MainVC: UIViewController {
    
    var bookmarkArray: [BookmarkModel] = [
        BookmarkModel(title: "YouTube", url: URL(string: "https://www.youtube.com")!),
        BookmarkModel(title: "FaceBook", url: URL(string: "https://www.facebook.com/?locale=ru_RU")!)
    ]
    
    var titleLabel: UILabel?
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    // MARK: - Actions
    
    func addBookmark(bookmark: BookmarkModel) {
        bookmarkArray.append(bookmark)
    }
    
    @objc private func addButtonTapped() {
        let alert = UIAlertController(title: "Add Bookmark", message: nil , preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Bookmart title"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Bookmark link"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            guard let self else { return }
            if let titleTextField = alert.textFields?[0].text,
               let linkTextField = alert.textFields?[1].text,
               !titleTextField.isEmpty, !linkTextField.isEmpty {
                let bookmark = BookmarkModel(title: titleTextField, url: URL(string: linkTextField)!)
                self.addBookmark(bookmark: bookmark)

                titleLabel?.removeFromSuperview()
                titleLabel = nil

                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true)
    }
    
    // MARK: - UI
    private func configUI() {
        title = "List"
        view.backgroundColor = .white
        
        let addBookmarButton = UIButton()
        addBookmarButton.setTitle("Add bookmark", for: .normal)
        addBookmarButton.setTitleColor(.white, for: .normal)
        addBookmarButton.backgroundColor = .black
        addBookmarButton.layer.cornerRadius = 16
        addBookmarButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        view.addSubview(addBookmarButton)
        addBookmarButton.snp.makeConstraints {
            $0.size.equalTo(BookmarUIKitConstants.buttonSize)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        tableView = UITableView()
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.register(BookmarkCell.self, forCellReuseIdentifier: "BookmarkCell")
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.bottom.equalTo(addBookmarButton.snp.top)
            $0.width.equalToSuperview()
        }
    }
}

// MARK: - TableView

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookmarkArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCell") as! BookmarkCell
        cell.set(bookmark: bookmarkArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { deleteAction, view, completionHandler in
            self.bookmarkArray.remove(at: indexPath.row)
            self.didRemoveRowTableView()
            completionHandler(true)
        }
        
        let changeAction = UIContextualAction(style: .normal, title: "Change") { action, view,
            completionHandler in
            self.didChangeRowTableView(indexPath: indexPath)
            completionHandler(true)
        }
        
        changeAction.backgroundColor = .blue
        
        let configuration = UISwipeActionsConfiguration(actions: [changeAction, deleteAction])
        
        return configuration
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let url = bookmarkArray[indexPath.row].url, UIApplication.shared.canOpenURL(url) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                showAlert(message: "URL cannot be opened")
            }
        } else {
            showAlert(message: "Invalid URL")
        }
        
        func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    private func didRemoveRowTableView() {
        if bookmarkArray.isEmpty {
            titleLabel = UILabel()
            titleLabel?.text = "Save your first \n bookmark"
            titleLabel?.textColor = .black
            titleLabel?.font = UIFont.boldSystemFont(ofSize: 36)
            titleLabel?.numberOfLines = 2
            titleLabel?.textAlignment = .center
            
            titleLabel?.alpha = 0.0
            let scale: CGFloat = 0.65
            titleLabel?.transform = .init(scaleX: scale, y: scale)
            
            view.addSubview(titleLabel!)
            titleLabel?.snp.makeConstraints {
                $0.centerX.centerY.equalToSuperview()
            }
            
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           usingSpringWithDamping: 0.65,
                           initialSpringVelocity: 0.65,
                           options: .curveEaseOut) { [weak self] in
                self?.titleLabel?.alpha = 1.0
                self?.titleLabel?.transform = .identity
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            tableView.reloadData()
        }
    }
    
    private func didChangeRowTableView(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Change", message: nil , preferredStyle: .alert)
        
        alert.addTextField { [weak self] textField in
            guard let self else { return }
            textField.text = self.bookmarkArray[indexPath.row].title
        }
        alert.addTextField { [weak self] textField in
            guard let self else { return }
            textField.text = self.bookmarkArray[indexPath.row].url?.absoluteString
        }
        
        let changeAction = UIAlertAction(title: "Change", style: .default) { [weak self] action in
            guard let self else { return }
            
            if let titleTextField = alert.textFields?[0].text,
               let linkTextField = alert.textFields?[1].text,
               !titleTextField.isEmpty, !linkTextField.isEmpty {
                bookmarkArray[indexPath.row].title = titleTextField
                bookmarkArray[indexPath.row].url = URL(string: linkTextField)!
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(cancelAction)
        alert.addAction(changeAction)
        present(alert, animated: true)
    }
    
}

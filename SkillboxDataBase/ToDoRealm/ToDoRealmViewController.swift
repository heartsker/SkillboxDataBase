//
//  ToDoRealmViewController.swift
//  SkillboxDataBase
//
//  Created by Daniel Pustotin on 26.05.2021.
//

import UIKit

import RealmSwift

class ToDo: Object {
	@objc dynamic var text = String()
}

class ToDoRealmViewController: UIViewController, UITableViewDataSource {

	private let realm = try! Realm()

	private let table: UITableView = {
		let table = UITableView()
		table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		return table
	}()

	var todos = [ToDo]()

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "ToDo with Realm"

		view.addSubview(table)
		table.dataSource = self

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))

		for todo in realm.objects(ToDo.self) {
			todos.append(todo)
		}
		table.reloadData()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		table.frame = view.bounds
	}

	@objc private func didTapAdd() {
		let alert = UIAlertController(title: "New Item", message: "Enter new ToDo to add", preferredStyle: .alert)

		alert.addTextField(configurationHandler: { field in
			field.placeholder = "New ToDo"
		})

		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		alert.addAction(UIAlertAction(title: "Done", style: .default, handler: {[weak self] (_) in
			if let field = alert.textFields?.first {
				if let text = field.text, !text.isEmpty {
					DispatchQueue.main.async {

						let newToDo = ToDo()
						newToDo.text = text
						self?.todos.append(newToDo)

						try! self?.realm.write {
							self?.realm.add(newToDo)
						}

						self?.table.reloadData()
					}
				}
			}
		}))

		present(alert, animated: true)
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return todos.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

		cell.textLabel?.text = todos[indexPath.row].text
		return cell
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			try! realm.write {
				realm.delete(todos[indexPath.row])
			}
			todos.remove(at: indexPath.row)
			table.deleteRows(at: [indexPath], with: .bottom)
			table.reloadData()
		}
	}

}

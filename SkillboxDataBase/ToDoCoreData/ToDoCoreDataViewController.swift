//
//  ToDoCoreDataViewController.swift
//  SkillboxDataBase
//
//  Created by Daniel Pustotin on 26.05.2021.
//

import UIKit

class ToDoCoreDataViewController: UIViewController, UITableViewDataSource {

	private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

	private let table: UITableView = {
		let table = UITableView()
		table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		return table
	}()

	var todos = [ToDoListItem]()

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "ToDo with CoreData"

		view.addSubview(table)
		table.dataSource = self

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))

		fetchItems()
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

						// save new todo
						self?.createItem(text: text)
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
			deleteItem(item: todos[indexPath.row])
			todos.remove(at: indexPath.row)
			table.deleteRows(at: [indexPath], with: .bottom)
		}
	}

	func fetchItems() {
		do {
			todos = try context.fetch(ToDoListItem.fetchRequest())

			DispatchQueue.main.async {
				self.table.reloadData()
			}

		}
		catch let error as NSError {
			print(error)
		}
	}

	func createItem(text: String) {
		let newItem = ToDoListItem(context: context)
		newItem.text = text

		do {
			try context.save()
			fetchItems()
		}
		catch let error as NSError {
			print(error)
		}
	}

	func deleteItem(item: ToDoListItem) {
		context.delete(item)

		do {
			try context.save()
		}
		catch let error as NSError {
			print(error)
		}
	}

}

//
//  UsernameViewController.swift
//  SkillboxDataBase
//
//  Created by Daniel Pustotin on 25.05.2021.
//

import UIKit

class UsernameViewController: UIViewController {

	@IBOutlet weak var name: UITextField!
	@IBOutlet weak var surname: UITextField!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		name.placeholder = "Name"
		surname.placeholder =  "Surname"

		name.text = PersistanceUserDefaults.shared.name
		surname.text = PersistanceUserDefaults.shared.surname

		name.addTarget(self, action: #selector(saveUsername), for: .allEditingEvents)
		surname.addTarget(self, action: #selector(saveUsername), for: .allEditingEvents)
	}

	@objc func saveUsername() {
		PersistanceUserDefaults.shared.name = name.text
		PersistanceUserDefaults.shared.surname = surname.text
	}

}


//
//  PersistanceUserDefaults.swift
//  SkillboxDataBase
//
//  Created by Daniel Pustotin on 25.05.2021.
//

import Foundation

class PersistanceUserDefaults {
	static let shared = PersistanceUserDefaults()

	private let kNameKey = "PersistanceUserDefaults.kNameKey"
	private let kSurnameKey = "PersistanceUserDefaults.kSurnameKey"

	var name: String? {
		set { UserDefaults.standard.set(newValue, forKey: kNameKey) }
		get { return UserDefaults.standard.string(forKey: kNameKey) }
	}

	var surname: String? {
		set { UserDefaults.standard.set(newValue, forKey: kSurnameKey) }
		get { return UserDefaults.standard.string(forKey: kSurnameKey) }
	}
}

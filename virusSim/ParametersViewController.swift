//
//  ParametersViewController.swift
//  virusSim
//
//  Created by Danil Masnaviev on 27/03/24.
//

import Foundation
import UIKit

class ParametersViewController: UIViewController {
    
    let numberOfPeopleLabel = UILabel()
    let infectionFactorLabel = UILabel()
    let recalculationPeriodLabel = UILabel()
    
    let numberOfPeopleTextField = UITextField()
    let infectionFactorTextField = UITextField()
    let recalculationPeriodTextField = UITextField()
    let startButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Параметры"
        view.backgroundColor = .systemBackground
        
        setupUI()
    }
    
    func setupUI() {
        
        numberOfPeopleLabel.text = "Количество людей:"
        numberOfPeopleLabel.textColor = .gray
        
        infectionFactorLabel.text = "Infection Factor:"
        infectionFactorLabel.textColor = .gray
        
        recalculationPeriodLabel.text = "Период пересчета (секунды):"
        recalculationPeriodLabel.textColor = .gray
        
        numberOfPeopleTextField.text = "100"
        numberOfPeopleTextField.borderStyle = .roundedRect
        numberOfPeopleTextField.keyboardType = .numberPad
        
        infectionFactorTextField.text = "3"
        infectionFactorTextField.borderStyle = .roundedRect
        infectionFactorTextField.keyboardType = .numberPad
        
        recalculationPeriodTextField.text = "3"
        recalculationPeriodTextField.borderStyle = .roundedRect
        recalculationPeriodTextField.keyboardType = .numberPad
        
        startButton.setTitle("Запустить Моделирование", for: .normal)
        startButton.backgroundColor = .systemBlue
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 8
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        startButton.addTarget(self, action: #selector(startCalculation), for: .touchUpInside)
        
        numberOfPeopleLabel.translatesAutoresizingMaskIntoConstraints = false
        infectionFactorLabel.translatesAutoresizingMaskIntoConstraints = false
        recalculationPeriodLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfPeopleTextField.translatesAutoresizingMaskIntoConstraints = false
        infectionFactorTextField.translatesAutoresizingMaskIntoConstraints = false
        recalculationPeriodTextField.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(numberOfPeopleLabel)
        view.addSubview(infectionFactorLabel)
        view.addSubview(recalculationPeriodLabel)
        view.addSubview(numberOfPeopleTextField)
        view.addSubview(infectionFactorTextField)
        view.addSubview(recalculationPeriodTextField)
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            numberOfPeopleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            numberOfPeopleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            numberOfPeopleTextField.topAnchor.constraint(equalTo: numberOfPeopleLabel.bottomAnchor, constant: 8),
            numberOfPeopleTextField.leadingAnchor.constraint(equalTo: numberOfPeopleLabel.leadingAnchor),
            numberOfPeopleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            infectionFactorLabel.topAnchor.constraint(equalTo: numberOfPeopleTextField.bottomAnchor, constant: 20),
            infectionFactorLabel.leadingAnchor.constraint(equalTo: numberOfPeopleLabel.leadingAnchor),
            
            infectionFactorTextField.topAnchor.constraint(equalTo: infectionFactorLabel.bottomAnchor, constant: 8),
            infectionFactorTextField.leadingAnchor.constraint(equalTo: numberOfPeopleLabel.leadingAnchor),
            infectionFactorTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            recalculationPeriodLabel.topAnchor.constraint(equalTo: infectionFactorTextField.bottomAnchor, constant: 20),
            recalculationPeriodLabel.leadingAnchor.constraint(equalTo: numberOfPeopleLabel.leadingAnchor),
            
            recalculationPeriodTextField.topAnchor.constraint(equalTo: recalculationPeriodLabel.bottomAnchor, constant: 8),
            recalculationPeriodTextField.leadingAnchor.constraint(equalTo: numberOfPeopleLabel.leadingAnchor),
            recalculationPeriodTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            startButton.topAnchor.constraint(equalTo: recalculationPeriodTextField.bottomAnchor, constant: 40),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    @objc func startCalculation() {
        guard let numberOfPeopleText = numberOfPeopleTextField.text,
              let infectionFactorText = infectionFactorTextField.text,
              let recalculationPeriodText = recalculationPeriodTextField.text,
              let numberOfPeople = Int(numberOfPeopleText),
              let infectionFactor = Int(infectionFactorText),
              let recalculationPeriod = Int(recalculationPeriodText) else {
            showAlert(message: "Введите верные параметры.")
            return
        }
        
        if numberOfPeople > 100000 {
            let alert = UIAlertController(title: "Многовато...", message: "При слишком большом количестве людей, приложение может работать нестабильно :(", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Все равно продолжить", style: .default, handler: { _ in
                let mainViewController = MainViewController(numberOfPeople: numberOfPeople, infectionFactor: infectionFactor, recalculationPeriod: recalculationPeriod)
                self.navigationController?.pushViewController(mainViewController, animated: true)
            }))
            present(alert, animated: true, completion: nil)
        } else {
            let mainViewController = MainViewController(numberOfPeople: numberOfPeople, infectionFactor: infectionFactor, recalculationPeriod: recalculationPeriod)
            self.navigationController?.pushViewController(mainViewController, animated: true)
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка!", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

import UIKit

class MainViewController: UIViewController {
    
    let numberOfPeople: Int
    let infectionFactor: Int
    let recalculationPeriod: Int
    
    init(numberOfPeople: Int, infectionFactor: Int, recalculationPeriod: Int) {
        self.numberOfPeople = numberOfPeople
        self.infectionFactor = infectionFactor
        self.recalculationPeriod = recalculationPeriod
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var personSize: CGFloat = 50 {
        didSet {
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.itemSize = CGSize(width: personSize, height: personSize)
                layout.minimumLineSpacing = layout.minimumInteritemSpacing
            }
        }
    }
    
    var infectedLabel: UILabel!
    var healthyLabel: UILabel!
    var collectionView: UICollectionView!
    
    var pinchGestureRecognizer: UIPinchGestureRecognizer!
    var peopleStatus = [Bool]()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        setupCollectionView()
        setupPinchGestureRecognizer()
        startSimulation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    func setupHeader() {
        let counterContainer = UIView()
        counterContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(counterContainer)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            counterContainer.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            counterContainer.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            counterContainer.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10)
        ])
        
        infectedLabel = UILabel()
        infectedLabel.translatesAutoresizingMaskIntoConstraints = false
        infectedLabel.textColor = .red
        counterContainer.addSubview(infectedLabel)
        NSLayoutConstraint.activate([
            infectedLabel.topAnchor.constraint(equalTo: counterContainer.topAnchor),
            infectedLabel.leadingAnchor.constraint(equalTo: counterContainer.leadingAnchor),
            infectedLabel.bottomAnchor.constraint(equalTo: counterContainer.bottomAnchor)
        ])
        
        healthyLabel = UILabel()
        healthyLabel.translatesAutoresizingMaskIntoConstraints = false
        healthyLabel.textColor = .green
        counterContainer.addSubview(healthyLabel)
        NSLayoutConstraint.activate([
            healthyLabel.topAnchor.constraint(equalTo: counterContainer.topAnchor),
            healthyLabel.trailingAnchor.constraint(equalTo: counterContainer.trailingAnchor),
            healthyLabel.bottomAnchor.constraint(equalTo: counterContainer.bottomAnchor)
        ])
        
        updateCounterLabels()
    }
    
    func setupPinchGestureRecognizer() {
        pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        collectionView.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    @objc func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let scale = gestureRecognizer.scale
            let currentSize = personSize
            let newSize = currentSize * scale
            
            if newSize >= 30 && newSize <= 90 {
                personSize = newSize
            }
            
            gestureRecognizer.scale = 1
        }
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: personSize, height: personSize)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PersonCell.self, forCellWithReuseIdentifier: "PersonCell")
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func startSimulation() {
        peopleStatus = Array(repeating: false, count: numberOfPeople)
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(recalculationPeriod), target: self, selector: #selector(recalculateStatus), userInfo: nil, repeats: true)
    }
    
    
    @objc func recalculateStatus() {
        DispatchQueue.global().async {
            var newPeopleStatus = self.peopleStatus
            
            for i in 0..<self.numberOfPeople {
                if self.peopleStatus[i] {
                    let randomInfectionCount = Int.random(in: 0...self.infectionFactor)
                    
                    var infections = 0
                    while infections < randomInfectionCount {
                        let randomIndex = Int.random(in: 0..<self.numberOfPeople)
                        if randomIndex == i {
                            continue
                        } else {
                            newPeopleStatus[randomIndex] = true
                            infections += 1
                        }
                    }
                }
            }
            
            self.peopleStatus = newPeopleStatus
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.updateCounterLabels()
            }
        }
    }
    
    func updateCounterLabels() {
        let infectedCount = peopleStatus.filter { $0 }.count
        let healthyCount = numberOfPeople - infectedCount
        infectedLabel.text = "Зараженные: \(infectedCount)"
        healthyLabel.text = "Здоровые: \(healthyCount)"
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfPeople
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as! PersonCell
        cell.backgroundColor = peopleStatus[indexPath.item] ? .red : .green
        cell.configure(for: peopleStatus[indexPath.item])
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        peopleStatus[indexPath.item] = true
        collectionView.reloadData()
        updateCounterLabels()
    }
}

import UIKit

/// Displays the list of favourite cities and their current weather.
/// Users can remove favourites with swipe‑to‑delete and navigate to
/// the map or settings via the navigation bar buttons.
class FavoritesViewController: UIViewController {
    private let viewModel = FavoritesViewModel(repository: AppContainer.shared.weatherRepository)
    private let settingsViewModel = SettingsViewModel()
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped)),
            UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingsTapped))
        ]
        setupTableView()
        viewModel.units = settingsViewModel.isMetricUnits ? "metric" : "imperial"
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Update units and reload weather each time the view appears.
        viewModel.units = settingsViewModel.isMetricUnits ? "metric" : "imperial"
        viewModel.loadWeather()
    }

    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc private func addTapped() {
        // Navigate to map tab to add new favourites.
        tabBarController?.selectedIndex = 2
    }

    @objc private func settingsTapped() {
        tabBarController?.selectedIndex = 3
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoritesWeather.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let info = viewModel.favoritesWeather[indexPath.row]
        cell.textLabel?.text = "\(info.cityName)  \(Int(info.temperature))°"
        cell.detailTextLabel?.text = info.description.capitalized
        return cell
    }
    // Enable swipe to delete
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeFavorite(at: indexPath.row)
        }
    }
}
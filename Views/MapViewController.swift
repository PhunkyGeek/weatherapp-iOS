import UIKit
import MapKit

/// Presents a map interface that allows users to search for cities or
/// airports and see the result on the map.  A "My Location" button
/// enables the display of the user’s current location.  This screen
/// acts as a placeholder for more advanced map features.
class MapViewController: UIViewController, UISearchBarDelegate {
    private let mapView = MKMapView()
    private let searchBar = UISearchBar()
    private let locationButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Map"
        view.backgroundColor = .systemBackground
        setupViews()
    }

    private func setupViews() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        locationButton.translatesAutoresizingMaskIntoConstraints = false

        searchBar.placeholder = "Search for a city or airport"
        searchBar.delegate = self

        locationButton.setTitle("My Location", for: .normal)
        locationButton.backgroundColor = .systemBlue
        locationButton.setTitleColor(.white, for: .normal)
        locationButton.layer.cornerRadius = 8
        locationButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        locationButton.addTarget(self, action: #selector(locationTapped), for: .touchUpInside)

        view.addSubview(searchBar)
        view.addSubview(mapView)
        view.addSubview(locationButton)

        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safe.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: safe.trailingAnchor),

            mapView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),

            locationButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            locationButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -40)
        ])
    }

    @objc private func locationTapped() {
        mapView.showsUserLocation = true
    }

    // MARK: UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchBar.resignFirstResponder()
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let response = response, let coordinate = response.mapItems.first?.placemark.coordinate else { return }
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            self?.mapView.setRegion(region, animated: true)
        }
    }
}
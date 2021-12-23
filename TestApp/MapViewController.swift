
import UIKit
import MapKit
import RxCocoa
import RxSwift

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var buildRoute: UIButton!
    @IBOutlet weak var deleteRoute: UIButton!
    private let modelProperty = PostApp()
    private let disposeBag = DisposeBag()
    private var arrayAnnotation: [MKPointAnnotation] = []
    private var userCity = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        modelProperty.ipQuery().subscribe(onNext: {
            obs in
            self.userCity = obs.city
            let userLocation = CLLocation(latitude: obs.latitude, longitude: obs.longitude)
            let userCoordinate = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
            self.mapView.setRegion(userCoordinate, animated: true)
        }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBtn.layer.cornerRadius = searchBtn.bounds.size.width/2
        buildRoute.layer.cornerRadius = 12
        deleteRoute.layer.cornerRadius = 12
    }
    
    @IBAction func searchButton(_ sender: Any) {
        myAlert(tittle: "Добавить", placeholder: "Введите адрес") { text in
            self.setupMarks(address: self.userCity + "," + text)
            print(text)
        }
    }
    
    @IBAction func buildRouteAction(_ sender: Any) {
        for i in 0 ... arrayAnnotation.count - 2 {
            createToBuildRoute(startCoordinate: arrayAnnotation[i].coordinate, endCoordinate: arrayAnnotation[i+1].coordinate)
        }
        mapView.showAnnotations(arrayAnnotation, animated: true)
    }
    
    @IBAction func deleteRouteAction(_ sender: Any) {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        arrayAnnotation.removeAll()
        searchBtn.isEnabled = true
    }
    
    private func setupMarks(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print(error)
            }
            guard let placemarks = placemarks else {return}
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = "\(address)"
            guard let placemarkLocation = placemark?.location else {return}
            annotation.coordinate = placemarkLocation.coordinate
            self.arrayAnnotation.append(annotation)
            if self.arrayAnnotation.count > 2 {
                let alertControl = UIAlertController(title: "Предупреждение!", message: "Вы можете ввести не более 3-х мест", preferredStyle: .alert)
                let alertClose = UIAlertAction(title: "Ok", style: .default) { (_) in
                }
                self.searchBtn.isEnabled = false
                alertControl.addAction(alertClose)
                self.present(alertControl, animated: true, completion: nil)
            }
            self.mapView.showAnnotations(self.arrayAnnotation, animated: true)
        }
    }
    
    private func createToBuildRoute(startCoordinate: CLLocationCoordinate2D, endCoordinate: CLLocationCoordinate2D) {
        let start = MKPlacemark(coordinate: startCoordinate)
        let end = MKPlacemark(coordinate: endCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: start)
        request.destination = MKMapItem(placemark: end)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        let direction = MKDirections(request: request)
        direction.calculate { response, error in
            if let error = error {
                print(error)
            }
            self.mapView.addOverlay(response?.routes[0].polyline as! MKOverlay)
        }
    }

    private func myAlert(tittle: String, placeholder: String, completion: @escaping (String) -> Void ) {
        let alertController = UIAlertController(title: tittle, message: nil, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "Ok", style: .default) { action in
            let textFieldText = alertController.textFields?.first
            guard let text = textFieldText?.text else {return}
            completion(text)
        }
        alertController.addTextField { textField in
            textField.placeholder = placeholder
        }
        let alertCancel = UIAlertAction(title: "Отмена", style: .default) { (_) in
        }
        alertController.addAction(alertOk)
        alertController.addAction(alertCancel)
        present(alertController, animated: true, completion: nil)
    }
    
}
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = .orange
        return render
    }
}

  

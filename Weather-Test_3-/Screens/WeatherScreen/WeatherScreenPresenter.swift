protocol WeatherScreenPresenterProtocol: AnyObject {
    
}

final class WeatherScreenPresenter: WeatherScreenPresenterProtocol {
    weak var view: WeatherScreenViewControllerProtocol?
    
    private let cityModel: MainScreenViewCell.Model
    
    init(cityModel: MainScreenViewCell.Model) {
        self.cityModel = cityModel
    }
    
    func viewDidLoad() {
        CellDataUpdating()
    }
}

extension WeatherScreenPresenter {
    func CellDataUpdating() {
        
        let headerModel = WeatherScreenView.ModelView(
            name: cityModel.name,
            country: cityModel.country,
            temp: cityModel.temp,
            description: cityModel.description,
            tempMin: cityModel.tempMin,
            tempMax: cityModel.tempMax,
            videoFileName: cityModel.videoFileName
        )
        
        let tableModel = WeatherScreenView.Model(
            items: [
                WeatherScreenViewCell.Model(dateTime: cityModel.dateTime, tempMin: cityModel.tempMin, tempMax: cityModel.tempMax, icon: cityModel.icon)
            ]
        )
        
        view?.updateHeader(modelView: headerModel)
        view?.updateTable(model: tableModel)
    }

}

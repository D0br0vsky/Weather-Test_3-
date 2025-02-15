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
        
        let tableItems = cityModel.weatherList.map { weatherInfo in
            WeatherScreenViewCell.Model(
                dateTime: weatherInfo.dateTime,
                tempMin: weatherInfo.tempMin,
                tempMax: weatherInfo.tempMax,
                icon: weatherInfo.icon
            )
        }
        let tableModel = WeatherScreenView.Model(items: tableItems)
        view?.updateTable(model: tableModel)
        view?.updateHeader(modelView: headerModel)
    }

}

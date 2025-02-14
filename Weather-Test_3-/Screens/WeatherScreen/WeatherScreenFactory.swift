final class WeatherScreenFactory {
    func make(city: MainScreenViewCell.Model) -> WeatherScreenViewController {
        let presenter = WeatherScreenPresenter(cityModel: city)
        let vc = WeatherScreenViewController(presenter: presenter)
        return vc
    }
}

final class WeatherScreenFactory {
    func make(city: MainScreenViewCell.Model) -> WeatherScreenViewController {
        let presenter = WeatherScreenPresenter(cityModel: city)
        let screenStateView = ScreenStateView()
        let vc = WeatherScreenViewController(presenter: presenter, screenStateView: screenStateView)
        return vc
    }
}

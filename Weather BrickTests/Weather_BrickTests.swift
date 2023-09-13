//
//  Weather_BrickTests.swift
//  Weather BrickTests
//
//  Created by Ivan Solohub on 12.09.2023.
//


import SnapshotTesting
import XCTest
@testable import Weather_Brick

class Weather_BrickTests: XCTestCase {
    
    func testInfoPageViewController() {
      
        let vc = InfoPageViewController()

        assertSnapshot(of: vc, as: .image)
    }
    
    func testSunnyBrickWeatherMode() {

        let cell = CustomTableViewCell()
        let viewModel = BrickCellViewModel(weather: R.string.localizable.sunny(), temperature: 25, windSpeed: 1)
        let sunnyImage = cell.updateBrickStateImage(with: viewModel)
        
        assertSnapshot(matching: sunnyImage, as: .image)
    }
    
    func testHeatBrickWeatherMode() {
        
        let cell = CustomTableViewCell()
        let viewModel = BrickCellViewModel(weather: R.string.localizable.sunny(), temperature: 38, windSpeed: 1)
        let sunnyImage = cell.updateBrickStateImage(with: viewModel)
        
        assertSnapshot(matching: sunnyImage, as: .image)
    }
    
    func testClearBrickWeatherMode() {
        
        let cell = CustomTableViewCell()
        let viewModel = BrickCellViewModel(weather: R.string.localizable.clear(), temperature: 20, windSpeed: 2)
        let clearImage = cell.updateBrickStateImage(with: viewModel)
        
        assertSnapshot(matching: clearImage, as: .image)
    }
    
    func testRainBrickWeatherMode() {
        
        let cell = CustomTableViewCell()
        let viewModel = BrickCellViewModel(weather: R.string.localizable.rain(), temperature: 15, windSpeed: 3)
        let clearImage = cell.updateBrickStateImage(with: viewModel)
        
        assertSnapshot(matching: clearImage, as: .image)
    }
    
    func testDrizzleBrickWeatherMode() {
        
        let cell = CustomTableViewCell()
        let viewModel = BrickCellViewModel(weather: R.string.localizable.drizzle(), temperature: 10, windSpeed: 2)
        let clearImage = cell.updateBrickStateImage(with: viewModel)
        
        assertSnapshot(matching: clearImage, as: .image)
    }
    
    func testSnowBrickWeatherMode() {
        
        let cell = CustomTableViewCell()
        let viewModel = BrickCellViewModel(weather: R.string.localizable.snow(), temperature: 0, windSpeed: 5)
        let clearImage = cell.updateBrickStateImage(with: viewModel)
        
        assertSnapshot(matching: clearImage, as: .image)
    }
    
    func testFogBrickWeatherMode() {
        
        let cell = CustomTableViewCell()
        let viewModel = BrickCellViewModel(weather: R.string.localizable.fog(), temperature: 5, windSpeed: 0)
        let clearImage = cell.updateBrickStateImage(with: viewModel)
        
        assertSnapshot(matching: clearImage, as: .image)
    }
    
    func testHazeBrickWeatherMode() {
        
        let cell = CustomTableViewCell()
        let viewModel = BrickCellViewModel(weather: R.string.localizable.haze(), temperature: 6, windSpeed: 2)
        let clearImage = cell.updateBrickStateImage(with: viewModel)
        
        assertSnapshot(matching: clearImage, as: .image)
    }
    
    func testMistBrickWeatherMode() {
        
        let cell = CustomTableViewCell()
        let viewModel = BrickCellViewModel(weather: R.string.localizable.mist(), temperature: 8, windSpeed: 3)
        let clearImage = cell.updateBrickStateImage(with: viewModel)
        
        assertSnapshot(matching: clearImage, as: .image)
    }
}

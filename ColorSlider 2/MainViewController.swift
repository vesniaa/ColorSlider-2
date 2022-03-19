//
//  MainViewController.swift
//  ColorSlider 2
//
//  Created by Евгения Аникина on 18.03.2022.
//

import UIKit

protocol ColorViewControllerDelegate {
    func updateBackgroundColor(with color: UIColor)
}

class MainViewController: UIViewController, ColorViewControllerDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let colorViewController = segue.destination as? ColorViewController else { return }
        
        colorViewController.delegate = self
        colorViewController.color = view.backgroundColor ?? .white
    }
    
    func updateBackgroundColor(with color: UIColor) {
        view.backgroundColor = color
    }

}

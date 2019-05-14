//
//  HomeViewController.swift
//  freekicker
//
//  Created by Emir Can Marangoz on 13.05.2019.
//  Copyright © 2019 Emir Can Marangoz. All rights reserved.
//

import UIKit
import SceneKit
class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var preview: SCNView!
    var setupScene: SCNScene!
    var camera: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene = SCNScene(named: "freekickerArt.scnassets/Scene/model_2.scn")
        preview.scene = setupScene
        camera = setupScene.rootNode.childNode(withName: "preview", recursively: true)!
    }
    
    
    @IBAction func onPlayButton(_ sender: Any) {
        performSegue(withIdentifier: "homeToGameSegue", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

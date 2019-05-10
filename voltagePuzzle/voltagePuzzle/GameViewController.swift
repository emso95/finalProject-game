import UIKit
import SceneKit

class GameViewController: UIViewController {
    
    var scnView: SCNView!
    var scnScene: SCNScene!
    var game = GameHelper.sharedInstance
    var verticalCameraNode: SCNNode!
    var ballNode: SCNNode!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        setupNodes()
        setupSounds()
    }
    
    func setupScene() {
        
        scnView = self.view as! SCNView
        scnView.delegate = self
        
        scnScene = SCNScene(named: "GeometryFighter.scnassets/Scene/model.scn")
        scnView.scene = scnScene
        scnView.showsStatistics = true
        // 2
        
    }
    
    func setupNodes() {
        
        verticalCameraNode = scnScene.rootNode.childNode(withName: "cameraa", recursively: true)!
        
        scnScene.rootNode.addChildNode(game.hudNode)
        ballNode = scnScene.rootNode.childNode(withName: "Ball", recursively:
            true)!
    }
    
    func setupSounds() {
    }
    
    override var shouldAutorotate: Bool { return true }
    
    override var prefersStatusBarHidden: Bool { return false }
    
    
    
}

extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        game.updateHUD()
    }
}

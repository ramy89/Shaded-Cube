//
//  GameViewController.swift
//  Shaded Cube
//
//  Created by Ramy Al Zuhouri on 25/03/16.
//  Copyright (c) 2016 Ramy Al Zuhouri. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import MetalKit

struct Uniforms {
    var color:vector_float4
}

class GameViewController: UIViewController {
    
    var scene:SCNScene!
    var cube:SCNNode!
    var lights:SCNNode!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        scene = SCNScene()
        
        makeCube(scene)
        makeCamera(scene)
        makeLights(scene)
        makeShaders()
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.blackColor()
    }
    
    func makeCube(scene: SCNScene) -> SCNNode
    {
        let size:CGFloat = 12.5
        let cubeGeometry = SCNBox(width: size, height: size, length: size, chamferRadius: 0)
        cubeGeometry.firstMaterial?.diffuse.contents = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        cubeGeometry.firstMaterial?.specular.contents = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        cube = SCNNode(geometry: cubeGeometry)
        cube.position = SCNVector3Make(0.0, 0.0, 0.0)
        cube.rotation = SCNVector4Make(0.8,1.0,0.0, Float(M_PI / 4.0))
        
        scene.rootNode.addChildNode(cube)
        return cube
    }
    
    func makeShaders()
    {
        let program = SCNProgram()
        program.vertexFunctionName = "myVertex"
        program.fragmentFunctionName = "myFragment"
        cube.geometry?.program = program
        
        var uniforms = Uniforms(color: vector_float4(0.0,1.0,0.0,1.0))
        let uniformsData = NSData(bytes: &uniforms, length: sizeof(Uniforms))
        cube.geometry?.setValue(uniformsData, forKey: "uniforms")
    }
    
    func makeCamera(scene:SCNScene) -> SCNNode
    {
        let camera = SCNCamera()
        camera.xFov = 70.0
        camera.yFov = 70.0
        camera.zNear = 1.0
        camera.zFar = 1000.0
        
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3Make(0.0, 0.0, 40.0)
        
        let lookAt = SCNLookAtConstraint(target: cube)
        cameraNode.constraints = [lookAt]
        
        scene.rootNode.addChildNode(cameraNode)
        
        return cameraNode
    }
    
    func makeLights(scene:SCNScene) -> SCNNode
    {
        lights = SCNNode()
        
        let ambientLight = SCNLight()
        ambientLight.type = SCNLightTypeAmbient
        ambientLight.color = UIColor(white: 0.25, alpha: 1.0)
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        lights.addChildNode(ambientLightNode)
        
        let spotLight = SCNLight()
        spotLight.type = SCNLightTypeSpot
        spotLight.castsShadow = true
        spotLight.color = UIColor(white: 0.75, alpha: 1.0)
        spotLight.spotInnerAngle = 0.0
        spotLight.spotOuterAngle = 45.0
        spotLight.shadowColor = UIColor.blackColor()
        spotLight.zFar = 400.0
        spotLight.zNear = 10.0
        let spotLightNode = SCNNode()
        spotLightNode.light = spotLight
        
        // Make the light look towards the cube
        let lookAt = SCNLookAtConstraint(target: cube)
        spotLightNode.constraints = [lookAt]
        
        lights.addChildNode(spotLightNode)
        lights.position = SCNVector3Make(-20.0, 40.0, 70.0)
        
        scene.rootNode.addChildNode(lights)
        return lights
    }
    
}






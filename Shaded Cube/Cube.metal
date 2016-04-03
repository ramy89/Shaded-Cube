//
//  Cube.metal
//  Shaded Cube
//
//  Created by Ramy Al Zuhouri on 26/03/16.
//  Copyright © 2016 Ramy Al Zuhouri. All rights reserved.
//


#include <metal_stdlib>
using namespace metal;
#include "SceneKit/scn_metal"

typedef struct {
    float3 position [[ attribute(SCNVertexSemanticPosition) ]];
    float3 normal   [[ attribute(SCNVertexSemanticNormal) ]];
} MyVertexInput;

struct MyNodeBuffer {
    float4x4 modelTransform;
    float4x4 modelViewProjectionTransform;
};

struct MyVertexOutput
{
    float4 position [[position]];
    float4 normal;
    float4 lightPosition;
};


vertex MyVertexOutput myVertex(MyVertexInput in [[ stage_in ]],
                               constant SCNSceneBuffer& scn_frame [[buffer(0)]],
                               constant MyNodeBuffer& scn_node [[buffer(1)]])
{
    MyVertexOutput output;
    output.position = scn_node.modelViewProjectionTransform * float4(in.position,1.0);
    output.normal = float4(in.normal, 1.0);
    return output;
}

struct Uniforms
{
    float4 color;
};

fragment float4 myFragment(MyVertexOutput in [[ stage_in ]],
                           constant Uniforms& uniforms [[buffer(2)]])
{
    //float4 lightPosition = float4(-20.0, 40.0, 70.0, 1.0);
    //float intensity = dot(in.normal, normalize(lightPosition));
    //return float4(1.0, 0.0, 0.0, 1.0) * intensity;
    return uniforms.color;
}





// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Custom/mb_uvrollalphablend_twotex_mulculloff" {
    Properties {
        _FlowTex1 ("FlowTex1", 2D) = "white" {}
        _FlowTex1USpeed ("FlowTex1U Speed", Range(-10, 10)) = 1
        _FlowTex1VSpeed ("FlowTex1V Speed", Range(-10, 10)) = 0
        _FlowTex2 ("FlowTex2", 2D) = "white" {}
        _FlowTex2USpeed ("FlowTex2U Speed", Range(-10, 10)) = 0
        _FlowTex2VSpeed ("FlowTex2V Speed", Range(-10, 10)) = 0
        _Color ("Color", Color) = (0.5,0.5,0.5,1)
        _BrightenIntensity ("BrightenIntensity", Range(0, 20)) = 1
        _MaskTex ("MaskTex", 2D) = "white" {}
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
            "ForceNoShadowCasting"="True"
        }

        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            //#pragma multi_compile_fog
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _MaskTex; uniform fixed4 _MaskTex_ST;
            uniform fixed4 _Color;
            uniform half _FlowTex1USpeed;
            uniform half _FlowTex1VSpeed;
            uniform sampler2D _FlowTex1; uniform fixed4 _FlowTex1_ST;
            uniform sampler2D _FlowTex2; uniform fixed4 _FlowTex2_ST;
            uniform half _FlowTex2USpeed;
            uniform half _FlowTex2VSpeed;
            uniform fixed _BrightenIntensity;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                fixed4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                fixed4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
            }
            fixed4 frag(VertexOutput i, fixed facing : VFACE) : COLOR {
                fixed isFrontFace = ( facing >= 0 ? 1 : 0 );
                fixed faceSign = ( facing >= 0 ? 1 : -1 );
////// Lighting:
////// Emissive:
                float4 node_9350 = _Time + _TimeEditor;
                float2 node_2607 = (i.uv0+(node_9350.g*half2(_FlowTex1USpeed,_FlowTex1VSpeed)));
                fixed4 _FlowTex1_var = tex2D(_FlowTex1,TRANSFORM_TEX(node_2607, _FlowTex1));
                fixed4 node_882 = _Time + _TimeEditor;
                float2 node_8637 = (i.uv0+(node_882.g*half2(_FlowTex2USpeed,_FlowTex2VSpeed)));
                fixed4 _FlowTex2_var = tex2D(_FlowTex2,TRANSFORM_TEX(node_8637, _FlowTex2));
                fixed3 emissive = (((_FlowTex1_var.rgb*_FlowTex2_var.rgb)*_BrightenIntensity)*i.vertexColor.rgb*_Color.rgb);
                fixed3 finalColor = emissive;
                fixed4 _MaskTex_var = tex2D(_MaskTex,TRANSFORM_TEX(i.uv0, _MaskTex));
                fixed4 finalRGBA = fixed4(finalColor,(i.vertexColor.a*_Color.a*_MaskTex_var.r*_FlowTex1_var.a*_FlowTex2_var.a));
                return finalRGBA;
            }
            ENDCG
        }
    }
}

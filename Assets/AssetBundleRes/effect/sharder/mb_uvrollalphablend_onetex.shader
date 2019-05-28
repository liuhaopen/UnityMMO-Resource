// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Custom/mb_uvrollalphablend_onetex" {
    Properties {
        _AmitTex ("AmitTex", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _Brighteen ("Brighteen", Range(0, 10)) = 1
        _Uspeed ("U speed", Range(-10, 10)) = 1
        _VSpeed ("V Speed", Range(-10, 10)) = 1
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        LOD 200
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _AmitTex; uniform fixed4 _AmitTex_ST;
            uniform fixed4 _Color;
            uniform fixed _Brighteen;
            uniform half _Uspeed;
            uniform half _VSpeed;
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
                float2 node_6726 = (i.uv0+(node_9350.g*half2(_Uspeed,_VSpeed)));
                fixed4 _AmitTex_var = tex2D(_AmitTex,TRANSFORM_TEX(node_6726, _AmitTex));
                fixed3 emissive = ((_Brighteen*_AmitTex_var.rgb)*i.vertexColor.rgb*_Color.rgb);
                fixed3 finalColor = emissive;
                return fixed4(finalColor,(_AmitTex_var.a*i.vertexColor.a*_Color.a));
            }
            ENDCG
        }
    }

}

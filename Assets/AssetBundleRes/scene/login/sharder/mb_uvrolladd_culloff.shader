// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/mb_uvrolladd_culloff" {
    Properties {
        _AmitTex ("AmitTex", 2D) = "white" {}
        _Color ("Color", Color) = (0.5,0.5,0.5,1)
        _Brighteen ("Brighteen", Range(0, 10)) = 1
        _Uspeed ("U speed", Range(-10, 10)) = 1
        _VSpeed ("V Speed", Range(-10, 10)) = 1
        _Mask ("Mask", 2D) = "white" {}
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
            Blend One One
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma target 3.0
            uniform fixed4 _TimeEditor;
            uniform sampler2D _AmitTex; uniform fixed4 _AmitTex_ST;
            uniform fixed4 _Color;
            uniform fixed _Brighteen;
            uniform fixed _Uspeed;
            uniform fixed _VSpeed;
            uniform sampler2D _Mask; uniform fixed4 _Mask_ST;
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
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
////// Lighting:
////// Emissive:
                float4 node_9350 = _Time + _TimeEditor;
                float2 node_6726 = (i.uv0+(node_9350.g*float2(_Uspeed,_VSpeed)));
                float4 _AmitTex_var = tex2D(_AmitTex,TRANSFORM_TEX(node_6726, _AmitTex));
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                float3 emissive = (_Brighteen*(_AmitTex_var.rgb*i.vertexColor.rgb*_Color.rgb)*(i.vertexColor.a*_Color.a*_Mask_var.r));
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }

}

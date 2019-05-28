// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Custom/mb_dissolve_alphablend" {
    Properties {
        _aimtex ("aimtex", 2D) = "white" {}
        _TintColor ("Tint Color", Color) = (1,1,1,1)
        _aimintensity ("aimintensity", Range(0, 10)) = 1
        _disstex ("disstex", 2D) = "white" {}
        _dissintensity ("dissintensity", Range(0, 1)) = 1
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="Geometry"
            "RenderType"="Opaque"
        }

        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            //#pragma multi_compile_fwdbase_fullshadows
            #pragma target 3.0
            uniform sampler2D _disstex; uniform fixed4 _disstex_ST;
            uniform fixed _dissintensity;
            uniform sampler2D _aimtex; uniform fixed4 _aimtex_ST;
            uniform fixed4 _TintColor;
            uniform fixed _aimintensity;
            struct VertexInput {
                float4 vertex : POSITION;
                half2 texcoord0 : TEXCOORD0;
                fixed4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                half2 uv0 : TEXCOORD0;
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
                fixed4 _disstex_var = tex2D(_disstex,TRANSFORM_TEX(i.uv0, _disstex));
                fixed4 _aimtex_var = tex2D(_aimtex,TRANSFORM_TEX(i.uv0, _aimtex));
                clip((exp(_disstex_var.r)*_dissintensity*(_aimtex_var.a*_TintColor.a*i.vertexColor.a)) - 0.5);
////// Lighting:
////// Emissive:
                fixed3 emissive = ((_aimtex_var.rgb*_aimintensity)*_TintColor.rgb*i.vertexColor.rgb);
                fixed3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
 
    }
}

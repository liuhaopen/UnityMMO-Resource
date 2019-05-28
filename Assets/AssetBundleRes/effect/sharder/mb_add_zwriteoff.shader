// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Custom/mb_add_zwriteoff" {
    Properties {
        _Amitex ("Amitex", 2D) = "white" {}
        _TintColor ("Tint Color", Color) = (1,1,1,1)
        _AmitIntensity ("AmitIntensity", Range(0, 20)) = 1
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }

        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha One
            Zwrite Off
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma target 3.0
            uniform sampler2D _Amitex; uniform fixed4 _Amitex_ST;
            uniform fixed4 _TintColor;
            uniform fixed _AmitIntensity;
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
            fixed4 frag(VertexOutput i) : COLOR {
////// Lighting:
////// Emissive:
                fixed4 _Amitex_var = tex2D(_Amitex,TRANSFORM_TEX(i.uv0, _Amitex));
                fixed3 emissive = ((_Amitex_var.rgb*_TintColor.rgb*i.vertexColor.rgb)*(_Amitex_var.a*_TintColor.a*i.vertexColor.a)*_AmitIntensity);
                fixed3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
}

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:9356,x:33049,y:32680,varname:node_9356,prsc:2|emission-2379-OUT;n:type:ShaderForge.SFN_Tex2d,id:69,x:32248,y:32548,ptovrint:False,ptlb:AmitTex,ptin:_AmitTex,varname:node_69,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-6726-OUT;n:type:ShaderForge.SFN_VertexColor,id:771,x:32249,y:32733,varname:node_771,prsc:2;n:type:ShaderForge.SFN_Multiply,id:5362,x:32491,y:32722,varname:node_5362,prsc:2|A-69-RGB,B-771-RGB,C-7459-RGB;n:type:ShaderForge.SFN_Color,id:7459,x:32249,y:32931,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_7459,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:911,x:32540,y:32975,varname:node_911,prsc:2|A-771-A,B-7459-A,C-6067-R;n:type:ShaderForge.SFN_TexCoord,id:4593,x:31695,y:32481,varname:node_4593,prsc:2,uv:0;n:type:ShaderForge.SFN_Time,id:9350,x:31407,y:32727,varname:node_9350,prsc:2;n:type:ShaderForge.SFN_Slider,id:4828,x:32459,y:32604,ptovrint:False,ptlb:Brighteen,ptin:_Brighteen,varname:node_4828,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:10;n:type:ShaderForge.SFN_Multiply,id:2379,x:32741,y:32722,varname:node_2379,prsc:2|A-4828-OUT,B-5362-OUT,C-911-OUT;n:type:ShaderForge.SFN_Slider,id:9954,x:31333,y:33036,ptovrint:False,ptlb:U speed,ptin:_Uspeed,varname:node_9954,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-10,cur:1,max:10;n:type:ShaderForge.SFN_Slider,id:4737,x:31321,y:33162,ptovrint:False,ptlb:V Speed,ptin:_VSpeed,varname:node_4737,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-10,cur:1,max:10;n:type:ShaderForge.SFN_Multiply,id:5257,x:31834,y:32853,varname:node_5257,prsc:2|A-9350-T,B-895-OUT;n:type:ShaderForge.SFN_Append,id:895,x:31678,y:33058,varname:node_895,prsc:2|A-9954-OUT,B-4737-OUT;n:type:ShaderForge.SFN_Add,id:6726,x:31969,y:32581,varname:node_6726,prsc:2|A-4593-UVOUT,B-5257-OUT;n:type:ShaderForge.SFN_Tex2d,id:6067,x:32230,y:33157,ptovrint:False,ptlb:Mask,ptin:_Mask,varname:node_6067,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;proporder:69-7459-4828-9954-4737-6067;pass:END;sub:END;*/

Shader "Custom/UVRoll_add" {
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
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma exclude_renderers metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _AmitTex; uniform float4 _AmitTex_ST;
            uniform float4 _Color;
            uniform float _Brighteen;
            uniform float _Uspeed;
            uniform float _VSpeed;
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
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
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}

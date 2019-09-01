// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:9356,x:33050,y:32651,varname:node_9356,prsc:2|emission-442-OUT;n:type:ShaderForge.SFN_Fresnel,id:1198,x:32354,y:32659,varname:node_1198,prsc:2|EXP-6564-OUT;n:type:ShaderForge.SFN_Color,id:5150,x:32292,y:32836,ptovrint:False,ptlb:Tint Color,ptin:_TintColor,varname:node_5150,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:1056,x:32591,y:32735,varname:node_1056,prsc:2|A-1198-OUT,B-5150-RGB,C-5150-A;n:type:ShaderForge.SFN_ValueProperty,id:6564,x:32131,y:32677,ptovrint:False,ptlb:Exp,ptin:_Exp,varname:node_6564,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:442,x:32816,y:32735,varname:node_442,prsc:2|A-1056-OUT,B-3964-OUT;n:type:ShaderForge.SFN_Slider,id:3964,x:32463,y:33076,ptovrint:False,ptlb:Intensity,ptin:_Intensity,varname:node_3964,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.7692308,max:50;proporder:5150-6564-3964;pass:END;sub:END;*/

Shader "Custom/mb_fresnel" {
    Properties {
        _TintColor ("Tint Color", Color) = (1,0.22745,1,1)
        _Exp ("Exp", Float ) = 1.5
        _Intensity ("Intensity", Range(0, 50)) = 3
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent+600"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One One
            //ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma target 3.0
            uniform fixed4 _TintColor;
            uniform fixed _Exp;
            uniform fixed _Intensity;
            struct VertexInput {
                fixed4 vertex : POSITION;
                fixed3 normal : NORMAL;
            };
            struct VertexOutput {
                fixed4 pos : SV_POSITION;
                fixed4 posWorld : TEXCOORD0;
                fixed3 normalDir : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                fixed3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                fixed3 normalDirection = i.normalDir;
////// Lighting:
////// Emissive:
                fixed3 emissive = ((pow(1.0-max(0,dot(normalDirection, viewDirection)),_Exp)*_TintColor.rgb*_TintColor.a)*_Intensity);
                fixed3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
}

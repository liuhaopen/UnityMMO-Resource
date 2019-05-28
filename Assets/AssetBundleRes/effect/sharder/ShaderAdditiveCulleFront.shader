// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "SDShader/AdditiveCulledFront" {
Properties {
	_TintColor ("Tint Color", Color) = (1,1,1,1)
	_MainTex ("Particle Texture", 2D) = "white" {}
	
	
}
/*
Category {
	Tags { "Queue"="Transparent+101" "IgnoreProjector"="True" "RenderType"="Transparent" }
	Blend SrcAlpha One
	AlphaTest Greater .01
	ColorMask RGB
	Ztest Off
	Cull Off Lighting Off ZWrite Off Fog { Mode Off }
	BindChannels {
		Bind "Color", color
		Bind "Vertex", vertex
		Bind "TexCoord", texcoord
	}
	
	// ---- Dual texture cards
	SubShader {
		Pass {
			SetTexture [_MainTex] {
				constantColor [_TintColor]
				combine constant * primary
			}
			SetTexture [_MainTex] {
				combine texture * previous DOUBLE
			}
		}
	}
	
	// ---- Single texture cards (does not do color tint)
	SubShader {
		Pass {
			SetTexture [_MainTex] {
				combine texture * primary DOUBLE
			}
		}
	}
}
}*/

CGINCLUDE

	#include "UnityCG.cginc"

	uniform sampler2D _MainTex;
	fixed4 _TintColor;
	uniform fixed4 _MainTex_ST;

	struct appdata {
		half4 vertex : POSITION;
		half2 texcoord : TEXCOORD0;
		fixed4 color : COLOR0;
	};

	struct v2f {
		half4 pos : SV_POSITION;
		half2	uv : TEXCOORD0;
		fixed4	color : COLOR;
	};	

	v2f vert (appdata v)
	{
		v2f o;
		o.pos = UnityObjectToClipPos (v.vertex);		
		o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
		o.color = v.color;
		return o;
	}
	
	fixed4 frag (v2f i) : COLOR
	{
		fixed4 vercol = i.color * _TintColor;
		fixed4 texcol = tex2D( _MainTex, i.uv ) * vercol*2;
		return texcol;
	}

	ENDCG
	
SubShader {
	Tags { "Queue"="Transparent+101" "IgnoreProjector"="True" "RenderType"="Transparent" }
	
   
    
    pass{
		     
	            Blend SrcAlpha One
	        	AlphaTest off
	            ColorMask RGB
	            Ztest Off
	            Cull Off Lighting off ZWrite Off Fog { Mode Off }  
		  
			CGPROGRAM
	#pragma vertex vert 
	#pragma fragment frag 
	
	ENDCG 

		}
   /* pass{
	Blend  One One

	AlphaTest off
	ColorMask RGB
	Ztest Off
	Cull Off Lighting off ZWrite Off Fog { Mode Off }
	CGPROGRAM
	#pragma vertex vert 
	#pragma fragment frag 
	
	ENDCG
		}*/


}




	/*SubShader {
		Tags { "Queue"="Transparent+101" "IgnoreProjector"="True" "RenderType"="Transparent" }
	
		pass{
		     Blend SrcAlpha OneMinusSrcAlpha 
	
	        	AlphaTest off
	            ColorMask RGB
	            Ztest Off
	            Cull Off Lighting On ZWrite Off Fog { Mode Off }  
		        Material{Emission[_TintColor] } 
		        SetTexture[_MainTex]{
		        combine Texture*Primary DOUBLE  ,Texture*Primary
		     }

		}
		pass{
	Blend  One One

	AlphaTest off
	ColorMask RGB
	Ztest Off
	Cull Off Lighting On ZWrite Off Fog { Mode Off }
		     Material{Diffuse[_TintColor] } 
		     SetTexture[_MainTex]{
		      combine Texture
		     }

		}
	} */
}
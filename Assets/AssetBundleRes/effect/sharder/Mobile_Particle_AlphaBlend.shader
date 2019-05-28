Shader "Mobile/Particles/Alpha Blended"
{
	Properties{
		_TintColor("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex("Particle Texture", 2D) = "white" {}
	}

		Category{
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" "PreviewType" = "Plane" }
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off Lighting Off ZWrite Off Fog{ Color(0,0,0,0) }

		BindChannels{
		Bind "Color", color
		Bind "Vertex", vertex
		Bind "TexCoord", texcoord
	}

		SubShader{

		Pass{
		SetTexture[_MainTex]{
		constantColor[_TintColor]
		combine constant*texture double
	}
	SetTexture[_MainTex]{
		combine previous*primary
	}
	}
	}
	}
}

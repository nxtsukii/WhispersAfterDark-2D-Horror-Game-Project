Shader "WhispersAfterDark/Lighting/DarknessLightRadius"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _DarknessColor ("Darkness Color", Color) = (0, 0, 0, 0.85)
        _LightCenter ("Light Center", Vector) = (0.5, 0.5, 0, 0)
        _LightRadius ("Light Radius", Range(0.01, 1)) = 0.25
        _Softness ("Edge Softness", Range(0.001, 0.5)) = 0.05
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
        }

        Cull Off
        ZWrite Off
        ZTest Always

        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            CBUFFER_START(UnityPerMaterial)

            float4 _DarknessColor;
            float4 _LightCenter;
            float _LightRadius;
            float _Softness;

            CBUFFER_END

            Varyings vert(Attributes input)
            {
                Varyings output;

                output.positionHCS =
                    TransformObjectToHClip(input.positionOS.xyz);

                output.uv = input.uv;

                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                float2 difference =
                    input.uv - _LightCenter.xy;

                float aspectRatio =
                    _ScreenParams.x / _ScreenParams.y;

                difference.x *= aspectRatio;

                float distanceFromLight =
                    length(difference);

                float darkness =
                    smoothstep(
                        _LightRadius - _Softness,
                        _LightRadius,
                        distanceFromLight
                    );

                half4 color = _DarknessColor;

                color.a *= darkness;

                return color;
            }

            ENDHLSL
        }
    }
}
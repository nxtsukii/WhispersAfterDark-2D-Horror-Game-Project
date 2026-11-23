Shader "WhispersAfterDark/Fog/AnimatedFog"
{
    Properties
    {
        _MainTex ("Fog Texture", 2D) = "white" {}

        _FogColor ("Fog Color", Color) = (0.7, 0.75, 0.8, 0.25)

        _Tiling ("Tiling", Float) = 2.0

        _ScrollSpeedX ("Scroll Speed X", Float) = 0.02
        _ScrollSpeedY ("Scroll Speed Y", Float) = 0.01
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

            float4 _FogColor;
            float _Tiling;
            float _ScrollSpeedX;
            float _ScrollSpeedY;

            CBUFFER_END

            Varyings vert(Attributes input)
            {
                Varyings output;

                output.positionHCS = TransformObjectToHClip(input.positionOS.xyz);

                output.uv = input.uv;

                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                float2 tiledUV = input.uv * _Tiling;

                float2 scroll =
                    float2(
                        _ScrollSpeedX,
                        _ScrollSpeedY
                    ) * _Time.y;

                float2 animatedUV = tiledUV + scroll;

                half fogSample =
                    SAMPLE_TEXTURE2D(
                        _MainTex,
                        sampler_MainTex,
                        animatedUV
                    ).r;

                half4 finalColor = _FogColor;

                finalColor.a *= fogSample;

                return finalColor;
            }

            ENDHLSL
        }
    }
}
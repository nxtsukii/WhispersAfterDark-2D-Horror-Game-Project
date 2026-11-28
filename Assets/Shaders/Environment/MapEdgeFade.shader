Shader "WhispersAfterDark/Environment/MapEdgeFade"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}

        _FadeWidth ("Fade Width", Range(0.1, 3)) = 1

        _CourtyardBounds ("Courtyard Bounds", Vector)
            = (-22.8, -15.3, 22.8, 15.3)

        _SchoolBounds ("School Bounds", Vector)
            = (-22.3, 10, 22.3, 18.8)

        _StaffBounds ("Staff Building Bounds", Vector)
            = (18, -10.3, 26.8, 8.3)

        _ViewRect ("Camera View", Vector) = (0, 0, 0, 0)
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
                float _FadeWidth;
                float4 _CourtyardBounds;
                float4 _SchoolBounds;
                float4 _StaffBounds;
                float4 _ViewRect;
            CBUFFER_END

            Varyings vert(Attributes input)
            {
                Varyings output;

                output.positionHCS =
                    TransformObjectToHClip(input.positionOS.xyz);

                output.uv = input.uv;

                return output;
            }

            float InsideDistance(float2 position, float4 bounds)
            {
                float2 distanceToEdge = min(
                    position - bounds.xy,
                    bounds.zw - position
                );

                return min(distanceToEdge.x, distanceToEdge.y);
            }

            half4 frag(Varyings input) : SV_Target
            {
                float2 worldPosition =
                    _ViewRect.xy + input.uv * _ViewRect.zw;

                float courtyard = InsideDistance(
                    worldPosition, _CourtyardBounds);

                float school = InsideDistance(
                    worldPosition, _SchoolBounds);

                float staff = InsideDistance(
                    worldPosition, _StaffBounds);

                float distanceFromEdge =
                    max(courtyard, max(school, staff));

                float darkness = 1.0 - smoothstep(
                    0.0, _FadeWidth, distanceFromEdge);

                return half4(0, 0, 0, darkness);
            }

            ENDHLSL
        }
    }
}
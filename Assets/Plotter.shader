Shader "Hidden/Plotter"
{
    CGINCLUDE

    #include "UnityCG.cginc"

    float4 _Range;
    half4 _LineColor;
    half4 _GridColor;
    half4 _ZeroColor;

    ENDCG

    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex Vertex
            #pragma fragment Fragment

            float4 Vertex(uint vid : SV_VertexID) : SV_Position
            {
                float p = 1.0 / 512 * vid;

                float x = lerp(_Range.x, _Range.y, p);
                float sx = p * 2 - 1;

                float y = sin(x * UNITY_PI);
                float sy = (y - _Range.z) / (_Range.w - _Range.z) * 2 - 1;

                return float4(sx, -sy, 1, 1);
            }

            half4 Fragment(float4 vertex : SV_Position) : SV_Target
            {
                return _LineColor;
            }

            ENDCG
        }

        Pass
        {
            CGPROGRAM

            #pragma vertex Vertex
            #pragma fragment Fragment

            float4 Vertex(uint vid : SV_VertexID) : SV_Position
            {
                float x = floor(_Range.x) + (vid / 2);
                x = (x - _Range.x) / (_Range.y - _Range.x) * 2 - 1;

                float y = (vid & 1) * 2.0 - 1;

                return float4(x, y, 1, 1);
            }

            half4 Fragment(float4 vertex : SV_Position) : SV_Target
            {
                return _GridColor;
            }

            ENDCG
        }

        Pass
        {
            CGPROGRAM

            #pragma vertex Vertex
            #pragma fragment Fragment

            float4 Vertex(uint vid : SV_VertexID) : SV_Position
            {
                float x = (vid & 1) * 2.0 - 1;

                float y = floor(_Range.z) + (vid / 2);
                y = (y - _Range.z) / (_Range.w - _Range.z) * 2 - 1;

                return float4(x, -y, 1, 1);
            }

            half4 Fragment(float4 vertex : SV_Position) : SV_Target
            {
                return _GridColor;
            }

            ENDCG
        }

        Pass
        {
            CGPROGRAM

            #pragma vertex Vertex
            #pragma fragment Fragment

            float4 Vertex(uint vid : SV_VertexID) : SV_Position
            {
                float v = (vid & 1) * 2.0 - 1;

                float2 p1 = float2(v, -_Range.z / (_Range.w - _Range.z) * 2 - 1);
                float2 p2 = float2(-_Range.x / (_Range.y - _Range.x) * 2 - 1, v);

                return float4(vid < 2 ? p1 : p2, 1, 1) * float4(1, -1, 1, 1);
            }

            half4 Fragment(float4 vertex : SV_Position) : SV_Target
            {
                return _ZeroColor;
            }

            ENDCG
        }
    }
}

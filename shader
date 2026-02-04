 Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _Radius("Radius", Range(0.0, 5)) = 0.5
        _MainTex("MainTex", 2D) = "white" {}
        _BG("Background", 2D) = "white" {}
        _Hardness("Hardness", Range(0.01, 0.99999)) = 1.0
        _CenterPoint("Center", Vector) = (0, 0, 0, 0)
        _value1("value1", float) = 2.0
        _value2("value2", float) = 1.0

    }
        SubShader
        {
            Tags {"Queue" = "Transparent" "RenderType" = "Transparent"}
            LOD 200

            CGPROGRAM
            // Physically based Standard lighting model, and enable shadows on all light types
            //#pragma surface surf Standard fullforwardshadows alpha:fade
            #pragma surface surf NoLighting noambient alpha:fade

            // Use shader model 3.0 target, to get nicer looking lighting


            sampler2D _MainTex;
            sampler2D _BG;
            float4 _BG_ST;

            float3 _CenterPoint;
            float _Radius;
            float _Hardness;
            float _value1;
            float _value2;

            struct Input
            {
                float2 uv_MainTex;
                float3 viewDir;
                float3 worldNormal;
                float3 worldPos;
                float4 screenPos;
            };

            fixed4 _Color;

            fixed4 LightingNoLighting(SurfaceOutput s, fixed3 lightDir, fixed atten) {
                fixed4 c;
                c.rgb = s.Albedo;
                c.a = s.Alpha;
                return c;
            }

            void surf(Input i, inout SurfaceOutput  o) {
                float2 textureCoordinate = i.screenPos.xy / i.screenPos.w;
                float aspect = _ScreenParams.x / _ScreenParams.y;
                textureCoordinate.y = 1-textureCoordinate.y;
                textureCoordinate.x = 1 - textureCoordinate.x;
                textureCoordinate = TRANSFORM_TEX(textureCoordinate, _BG);

                fixed4 col = tex2D(_BG, textureCoordinate);
                //col *= _Color;
                o.Albedo = col.rgb;
                //o.Metallic = _Metallic;
                //o.Smoothness = _Smoothness;
                //o.Emission = _Emission;
                o.Alpha = saturate(saturate((length(_CenterPoint - i.worldPos) - _Radius) / (1.0 - _Hardness)) + saturate(1 - pow(dot(i.viewDir, i.worldNormal), _value2) * _value1));
                //o.Alpha = 1.0;
            }
            ENDCG
        }
            FallBack "Diffuse"
}









/*
Properties
{
    _Color("Color", Color) = (1,1,1,1)
    _MainTex("MainTex", 2D) = "white" {}

    _BG("Background", 2D) = "white" {}
    _Hardness("Hardness", Range(0.01, 0.99999)) = 1.0
    _value1("value1", float) = 2.0
    _value2("value2", float) = 1.0

    _Radius("Radius", Range(0.0, 5)) = 0.5
    _CenterPoint("Center", Vector) = (0, 0, 0, 0)

    _RadiusLock("Radius Lockk",Range(0.0, 5)) = 0.5
    _RadiusColor("Radius Color", Color) = (1,0,0,1)
    _RadiusWidth("Radius Width", Float) = 0.001
}

    SubShader
    {
        Tags {"Queue" = "Transparent" "RenderType" = "Transparent"}
        LOD 200


        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        //#pragma surface surf Standard fullforwardshadows alpha:fade
        #pragma surface surf NoLighting noambient alpha:fade


        sampler2D _MainTex;
        sampler2D _BG;
        float4 _BG_ST;

        float3 _CenterPoint;
        float _Radius;
        float _Hardness;
        float _value1;
        float _value2;

        float   _RadiusLock;
        fixed4  _RadiusColor;
        float   _RadiusWidth;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
            float3 worldNormal;
            float3 worldPos;
            float4 screenPos;
        };

        fixed4 _Color;

        fixed4 LightingNoLighting(SurfaceOutput s, fixed3 lightDir, fixed atten) {
            fixed4 c;
            c.rgb = s.Albedo;
            c.a = s.Alpha;
            return c;
        }

        void surf(Input i, inout SurfaceOutput  o) {
            float2 textureCoordinate = i.screenPos.xy / i.screenPos.w;
            float aspect = _ScreenParams.x / _ScreenParams.y;
            textureCoordinate.y = 1 - textureCoordinate.y;
            textureCoordinate.x = 1 - textureCoordinate.x;
            textureCoordinate = TRANSFORM_TEX(textureCoordinate, _BG);

            fixed4 col = tex2D(_BG, textureCoordinate);
            //col *= _Color;
            float d = distance(_CenterPoint, i.worldPos);
            float border = pow(1 - saturate(dot(i.viewDir, i.worldNormal)), 2);

            // If the distance is larger than the radius and it is less than our radius + width change the color
            if ((d > _RadiusLock) && (d < (_RadiusLock + _RadiusWidth)))
            {
                o.Albedo = _RadiusColor;
            }
            else if ((d < (_RadiusLock + _RadiusWidth)))
            {
                if ((d - 0.02 > border) && (d < (border + 0.02)))
                {
                    o.Albedo = _RadiusColor;
                }
            }
            else {
                o.Albedo = col.rgb;
              }

            o.Alpha = saturate(saturate((length(_CenterPoint - i.worldPos) - _Radius) / (1.0 - _Hardness)) + saturate(1 - pow(dot(i.viewDir, i.worldNormal), _value2) * _value1));
        }
        ENDCG
    }
        FallBack "Diffuse"  */

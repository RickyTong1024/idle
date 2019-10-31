// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:False,bkdf:True,hqlp:False,rprd:False,enco:False,rmgx:True,imps:False,rpth:0,vtps:0,hqsc:False,nrmq:0,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:False,rfrpn:Refraction,coma:15,ufog:True,aust:False,igpj:False,qofs:0,qpre:1,rntp:1,fgom:True,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.005,fgrn:60,fgrf:150,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:1,x:33926,y:32549,varname:node_1,prsc:2|diff-152-OUT,emission-2095-OUT,lwrap-4672-OUT;n:type:ShaderForge.SFN_Tex2d,id:2,x:31967,y:31857,ptovrint:False,ptlb:D01,ptin:_D01,varname:_D01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False|UVIN-9963-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:9963,x:31775,y:31857,varname:node_9963,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_AmbientLight,id:2447,x:33215,y:32668,varname:node_2447,prsc:2;n:type:ShaderForge.SFN_Multiply,id:8121,x:33411,y:32690,varname:node_8121,prsc:2|A-2447-RGB,B-6890-RGB,C-6993-OUT;n:type:ShaderForge.SFN_Color,id:6890,x:33215,y:32825,ptovrint:False,ptlb:Amb_Color,ptin:_Amb_Color,varname:_Amb_Color,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Slider,id:6993,x:33107,y:33223,ptovrint:False,ptlb:Amb,ptin:_Amb,varname:_Amb,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_Fresnel,id:5498,x:32743,y:32481,varname:node_5498,prsc:2|EXP-1803-OUT;n:type:ShaderForge.SFN_ValueProperty,id:1803,x:32556,y:32500,ptovrint:False,ptlb:RimPower,ptin:_RimPower,varname:_RimPower,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:2.5;n:type:ShaderForge.SFN_Multiply,id:2620,x:32933,y:32555,varname:node_2620,prsc:2|A-5498-OUT,B-9454-OUT,C-5082-RGB,D-9192-OUT;n:type:ShaderForge.SFN_Slider,id:9454,x:32478,y:32619,ptovrint:False,ptlb:Rim_bright,ptin:_Rim_bright,varname:_Rim_bright,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:1,cur:1,max:5;n:type:ShaderForge.SFN_Color,id:5082,x:32586,y:32742,ptovrint:False,ptlb:RimColor,ptin:_RimColor,varname:_RimColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Dot,id:9192,x:32682,y:33088,varname:node_9192,prsc:2,dt:1|A-8143-XYZ,B-5459-OUT;n:type:ShaderForge.SFN_LightPosition,id:8143,x:32478,y:33010,varname:node_8143,prsc:2;n:type:ShaderForge.SFN_NormalVector,id:5459,x:32478,y:33149,prsc:2,pt:False;n:type:ShaderForge.SFN_Desaturate,id:152,x:33707,y:32394,varname:node_152,prsc:2|COL-8989-OUT,DES-6023-OUT;n:type:ShaderForge.SFN_ValueProperty,id:6023,x:33255,y:32494,ptovrint:False,ptlb:Desaturate,ptin:_Desaturate,varname:_Desaturate,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Desaturate,id:2095,x:33625,y:32581,varname:node_2095,prsc:2|COL-8573-OUT,DES-6023-OUT;n:type:ShaderForge.SFN_Desaturate,id:4672,x:33700,y:32700,varname:node_4672,prsc:2|COL-8121-OUT,DES-6023-OUT;n:type:ShaderForge.SFN_Add,id:8573,x:33167,y:32534,varname:node_8573,prsc:2|A-3063-OUT,B-2620-OUT;n:type:ShaderForge.SFN_ValueProperty,id:3063,x:32977,y:32416,ptovrint:False,ptlb:bright,ptin:_bright,varname:_bright,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_If,id:7323,x:32178,y:32337,varname:node_7323,prsc:2|A-8593-OUT,B-8919-OUT,GT-1777-OUT,EQ-3385-OUT,LT-3385-OUT;n:type:ShaderForge.SFN_Get,id:8593,x:31946,y:32238,varname:node_8593,prsc:2|IN-6434-OUT;n:type:ShaderForge.SFN_Vector1,id:8919,x:31946,y:32307,varname:node_8919,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Set,id:6434,x:32171,y:31857,varname:A,prsc:2|IN-2-RGB;n:type:ShaderForge.SFN_Set,id:1100,x:31967,y:32047,varname:B,prsc:2|IN-3530-RGB;n:type:ShaderForge.SFN_Multiply,id:3385,x:31946,y:32567,varname:node_3385,prsc:2|A-5493-OUT,B-8553-OUT,C-3504-OUT;n:type:ShaderForge.SFN_Subtract,id:1777,x:31946,y:32377,varname:node_1777,prsc:2|A-2498-OUT,B-1356-OUT;n:type:ShaderForge.SFN_Vector1,id:5493,x:31728,y:32568,varname:node_5493,prsc:2,v1:2;n:type:ShaderForge.SFN_Get,id:8553,x:31707,y:32630,varname:node_8553,prsc:2|IN-6434-OUT;n:type:ShaderForge.SFN_Get,id:3504,x:31707,y:32700,varname:node_3504,prsc:2|IN-1100-OUT;n:type:ShaderForge.SFN_Vector1,id:2498,x:31762,y:32325,varname:node_2498,prsc:2,v1:1;n:type:ShaderForge.SFN_Multiply,id:1356,x:31762,y:32397,varname:node_1356,prsc:2|A-1441-OUT,B-2792-OUT,C-1986-OUT;n:type:ShaderForge.SFN_Subtract,id:1441,x:31486,y:32332,varname:node_1441,prsc:2|A-1557-OUT,B-340-OUT;n:type:ShaderForge.SFN_Subtract,id:2792,x:31486,y:32489,varname:node_2792,prsc:2|A-1557-OUT,B-7986-OUT;n:type:ShaderForge.SFN_Vector1,id:1986,x:31486,y:32646,varname:node_1986,prsc:2,v1:2;n:type:ShaderForge.SFN_Get,id:340,x:31294,y:32352,varname:node_340,prsc:2|IN-6434-OUT;n:type:ShaderForge.SFN_Vector1,id:1557,x:31315,y:32419,varname:node_1557,prsc:2,v1:1;n:type:ShaderForge.SFN_Get,id:7986,x:31294,y:32503,varname:node_7986,prsc:2|IN-1100-OUT;n:type:ShaderForge.SFN_VertexColor,id:4860,x:32576,y:32322,varname:node_4860,prsc:2;n:type:ShaderForge.SFN_Multiply,id:8989,x:32911,y:32197,varname:node_8989,prsc:2|A-7323-OUT,B-4860-RGB;n:type:ShaderForge.SFN_Color,id:3530,x:31775,y:32047,ptovrint:False,ptlb:color,ptin:_color,varname:node_3530,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;proporder:2-3530-6993-6890-1803-9454-5082-6023-3063;pass:END;sub:END;*/

Shader "yh/Diffuse/Diffuse" {
    Properties {
        _D01 ("D01", 2D) = "black" {}
        _color ("color", Color) = (0.5,0.5,0.5,1)
        _Amb ("Amb", Range(0, 10)) = 0
        _Amb_Color ("Amb_Color", Color) = (1,1,1,1)
        _RimPower ("RimPower", Float ) = 2.5
        _Rim_bright ("Rim_bright", Range(1, 5)) = 1
        _RimColor ("RimColor", Color) = (1,1,1,1)
        _Desaturate ("Desaturate", Float ) = 0
        _bright ("bright", Float ) = 0
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define SHOULD_SAMPLE_SH ( defined (LIGHTMAP_OFF) && defined(DYNAMICLIGHTMAP_OFF) )
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma only_renderers d3d11 glcore gles gles3 metal d3d11_9x 
            #pragma target 3.0
            uniform sampler2D _D01; uniform float4 _D01_ST;
            uniform float4 _Amb_Color;
            uniform float _Amb;
            uniform float _RimPower;
            uniform float _Rim_bright;
            uniform float4 _RimColor;
            uniform float _Desaturate;
            uniform float _bright;
            uniform float4 _color;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float4 posWorld : TEXCOORD3;
                float3 normalDir : TEXCOORD4;
                float3 tangentDir : TEXCOORD5;
                float3 bitangentDir : TEXCOORD6;
                float4 vertexColor : COLOR;
                LIGHTING_COORDS(7,8)
                UNITY_FOG_COORDS(9)
                #if defined(LIGHTMAP_ON) || defined(UNITY_SHOULD_SAMPLE_SH)
                    float4 ambientOrLightmapUV : TEXCOORD10;
                #endif
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                o.vertexColor = v.vertexColor;
                #ifdef LIGHTMAP_ON
                    o.ambientOrLightmapUV.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                    o.ambientOrLightmapUV.zw = 0;
                #elif UNITY_SHOULD_SAMPLE_SH
                #endif
                #ifdef DYNAMICLIGHTMAP_ON
                    o.ambientOrLightmapUV.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
                #endif
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                UNITY_LIGHT_ATTENUATION(attenuation, i, i.posWorld.xyz);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// GI Data:
                UnityLight light;
                #ifdef LIGHTMAP_OFF
                    light.color = lightColor;
                    light.dir = lightDirection;
                    light.ndotl = LambertTerm (normalDirection, light.dir);
                #else
                    light.color = half3(0.f, 0.f, 0.f);
                    light.ndotl = 0.0f;
                    light.dir = half3(0.f, 0.f, 0.f);
                #endif
                UnityGIInput d;
                d.light = light;
                d.worldPos = i.posWorld.xyz;
                d.worldViewDir = viewDirection;
                d.atten = attenuation;
                #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
                    d.ambient = 0;
                    d.lightmapUV = i.ambientOrLightmapUV;
                #else
                    d.ambient = i.ambientOrLightmapUV;
                #endif
                Unity_GlossyEnvironmentData ugls_en_data;
                ugls_en_data.roughness = 1.0 - 0;
                ugls_en_data.reflUVW = viewReflectDirection;
                UnityGI gi = UnityGlobalIllumination(d, 1, normalDirection, ugls_en_data );
                lightDirection = gi.light.dir;
                lightColor = gi.light.color;
/////// Diffuse:
                float NdotL = dot( normalDirection, lightDirection );
                float3 w = lerp((UNITY_LIGHTMODEL_AMBIENT.rgb*_Amb_Color.rgb*_Amb),dot((UNITY_LIGHTMODEL_AMBIENT.rgb*_Amb_Color.rgb*_Amb),float3(0.3,0.59,0.11)),_Desaturate)*0.5; // Light wrapping
                float3 NdotLWrap = NdotL * ( 1.0 - w );
                float3 forwardLight = max(float3(0.0,0.0,0.0), NdotLWrap + w );
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = forwardLight * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += gi.indirect.diffuse;
                float4 _D01_var = tex2D(_D01,TRANSFORM_TEX(i.uv0, _D01));
                float3 A = _D01_var.rgb;
                float node_7323_if_leA = step(A,0.5);
                float node_7323_if_leB = step(0.5,A);
                float3 B = _color.rgb;
                float3 node_3385 = (2.0*A*B);
                float node_1557 = 1.0;
                float3 diffuseColor = lerp((lerp((node_7323_if_leA*node_3385)+(node_7323_if_leB*(1.0-((node_1557-A)*(node_1557-B)*2.0))),node_3385,node_7323_if_leA*node_7323_if_leB)*i.vertexColor.rgb),dot((lerp((node_7323_if_leA*node_3385)+(node_7323_if_leB*(1.0-((node_1557-A)*(node_1557-B)*2.0))),node_3385,node_7323_if_leA*node_7323_if_leB)*i.vertexColor.rgb),float3(0.3,0.59,0.11)),_Desaturate);
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
////// Emissive:
                float3 emissive = lerp((_bright+(pow(1.0-max(0,dot(normalDirection, viewDirection)),_RimPower)*_Rim_bright*_RimColor.rgb*max(0,dot(_WorldSpaceLightPos0.rgb,i.normalDir)))),dot((_bright+(pow(1.0-max(0,dot(normalDirection, viewDirection)),_RimPower)*_Rim_bright*_RimColor.rgb*max(0,dot(_WorldSpaceLightPos0.rgb,i.normalDir)))),float3(0.3,0.59,0.11)),_Desaturate);
/// Final Color:
                float3 finalColor = diffuse + emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define SHOULD_SAMPLE_SH ( defined (LIGHTMAP_OFF) && defined(DYNAMICLIGHTMAP_OFF) )
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma only_renderers d3d11 glcore gles gles3 metal d3d11_9x 
            #pragma target 3.0
            uniform sampler2D _D01; uniform float4 _D01_ST;
            uniform float4 _Amb_Color;
            uniform float _Amb;
            uniform float _RimPower;
            uniform float _Rim_bright;
            uniform float4 _RimColor;
            uniform float _Desaturate;
            uniform float _bright;
            uniform float4 _color;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float4 posWorld : TEXCOORD3;
                float3 normalDir : TEXCOORD4;
                float3 tangentDir : TEXCOORD5;
                float3 bitangentDir : TEXCOORD6;
                float4 vertexColor : COLOR;
                LIGHTING_COORDS(7,8)
                UNITY_FOG_COORDS(9)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                o.vertexColor = v.vertexColor;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                UNITY_LIGHT_ATTENUATION(attenuation, i, i.posWorld.xyz);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = dot( normalDirection, lightDirection );
                float3 w = lerp((UNITY_LIGHTMODEL_AMBIENT.rgb*_Amb_Color.rgb*_Amb),dot((UNITY_LIGHTMODEL_AMBIENT.rgb*_Amb_Color.rgb*_Amb),float3(0.3,0.59,0.11)),_Desaturate)*0.5; // Light wrapping
                float3 NdotLWrap = NdotL * ( 1.0 - w );
                float3 forwardLight = max(float3(0.0,0.0,0.0), NdotLWrap + w );
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = forwardLight * attenColor;
                float4 _D01_var = tex2D(_D01,TRANSFORM_TEX(i.uv0, _D01));
                float3 A = _D01_var.rgb;
                float node_7323_if_leA = step(A,0.5);
                float node_7323_if_leB = step(0.5,A);
                float3 B = _color.rgb;
                float3 node_3385 = (2.0*A*B);
                float node_1557 = 1.0;
                float3 diffuseColor = lerp((lerp((node_7323_if_leA*node_3385)+(node_7323_if_leB*(1.0-((node_1557-A)*(node_1557-B)*2.0))),node_3385,node_7323_if_leA*node_7323_if_leB)*i.vertexColor.rgb),dot((lerp((node_7323_if_leA*node_3385)+(node_7323_if_leB*(1.0-((node_1557-A)*(node_1557-B)*2.0))),node_3385,node_7323_if_leA*node_7323_if_leB)*i.vertexColor.rgb),float3(0.3,0.59,0.11)),_Desaturate);
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse;
                fixed4 finalRGBA = fixed4(finalColor * 1,0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}

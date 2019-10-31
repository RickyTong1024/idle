// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:False,bkdf:True,hqlp:False,rprd:False,enco:False,rmgx:True,imps:False,rpth:0,vtps:0,hqsc:False,nrmq:0,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:False,rfrpn:Refraction,coma:15,ufog:True,aust:False,igpj:False,qofs:0,qpre:1,rntp:1,fgom:True,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.005,fgrn:60,fgrf:150,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:1,x:33926,y:32549,varname:node_1,prsc:2|diff-152-OUT,emission-2095-OUT,lwrap-4672-OUT;n:type:ShaderForge.SFN_Tex2d,id:2,x:31726,y:32262,ptovrint:False,ptlb:D01,ptin:_D01,varname:_D01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False|UVIN-9963-UVOUT;n:type:ShaderForge.SFN_Power,id:130,x:33719,y:32171,varname:node_130,prsc:2|VAL-195-OUT,EXP-132-OUT;n:type:ShaderForge.SFN_ValueProperty,id:132,x:33529,y:32190,ptovrint:False,ptlb:Tex_Power,ptin:_Tex_Power,varname:_Tex_Power,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Code,id:1817,x:31949,y:31675,varname:node_1817,prsc:2,code:ZgBsAG8AYQB0ADQAIABrACAAPQBmAGwAbwBhAHQANAAoADAALgAwACwALQAxAC4AMAAvADMALgAwACwAMgAuADAALwAzAC4AMAAsAC0AMQAuADAAKQA7AAoAZgBsAG8AYQB0ADQAIABwACAAPQBSAEcAQgAuAGcAPABSAEcAQgAuAGIAPwBmAGwAbwBhAHQANAAoAFIARwBCAC4AYgAsAFIARwBCAC4AZwAsAGsALgB3ACwAawAuAHoAKQA6AGYAbABvAGEAdAA0ACgAUgBHAEIALgBnAGIALABrAC4AeAB5ACkAOwAKAGYAbABvAGEAdAA0ACAAcQAgAD0AUgBHAEIALgByADwAcAAuAHgAIAAgAD8AZgBsAG8AYQB0ADQAKABwAC4AeAAsAHAALgB5ACwAcAAuAHcALABSAEcAQgAuAHIAKQA6AGYAbABvAGEAdAA0ACgAUgBHAEIALgByACwAcAAuAHkAegB4ACkAOwAKAGYAbABvAGEAdAAgAGQAIAA9AHEALgB4AC0AbQBpAG4AKABxAC4AdwAsAHEALgB5ACkAOwAKAGYAbABvAGEAdAAgAGUAPQAxAC4AMABlAC0AMQAwADsACgByAGUAdAB1AHIAbgAgAGYAbABvAGEAdAAzACgAYQBiAHMAKABxAC4AegArACgAcQAuAHcALQBxAC4AeQApAC8AKAA2AC4AMAAqAGQAKwBlACkAKQAsAGQALwAoAHEALgB4ACsAZQApACwAcQAuAHgAKQA7AA==,output:2,fname:RGBtoHSV,width:716,height:154,input:2,input_1_label:RGB|A-6966-OUT;n:type:ShaderForge.SFN_Code,id:1819,x:33434,y:31545,varname:node_1819,prsc:2,code:ZgBsAG8AYQB0ADQAIABrACAAPQAgAGYAbABvAGEAdAA0ACgAMQAuADAALAAyAC4AMAAvADMALgAwACwAMQAuADAALwAzAC4AMAAsADMALgAwACkAOwAKAGYAbABvAGEAdAAzACAAcAAgAD0AYQBiAHMAKABmAHIAYQBjACgASABTAFYALgB4AHgAeAArAGsALgB4AHkAegApACoANgAuADAALQBrAC4AdwB3AHcAKQA7AAoAcgBlAHQAdQByAG4AIABIAFMAVgAuAHoAKgBsAGUAcgBwACgAawAuAHgAeAB4ACwAYwBsAGEAbQBwACgAcAAtAGsALgB4AHgAeAAsADAALgAwACwAMQAuADAAKQAsAEgAUwBWAC4AeQApADsA,output:2,fname:HSVtoRGB,width:699,height:127,input:2,input_1_label:HSV|A-1960-OUT;n:type:ShaderForge.SFN_Add,id:1939,x:32944,y:31442,varname:node_1939,prsc:2|A-1953-X,B-1969-R;n:type:ShaderForge.SFN_Vector4Property,id:1953,x:32733,y:31524,ptovrint:False,ptlb:Hsv,ptin:_Hsv,varname:_Hsv,prsc:0,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1,v2:1,v3:1,v4:1;n:type:ShaderForge.SFN_Append,id:1960,x:33261,y:31544,varname:node_1960,prsc:2|A-1962-OUT,B-1967-OUT;n:type:ShaderForge.SFN_Append,id:1962,x:33098,y:31544,varname:node_1962,prsc:2|A-1939-OUT,B-1964-OUT;n:type:ShaderForge.SFN_Multiply,id:1964,x:32944,y:31563,varname:node_1964,prsc:2|A-1953-Y,B-1969-G;n:type:ShaderForge.SFN_Multiply,id:1967,x:32944,y:31695,varname:node_1967,prsc:2|A-1953-Z,B-1969-B;n:type:ShaderForge.SFN_ComponentMask,id:1969,x:32733,y:31674,varname:node_1969,prsc:0,cc1:0,cc2:1,cc3:2,cc4:-1|IN-1817-OUT;n:type:ShaderForge.SFN_Min,id:6966,x:31785,y:31981,varname:node_6966,prsc:2|A-139-RGB,B-2-RGB;n:type:ShaderForge.SFN_Color,id:139,x:31435,y:31802,ptovrint:False,ptlb:D01_Color,ptin:_D01_Color,varname:_D01_Color,prsc:0,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_TexCoord,id:9963,x:31534,y:32262,varname:node_9963,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_AmbientLight,id:2447,x:33215,y:32668,varname:node_2447,prsc:2;n:type:ShaderForge.SFN_Multiply,id:8121,x:33411,y:32690,varname:node_8121,prsc:2|A-2447-RGB,B-6890-RGB,C-6993-OUT;n:type:ShaderForge.SFN_Color,id:6890,x:33215,y:32825,ptovrint:False,ptlb:Amb_Color,ptin:_Amb_Color,varname:_Amb_Color,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Slider,id:6993,x:33107,y:33223,ptovrint:False,ptlb:Amb,ptin:_Amb,varname:_Amb,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_Fresnel,id:5498,x:32743,y:32481,varname:node_5498,prsc:2|EXP-1803-OUT;n:type:ShaderForge.SFN_ValueProperty,id:1803,x:32556,y:32500,ptovrint:False,ptlb:RimPower,ptin:_RimPower,varname:_RimPower,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:2.5;n:type:ShaderForge.SFN_Multiply,id:2620,x:32933,y:32555,varname:node_2620,prsc:2|A-5498-OUT,B-9454-OUT,C-5082-RGB,D-9192-OUT;n:type:ShaderForge.SFN_Slider,id:9454,x:32478,y:32619,ptovrint:False,ptlb:Rim_bright,ptin:_Rim_bright,varname:_Rim_bright,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:1,cur:1,max:5;n:type:ShaderForge.SFN_Color,id:5082,x:32586,y:32742,ptovrint:False,ptlb:RimColor,ptin:_RimColor,varname:_RimColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Dot,id:9192,x:32682,y:33088,varname:node_9192,prsc:2,dt:1|A-8143-XYZ,B-5459-OUT;n:type:ShaderForge.SFN_LightPosition,id:8143,x:32478,y:33010,varname:node_8143,prsc:2;n:type:ShaderForge.SFN_NormalVector,id:5459,x:32478,y:33149,prsc:2,pt:False;n:type:ShaderForge.SFN_Desaturate,id:152,x:33707,y:32394,varname:node_152,prsc:2|COL-130-OUT,DES-6023-OUT;n:type:ShaderForge.SFN_ValueProperty,id:6023,x:33275,y:32410,ptovrint:False,ptlb:Desaturate,ptin:_Desaturate,varname:_Desaturate,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Desaturate,id:2095,x:33625,y:32581,varname:node_2095,prsc:2|COL-8573-OUT,DES-6023-OUT;n:type:ShaderForge.SFN_Desaturate,id:4672,x:33700,y:32700,varname:node_4672,prsc:2|COL-8121-OUT,DES-6023-OUT;n:type:ShaderForge.SFN_Add,id:8573,x:33167,y:32534,varname:node_8573,prsc:2|A-3063-OUT,B-2620-OUT,C-5630-OUT;n:type:ShaderForge.SFN_ValueProperty,id:3063,x:32977,y:32416,ptovrint:False,ptlb:bright,ptin:_bright,varname:_bright,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Clamp01,id:195,x:34245,y:31544,varname:node_195,prsc:2|IN-1819-OUT;n:type:ShaderForge.SFN_Tex2d,id:7870,x:33006,y:33484,ptovrint:False,ptlb:E01,ptin:_E01,varname:_E01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-6182-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:9891,x:32168,y:33305,varname:node_9891,prsc:2,uv:1,uaff:False;n:type:ShaderForge.SFN_Rotator,id:6182,x:32812,y:33484,varname:node_6182,prsc:2|UVIN-7168-OUT,ANG-7201-OUT;n:type:ShaderForge.SFN_Multiply,id:7201,x:32629,y:33640,varname:node_7201,prsc:2|A-5095-OUT,B-6552-OUT;n:type:ShaderForge.SFN_Pi,id:5095,x:32488,y:33640,varname:node_5095,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:6552,x:32455,y:33768,ptovrint:False,ptlb:E01_UVangle,ptin:_E01_UVangle,varname:_E01_UVangle,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Panner,id:2925,x:32415,y:33321,varname:node_2925,prsc:2,spu:1,spv:0|UVIN-9891-UVOUT,DIST-3782-OUT;n:type:ShaderForge.SFN_Multiply,id:3782,x:32168,y:33461,varname:node_3782,prsc:2|A-299-T,B-2960-OUT;n:type:ShaderForge.SFN_Time,id:299,x:31921,y:33390,varname:node_299,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:2960,x:31921,y:33583,ptovrint:False,ptlb:E01_UVpan_speed,ptin:_E01_UVpan_speed,varname:_E01_UVpan_speed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_SwitchProperty,id:7168,x:32617,y:33388,ptovrint:False,ptlb:E01_U/Vpan,ptin:_E01_UVpan,varname:_E01_UVpan,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-2925-UVOUT,B-8597-UVOUT;n:type:ShaderForge.SFN_Panner,id:8597,x:32415,y:33478,varname:node_8597,prsc:2,spu:0,spv:1|UVIN-9891-UVOUT,DIST-3782-OUT;n:type:ShaderForge.SFN_Multiply,id:9695,x:33235,y:33484,varname:node_9695,prsc:2|A-7870-RGB,B-5291-RGB,C-3104-OUT;n:type:ShaderForge.SFN_Color,id:5291,x:33073,y:33940,ptovrint:False,ptlb:E01_Color,ptin:_E01_Color,varname:_E01_Color,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_ValueProperty,id:3104,x:33006,y:33719,ptovrint:False,ptlb:E01_bright,ptin:_E01_bright,varname:_E01_bright,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Tex2d,id:3811,x:33221,y:33691,ptovrint:False,ptlb:E01_mask,ptin:_E01_mask,varname:_E01_mask,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-9891-UVOUT;n:type:ShaderForge.SFN_Multiply,id:5630,x:33421,y:33484,varname:node_5630,prsc:2|A-9695-OUT,B-3811-RGB;proporder:132-2-139-1953-6993-6890-1803-9454-5082-6023-3063-7870-5291-6552-3104-7168-2960-3811;pass:END;sub:END;*/

Shader "yh/Diffuse/Diffuse_flowTex01" {
    Properties {
        _Tex_Power ("Tex_Power", Float ) = 1
        _D01 ("D01", 2D) = "black" {}
        _D01_Color ("D01_Color", Color) = (1,1,1,1)
        _Hsv ("Hsv", Vector) = (1,1,1,1)
        _Amb ("Amb", Range(0, 10)) = 0
        _Amb_Color ("Amb_Color", Color) = (1,1,1,1)
        _RimPower ("RimPower", Float ) = 2.5
        _Rim_bright ("Rim_bright", Range(1, 5)) = 1
        _RimColor ("RimColor", Color) = (1,1,1,1)
        _Desaturate ("Desaturate", Float ) = 0
        _bright ("bright", Float ) = 0
        _E01 ("E01", 2D) = "white" {}
        _E01_Color ("E01_Color", Color) = (1,1,1,1)
        _E01_UVangle ("E01_UVangle", Float ) = 0
        _E01_bright ("E01_bright", Float ) = 1
        [MaterialToggle] _E01_UVpan ("E01_U/Vpan", Float ) = 0
        _E01_UVpan_speed ("E01_UVpan_speed", Float ) = 0
        _E01_mask ("E01_mask", 2D) = "white" {}
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
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x 
            #pragma target 3.0
            uniform sampler2D _D01; uniform float4 _D01_ST;
            uniform float _Tex_Power;
            float3 RGBtoHSV( float3 RGB ){
            float4 k =float4(0.0,-1.0/3.0,2.0/3.0,-1.0);
            float4 p =RGB.g<RGB.b?float4(RGB.b,RGB.g,k.w,k.z):float4(RGB.gb,k.xy);
            float4 q =RGB.r<p.x  ?float4(p.x,p.y,p.w,RGB.r):float4(RGB.r,p.yzx);
            float d =q.x-min(q.w,q.y);
            float e=1.0e-10;
            return float3(abs(q.z+(q.w-q.y)/(6.0*d+e)),d/(q.x+e),q.x);
            }
            
            float3 HSVtoRGB( float3 HSV ){
            float4 k = float4(1.0,2.0/3.0,1.0/3.0,3.0);
            float3 p =abs(frac(HSV.xxx+k.xyz)*6.0-k.www);
            return HSV.z*lerp(k.xxx,clamp(p-k.xxx,0.0,1.0),HSV.y);
            }
            
            uniform fixed4 _Hsv;
            uniform fixed4 _D01_Color;
            uniform float4 _Amb_Color;
            uniform float _Amb;
            uniform float _RimPower;
            uniform float _Rim_bright;
            uniform float4 _RimColor;
            uniform float _Desaturate;
            uniform float _bright;
            uniform sampler2D _E01; uniform float4 _E01_ST;
            uniform float _E01_UVangle;
            uniform float _E01_UVpan_speed;
            uniform fixed _E01_UVpan;
            uniform float4 _E01_Color;
            uniform float _E01_bright;
            uniform sampler2D _E01_mask; uniform float4 _E01_mask_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
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
                fixed3 node_1969 = RGBtoHSV( min(_D01_Color.rgb,_D01_var.rgb) ).rgb;
                float3 diffuseColor = lerp(pow(saturate(HSVtoRGB( float3(float2((_Hsv.r+node_1969.r),(_Hsv.g*node_1969.g)),(_Hsv.b*node_1969.b)) )),_Tex_Power),dot(pow(saturate(HSVtoRGB( float3(float2((_Hsv.r+node_1969.r),(_Hsv.g*node_1969.g)),(_Hsv.b*node_1969.b)) )),_Tex_Power),float3(0.3,0.59,0.11)),_Desaturate);
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
////// Emissive:
                float node_6182_ang = (3.141592654*_E01_UVangle);
                float node_6182_spd = 1.0;
                float node_6182_cos = cos(node_6182_spd*node_6182_ang);
                float node_6182_sin = sin(node_6182_spd*node_6182_ang);
                float2 node_6182_piv = float2(0.5,0.5);
                float4 node_299 = _Time;
                float node_3782 = (node_299.g*_E01_UVpan_speed);
                float2 node_6182 = (mul(lerp( (i.uv1+node_3782*float2(1,0)), (i.uv1+node_3782*float2(0,1)), _E01_UVpan )-node_6182_piv,float2x2( node_6182_cos, -node_6182_sin, node_6182_sin, node_6182_cos))+node_6182_piv);
                float4 _E01_var = tex2D(_E01,TRANSFORM_TEX(node_6182, _E01));
                float4 _E01_mask_var = tex2D(_E01_mask,TRANSFORM_TEX(i.uv1, _E01_mask));
                float3 emissive = lerp((_bright+(pow(1.0-max(0,dot(normalDirection, viewDirection)),_RimPower)*_Rim_bright*_RimColor.rgb*max(0,dot(_WorldSpaceLightPos0.rgb,i.normalDir)))+((_E01_var.rgb*_E01_Color.rgb*_E01_bright)*_E01_mask_var.rgb)),dot((_bright+(pow(1.0-max(0,dot(normalDirection, viewDirection)),_RimPower)*_Rim_bright*_RimColor.rgb*max(0,dot(_WorldSpaceLightPos0.rgb,i.normalDir)))+((_E01_var.rgb*_E01_Color.rgb*_E01_bright)*_E01_mask_var.rgb)),float3(0.3,0.59,0.11)),_Desaturate);
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
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x 
            #pragma target 3.0
            uniform sampler2D _D01; uniform float4 _D01_ST;
            uniform float _Tex_Power;
            float3 RGBtoHSV( float3 RGB ){
            float4 k =float4(0.0,-1.0/3.0,2.0/3.0,-1.0);
            float4 p =RGB.g<RGB.b?float4(RGB.b,RGB.g,k.w,k.z):float4(RGB.gb,k.xy);
            float4 q =RGB.r<p.x  ?float4(p.x,p.y,p.w,RGB.r):float4(RGB.r,p.yzx);
            float d =q.x-min(q.w,q.y);
            float e=1.0e-10;
            return float3(abs(q.z+(q.w-q.y)/(6.0*d+e)),d/(q.x+e),q.x);
            }
            
            float3 HSVtoRGB( float3 HSV ){
            float4 k = float4(1.0,2.0/3.0,1.0/3.0,3.0);
            float3 p =abs(frac(HSV.xxx+k.xyz)*6.0-k.www);
            return HSV.z*lerp(k.xxx,clamp(p-k.xxx,0.0,1.0),HSV.y);
            }
            
            uniform fixed4 _Hsv;
            uniform fixed4 _D01_Color;
            uniform float4 _Amb_Color;
            uniform float _Amb;
            uniform float _RimPower;
            uniform float _Rim_bright;
            uniform float4 _RimColor;
            uniform float _Desaturate;
            uniform float _bright;
            uniform sampler2D _E01; uniform float4 _E01_ST;
            uniform float _E01_UVangle;
            uniform float _E01_UVpan_speed;
            uniform fixed _E01_UVpan;
            uniform float4 _E01_Color;
            uniform float _E01_bright;
            uniform sampler2D _E01_mask; uniform float4 _E01_mask_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
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
                LIGHTING_COORDS(7,8)
                UNITY_FOG_COORDS(9)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
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
                fixed3 node_1969 = RGBtoHSV( min(_D01_Color.rgb,_D01_var.rgb) ).rgb;
                float3 diffuseColor = lerp(pow(saturate(HSVtoRGB( float3(float2((_Hsv.r+node_1969.r),(_Hsv.g*node_1969.g)),(_Hsv.b*node_1969.b)) )),_Tex_Power),dot(pow(saturate(HSVtoRGB( float3(float2((_Hsv.r+node_1969.r),(_Hsv.g*node_1969.g)),(_Hsv.b*node_1969.b)) )),_Tex_Power),float3(0.3,0.59,0.11)),_Desaturate);
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

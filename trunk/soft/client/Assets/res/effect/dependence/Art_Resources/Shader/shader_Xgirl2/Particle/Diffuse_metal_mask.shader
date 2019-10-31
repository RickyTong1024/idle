// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:False,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:False,nrmq:0,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:False,rfrpn:Refraction,coma:15,ufog:True,aust:False,igpj:False,qofs:0,qpre:1,rntp:1,fgom:True,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.2279412,fgcg:0.2279412,fgcb:0.2279412,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:1,x:34779,y:32391,varname:node_1,prsc:2|diff-579-OUT,emission-514-OUT,lwrap-7307-OUT,amdfl-3156-OUT,alpha-9156-A;n:type:ShaderForge.SFN_Cubemap,id:129,x:33345,y:32537,ptovrint:False,ptlb:Cubemap,ptin:_Cubemap,varname:_Cubemap,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,pvfc:0|DIR-1052-OUT;n:type:ShaderForge.SFN_Tex2d,id:570,x:32165,y:31925,ptovrint:False,ptlb:D01,ptin:_D01,varname:_D01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False|UVIN-1199-UVOUT;n:type:ShaderForge.SFN_Power,id:579,x:34867,y:32139,varname:node_579,prsc:2|VAL-6854-OUT,EXP-580-OUT;n:type:ShaderForge.SFN_ValueProperty,id:580,x:34617,y:32158,ptovrint:False,ptlb:Tex_power,ptin:_Tex_power,varname:_Tex_power,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Code,id:1975,x:32596,y:31555,varname:node_1975,prsc:2,code:ZgBsAG8AYQB0ADQAIABrACAAPQBmAGwAbwBhAHQANAAoADAALgAwACwALQAxAC4AMAAvADMALgAwACwAMgAuADAALwAzAC4AMAAsAC0AMQAuADAAKQA7AAoAZgBsAG8AYQB0ADQAIABwACAAPQBSAEcAQgAuAGcAPABSAEcAQgAuAGIAPwBmAGwAbwBhAHQANAAoAFIARwBCAC4AYgAsAFIARwBCAC4AZwAsAGsALgB3ACwAawAuAHoAKQA6AGYAbABvAGEAdAA0ACgAUgBHAEIALgBnAGIALABrAC4AeAB5ACkAOwAKAGYAbABvAGEAdAA0ACAAcQAgAD0AUgBHAEIALgByADwAcAAuAHgAIAAgAD8AZgBsAG8AYQB0ADQAKABwAC4AeAAsAHAALgB5ACwAcAAuAHcALABSAEcAQgAuAHIAKQA6AGYAbABvAGEAdAA0ACgAUgBHAEIALgByACwAcAAuAHkAegB4ACkAOwAKAGYAbABvAGEAdAAgAGQAIAA9AHEALgB4AC0AbQBpAG4AKABxAC4AdwAsAHEALgB5ACkAOwAKAGYAbABvAGEAdAAgAGUAPQAxAC4AMABlAC0AMQAwADsACgByAGUAdAB1AHIAbgAgAGYAbABvAGEAdAAzACgAYQBiAHMAKABxAC4AegArACgAcQAuAHcALQBxAC4AeQApAC8AKAA2AC4AMAAqAGQAKwBlACkAKQAsAGQALwAoAHEALgB4ACsAZQApACwAcQAuAHgAKQA7AA==,output:2,fname:RGBtoHSV,width:716,height:154,input:2,input_1_label:RGB|A-8825-OUT;n:type:ShaderForge.SFN_Code,id:1977,x:34081,y:31425,varname:node_1977,prsc:2,code:ZgBsAG8AYQB0ADQAIABrACAAPQAgAGYAbABvAGEAdAA0ACgAMQAuADAALAAyAC4AMAAvADMALgAwACwAMQAuADAALwAzAC4AMAAsADMALgAwACkAOwAKAGYAbABvAGEAdAAzACAAcAAgAD0AYQBiAHMAKABmAHIAYQBjACgASABTAFYALgB4AHgAeAArAGsALgB4AHkAegApACoANgAuADAALQBrAC4AdwB3AHcAKQA7AAoAcgBlAHQAdQByAG4AIABIAFMAVgAuAHoAKgBsAGUAcgBwACgAawAuAHgAeAB4ACwAYwBsAGEAbQBwACgAcAAtAGsALgB4AHgAeAAsADAALgAwACwAMQAuADAAKQAsAEgAUwBWAC4AeQApADsA,output:2,fname:HSVtoRGB,width:699,height:127,input:2,input_1_label:HSV|A-1983-OUT;n:type:ShaderForge.SFN_Add,id:1979,x:33591,y:31322,varname:node_1979,prsc:2|A-1981-X,B-1991-R;n:type:ShaderForge.SFN_Vector4Property,id:1981,x:33380,y:31404,ptovrint:False,ptlb:Hsv,ptin:_Hsv,varname:_HSV,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1,v2:1,v3:1,v4:1;n:type:ShaderForge.SFN_Append,id:1983,x:33908,y:31424,varname:node_1983,prsc:2|A-1985-OUT,B-1989-OUT;n:type:ShaderForge.SFN_Append,id:1985,x:33745,y:31424,varname:node_1985,prsc:2|A-1979-OUT,B-1987-OUT;n:type:ShaderForge.SFN_Multiply,id:1987,x:33591,y:31443,varname:node_1987,prsc:2|A-1981-Y,B-1991-G;n:type:ShaderForge.SFN_Multiply,id:1989,x:33591,y:31575,varname:node_1989,prsc:2|A-1981-Z,B-1991-B;n:type:ShaderForge.SFN_ComponentMask,id:1991,x:33380,y:31554,varname:node_1991,prsc:2,cc1:0,cc2:1,cc3:2,cc4:-1|IN-1975-OUT;n:type:ShaderForge.SFN_Fresnel,id:2005,x:33765,y:32944,varname:node_2005,prsc:2|EXP-2007-OUT;n:type:ShaderForge.SFN_ValueProperty,id:2007,x:33585,y:32947,ptovrint:False,ptlb:RimPower,ptin:_RimPower,varname:_RimPower,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:3;n:type:ShaderForge.SFN_Multiply,id:2009,x:33959,y:32944,varname:node_2009,prsc:2|A-2005-OUT,B-9798-OUT,C-2011-RGB,D-7345-OUT;n:type:ShaderForge.SFN_Color,id:2011,x:33754,y:33090,ptovrint:False,ptlb:RimColor,ptin:_RimColor,varname:_RimColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_ViewReflectionVector,id:1052,x:33124,y:32547,varname:node_1052,prsc:2;n:type:ShaderForge.SFN_Slider,id:8824,x:33300,y:32738,ptovrint:False,ptlb:Cubemap_brightness,ptin:_Cubemap_brightness,varname:_Cubemap_brightness,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:2;n:type:ShaderForge.SFN_Multiply,id:8825,x:32392,y:31925,varname:node_8825,prsc:2|A-3580-RGB,B-570-RGB,C-9156-RGB;n:type:ShaderForge.SFN_Color,id:3580,x:32165,y:31754,ptovrint:False,ptlb:D01_Color,ptin:_D01_Color,varname:_D01_Color,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Slider,id:9798,x:33428,y:33031,ptovrint:False,ptlb:Rim_bright,ptin:_Rim_bright,varname:_Rim_bright,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:1,cur:1,max:5;n:type:ShaderForge.SFN_Dot,id:7345,x:33754,y:33251,varname:node_7345,prsc:2,dt:1|A-5379-XYZ,B-1842-OUT;n:type:ShaderForge.SFN_LightPosition,id:5379,x:33506,y:33251,varname:node_5379,prsc:2;n:type:ShaderForge.SFN_NormalVector,id:1842,x:33506,y:33399,prsc:2,pt:False;n:type:ShaderForge.SFN_Multiply,id:5560,x:34393,y:32959,varname:node_5560,prsc:2|A-5893-RGB,B-1179-RGB,C-9437-OUT;n:type:ShaderForge.SFN_AmbientLight,id:5893,x:34169,y:32959,varname:node_5893,prsc:2;n:type:ShaderForge.SFN_Color,id:1179,x:34169,y:33105,ptovrint:False,ptlb:Amb_Color,ptin:_Amb_Color,varname:_Amb_Color,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Slider,id:9437,x:34072,y:33317,ptovrint:False,ptlb:Amb,ptin:_Amb,varname:_Amb,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_Multiply,id:3357,x:33669,y:32540,varname:node_3357,prsc:2|A-129-RGB,B-4579-RGB,C-8824-OUT;n:type:ShaderForge.SFN_VertexColor,id:9156,x:32165,y:32092,varname:node_9156,prsc:2;n:type:ShaderForge.SFN_Desaturate,id:6854,x:34853,y:31861,varname:node_6854,prsc:2|COL-1977-OUT,DES-7493-OUT;n:type:ShaderForge.SFN_Desaturate,id:7307,x:34573,y:32712,varname:node_7307,prsc:2|COL-5560-OUT,DES-7493-OUT;n:type:ShaderForge.SFN_ValueProperty,id:7493,x:34246,y:32385,ptovrint:False,ptlb:Desaturate,ptin:_Desaturate,varname:_Desaturate,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Add,id:514,x:34169,y:32838,varname:node_514,prsc:2|A-3323-OUT,B-2009-OUT;n:type:ShaderForge.SFN_ValueProperty,id:3323,x:33959,y:32838,ptovrint:False,ptlb:bright,ptin:_bright,varname:_bright,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_AmbientLight,id:4579,x:33475,y:32604,varname:node_4579,prsc:2;n:type:ShaderForge.SFN_Clamp01,id:3849,x:33860,y:32540,varname:node_3849,prsc:2|IN-3357-OUT;n:type:ShaderForge.SFN_TexCoord,id:1199,x:31877,y:31924,varname:node_1199,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Multiply,id:3156,x:34089,y:32433,varname:node_3156,prsc:2|A-2201-RGB,B-3849-OUT;n:type:ShaderForge.SFN_Tex2d,id:2201,x:33841,y:32260,ptovrint:False,ptlb:Cubemap_mask,ptin:_Cubemap_mask,varname:node_2201,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False;proporder:580-570-3580-1981-129-2201-8824-2011-2007-9798-9437-1179-7493-3323;pass:END;sub:END;*/

Shader "yh/Diffuse/Diffuse_metal_mask" {
    Properties {
        _Tex_power ("Tex_power", Float ) = 1
        _D01 ("D01", 2D) = "black" {}
        _D01_Color ("D01_Color", Color) = (1,1,1,1)
        _Hsv ("Hsv", Vector) = (1,1,1,1)
        _Cubemap ("Cubemap", Cube) = "_Skybox" {}
        _Cubemap_mask ("Cubemap_mask", 2D) = "black" {}
        _Cubemap_brightness ("Cubemap_brightness", Range(0, 2)) = 1
        _RimColor ("RimColor", Color) = (1,1,1,1)
        _RimPower ("RimPower", Float ) = 3
        _Rim_bright ("Rim_bright", Range(1, 5)) = 1
        _Amb ("Amb", Range(0, 10)) = 0
        _Amb_Color ("Amb_Color", Color) = (1,1,1,1)
        _Desaturate ("Desaturate", Float ) = 0
        _bright ("bright", Float ) = 0
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
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
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d11 glcore gles gles3 metal d3d11_9x 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform samplerCUBE _Cubemap;
            uniform sampler2D _D01; uniform float4 _D01_ST;
            uniform float _Tex_power;
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
            
            uniform float4 _Hsv;
            uniform float _RimPower;
            uniform float4 _RimColor;
            uniform float _Cubemap_brightness;
            uniform float4 _D01_Color;
            uniform float _Rim_bright;
            uniform float4 _Amb_Color;
            uniform float _Amb;
            uniform float _Desaturate;
            uniform float _bright;
            uniform sampler2D _Cubemap_mask; uniform float4 _Cubemap_mask_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float4 vertexColor : COLOR;
                LIGHTING_COORDS(3,4)
                UNITY_FOG_COORDS(5)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
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
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                float4 _Cubemap_mask_var = tex2D(_Cubemap_mask,TRANSFORM_TEX(i.uv0, _Cubemap_mask));
                indirectDiffuse += (_Cubemap_mask_var.rgb*saturate((texCUBE(_Cubemap,viewReflectDirection).rgb*UNITY_LIGHTMODEL_AMBIENT.rgb*_Cubemap_brightness))); // Diffuse Ambient Light
                float4 _D01_var = tex2D(_D01,TRANSFORM_TEX(i.uv0, _D01));
                float3 node_1991 = RGBtoHSV( (_D01_Color.rgb*_D01_var.rgb*i.vertexColor.rgb) ).rgb;
                float3 node_579 = pow(lerp(HSVtoRGB( float3(float2((_Hsv.r+node_1991.r),(_Hsv.g*node_1991.g)),(_Hsv.b*node_1991.b)) ),dot(HSVtoRGB( float3(float2((_Hsv.r+node_1991.r),(_Hsv.g*node_1991.g)),(_Hsv.b*node_1991.b)) ),float3(0.3,0.59,0.11)),_Desaturate),_Tex_power);
                float3 diffuseColor = float3(node_579);
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
////// Emissive:
                float3 emissive = (_bright+(pow(1.0-max(0,dot(normalDirection, viewDirection)),_RimPower)*_Rim_bright*_RimColor.rgb*max(0,dot(_WorldSpaceLightPos0.rgb,i.normalDir))));
/// Final Color:
                float3 finalColor = diffuse + emissive;
                fixed4 finalRGBA = fixed4(finalColor,i.vertexColor.a);
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
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d11 glcore gles gles3 metal d3d11_9x 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _D01; uniform float4 _D01_ST;
            uniform float _Tex_power;
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
            
            uniform float4 _Hsv;
            uniform float _RimPower;
            uniform float4 _RimColor;
            uniform float4 _D01_Color;
            uniform float _Rim_bright;
            uniform float4 _Amb_Color;
            uniform float _Amb;
            uniform float _Desaturate;
            uniform float _bright;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float4 vertexColor : COLOR;
                LIGHTING_COORDS(3,4)
                UNITY_FOG_COORDS(5)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
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
                float3 node_1991 = RGBtoHSV( (_D01_Color.rgb*_D01_var.rgb*i.vertexColor.rgb) ).rgb;
                float3 node_579 = pow(lerp(HSVtoRGB( float3(float2((_Hsv.r+node_1991.r),(_Hsv.g*node_1991.g)),(_Hsv.b*node_1991.b)) ),dot(HSVtoRGB( float3(float2((_Hsv.r+node_1991.r),(_Hsv.g*node_1991.g)),(_Hsv.b*node_1991.b)) ),float3(0.3,0.59,0.11)),_Desaturate),_Tex_power);
                float3 diffuseColor = float3(node_579);
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse;
                fixed4 finalRGBA = fixed4(finalColor * i.vertexColor.a,0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}

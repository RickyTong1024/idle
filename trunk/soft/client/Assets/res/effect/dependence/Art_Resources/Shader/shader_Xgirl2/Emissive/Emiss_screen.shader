// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:0,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:False,nrmq:0,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:0,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:False,rfrpn:Refraction,coma:15,ufog:False,aust:False,igpj:False,qofs:0,qpre:3,rntp:2,fgom:True,fgoc:True,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.005,fgrn:60,fgrf:150,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:1,x:35241,y:32507,varname:node_1,prsc:2|emission-29-OUT,alpha-28-A;n:type:ShaderForge.SFN_Tex2d,id:4,x:33807,y:32143,ptovrint:False,ptlb:E01,ptin:_E01,varname:_E01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False|UVIN-4751-OUT;n:type:ShaderForge.SFN_Color,id:16,x:33928,y:32014,ptovrint:False,ptlb:E01_Color,ptin:_E01_Color,varname:_E01_Color,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:18,x:34089,y:32124,varname:node_18,prsc:2|A-16-RGB,B-4-RGB;n:type:ShaderForge.SFN_Panner,id:20,x:33472,y:32071,varname:node_20,prsc:2,spu:1,spv:0|UVIN-8748-UVOUT,DIST-22-OUT;n:type:ShaderForge.SFN_Multiply,id:22,x:33293,y:32170,varname:node_22,prsc:2|A-3960-OUT,B-24-OUT;n:type:ShaderForge.SFN_ValueProperty,id:24,x:33041,y:32293,ptovrint:False,ptlb:E01_UVpan_Speed,ptin:_E01_UVpan_Speed,varname:_E01_UVpan_Speed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Time,id:26,x:32979,y:32428,varname:node_26,prsc:2;n:type:ShaderForge.SFN_Add,id:27,x:34377,y:32507,varname:node_27,prsc:2|A-18-OUT,B-9647-OUT;n:type:ShaderForge.SFN_VertexColor,id:28,x:34686,y:32682,varname:node_28,prsc:2;n:type:ShaderForge.SFN_Multiply,id:29,x:34990,y:32623,varname:node_29,prsc:2|A-4657-OUT,B-28-RGB,C-28-A;n:type:ShaderForge.SFN_ValueProperty,id:50,x:34468,y:32421,ptovrint:False,ptlb:E_Bright,ptin:_E_Bright,varname:_E_Bright,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:90,x:34631,y:32486,varname:node_90,prsc:2|A-50-OUT,B-27-OUT;n:type:ShaderForge.SFN_Tex2d,id:101,x:33848,y:32690,ptovrint:False,ptlb:E02,ptin:_E02,varname:_E02,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False|UVIN-7622-OUT;n:type:ShaderForge.SFN_Multiply,id:109,x:33320,y:32689,varname:node_109,prsc:2|A-3960-OUT,B-111-OUT;n:type:ShaderForge.SFN_ValueProperty,id:111,x:33149,y:32799,ptovrint:False,ptlb:E02_UVpan_Speed,ptin:_E02_UVpan_Speed,varname:_E02_UVpan_Speed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Fresnel,id:114,x:34448,y:32067,varname:node_114,prsc:2|EXP-115-OUT;n:type:ShaderForge.SFN_ValueProperty,id:115,x:34275,y:32086,ptovrint:False,ptlb:RimPower,ptin:_RimPower,varname:_RimPower,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:2.5;n:type:ShaderForge.SFN_Multiply,id:116,x:34810,y:32052,varname:node_116,prsc:2|A-117-RGB,B-5084-OUT;n:type:ShaderForge.SFN_Color,id:117,x:34448,y:31924,ptovrint:False,ptlb:RimColor,ptin:_RimColor,varname:_RimColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:9647,x:34138,y:32664,varname:node_9647,prsc:2|A-201-RGB,B-101-RGB;n:type:ShaderForge.SFN_Color,id:201,x:33977,y:32555,ptovrint:False,ptlb:E02_Color,ptin:_E02_Color,varname:_E02_Color,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Panner,id:155,x:33472,y:32225,varname:node_155,prsc:2,spu:0,spv:1|UVIN-8748-UVOUT,DIST-22-OUT;n:type:ShaderForge.SFN_SwitchProperty,id:4751,x:33629,y:32143,ptovrint:False,ptlb:E01_U/Vpan,ptin:_E01_UVpan,varname:_E01_UVpan,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-20-UVOUT,B-155-UVOUT;n:type:ShaderForge.SFN_Panner,id:7274,x:33510,y:32618,varname:node_7274,prsc:2,spu:1,spv:0|UVIN-7145-UVOUT,DIST-109-OUT;n:type:ShaderForge.SFN_Panner,id:8172,x:33510,y:32772,varname:node_8172,prsc:2,spu:0,spv:1|UVIN-7145-UVOUT,DIST-109-OUT;n:type:ShaderForge.SFN_SwitchProperty,id:7622,x:33667,y:32690,ptovrint:False,ptlb:E02_U/Vpan,ptin:_E02_UVpan,varname:_E02_UVpan,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-7274-UVOUT,B-8172-UVOUT;n:type:ShaderForge.SFN_SwitchProperty,id:3960,x:33180,y:32450,ptovrint:False,ptlb:E_UVpan_Time/VertexAlpha,ptin:_E_UVpan_TimeVertexAlpha,varname:_E_UVpan_TimeVertexAlpha,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-26-T,B-28-A;n:type:ShaderForge.SFN_RemapRange,id:5084,x:34636,y:32067,varname:node_5084,prsc:2,frmn:0,frmx:1,tomn:-1,tomx:2|IN-114-OUT;n:type:ShaderForge.SFN_Add,id:2194,x:34885,y:32468,varname:node_2194,prsc:2|A-116-OUT,B-90-OUT;n:type:ShaderForge.SFN_TexCoord,id:8748,x:33293,y:32031,varname:node_8748,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_TexCoord,id:7145,x:33320,y:32530,varname:node_7145,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Clamp01,id:4657,x:35043,y:32468,varname:node_4657,prsc:2|IN-2194-OUT;proporder:50-3960-4-16-4751-24-101-201-7622-111-115-117;pass:END;sub:END;*/

Shader "yh/Emiss_screen" {
    Properties {
        _E_Bright ("E_Bright", Float ) = 1
        [MaterialToggle] _E_UVpan_TimeVertexAlpha ("E_UVpan_Time/VertexAlpha", Float ) = 0
        _E01 ("E01", 2D) = "black" {}
        _E01_Color ("E01_Color", Color) = (1,1,1,1)
        [MaterialToggle] _E01_UVpan ("E01_U/Vpan", Float ) = 0
        _E01_UVpan_Speed ("E01_UVpan_Speed", Float ) = 1
        _E02 ("E02", 2D) = "black" {}
        _E02_Color ("E02_Color", Color) = (1,1,1,1)
        [MaterialToggle] _E02_UVpan ("E02_U/Vpan", Float ) = 0
        _E02_UVpan_Speed ("E02_UVpan_Speed", Float ) = 1
        _RimPower ("RimPower", Float ) = 2.5
        _RimColor ("RimColor", Color) = (0.5,0.5,0.5,1)
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One One
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma only_renderers d3d11 glcore gles gles3 metal d3d11_9x 
            #pragma target 3.0
            uniform sampler2D _E01; uniform float4 _E01_ST;
            uniform float4 _E01_Color;
            uniform float _E01_UVpan_Speed;
            uniform float _E_Bright;
            uniform sampler2D _E02; uniform float4 _E02_ST;
            uniform float _E02_UVpan_Speed;
            uniform float _RimPower;
            uniform float4 _RimColor;
            uniform float4 _E02_Color;
            uniform fixed _E01_UVpan;
            uniform fixed _E02_UVpan;
            uniform fixed _E_UVpan_TimeVertexAlpha;
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
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
////// Lighting:
////// Emissive:
                float4 node_26 = _Time;
                float _E_UVpan_TimeVertexAlpha_var = lerp( node_26.g, i.vertexColor.a, _E_UVpan_TimeVertexAlpha );
                float node_22 = (_E_UVpan_TimeVertexAlpha_var*_E01_UVpan_Speed);
                float2 _E01_UVpan_var = lerp( (i.uv0+node_22*float2(1,0)), (i.uv0+node_22*float2(0,1)), _E01_UVpan );
                float4 _E01_var = tex2D(_E01,TRANSFORM_TEX(_E01_UVpan_var, _E01));
                float node_109 = (_E_UVpan_TimeVertexAlpha_var*_E02_UVpan_Speed);
                float2 _E02_UVpan_var = lerp( (i.uv0+node_109*float2(1,0)), (i.uv0+node_109*float2(0,1)), _E02_UVpan );
                float4 _E02_var = tex2D(_E02,TRANSFORM_TEX(_E02_UVpan_var, _E02));
                float3 emissive = (saturate(((_RimColor.rgb*(pow(1.0-max(0,dot(normalDirection, viewDirection)),_RimPower)*3.0+-1.0))+(_E_Bright*((_E01_Color.rgb*_E01_var.rgb)+(_E02_Color.rgb*_E02_var.rgb)))))*i.vertexColor.rgb*i.vertexColor.a);
                float3 finalColor = emissive;
                return fixed4(finalColor,i.vertexColor.a);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}

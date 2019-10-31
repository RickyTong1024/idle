// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:False,nrmq:0,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:False,rfrpn:Refraction,coma:15,ufog:True,aust:False,igpj:True,qofs:0,qpre:3,rntp:2,fgom:True,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.005,fgrn:60,fgrf:150,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:1,x:35143,y:32507,varname:node_1,prsc:2|emission-29-OUT,alpha-4311-OUT;n:type:ShaderForge.SFN_Tex2d,id:2,x:33196,y:32675,ptovrint:False,ptlb:DisE01,ptin:_DisE01,varname:_DisE01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:37fae2dfa47e5604a9c12deaa4753d28,ntxv:0,isnm:False|UVIN-8-UVOUT;n:type:ShaderForge.SFN_Tex2d,id:3,x:33715,y:32635,ptovrint:False,ptlb:E01,ptin:_E01,varname:_E01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:37fae2dfa47e5604a9c12deaa4753d28,ntxv:0,isnm:False|UVIN-11-OUT;n:type:ShaderForge.SFN_Tex2d,id:4,x:33718,y:33057,ptovrint:False,ptlb:Alpha01,ptin:_Alpha01,varname:_Alpha01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:0526192ce5faaba47bbce7adb8414887,ntxv:2,isnm:False|UVIN-20-UVOUT;n:type:ShaderForge.SFN_Time,id:5,x:32697,y:32674,varname:node_5,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:6,x:32697,y:32805,ptovrint:False,ptlb:DisE01_Vpan_Speed,ptin:_DisE01_Vpan_Speed,varname:_DisE01_Vpan_Speed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:7,x:32880,y:32695,varname:node_7,prsc:2|A-5-T,B-6-OUT;n:type:ShaderForge.SFN_Panner,id:8,x:33036,y:32675,varname:node_8,prsc:2,spu:0,spv:1|UVIN-3750-UVOUT,DIST-7-OUT;n:type:ShaderForge.SFN_Multiply,id:9,x:33382,y:32655,varname:node_9,prsc:2|A-10-OUT,B-2-RGB;n:type:ShaderForge.SFN_ValueProperty,id:10,x:33220,y:32590,ptovrint:False,ptlb:DisE01_value,ptin:_DisE01_value,varname:_DisE01_value,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Add,id:11,x:33546,y:32635,varname:node_11,prsc:2|A-9-OUT,B-12-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:12,x:33382,y:32786,varname:node_12,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Color,id:13,x:33847,y:32497,ptovrint:False,ptlb:E01_Color,ptin:_E01_Color,varname:_E01_Color,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:14,x:34018,y:32614,varname:node_14,prsc:2|A-13-RGB,B-3-RGB;n:type:ShaderForge.SFN_Multiply,id:18,x:34006,y:33038,varname:node_18,prsc:2|A-109-OUT,B-4-RGB;n:type:ShaderForge.SFN_Panner,id:20,x:33546,y:33076,varname:node_20,prsc:2,spu:1,spv:0|UVIN-2333-UVOUT,DIST-102-OUT;n:type:ShaderForge.SFN_ValueProperty,id:24,x:33092,y:33192,ptovrint:False,ptlb:Alpha01_Upan_Speed,ptin:_Alpha01_Upan_Speed,varname:_Alpha01_Upan_Speed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_VertexColor,id:28,x:34636,y:32738,varname:node_28,prsc:2;n:type:ShaderForge.SFN_Multiply,id:29,x:34979,y:32607,varname:node_29,prsc:2|A-156-OUT,B-28-RGB;n:type:ShaderForge.SFN_Multiply,id:102,x:33375,y:33101,varname:node_102,prsc:2|A-28-A,B-24-OUT;n:type:ShaderForge.SFN_ValueProperty,id:109,x:33855,y:32969,ptovrint:False,ptlb:Alpha01_Bright,ptin:_Alpha01_Bright,varname:_Alpha01_Bright,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:119,x:34322,y:33122,varname:node_119,prsc:2|A-4-R,B-120-R;n:type:ShaderForge.SFN_Tex2d,id:120,x:34198,y:33350,ptovrint:False,ptlb:Alpha02,ptin:_Alpha02,varname:_Alpha02,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:e9af51686730ed940856a9aaecd7758b,ntxv:0,isnm:False|UVIN-121-UVOUT;n:type:ShaderForge.SFN_Panner,id:121,x:34024,y:33350,varname:node_121,prsc:2,spu:0,spv:1|UVIN-2333-UVOUT,DIST-9154-OUT;n:type:ShaderForge.SFN_Time,id:123,x:33603,y:33398,varname:node_123,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:125,x:33603,y:33529,ptovrint:False,ptlb:Alpha02_Vpan_Speed,ptin:_Alpha02_Vpan_Speed,varname:_Alpha02_Vpan_Speed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:132,x:34415,y:33290,ptovrint:False,ptlb:Alpha02_Bright,ptin:_Alpha02_Bright,varname:_Alpha02_Bright,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:156,x:34336,y:32615,varname:node_156,prsc:2|A-14-OUT,B-18-OUT;n:type:ShaderForge.SFN_Multiply,id:230,x:34571,y:33122,varname:node_230,prsc:2|A-3-B,B-119-OUT,C-132-OUT;n:type:ShaderForge.SFN_Multiply,id:4311,x:34860,y:32955,varname:node_4311,prsc:2|A-28-A,B-230-OUT;n:type:ShaderForge.SFN_Multiply,id:9154,x:33824,y:33421,varname:node_9154,prsc:2|A-123-T,B-125-OUT;n:type:ShaderForge.SFN_TexCoord,id:3750,x:32868,y:32531,varname:node_3750,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_TexCoord,id:2333,x:33375,y:33300,varname:node_2333,prsc:2,uv:0,uaff:False;proporder:3-13-2-10-6-4-109-24-120-132-125;pass:END;sub:END;*/

Shader "yh/daoguang_blend" {
    Properties {
        _E01 ("E01", 2D) = "white" {}
        _E01_Color ("E01_Color", Color) = (1,1,1,1)
        _DisE01 ("DisE01", 2D) = "white" {}
        _DisE01_value ("DisE01_value", Float ) = 0
        _DisE01_Vpan_Speed ("DisE01_Vpan_Speed", Float ) = 1
        _Alpha01 ("Alpha01", 2D) = "black" {}
        _Alpha01_Bright ("Alpha01_Bright", Float ) = 1
        _Alpha01_Upan_Speed ("Alpha01_Upan_Speed", Float ) = 1
        _Alpha02 ("Alpha02", 2D) = "white" {}
        _Alpha02_Bright ("Alpha02_Bright", Float ) = 1
        _Alpha02_Vpan_Speed ("Alpha02_Vpan_Speed", Float ) = 0
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma only_renderers d3d11 glcore gles gles3 metal d3d11_9x 
            #pragma target 3.0
            uniform sampler2D _DisE01; uniform float4 _DisE01_ST;
            uniform sampler2D _E01; uniform float4 _E01_ST;
            uniform sampler2D _Alpha01; uniform float4 _Alpha01_ST;
            uniform float _DisE01_Vpan_Speed;
            uniform float _DisE01_value;
            uniform float4 _E01_Color;
            uniform float _Alpha01_Upan_Speed;
            uniform float _Alpha01_Bright;
            uniform sampler2D _Alpha02; uniform float4 _Alpha02_ST;
            uniform float _Alpha02_Vpan_Speed;
            uniform float _Alpha02_Bright;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 vertexColor : COLOR;
                UNITY_FOG_COORDS(1)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
////// Lighting:
////// Emissive:
                float4 node_5 = _Time;
                float2 node_8 = (i.uv0+(node_5.g*_DisE01_Vpan_Speed)*float2(0,1));
                float4 _DisE01_var = tex2D(_DisE01,TRANSFORM_TEX(node_8, _DisE01));
                float3 node_11 = ((_DisE01_value*_DisE01_var.rgb)+float3(i.uv0,0.0));
                float4 _E01_var = tex2D(_E01,TRANSFORM_TEX(node_11, _E01));
                float2 node_20 = (i.uv0+(i.vertexColor.a*_Alpha01_Upan_Speed)*float2(1,0));
                float4 _Alpha01_var = tex2D(_Alpha01,TRANSFORM_TEX(node_20, _Alpha01));
                float3 emissive = (((_E01_Color.rgb*_E01_var.rgb)*(_Alpha01_Bright*_Alpha01_var.rgb))*i.vertexColor.rgb);
                float3 finalColor = emissive;
                float4 node_123 = _Time;
                float2 node_121 = (i.uv0+(node_123.g*_Alpha02_Vpan_Speed)*float2(0,1));
                float4 _Alpha02_var = tex2D(_Alpha02,TRANSFORM_TEX(node_121, _Alpha02));
                fixed4 finalRGBA = fixed4(finalColor,(i.vertexColor.a*(_E01_var.b*(_Alpha01_var.r*_Alpha02_var.r)*_Alpha02_Bright)));
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma only_renderers d3d11 glcore gles gles3 metal d3d11_9x 
            #pragma target 3.0
            struct VertexInput {
                float4 vertex : POSITION;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}

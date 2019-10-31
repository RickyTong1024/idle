// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:False,nrmq:0,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:False,rfrpn:Refraction,coma:15,ufog:False,aust:False,igpj:True,qofs:0,qpre:3,rntp:2,fgom:True,fgoc:False,fgod:False,fgor:True,fgmd:0,fgcr:0.2279412,fgcg:0.2279412,fgcb:0.2279412,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:1,x:35062,y:32559,varname:node_1,prsc:2|emission-1467-OUT,alpha-5602-OUT;n:type:ShaderForge.SFN_Tex2d,id:2,x:33391,y:32540,ptovrint:False,ptlb:E01,ptin:_E01,varname:_E01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:78616e1a5f883c04e85b907ca9d2b2da,ntxv:0,isnm:False|UVIN-6291-UVOUT;n:type:ShaderForge.SFN_Tex2d,id:7,x:32664,y:32498,ptovrint:False,ptlb:DisE01,ptin:_DisE01,varname:_DisE01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:28c7aad1372ff114b90d330f8a2dd938,ntxv:0,isnm:False|UVIN-7564-OUT;n:type:ShaderForge.SFN_Panner,id:15,x:32294,y:32443,varname:node_15,prsc:2,spu:1,spv:0|UVIN-1777-UVOUT,DIST-631-OUT;n:type:ShaderForge.SFN_Multiply,id:217,x:32872,y:32435,varname:node_217,prsc:2|A-589-OUT,B-7-R;n:type:ShaderForge.SFN_TexCoord,id:496,x:32872,y:32560,varname:node_496,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Add,id:554,x:33034,y:32540,varname:node_554,prsc:2|A-217-OUT,B-496-UVOUT;n:type:ShaderForge.SFN_ValueProperty,id:589,x:32664,y:32413,ptovrint:False,ptlb:DisE01_value,ptin:_DisE01_value,varname:_DisE01_value,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.2;n:type:ShaderForge.SFN_Time,id:630,x:31976,y:32424,varname:node_630,prsc:2;n:type:ShaderForge.SFN_Multiply,id:631,x:32133,y:32502,varname:node_631,prsc:2|A-630-T,B-633-OUT;n:type:ShaderForge.SFN_ValueProperty,id:633,x:31953,y:32627,ptovrint:False,ptlb:DisE01_UVpan_Speed,ptin:_DisE01_UVpan_Speed,varname:_DisE01_UVpan_Speed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:643,x:33785,y:32765,varname:node_643,prsc:2|A-2-R,B-647-R;n:type:ShaderForge.SFN_Tex2d,id:647,x:33508,y:32885,ptovrint:False,ptlb:Alpha01,ptin:_Alpha01,varname:_Alpha01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-2816-UVOUT;n:type:ShaderForge.SFN_VertexColor,id:653,x:34075,y:32671,varname:node_653,prsc:2;n:type:ShaderForge.SFN_Multiply,id:669,x:34657,y:32817,varname:node_669,prsc:2|A-7126-OUT,B-4337-OUT;n:type:ShaderForge.SFN_Multiply,id:700,x:34231,y:32817,varname:node_700,prsc:2|A-653-A,B-643-OUT;n:type:ShaderForge.SFN_Add,id:808,x:34251,y:32497,varname:node_808,prsc:2|A-6959-OUT,B-4165-OUT;n:type:ShaderForge.SFN_Panner,id:2098,x:32294,y:32606,varname:node_2098,prsc:2,spu:0,spv:1|UVIN-1777-UVOUT,DIST-631-OUT;n:type:ShaderForge.SFN_SwitchProperty,id:7564,x:32474,y:32515,ptovrint:False,ptlb:DisE01_U/Vpan,ptin:_DisE01_UVpan,varname:_DisE01_UVpan,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-15-UVOUT,B-2098-UVOUT;n:type:ShaderForge.SFN_Rotator,id:6291,x:33214,y:32540,varname:node_6291,prsc:2|UVIN-554-OUT,ANG-1220-OUT;n:type:ShaderForge.SFN_ValueProperty,id:1375,x:32849,y:32887,ptovrint:False,ptlb:E01_UVangle,ptin:_E01_UVangle,varname:_E01_UVangle,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:4165,x:33944,y:32521,varname:node_4165,prsc:2|A-9284-RGB,B-2-RGB;n:type:ShaderForge.SFN_Color,id:9284,x:33749,y:32356,ptovrint:False,ptlb:E01_Color,ptin:_E01_Color,varname:_E01_Color,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Slider,id:6959,x:33914,y:32265,ptovrint:False,ptlb:E01_Bright,ptin:_E01_Bright,varname:_E01_Bright,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:2;n:type:ShaderForge.SFN_TexCoord,id:1777,x:32133,y:32367,varname:node_1777,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_If,id:7126,x:34473,y:32817,varname:node_7126,prsc:2|A-700-OUT,B-1649-OUT,GT-9213-OUT,EQ-9213-OUT,LT-4230-OUT;n:type:ShaderForge.SFN_Vector1,id:9213,x:33752,y:33433,varname:node_9213,prsc:2,v1:1;n:type:ShaderForge.SFN_Vector1,id:4230,x:33752,y:33530,varname:node_4230,prsc:2,v1:0;n:type:ShaderForge.SFN_Slider,id:1649,x:33700,y:33295,ptovrint:False,ptlb:AlphaClip,ptin:_AlphaClip,varname:_AlphaClip,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0.01,cur:0.01,max:0.5;n:type:ShaderForge.SFN_Slider,id:4337,x:34342,y:33035,ptovrint:False,ptlb:Alpha01_Bright,ptin:_Alpha01_Bright,varname:_Alpha01_Bright,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:1;n:type:ShaderForge.SFN_Multiply,id:1220,x:33031,y:32887,varname:node_1220,prsc:2|A-1375-OUT,B-9964-OUT;n:type:ShaderForge.SFN_Pi,id:9964,x:32882,y:33010,varname:node_9964,prsc:2;n:type:ShaderForge.SFN_Add,id:6282,x:34855,y:32817,varname:node_6282,prsc:2|A-669-OUT,B-8413-OUT;n:type:ShaderForge.SFN_Slider,id:8312,x:34342,y:33235,ptovrint:False,ptlb:Glow_Bright,ptin:_Glow_Bright,varname:_Glow_Bright,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5,max:10;n:type:ShaderForge.SFN_Multiply,id:8413,x:34685,y:33119,varname:node_8413,prsc:2|A-700-OUT,B-8312-OUT;n:type:ShaderForge.SFN_Multiply,id:1467,x:34505,y:32633,varname:node_1467,prsc:2|A-808-OUT,B-653-RGB;n:type:ShaderForge.SFN_Rotator,id:2816,x:33299,y:33100,varname:node_2816,prsc:2|UVIN-2687-UVOUT,ANG-3214-OUT;n:type:ShaderForge.SFN_Multiply,id:3214,x:33133,y:33184,varname:node_3214,prsc:2|A-6085-OUT,B-5617-OUT;n:type:ShaderForge.SFN_TexCoord,id:2687,x:33133,y:33039,varname:node_2687,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_ValueProperty,id:5617,x:32986,y:33416,ptovrint:False,ptlb:Alpha01_UVangle,ptin:_Alpha01_UVangle,varname:_Alpha01_UVangle,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Pi,id:6085,x:32971,y:33230,varname:node_6085,prsc:2;n:type:ShaderForge.SFN_Clamp01,id:5602,x:34881,y:33022,varname:node_5602,prsc:2|IN-6282-OUT;proporder:6959-2-9284-1375-7-589-633-7564-647-5617-4337-1649-8312;pass:END;sub:END;*/

Shader "yh/Particle/Particle_Blend_Toon" {
    Properties {
        _E01_Bright ("E01_Bright", Range(0, 2)) = 0
        _E01 ("E01", 2D) = "white" {}
        _E01_Color ("E01_Color", Color) = (1,1,1,1)
        _E01_UVangle ("E01_UVangle", Float ) = 0
        _DisE01 ("DisE01", 2D) = "white" {}
        _DisE01_value ("DisE01_value", Float ) = 0.2
        _DisE01_UVpan_Speed ("DisE01_UVpan_Speed", Float ) = 1
        [MaterialToggle] _DisE01_UVpan ("DisE01_U/Vpan", Float ) = 0
        _Alpha01 ("Alpha01", 2D) = "white" {}
        _Alpha01_UVangle ("Alpha01_UVangle", Float ) = 0
        _Alpha01_Bright ("Alpha01_Bright", Range(0, 1)) = 1
        _AlphaClip ("AlphaClip", Range(0.01, 0.5)) = 0.01
        _Glow_Bright ("Glow_Bright", Range(0, 10)) = 0.5
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
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x n3ds wiiu 
            #pragma target 3.0
            uniform sampler2D _E01; uniform float4 _E01_ST;
            uniform sampler2D _DisE01; uniform float4 _DisE01_ST;
            uniform float _DisE01_value;
            uniform float _DisE01_UVpan_Speed;
            uniform sampler2D _Alpha01; uniform float4 _Alpha01_ST;
            uniform fixed _DisE01_UVpan;
            uniform float _E01_UVangle;
            uniform float4 _E01_Color;
            uniform float _E01_Bright;
            uniform float _AlphaClip;
            uniform float _Alpha01_Bright;
            uniform float _Glow_Bright;
            uniform float _Alpha01_UVangle;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
////// Lighting:
////// Emissive:
                float node_6291_ang = (_E01_UVangle*3.141592654);
                float node_6291_spd = 1.0;
                float node_6291_cos = cos(node_6291_spd*node_6291_ang);
                float node_6291_sin = sin(node_6291_spd*node_6291_ang);
                float2 node_6291_piv = float2(0.5,0.5);
                float4 node_630 = _Time;
                float node_631 = (node_630.g*_DisE01_UVpan_Speed);
                float2 _DisE01_UVpan_var = lerp( (i.uv0+node_631*float2(1,0)), (i.uv0+node_631*float2(0,1)), _DisE01_UVpan );
                float4 _DisE01_var = tex2D(_DisE01,TRANSFORM_TEX(_DisE01_UVpan_var, _DisE01));
                float2 node_6291 = (mul(((_DisE01_value*_DisE01_var.r)+i.uv0)-node_6291_piv,float2x2( node_6291_cos, -node_6291_sin, node_6291_sin, node_6291_cos))+node_6291_piv);
                float4 _E01_var = tex2D(_E01,TRANSFORM_TEX(node_6291, _E01));
                float3 emissive = ((_E01_Bright+(_E01_Color.rgb*_E01_var.rgb))*i.vertexColor.rgb);
                float3 finalColor = emissive;
                float node_2816_ang = (3.141592654*_Alpha01_UVangle);
                float node_2816_spd = 1.0;
                float node_2816_cos = cos(node_2816_spd*node_2816_ang);
                float node_2816_sin = sin(node_2816_spd*node_2816_ang);
                float2 node_2816_piv = float2(0.5,0.5);
                float2 node_2816 = (mul(i.uv0-node_2816_piv,float2x2( node_2816_cos, -node_2816_sin, node_2816_sin, node_2816_cos))+node_2816_piv);
                float4 _Alpha01_var = tex2D(_Alpha01,TRANSFORM_TEX(node_2816, _Alpha01));
                float node_700 = (i.vertexColor.a*(_E01_var.r*_Alpha01_var.r));
                float node_7126_if_leA = step(node_700,_AlphaClip);
                float node_7126_if_leB = step(_AlphaClip,node_700);
                float node_9213 = 1.0;
                return fixed4(finalColor,saturate(((lerp((node_7126_if_leA*0.0)+(node_7126_if_leB*node_9213),node_9213,node_7126_if_leA*node_7126_if_leB)*_Alpha01_Bright)+(node_700*_Glow_Bright))));
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
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x n3ds wiiu 
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

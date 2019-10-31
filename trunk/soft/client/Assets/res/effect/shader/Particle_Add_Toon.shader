// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:False,nrmq:0,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:False,rfrpn:Refraction,coma:15,ufog:True,aust:False,igpj:True,qofs:0,qpre:3,rntp:2,fgom:True,fgoc:True,fgod:False,fgor:True,fgmd:1,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:45,fgrf:100,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:1,x:35240,y:32686,varname:node_1,prsc:2|emission-669-OUT;n:type:ShaderForge.SFN_Tex2d,id:2,x:33875,y:32694,ptovrint:False,ptlb:E01,ptin:_E01,varname:_E01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:b66bceaf0cc0ace4e9bdc92f14bba709,ntxv:0,isnm:False|UVIN-2473-UVOUT;n:type:ShaderForge.SFN_Tex2d,id:7,x:33090,y:32652,ptovrint:False,ptlb:DisE01,ptin:_DisE01,varname:_DisE01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:28c7aad1372ff114b90d330f8a2dd938,ntxv:0,isnm:False|UVIN-7443-OUT;n:type:ShaderForge.SFN_Panner,id:15,x:32776,y:32564,varname:node_15,prsc:2,spu:1,spv:0|UVIN-6331-UVOUT,DIST-631-OUT;n:type:ShaderForge.SFN_Multiply,id:217,x:33298,y:32589,varname:node_217,prsc:2|A-589-OUT,B-7-R;n:type:ShaderForge.SFN_TexCoord,id:496,x:33298,y:32714,varname:node_496,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Add,id:554,x:33460,y:32694,varname:node_554,prsc:2|A-217-OUT,B-496-UVOUT;n:type:ShaderForge.SFN_ValueProperty,id:589,x:33090,y:32567,ptovrint:False,ptlb:DisE01_value,ptin:_DisE01_value,varname:_DisE01_value,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Time,id:630,x:32440,y:32567,varname:node_630,prsc:2;n:type:ShaderForge.SFN_Multiply,id:631,x:32615,y:32635,varname:node_631,prsc:2|A-630-T,B-633-OUT;n:type:ShaderForge.SFN_ValueProperty,id:633,x:32440,y:32758,ptovrint:False,ptlb:DisE01_UVpan_Speed,ptin:_DisE01_UVpan_Speed,varname:_DisE01_UVpan_Speed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:643,x:34783,y:32787,varname:node_643,prsc:2|A-4981-OUT,B-653-RGB,C-647-RGB;n:type:ShaderForge.SFN_Tex2d,id:647,x:34454,y:33172,ptovrint:False,ptlb:MaskE01,ptin:_MaskE01,varname:_MaskE01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-7215-UVOUT;n:type:ShaderForge.SFN_VertexColor,id:653,x:33922,y:32940,varname:node_653,prsc:2;n:type:ShaderForge.SFN_Multiply,id:654,x:34108,y:32694,cmnt:这里像素会被取整if之后不会,varname:node_654,prsc:2|A-2-RGB,B-653-A;n:type:ShaderForge.SFN_Multiply,id:669,x:34996,y:32787,varname:node_669,prsc:2|A-643-OUT,B-7618-OUT,C-2570-RGB;n:type:ShaderForge.SFN_Panner,id:4833,x:32776,y:32785,varname:node_4833,prsc:2,spu:0,spv:1|UVIN-6331-UVOUT,DIST-631-OUT;n:type:ShaderForge.SFN_SwitchProperty,id:7443,x:32932,y:32701,ptovrint:False,ptlb:DisE01_U/Vpan,ptin:_DisE01_UVpan,varname:_DisE01_UVpan,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-15-UVOUT,B-4833-UVOUT;n:type:ShaderForge.SFN_Rotator,id:2473,x:33688,y:32694,varname:node_2473,prsc:2|UVIN-554-OUT,ANG-7962-OUT;n:type:ShaderForge.SFN_ValueProperty,id:5289,x:33378,y:32904,ptovrint:False,ptlb:E01_UVangle,ptin:_E01_UVangle,varname:_E01_UVangle,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_TexCoord,id:6331,x:32589,y:32812,varname:node_6331,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_If,id:9868,x:34314,y:32694,varname:node_9868,prsc:2|A-654-OUT,B-7401-OUT,GT-9015-OUT,EQ-9015-OUT,LT-7046-OUT;n:type:ShaderForge.SFN_Slider,id:7401,x:33694,y:33213,ptovrint:False,ptlb:AlphaClip,ptin:_AlphaClip,varname:_AlphaClip,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0.01,cur:0.02,max:1;n:type:ShaderForge.SFN_Vector1,id:9015,x:33759,y:33346,varname:node_9015,prsc:2,v1:1;n:type:ShaderForge.SFN_Vector1,id:7046,x:33772,y:33458,varname:node_7046,prsc:2,v1:0;n:type:ShaderForge.SFN_Color,id:2570,x:34743,y:33180,ptovrint:False,ptlb:E01_Color,ptin:_E01_Color,varname:_E01_Color,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Slider,id:7618,x:34569,y:33050,ptovrint:False,ptlb:E01_Bright,ptin:_E01_Bright,varname:_E01_Bright,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:2;n:type:ShaderForge.SFN_Multiply,id:7962,x:33535,y:32904,varname:node_7962,prsc:2|A-5289-OUT,B-8276-OUT;n:type:ShaderForge.SFN_Pi,id:8276,x:33378,y:32999,varname:node_8276,prsc:2;n:type:ShaderForge.SFN_Add,id:4981,x:34564,y:32674,varname:node_4981,prsc:2|A-2095-OUT,B-9868-OUT;n:type:ShaderForge.SFN_Multiply,id:2095,x:34357,y:32372,varname:node_2095,prsc:2|A-654-OUT,B-2448-OUT;n:type:ShaderForge.SFN_Slider,id:2448,x:33800,y:32324,ptovrint:False,ptlb:Glow_Bright,ptin:_Glow_Bright,varname:_Glow_Bright,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:10;n:type:ShaderForge.SFN_Rotator,id:7215,x:34298,y:33172,varname:node_7215,prsc:2|UVIN-7251-UVOUT,ANG-7252-OUT;n:type:ShaderForge.SFN_Multiply,id:7252,x:34132,y:33256,varname:node_7252,prsc:2|A-9718-OUT,B-5907-OUT;n:type:ShaderForge.SFN_Pi,id:9718,x:33970,y:33302,varname:node_9718,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:5907,x:33985,y:33488,ptovrint:False,ptlb:MaskE01_UVangle,ptin:_MaskE01_UVangle,varname:_MaskE01_UVangle,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_TexCoord,id:7251,x:34132,y:33111,varname:node_7251,prsc:2,uv:0,uaff:False;proporder:7618-2-2570-5289-7-589-633-7443-647-5907-7401-2448;pass:END;sub:END;*/

Shader "yh/Particle/Particle_Add_Toon" {
    Properties {
        _E01_Bright ("E01_Bright", Range(0, 2)) = 1
        _E01 ("E01", 2D) = "white" {}
        _E01_Color ("E01_Color", Color) = (1,1,1,1)
        _E01_UVangle ("E01_UVangle", Float ) = 0
        _DisE01 ("DisE01", 2D) = "white" {}
        _DisE01_value ("DisE01_value", Float ) = 0
        _DisE01_UVpan_Speed ("DisE01_UVpan_Speed", Float ) = 0
        [MaterialToggle] _DisE01_UVpan ("DisE01_U/Vpan", Float ) = 0
        _MaskE01 ("MaskE01", 2D) = "white" {}
        _MaskE01_UVangle ("MaskE01_UVangle", Float ) = 0
        _AlphaClip ("AlphaClip", Range(0.01, 1)) = 0.02
        _Glow_Bright ("Glow_Bright", Range(0, 10)) = 1
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
            Blend One One
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x n3ds wiiu 
            #pragma target 3.0
            uniform sampler2D _E01; uniform float4 _E01_ST;
            uniform sampler2D _DisE01; uniform float4 _DisE01_ST;
            uniform float _DisE01_value;
            uniform float _DisE01_UVpan_Speed;
            uniform sampler2D _MaskE01; uniform float4 _MaskE01_ST;
            uniform fixed _DisE01_UVpan;
            uniform float _E01_UVangle;
            uniform float _AlphaClip;
            uniform float4 _E01_Color;
            uniform float _E01_Bright;
            uniform float _Glow_Bright;
            uniform float _MaskE01_UVangle;
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
                float node_2473_ang = (_E01_UVangle*3.141592654);
                float node_2473_spd = 1.0;
                float node_2473_cos = cos(node_2473_spd*node_2473_ang);
                float node_2473_sin = sin(node_2473_spd*node_2473_ang);
                float2 node_2473_piv = float2(0.5,0.5);
                float4 node_630 = _Time;
                float node_631 = (node_630.g*_DisE01_UVpan_Speed);
                float2 _DisE01_UVpan_var = lerp( (i.uv0+node_631*float2(1,0)), (i.uv0+node_631*float2(0,1)), _DisE01_UVpan );
                float4 _DisE01_var = tex2D(_DisE01,TRANSFORM_TEX(_DisE01_UVpan_var, _DisE01));
                float2 node_2473 = (mul(((_DisE01_value*_DisE01_var.r)+i.uv0)-node_2473_piv,float2x2( node_2473_cos, -node_2473_sin, node_2473_sin, node_2473_cos))+node_2473_piv);
                float4 _E01_var = tex2D(_E01,TRANSFORM_TEX(node_2473, _E01));
                float3 node_654 = (_E01_var.rgb*i.vertexColor.a); // 这里像素会被取整if之后不会
                float node_9868_if_leA = step(node_654,_AlphaClip);
                float node_9868_if_leB = step(_AlphaClip,node_654);
                float node_9015 = 1.0;
                float node_7215_ang = (3.141592654*_MaskE01_UVangle);
                float node_7215_spd = 1.0;
                float node_7215_cos = cos(node_7215_spd*node_7215_ang);
                float node_7215_sin = sin(node_7215_spd*node_7215_ang);
                float2 node_7215_piv = float2(0.5,0.5);
                float2 node_7215 = (mul(i.uv0-node_7215_piv,float2x2( node_7215_cos, -node_7215_sin, node_7215_sin, node_7215_cos))+node_7215_piv);
                float4 _MaskE01_var = tex2D(_MaskE01,TRANSFORM_TEX(node_7215, _MaskE01));
                float3 emissive = ((((node_654*_Glow_Bright)+lerp((node_9868_if_leA*0.0)+(node_9868_if_leB*node_9015),node_9015,node_9868_if_leA*node_9868_if_leB))*i.vertexColor.rgb*_MaskE01_var.rgb)*_E01_Bright*_E01_Color.rgb);
                float3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG_COLOR(i.fogCoord, finalRGBA, fixed4(0,0,0,1));
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

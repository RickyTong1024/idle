// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:False,nrmq:0,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:False,rfrpn:Refraction,coma:15,ufog:True,aust:False,igpj:True,qofs:0,qpre:3,rntp:2,fgom:True,fgoc:True,fgod:False,fgor:True,fgmd:1,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:45,fgrf:100,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:1,x:34900,y:32712,varname:node_1,prsc:2|emission-654-OUT,alpha-653-A;n:type:ShaderForge.SFN_Tex2d,id:2,x:33848,y:32694,ptovrint:False,ptlb:E01,ptin:_E01,varname:_E01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:b66bceaf0cc0ace4e9bdc92f14bba709,ntxv:0,isnm:False|UVIN-2473-UVOUT;n:type:ShaderForge.SFN_Tex2d,id:7,x:33090,y:32652,ptovrint:False,ptlb:DisE01,ptin:_DisE01,varname:_DisE01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:28c7aad1372ff114b90d330f8a2dd938,ntxv:0,isnm:False|UVIN-7443-OUT;n:type:ShaderForge.SFN_Panner,id:15,x:32776,y:32564,varname:node_15,prsc:2,spu:1,spv:0|UVIN-6331-UVOUT,DIST-631-OUT;n:type:ShaderForge.SFN_Multiply,id:217,x:33298,y:32589,varname:node_217,prsc:2|A-589-OUT,B-7-R;n:type:ShaderForge.SFN_TexCoord,id:496,x:33298,y:32714,varname:node_496,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Add,id:554,x:33460,y:32694,varname:node_554,prsc:2|A-217-OUT,B-496-UVOUT;n:type:ShaderForge.SFN_ValueProperty,id:589,x:33090,y:32567,ptovrint:False,ptlb:DisE01_value,ptin:_DisE01_value,varname:_DisE01_value,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Time,id:630,x:32440,y:32567,varname:node_630,prsc:2;n:type:ShaderForge.SFN_Multiply,id:631,x:32615,y:32635,varname:node_631,prsc:2|A-630-T,B-633-OUT;n:type:ShaderForge.SFN_ValueProperty,id:633,x:32440,y:32758,ptovrint:False,ptlb:DisE01_UVpan_Speed,ptin:_DisE01_UVpan_Speed,varname:_DisE01_UVpan_Speed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:643,x:34052,y:32694,varname:node_643,prsc:2|A-2-RGB,B-647-R;n:type:ShaderForge.SFN_Tex2d,id:647,x:33848,y:32886,ptovrint:False,ptlb:MaskE01,ptin:_MaskE01,varname:_MaskE01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:3a5a96df060a5cf4a9cc0c59e13486b7,ntxv:0,isnm:False|UVIN-3758-UVOUT;n:type:ShaderForge.SFN_VertexColor,id:653,x:34540,y:32673,varname:node_653,prsc:2;n:type:ShaderForge.SFN_Multiply,id:654,x:34724,y:32635,cmnt:在UI里和背景做透明,varname:node_654,prsc:2|A-669-OUT,B-653-RGB,C-653-A;n:type:ShaderForge.SFN_Multiply,id:659,x:34208,y:32633,varname:node_659,prsc:2|A-664-RGB,B-643-OUT;n:type:ShaderForge.SFN_Color,id:664,x:34035,y:32483,ptovrint:False,ptlb:E01_Color,ptin:_E01_Color,varname:_E01_Color,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:669,x:34395,y:32633,varname:node_669,prsc:2|A-659-OUT,B-675-OUT;n:type:ShaderForge.SFN_ValueProperty,id:675,x:34246,y:32798,ptovrint:False,ptlb:E01_Bright,ptin:_E01_Bright,varname:_E01_Bright,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Panner,id:4833,x:32776,y:32785,varname:node_4833,prsc:2,spu:0,spv:1|UVIN-6331-UVOUT,DIST-631-OUT;n:type:ShaderForge.SFN_SwitchProperty,id:7443,x:32932,y:32701,ptovrint:False,ptlb:DisE01_U/Vpan,ptin:_DisE01_UVpan,varname:_DisE01_UVpan,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-15-UVOUT,B-4833-UVOUT;n:type:ShaderForge.SFN_Rotator,id:2473,x:33688,y:32694,varname:node_2473,prsc:2|UVIN-554-OUT,ANG-1623-OUT;n:type:ShaderForge.SFN_ValueProperty,id:5289,x:33356,y:32881,ptovrint:False,ptlb:E01_UVangle,ptin:_E01_UVangle,varname:_E01_UVangle,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_TexCoord,id:6331,x:32589,y:32812,varname:node_6331,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Multiply,id:1623,x:33521,y:32837,varname:node_1623,prsc:2|A-5289-OUT,B-6084-OUT;n:type:ShaderForge.SFN_Pi,id:6084,x:33389,y:32945,varname:node_6084,prsc:2;n:type:ShaderForge.SFN_Rotator,id:3758,x:33664,y:33105,varname:node_3758,prsc:2|UVIN-4911-UVOUT,ANG-8267-OUT;n:type:ShaderForge.SFN_Multiply,id:8267,x:33498,y:33189,varname:node_8267,prsc:2|A-3193-OUT,B-6644-OUT;n:type:ShaderForge.SFN_TexCoord,id:4911,x:33498,y:33044,varname:node_4911,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_ValueProperty,id:6644,x:33351,y:33421,ptovrint:False,ptlb:MaskE01_UVangle,ptin:_MaskE01_UVangle,varname:_MaskE01_UVangle,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Pi,id:3193,x:33336,y:33235,varname:node_3193,prsc:2;proporder:675-2-664-5289-7-589-633-7443-647-6644;pass:END;sub:END;*/

Shader "yh/Particle/Particle_Add" {
    Properties {
        _E01_Bright ("E01_Bright", Float ) = 1
        _E01 ("E01", 2D) = "white" {}
        _E01_Color ("E01_Color", Color) = (1,1,1,1)
        _E01_UVangle ("E01_UVangle", Float ) = 0
        _DisE01 ("DisE01", 2D) = "white" {}
        _DisE01_value ("DisE01_value", Float ) = 0
        _DisE01_UVpan_Speed ("DisE01_UVpan_Speed", Float ) = 0
        [MaterialToggle] _DisE01_UVpan ("DisE01_U/Vpan", Float ) = 0
        _MaskE01 ("MaskE01", 2D) = "white" {}
        _MaskE01_UVangle ("MaskE01_UVangle", Float ) = 0
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
            Blend One One
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
            uniform sampler2D _E01; uniform float4 _E01_ST;
            uniform sampler2D _DisE01; uniform float4 _DisE01_ST;
            uniform float _DisE01_value;
            uniform float _DisE01_UVpan_Speed;
            uniform sampler2D _MaskE01; uniform float4 _MaskE01_ST;
            uniform float4 _E01_Color;
            uniform float _E01_Bright;
            uniform fixed _DisE01_UVpan;
            uniform float _E01_UVangle;
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
                float node_3758_ang = (3.141592654*_MaskE01_UVangle);
                float node_3758_spd = 1.0;
                float node_3758_cos = cos(node_3758_spd*node_3758_ang);
                float node_3758_sin = sin(node_3758_spd*node_3758_ang);
                float2 node_3758_piv = float2(0.5,0.5);
                float2 node_3758 = (mul(i.uv0-node_3758_piv,float2x2( node_3758_cos, -node_3758_sin, node_3758_sin, node_3758_cos))+node_3758_piv);
                float4 _MaskE01_var = tex2D(_MaskE01,TRANSFORM_TEX(node_3758, _MaskE01));
                float3 emissive = (((_E01_Color.rgb*(_E01_var.rgb*_MaskE01_var.r))*_E01_Bright)*i.vertexColor.rgb*i.vertexColor.a);
                float3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(finalColor,i.vertexColor.a);
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

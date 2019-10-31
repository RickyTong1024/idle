// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:False,nrmq:0,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:False,rfrpn:Refraction,coma:15,ufog:True,aust:False,igpj:True,qofs:0,qpre:3,rntp:2,fgom:True,fgoc:True,fgod:False,fgor:False,fgmd:1,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:45,fgrf:100,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:1,x:34900,y:32712,varname:node_1,prsc:2|emission-654-OUT,alpha-653-A;n:type:ShaderForge.SFN_Tex2d,id:2,x:33753,y:32830,ptovrint:False,ptlb:E01,ptin:_E01,varname:_E01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:8a898f5dce9eaf44596b0526c36be952,ntxv:0,isnm:False|UVIN-5228-OUT;n:type:ShaderForge.SFN_Tex2d,id:7,x:33176,y:32673,ptovrint:False,ptlb:DisE01,ptin:_DisE01,varname:_DisE01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:28c7aad1372ff114b90d330f8a2dd938,ntxv:0,isnm:False|UVIN-7293-UVOUT;n:type:ShaderForge.SFN_Panner,id:15,x:32716,y:32770,varname:node_15,prsc:2,spu:1,spv:0|UVIN-7293-UVOUT,DIST-631-OUT;n:type:ShaderForge.SFN_Multiply,id:217,x:33415,y:32645,varname:node_217,prsc:2|A-589-OUT,B-7-R;n:type:ShaderForge.SFN_ValueProperty,id:589,x:33209,y:32564,ptovrint:False,ptlb:DisE01_value,ptin:_DisE01_value,varname:_DisE01_value,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Time,id:630,x:32098,y:32798,varname:node_630,prsc:2;n:type:ShaderForge.SFN_Multiply,id:631,x:32499,y:32861,varname:node_631,prsc:2|A-4998-OUT,B-633-OUT;n:type:ShaderForge.SFN_ValueProperty,id:633,x:32346,y:33056,ptovrint:False,ptlb:E01_UVpan_Speed,ptin:_E01_UVpan_Speed,varname:_E01_UVpan_Speed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:643,x:34005,y:32830,varname:node_643,prsc:2|A-2-RGB,B-647-R;n:type:ShaderForge.SFN_Tex2d,id:647,x:33834,y:33013,ptovrint:False,ptlb:MaskE01,ptin:_MaskE01,varname:_MaskE01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:3a5a96df060a5cf4a9cc0c59e13486b7,ntxv:0,isnm:False|UVIN-7745-UVOUT;n:type:ShaderForge.SFN_VertexColor,id:653,x:34520,y:32850,varname:node_653,prsc:2;n:type:ShaderForge.SFN_Multiply,id:654,x:34704,y:32812,varname:node_654,prsc:2|A-669-OUT,B-653-RGB,C-653-A;n:type:ShaderForge.SFN_Multiply,id:659,x:34188,y:32810,varname:node_659,prsc:2|A-664-RGB,B-643-OUT;n:type:ShaderForge.SFN_Color,id:664,x:33982,y:32640,ptovrint:False,ptlb:E01_Color,ptin:_E01_Color,varname:_E01_Color,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:669,x:34375,y:32810,varname:node_669,prsc:2|A-659-OUT,B-675-OUT;n:type:ShaderForge.SFN_ValueProperty,id:675,x:34226,y:32975,ptovrint:False,ptlb:E01_Bright,ptin:_E01_Bright,varname:_E01_Bright,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Panner,id:4833,x:32716,y:32936,varname:node_4833,prsc:2,spu:0,spv:1|UVIN-7293-UVOUT,DIST-631-OUT;n:type:ShaderForge.SFN_SwitchProperty,id:7443,x:32906,y:32852,ptovrint:False,ptlb:E01_U/Vpan,ptin:_E01_UVpan,varname:_E01_UVpan,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-15-UVOUT,B-4833-UVOUT;n:type:ShaderForge.SFN_Rotator,id:2473,x:33364,y:32830,varname:node_2473,prsc:2|UVIN-7443-OUT,ANG-6805-OUT;n:type:ShaderForge.SFN_ValueProperty,id:5289,x:33061,y:33123,ptovrint:False,ptlb:E01_UVangle,ptin:_E01_UVangle,varname:_E01_UVangle,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:6805,x:33212,y:32943,varname:node_6805,prsc:2|A-6997-OUT,B-5289-OUT;n:type:ShaderForge.SFN_Pi,id:6997,x:33078,y:32943,varname:node_6997,prsc:2;n:type:ShaderForge.SFN_Add,id:5228,x:33577,y:32830,varname:node_5228,prsc:2|A-217-OUT,B-2473-UVOUT;n:type:ShaderForge.SFN_SwitchProperty,id:4998,x:32284,y:32798,ptovrint:False,ptlb:E01_UVpan_Time/VertexAlpha,ptin:_E01_UVpan_TimeVertexAlpha,varname:_E01_UVpan_TimeVertexAlpha,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-630-T,B-653-A;n:type:ShaderForge.SFN_TexCoord,id:7293,x:32499,y:32714,varname:node_7293,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Rotator,id:7745,x:33611,y:33096,varname:node_7745,prsc:2|UVIN-7965-UVOUT,ANG-3843-OUT;n:type:ShaderForge.SFN_Multiply,id:3843,x:33445,y:33180,varname:node_3843,prsc:2|A-1565-OUT,B-3324-OUT;n:type:ShaderForge.SFN_TexCoord,id:7965,x:33445,y:33035,varname:node_7965,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_ValueProperty,id:3324,x:33298,y:33412,ptovrint:False,ptlb:MaskE01_UVangle,ptin:_MaskE01_UVangle,varname:_MaskE01_UVangle,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Pi,id:1565,x:33283,y:33226,varname:node_1565,prsc:2;proporder:2-675-664-7443-5289-4998-633-7-589-647-3324;pass:END;sub:END;*/

Shader "yh/Particle/Flow_Add" {
    Properties {
        _E01 ("E01", 2D) = "white" {}
        _E01_Bright ("E01_Bright", Float ) = 1
        _E01_Color ("E01_Color", Color) = (1,1,1,1)
        [MaterialToggle] _E01_UVpan ("E01_U/Vpan", Float ) = 0
        _E01_UVangle ("E01_UVangle", Float ) = 0
        [MaterialToggle] _E01_UVpan_TimeVertexAlpha ("E01_UVpan_Time/VertexAlpha", Float ) = 0
        _E01_UVpan_Speed ("E01_UVpan_Speed", Float ) = 0
        _DisE01 ("DisE01", 2D) = "white" {}
        _DisE01_value ("DisE01_value", Float ) = 0
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
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x xboxone ps4 psp2 n3ds wiiu 
            #pragma target 3.0
            uniform sampler2D _E01; uniform float4 _E01_ST;
            uniform sampler2D _DisE01; uniform float4 _DisE01_ST;
            uniform float _DisE01_value;
            uniform float _E01_UVpan_Speed;
            uniform sampler2D _MaskE01; uniform float4 _MaskE01_ST;
            uniform float4 _E01_Color;
            uniform float _E01_Bright;
            uniform fixed _E01_UVpan;
            uniform float _E01_UVangle;
            uniform fixed _E01_UVpan_TimeVertexAlpha;
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
                float4 _DisE01_var = tex2D(_DisE01,TRANSFORM_TEX(i.uv0, _DisE01));
                float node_2473_ang = (3.141592654*_E01_UVangle);
                float node_2473_spd = 1.0;
                float node_2473_cos = cos(node_2473_spd*node_2473_ang);
                float node_2473_sin = sin(node_2473_spd*node_2473_ang);
                float2 node_2473_piv = float2(0.5,0.5);
                float4 node_630 = _Time;
                float node_631 = (lerp( node_630.g, i.vertexColor.a, _E01_UVpan_TimeVertexAlpha )*_E01_UVpan_Speed);
                float2 node_2473 = (mul(lerp( (i.uv0+node_631*float2(1,0)), (i.uv0+node_631*float2(0,1)), _E01_UVpan )-node_2473_piv,float2x2( node_2473_cos, -node_2473_sin, node_2473_sin, node_2473_cos))+node_2473_piv);
                float2 node_5228 = ((_DisE01_value*_DisE01_var.r)+node_2473);
                float4 _E01_var = tex2D(_E01,TRANSFORM_TEX(node_5228, _E01));
                float node_7745_ang = (3.141592654*_MaskE01_UVangle);
                float node_7745_spd = 1.0;
                float node_7745_cos = cos(node_7745_spd*node_7745_ang);
                float node_7745_sin = sin(node_7745_spd*node_7745_ang);
                float2 node_7745_piv = float2(0.5,0.5);
                float2 node_7745 = (mul(i.uv0-node_7745_piv,float2x2( node_7745_cos, -node_7745_sin, node_7745_sin, node_7745_cos))+node_7745_piv);
                float4 _MaskE01_var = tex2D(_MaskE01,TRANSFORM_TEX(node_7745, _MaskE01));
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
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x xboxone ps4 psp2 n3ds wiiu 
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

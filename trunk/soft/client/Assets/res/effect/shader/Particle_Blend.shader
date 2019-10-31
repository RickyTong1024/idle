// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:False,nrmq:0,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:False,rfrpn:Refraction,coma:15,ufog:True,aust:False,igpj:True,qofs:0,qpre:3,rntp:2,fgom:True,fgoc:False,fgod:False,fgor:True,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:45,fgrf:100,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:1,x:36197,y:32532,varname:node_1,prsc:2|emission-654-OUT,alpha-700-OUT;n:type:ShaderForge.SFN_Tex2d,id:2,x:35079,y:32623,ptovrint:False,ptlb:E01,ptin:_E01,varname:_E01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-3886-UVOUT;n:type:ShaderForge.SFN_Tex2d,id:7,x:34218,y:32623,ptovrint:False,ptlb:DisE01,ptin:_DisE01,varname:_DisE01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:28c7aad1372ff114b90d330f8a2dd938,ntxv:0,isnm:False|UVIN-8589-OUT;n:type:ShaderForge.SFN_Panner,id:15,x:33798,y:32623,varname:node_15,prsc:2,spu:1,spv:0|UVIN-7517-UVOUT,DIST-631-OUT;n:type:ShaderForge.SFN_Multiply,id:217,x:34433,y:32623,varname:node_217,prsc:2|A-589-OUT,B-7-R;n:type:ShaderForge.SFN_TexCoord,id:496,x:34470,y:32777,varname:node_496,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Add,id:554,x:34620,y:32623,varname:node_554,prsc:2|A-217-OUT,B-496-UVOUT;n:type:ShaderForge.SFN_ValueProperty,id:589,x:34291,y:32527,ptovrint:False,ptlb:DisE01_value,ptin:_DisE01_value,varname:_DisE01_value,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Time,id:630,x:33413,y:32583,varname:node_630,prsc:2;n:type:ShaderForge.SFN_Multiply,id:631,x:33611,y:32644,varname:node_631,prsc:2|A-630-T,B-633-OUT;n:type:ShaderForge.SFN_ValueProperty,id:633,x:33462,y:32728,ptovrint:False,ptlb:DisE01_UVpan_Speed,ptin:_DisE01_UVpan_Speed,varname:_DisE01_UVpan_Speed,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:643,x:35682,y:32845,varname:node_643,prsc:2|A-2-R,B-669-OUT;n:type:ShaderForge.SFN_Tex2d,id:647,x:35285,y:32832,ptovrint:False,ptlb:Alpha01,ptin:_Alpha01,varname:_Alpha01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:3a5a96df060a5cf4a9cc0c59e13486b7,ntxv:0,isnm:False|UVIN-809-UVOUT;n:type:ShaderForge.SFN_VertexColor,id:653,x:35705,y:32701,varname:node_653,prsc:2;n:type:ShaderForge.SFN_Multiply,id:654,x:35876,y:32594,varname:node_654,prsc:2|A-659-OUT,B-653-RGB;n:type:ShaderForge.SFN_Multiply,id:659,x:35602,y:32596,varname:node_659,prsc:2|A-6427-OUT,B-3252-OUT;n:type:ShaderForge.SFN_Multiply,id:669,x:35471,y:32863,varname:node_669,prsc:2|A-647-R,B-675-OUT;n:type:ShaderForge.SFN_ValueProperty,id:675,x:35285,y:33047,ptovrint:False,ptlb:Alpha01_Bright,ptin:_Alpha01_Bright,varname:_Alpha01_Bright,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:700,x:35895,y:32821,varname:node_700,prsc:2|A-653-A,B-643-OUT;n:type:ShaderForge.SFN_ValueProperty,id:2669,x:34651,y:32787,ptovrint:False,ptlb:E01_UVangle,ptin:_E01_UVangle,varname:_E01_UVangle,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Rotator,id:3886,x:34856,y:32623,varname:node_3886,prsc:2|UVIN-554-OUT,ANG-4441-OUT;n:type:ShaderForge.SFN_ValueProperty,id:6427,x:35452,y:32498,ptovrint:False,ptlb:E01_Bright,ptin:_E01_Bright,varname:_E01_Bright,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:3252,x:35420,y:32613,varname:node_3252,prsc:2|A-3789-RGB,B-2-RGB;n:type:ShaderForge.SFN_Color,id:3789,x:35223,y:32498,ptovrint:False,ptlb:E01_Color,ptin:_E01_Color,varname:_E01_Color,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_SwitchProperty,id:8589,x:34012,y:32623,ptovrint:False,ptlb:DisE01_U/Vpan,ptin:_DisE01_UVpan,varname:_DisE01_UVpan,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-15-UVOUT,B-5382-UVOUT;n:type:ShaderForge.SFN_Panner,id:5382,x:33798,y:32766,varname:node_5382,prsc:2,spu:0,spv:1|UVIN-7517-UVOUT,DIST-631-OUT;n:type:ShaderForge.SFN_Pi,id:6748,x:34651,y:32855,varname:node_6748,prsc:2;n:type:ShaderForge.SFN_Multiply,id:4441,x:34856,y:32787,varname:node_4441,prsc:2|A-2669-OUT,B-6748-OUT;n:type:ShaderForge.SFN_TexCoord,id:7517,x:33623,y:32475,varname:node_7517,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Rotator,id:809,x:35022,y:33017,varname:node_809,prsc:2|UVIN-8097-UVOUT,ANG-4013-OUT;n:type:ShaderForge.SFN_Multiply,id:4013,x:34856,y:33101,varname:node_4013,prsc:2|A-3941-OUT,B-3497-OUT;n:type:ShaderForge.SFN_TexCoord,id:8097,x:34856,y:32956,varname:node_8097,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_ValueProperty,id:3497,x:34709,y:33333,ptovrint:False,ptlb:Alpha01_UVangle,ptin:_Alpha01_UVangle,varname:_Alpha01_UVangle,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Pi,id:3941,x:34694,y:33147,varname:node_3941,prsc:2;proporder:6427-2-3789-2669-7-589-633-8589-647-3497-675;pass:END;sub:END;*/

Shader "yh/Particle/Particle_Blend" {
    Properties {
        _E01_Bright ("E01_Bright", Float ) = 1
        _E01 ("E01", 2D) = "white" {}
        _E01_Color ("E01_Color", Color) = (1,1,1,1)
        _E01_UVangle ("E01_UVangle", Float ) = 1
        _DisE01 ("DisE01", 2D) = "white" {}
        _DisE01_value ("DisE01_value", Float ) = 0
        _DisE01_UVpan_Speed ("DisE01_UVpan_Speed", Float ) = 0
        [MaterialToggle] _DisE01_UVpan ("DisE01_U/Vpan", Float ) = 0
        _Alpha01 ("Alpha01", 2D) = "white" {}
        _Alpha01_UVangle ("Alpha01_UVangle", Float ) = 0
        _Alpha01_Bright ("Alpha01_Bright", Float ) = 1
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
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x n3ds wiiu 
            #pragma target 3.0
            uniform sampler2D _E01; uniform float4 _E01_ST;
            uniform sampler2D _DisE01; uniform float4 _DisE01_ST;
            uniform float _DisE01_value;
            uniform float _DisE01_UVpan_Speed;
            uniform sampler2D _Alpha01; uniform float4 _Alpha01_ST;
            uniform float _Alpha01_Bright;
            uniform float _E01_UVangle;
            uniform float _E01_Bright;
            uniform float4 _E01_Color;
            uniform fixed _DisE01_UVpan;
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
                float node_3886_ang = (_E01_UVangle*3.141592654);
                float node_3886_spd = 1.0;
                float node_3886_cos = cos(node_3886_spd*node_3886_ang);
                float node_3886_sin = sin(node_3886_spd*node_3886_ang);
                float2 node_3886_piv = float2(0.5,0.5);
                float4 node_630 = _Time;
                float node_631 = (node_630.g*_DisE01_UVpan_Speed);
                float2 _DisE01_UVpan_var = lerp( (i.uv0+node_631*float2(1,0)), (i.uv0+node_631*float2(0,1)), _DisE01_UVpan );
                float4 _DisE01_var = tex2D(_DisE01,TRANSFORM_TEX(_DisE01_UVpan_var, _DisE01));
                float2 node_3886 = (mul(((_DisE01_value*_DisE01_var.r)+i.uv0)-node_3886_piv,float2x2( node_3886_cos, -node_3886_sin, node_3886_sin, node_3886_cos))+node_3886_piv);
                float4 _E01_var = tex2D(_E01,TRANSFORM_TEX(node_3886, _E01));
                float3 emissive = ((_E01_Bright*(_E01_Color.rgb*_E01_var.rgb))*i.vertexColor.rgb);
                float3 finalColor = emissive;
                float node_809_ang = (3.141592654*_Alpha01_UVangle);
                float node_809_spd = 1.0;
                float node_809_cos = cos(node_809_spd*node_809_ang);
                float node_809_sin = sin(node_809_spd*node_809_ang);
                float2 node_809_piv = float2(0.5,0.5);
                float2 node_809 = (mul(i.uv0-node_809_piv,float2x2( node_809_cos, -node_809_sin, node_809_sin, node_809_cos))+node_809_piv);
                float4 _Alpha01_var = tex2D(_Alpha01,TRANSFORM_TEX(node_809, _Alpha01));
                fixed4 finalRGBA = fixed4(finalColor,(i.vertexColor.a*(_E01_var.r*(_Alpha01_var.r*_Alpha01_Bright))));
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

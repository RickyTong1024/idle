// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:False,nrmq:0,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:False,rfrpn:Refraction,coma:15,ufog:True,aust:False,igpj:False,qofs:0,qpre:1,rntp:1,fgom:True,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.2784314,fgcg:0.2784314,fgcb:0.2784314,fgca:1,fgde:0.01,fgrn:30,fgrf:150,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:796,x:32828,y:32694,varname:node_796,prsc:2|diff-4618-OUT,emission-9737-OUT,alpha-9096-A,clip-8340-OUT;n:type:ShaderForge.SFN_Tex2d,id:7438,x:30655,y:32920,ptovrint:False,ptlb:Alpha02,ptin:_Alpha02,varname:_Alpha02,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False;n:type:ShaderForge.SFN_If,id:5985,x:31888,y:32747,varname:node_5985,prsc:2|A-2590-OUT,B-238-OUT,GT-242-OUT,EQ-242-OUT,LT-7596-OUT;n:type:ShaderForge.SFN_Vector1,id:242,x:31336,y:33057,varname:node_242,prsc:2,v1:0;n:type:ShaderForge.SFN_Vector1,id:7596,x:31336,y:33120,varname:node_7596,prsc:2,v1:1;n:type:ShaderForge.SFN_Tex2d,id:9096,x:32055,y:32213,ptovrint:False,ptlb:D01,ptin:_D01,varname:_D01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_If,id:7270,x:31888,y:32914,varname:node_7270,prsc:2|A-2590-OUT,B-2525-OUT,GT-242-OUT,EQ-242-OUT,LT-7596-OUT;n:type:ShaderForge.SFN_Vector1,id:2525,x:31341,y:32938,varname:node_2525,prsc:2,v1:0.1;n:type:ShaderForge.SFN_Tex2d,id:2307,x:30655,y:32743,ptovrint:False,ptlb:Alpha01,ptin:_Alpha01,varname:_Alpha01,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:5382f9c91445af745931b2546ec13341,ntxv:2,isnm:False;n:type:ShaderForge.SFN_Subtract,id:6335,x:32333,y:32769,varname:node_6335,prsc:2|A-5985-OUT,B-7270-OUT;n:type:ShaderForge.SFN_VertexColor,id:2070,x:30764,y:32105,varname:node_2070,prsc:2;n:type:ShaderForge.SFN_Vector1,id:2866,x:31341,y:32763,varname:node_2866,prsc:2,v1:0.1;n:type:ShaderForge.SFN_Multiply,id:2590,x:31224,y:32640,varname:node_2590,prsc:2|A-5994-OUT,B-1182-OUT;n:type:ShaderForge.SFN_Color,id:4345,x:32011,y:32448,ptovrint:False,ptlb:Dissovle_Color,ptin:_Dissovle_Color,varname:_Dissovle_Color,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Vector1,id:627,x:30655,y:33105,varname:node_627,prsc:2,v1:0.1;n:type:ShaderForge.SFN_Add,id:1182,x:31082,y:32840,varname:node_1182,prsc:2|A-4115-OUT,B-3170-OUT;n:type:ShaderForge.SFN_Add,id:3170,x:30833,y:33153,varname:node_3170,prsc:2|A-627-OUT,B-6305-OUT;n:type:ShaderForge.SFN_Add,id:238,x:31514,y:32763,varname:node_238,prsc:2|A-2866-OUT,B-6305-OUT;n:type:ShaderForge.SFN_Slider,id:6305,x:30503,y:33383,ptovrint:False,ptlb:Dissovle_Width,ptin:_Dissovle_Width,varname:_Dissovle_Width,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0.002,cur:0.08,max:0.08;n:type:ShaderForge.SFN_Add,id:4115,x:30895,y:32842,varname:node_4115,prsc:2|A-2307-R,B-7438-R;n:type:ShaderForge.SFN_OneMinus,id:5994,x:31046,y:32640,varname:node_5994,prsc:2|IN-63-OUT;n:type:ShaderForge.SFN_Add,id:9773,x:32332,y:32448,varname:node_9773,prsc:2|A-4345-RGB,B-1432-OUT;n:type:ShaderForge.SFN_Multiply,id:4618,x:32342,y:32110,varname:node_4618,prsc:2|A-2070-RGB,B-9096-RGB;n:type:ShaderForge.SFN_Multiply,id:8340,x:32560,y:32958,varname:node_8340,prsc:2|A-9096-A,B-5985-OUT;n:type:ShaderForge.SFN_Slider,id:1432,x:31866,y:32611,ptovrint:False,ptlb:Dissovle_Bright,ptin:_Dissovle_Bright,varname:_Dissovle_Bright,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-1,cur:0,max:1;n:type:ShaderForge.SFN_Multiply,id:9737,x:32525,y:32747,varname:node_9737,prsc:2|A-9773-OUT,B-6335-OUT;n:type:ShaderForge.SFN_Slider,id:8855,x:30428,y:32447,ptovrint:False,ptlb:Dissovle_Time,ptin:_Dissovle_Time,varname:_Dissovle_Time,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.2364758,max:1;n:type:ShaderForge.SFN_SwitchProperty,id:63,x:30959,y:32430,ptovrint:False,ptlb:Anim/VertexAlpha,ptin:_AnimVertexAlpha,varname:_AnimVertexAlpha,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-8855-OUT,B-2070-A;n:type:ShaderForge.SFN_Rotator,id:8500,x:34618,y:33492,varname:node_8500,prsc:2|UVIN-7374-UVOUT;n:type:ShaderForge.SFN_Multiply,id:6782,x:34452,y:33576,varname:node_6782,prsc:2|A-2011-OUT,B-4690-OUT;n:type:ShaderForge.SFN_TexCoord,id:7374,x:34452,y:33431,varname:node_7374,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_ValueProperty,id:4690,x:34305,y:33808,ptovrint:False,ptlb:MaskE01_UVangle,ptin:_MaskE01_UVangle,varname:_MaskE01_UVangle,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Pi,id:2011,x:34290,y:33622,varname:node_2011,prsc:2;proporder:9096-2307-7438-4345-6305-1432-63-8855;pass:END;sub:END;*/

Shader "yh/Diffuse/Diffuse_Dissolve" {
    Properties {
        _D01 ("D01", 2D) = "white" {}
        _Alpha01 ("Alpha01", 2D) = "black" {}
        _Alpha02 ("Alpha02", 2D) = "black" {}
        _Dissovle_Color ("Dissovle_Color", Color) = (1,1,1,1)
        _Dissovle_Width ("Dissovle_Width", Range(0.002, 0.08)) = 0.08
        _Dissovle_Bright ("Dissovle_Bright", Range(-1, 1)) = 0
        [MaterialToggle] _AnimVertexAlpha ("Anim/VertexAlpha", Float ) = 0.2364758
        _Dissovle_Time ("Dissovle_Time", Range(0, 1)) = 0.2364758
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
            Cull Off
            
            
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
            uniform sampler2D _Alpha02; uniform float4 _Alpha02_ST;
            uniform sampler2D _D01; uniform float4 _D01_ST;
            uniform sampler2D _Alpha01; uniform float4 _Alpha01_ST;
            uniform float4 _Dissovle_Color;
            uniform float _Dissovle_Width;
            uniform float _Dissovle_Bright;
            uniform float _Dissovle_Time;
            uniform fixed _AnimVertexAlpha;
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
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float4 _D01_var = tex2D(_D01,TRANSFORM_TEX(i.uv0, _D01));
                float4 _Alpha01_var = tex2D(_Alpha01,TRANSFORM_TEX(i.uv0, _Alpha01));
                float4 _Alpha02_var = tex2D(_Alpha02,TRANSFORM_TEX(i.uv0, _Alpha02));
                float node_2590 = ((1.0 - lerp( _Dissovle_Time, i.vertexColor.a, _AnimVertexAlpha ))*((_Alpha01_var.r+_Alpha02_var.r)+(0.1+_Dissovle_Width)));
                float node_5985_if_leA = step(node_2590,(0.1+_Dissovle_Width));
                float node_5985_if_leB = step((0.1+_Dissovle_Width),node_2590);
                float node_7596 = 1.0;
                float node_242 = 0.0;
                float node_5985 = lerp((node_5985_if_leA*node_7596)+(node_5985_if_leB*node_242),node_242,node_5985_if_leA*node_5985_if_leB);
                clip((_D01_var.a*node_5985) - 0.5);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                UNITY_LIGHT_ATTENUATION(attenuation,i, i.posWorld.xyz);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                float3 diffuseColor = (i.vertexColor.rgb*_D01_var.rgb);
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
////// Emissive:
                float node_7270_if_leA = step(node_2590,0.1);
                float node_7270_if_leB = step(0.1,node_2590);
                float3 emissive = ((_Dissovle_Color.rgb+_Dissovle_Bright)*(node_5985-lerp((node_7270_if_leA*node_7596)+(node_7270_if_leB*node_242),node_242,node_7270_if_leA*node_7270_if_leB)));
/// Final Color:
                float3 finalColor = diffuse + emissive;
                fixed4 finalRGBA = fixed4(finalColor,_D01_var.a);
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
            Cull Off
            
            
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
            uniform sampler2D _Alpha02; uniform float4 _Alpha02_ST;
            uniform sampler2D _D01; uniform float4 _D01_ST;
            uniform sampler2D _Alpha01; uniform float4 _Alpha01_ST;
            uniform float4 _Dissovle_Color;
            uniform float _Dissovle_Width;
            uniform float _Dissovle_Bright;
            uniform float _Dissovle_Time;
            uniform fixed _AnimVertexAlpha;
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
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float4 _D01_var = tex2D(_D01,TRANSFORM_TEX(i.uv0, _D01));
                float4 _Alpha01_var = tex2D(_Alpha01,TRANSFORM_TEX(i.uv0, _Alpha01));
                float4 _Alpha02_var = tex2D(_Alpha02,TRANSFORM_TEX(i.uv0, _Alpha02));
                float node_2590 = ((1.0 - lerp( _Dissovle_Time, i.vertexColor.a, _AnimVertexAlpha ))*((_Alpha01_var.r+_Alpha02_var.r)+(0.1+_Dissovle_Width)));
                float node_5985_if_leA = step(node_2590,(0.1+_Dissovle_Width));
                float node_5985_if_leB = step((0.1+_Dissovle_Width),node_2590);
                float node_7596 = 1.0;
                float node_242 = 0.0;
                float node_5985 = lerp((node_5985_if_leA*node_7596)+(node_5985_if_leB*node_242),node_242,node_5985_if_leA*node_5985_if_leB);
                clip((_D01_var.a*node_5985) - 0.5);
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                UNITY_LIGHT_ATTENUATION(attenuation,i, i.posWorld.xyz);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float3 diffuseColor = (i.vertexColor.rgb*_D01_var.rgb);
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse;
                fixed4 finalRGBA = fixed4(finalColor * _D01_var.a,0);
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
            uniform sampler2D _Alpha02; uniform float4 _Alpha02_ST;
            uniform sampler2D _D01; uniform float4 _D01_ST;
            uniform sampler2D _Alpha01; uniform float4 _Alpha01_ST;
            uniform float _Dissovle_Width;
            uniform float _Dissovle_Time;
            uniform fixed _AnimVertexAlpha;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float4 _D01_var = tex2D(_D01,TRANSFORM_TEX(i.uv0, _D01));
                float4 _Alpha01_var = tex2D(_Alpha01,TRANSFORM_TEX(i.uv0, _Alpha01));
                float4 _Alpha02_var = tex2D(_Alpha02,TRANSFORM_TEX(i.uv0, _Alpha02));
                float node_2590 = ((1.0 - lerp( _Dissovle_Time, i.vertexColor.a, _AnimVertexAlpha ))*((_Alpha01_var.r+_Alpha02_var.r)+(0.1+_Dissovle_Width)));
                float node_5985_if_leA = step(node_2590,(0.1+_Dissovle_Width));
                float node_5985_if_leB = step((0.1+_Dissovle_Width),node_2590);
                float node_7596 = 1.0;
                float node_242 = 0.0;
                float node_5985 = lerp((node_5985_if_leA*node_7596)+(node_5985_if_leB*node_242),node_242,node_5985_if_leA*node_5985_if_leB);
                clip((_D01_var.a*node_5985) - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}

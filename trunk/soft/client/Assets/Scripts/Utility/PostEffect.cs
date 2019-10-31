using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class PostEffect : MonoBehaviour
{

    public Shader m_effectShader;
    private Material m_effectMaterial;
    public Material EffectMaterial
    {
        get
        {
            m_effectMaterial = CreateMaterial(m_effectShader, m_effectMaterial);
            return m_effectMaterial;
        }
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (EffectMaterial != null)
        {
            Graphics.Blit(src, dest, EffectMaterial);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }

    private void Start()
    {
        bool isSupported = CheckSupport();

        if (isSupported == false)
        {
            this.enabled = false;
        }
    }


    // 检测当前平台是否支持屏幕特效
    private bool CheckSupport()
    {
        if (SystemInfo.supportsImageEffects == false)
        {
            Debug.LogWarning("当前平台不支持！");
            return false;
        }
        return true;
    }


    // 创建材质
    private Material CreateMaterial(Shader shader, Material material)
    {
        if (shader == null)
        {
            return null;
        }

        if (shader.isSupported && material && material.shader == shader)
            return material;

        if (!shader.isSupported)
        {
            return null;
        }
        else
        {
            material = new Material(shader);
            material.hideFlags = HideFlags.DontSave;
            if (material)
                return material;
            else
                return null;
        }
    }
}
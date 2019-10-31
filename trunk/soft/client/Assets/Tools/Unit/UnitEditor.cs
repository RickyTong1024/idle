using UnityEngine;
using System.Collections.Generic;
using UnityEngine.UI;
using System.IO;
using System;

public class UnitEditor : MonoBehaviour
{
    public static UnitEditor instance;
    public GameObject m_unit;

    void Awake()
    {
        if (instance == null)
        {
            instance = this;
        }
    }

    Transform GetParent(GameObject obj, string part)
    {
        if (part == "weapon")
        {
            return Util.FindSub(obj.transform ,"Bip01 R Hand");
        }
        return obj.transform;
    }

    GameObject GetPart(GameObject obj, string part)
    {
        Transform par = GetParent(obj, part);
        GameObject p = par.Find(part).gameObject;
        return p;
    }

    public void ChangePart(string part, string name)
    {
        GameObject unit = m_unit;
        GameObject p = GetPart(unit, part);
        Transform pp = null;
        if (p != null)
        {
            if (part != "weapon") {
                SkinnedMeshRenderer s = p.GetComponent<SkinnedMeshRenderer>();
                if (s != null) {
                    GameObject.DestroyImmediate(s);
                }
            }
            else {
                pp = p.transform.parent;
                GameObject.Destroy(p.gameObject);
            }

        }
#if UNITY_EDITOR
        GameObject obj = UnityEditor.AssetDatabase.LoadAssetAtPath<GameObject>("Assets/res/unit/" + name + "/" + name + ".prefab");
        GameObject newp = GetPart(obj, part);
        if (newp != null) {
            if (part != "weapon") {
                SkinnedMeshRenderer news = newp.GetComponent<SkinnedMeshRenderer>();
                if (news != null) {
                    Transform bone_root = unit.transform.Find("Bip01");
                    Util.CopySkinnedMeshRenderer(news, p, bone_root);
                }
            }
            else {
                GameObject neww = GameObject.Instantiate(newp) as GameObject;
                neww.name = "weapon";
                if (pp != null) {
                    neww.transform.SetParent(pp, false);
                }
            }

        }
#endif
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            ChangePart("body", "body01");
        }
    }
}
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
[AddComponentMenu("UI/Effects/Gradient")]
public class Gradient : BaseMeshEffect
{

    public Color32 topColor = Color.white;
    public Color32 bottonColor = Color.black;

    public override void ModifyMesh(VertexHelper vh)
    {

        if (!IsActive())
        {
            return;
        }
        int count = vh.currentVertCount;
        if (count == 0) return;
        List<UIVertex> vertexs = new List<UIVertex>();
        for (int i = 0; i < count; i++)
        {
            UIVertex vertex = new UIVertex();
            vh.PopulateUIVertex(ref vertex, i);
            vertexs.Add(vertex);
        }
        float topY = vertexs[0].position.y;
        float bottonY = vertexs[0].position.y;
        for (int i = 1; i < count; i++)
        {
            float y = vertexs[i].position.y;
            if (y > topY)
            {
                topY = y;
            }
            else if (y < bottonY)
            {
                bottonY = y;
            }
        }
        float height = topY - bottonY;
        for (int i = 0; i < count; i++)
        {
            UIVertex vertex = vertexs[i];
            Color32 color = Color32.Lerp(bottonColor, topColor, (vertex.position.y - bottonY) / height);
            vertex.color = color;
            vh.SetUIVertex(vertex, i);
        }
    }

}


using UnityEngine;
using System.Collections.Generic;
using UnityEngine.UI;
using System.IO;
using System;

public class Tile
{
    public int obs;
}

public class MapEditor : MonoBehaviour
{
    public static MapEditor instance;
    public GameObject m_lx;
    public GameObject m_root;
    public GameObject m_map;
    public GameObject m_brush;
    private List<List<Tile>> m_tiles;
    private bool m_is_right_down = false;
    private int m_brush_type = 0;
    public GameObject m_color_text;
    public GameObject m_zb;
    public Canvas m_canvas;
    public RawImage m_img;
    public const int m_map_len = 85;
    public const int m_map_x = 35;
    private bool m_has_map = false;

    void Awake()
    {
        if (instance == null)
        {
            instance = this;
        }
    }

    void Start()
    {
        reset_brush();
    }

    public void new_map(string name)
    {
        if (name == "")
        {
            return;
        }
        if (!put_map(name))
        {
            return;
        }
        m_has_map = true;
        init_title();
        reset_lx();
    }

    private void init_title()
    {
        m_tiles = new List<List<Tile>>();
        for (int y = 0; y < m_map_len; ++y)
        {
            List<Tile> r = new List<Tile>();
            for (int x = 0; x < m_map_len; ++x)
            {
                Tile t = new Tile();
                t.obs = 1;
                r.Add(t);
            }
            m_tiles.Add(r);
        }
    }

    public void load_map(string name)
    {
        if (name == "")
        {
            return;
        }
        if (!put_map(name))
        {
            return;
        }
        m_has_map = true;
        init_title();
        string content = File.ReadAllText(Application.dataPath + "/res/map_config/" + name + ".txt");
        string[] ss = content.Split(' ');
        int count = 0;
        for (int y = 0; y < m_map_len; ++y)
        {
            for (int x = 0; x < m_map_len; ++x)
            {
                m_tiles[y][x].obs = int.Parse(ss[count++]);
            }
        }
        reset_lx();
    }

    public void save_map(string name)
    {
        if (name == "")
        {
            return;
        }
        string path = Application.dataPath + "/res/map_config/" + name + ".txt";
        if (File.Exists(path))
        {
            File.Delete(path);
        }
        string content = "";
        for (int y = 0; y < m_map_len; ++y)
        {
            for (int x = 0; x < m_map_len; ++x)
            {
                if (x != 0 || y != 0)
                {
                    content += " ";
                }
                content += m_tiles[y][x].obs.ToString();
            }
        }
        File.WriteAllText(path, content);
    }

    bool put_map(string name)
    {
#if UNITY_EDITOR
        Texture s = UnityEditor.AssetDatabase.LoadAssetAtPath<Texture>("Assets/res/map/" + name + ".jpg");
        if (s == null) {
            return false;
        }
        m_img.texture = s;
        m_img.rectTransform.sizeDelta = new Vector2(m_map_x * 64, (m_map_len - m_map_x) * 32 + 400);
        m_img.transform.localPosition = new Vector3(-m_map_x * 32, (m_map_x - 1) * 16 - 200, 0);
        return true;
#else
        return false;
#endif

    }

    void reset_lx()
    {
        for (int i = 0; i < m_root.transform.childCount; ++i)
        {
            GameObject.Destroy(m_root.transform.GetChild(i).gameObject);
        }
        for (int y = 0; y < m_map_len; ++y)
        {
            for (int x = 0; x < m_map_len; ++x)
            {
                GameObject obj = GameObject.Instantiate(m_lx);
                obj.transform.SetParent(m_root.transform, false);
                obj.name = x.ToString() + "_" + y.ToString();
                obj.transform.localPosition = new Vector3((x - y) * 32, (y + x) * 16, 0);
                obj.transform.localScale = Vector3.one;
                obj.SetActive(true);
                reset_obj(obj, m_tiles[y][x]);
            }
        }
    }

    void reset_obj(GameObject obj, Tile t)
    {
        if (t.obs == 0)
        {
            obj.GetComponent<Image>().color = new Color(0, 1, 0, 0.1f);
        }
        else
        {
            obj.GetComponent<Image>().color = new Color(1, 0, 0, 0.1f);
        }
    }

    void reset_brush()
    {
        if (m_brush_type == 0)
        {
            m_color_text.GetComponent<Text>().text = "绿色";
            m_color_text.GetComponent<Text>().color = new Color(0, 1, 0);
        }
        else
        {
            m_color_text.GetComponent<Text>().text = "红色";
            m_color_text.GetComponent<Text>().color = new Color(1, 0, 0);
        }
    }

    Vector2 get_xy(Vector3 v)
    {
        int fx = (int)v.x / 64;
        int fy = (int)v.y / 32;
        int xx = (int)v.x % 64;
        int yy = (int)v.y % 32;
        if (xx < 0)
        {
            fx = fx - 1;
            xx = xx + 64;
        }
        if (yy < 0)
        {
            fy = fy - 1;
            yy = yy + 32;
        }
        int x = fx + fy + 1;
        int y = fy - fx;
        if (xx < 32 && yy < 16 && (16 - yy) * 2 > xx)
        {
            x = x - 1;
        }
        else if (xx >= 32 && yy < 16 && yy * 2 < xx - 32)
        {
            y = y - 1;
        }
        else if (xx < 32 && yy >= 16 && (yy - 16) * 2 > xx)
        {
            y = y + 1;
        }
        else if (xx >= 32 && yy >= 16 && (32 - yy) * 2 < xx - 32)
        {
            x = x + 1;
        }
        return new Vector2(x, y);
    }

    void Update()
    {
        if (!m_has_map)
        {
            return;
        }
        if (Input.GetButtonDown("Fire2"))
        {
            m_is_right_down = true;
        }
        if (Input.GetButtonUp("Fire2"))
        {
            m_is_right_down = false;
        }
        if (m_is_right_down)
        {
            m_map.transform.localPosition += Vector3.right * Input.GetAxis("Mouse X") * 10;
            m_map.transform.localPosition += Vector3.up * Input.GetAxis("Mouse Y") * 10;
        }
        if (Input.GetKey(KeyCode.Q))
        {
            m_brush_type = 0;
            reset_brush();
        }
        else if (Input.GetKey(KeyCode.W))
        {
            m_brush_type = 1;
            reset_brush();
        }
        Vector3 v = Input.mousePosition;
        Vector2 pos;
        RectTransformUtility.ScreenPointToLocalPointInRectangle(m_canvas.transform as RectTransform, v, m_canvas.GetComponent<Camera>(), out pos);
        v.x = pos.x;
        v.y = pos.y;
        v.z = 0;
        v = v - m_map.transform.localPosition;
        Vector2 v2 = get_xy(v);
        int x = (int)v2.x;
        int y = (int)v2.y;
        m_zb.GetComponent<Text>().text = x.ToString() + "，" + y.ToString();
        m_brush.transform.localPosition = new Vector3((x - y) * 32, (y + x) * 16, 0);
        if (Input.GetMouseButton(0))
        {
            if (x >= 0 && y >= 0 && x < m_map_len && y < m_map_len)
            {
                if (m_tiles[y][x].obs != m_brush_type)
                {
                    m_tiles[y][x].obs = m_brush_type;
                    GameObject obj = m_root.transform.Find(x.ToString() + "_" + y.ToString()).gameObject;
                    reset_obj(obj, m_tiles[y][x]);
                }
            }
        }
    }
}

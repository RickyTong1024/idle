using UnityEngine;
using System.Collections.Generic;
using LuaInterface;
using UnityEngine.UI;

public class UIScrollGrid : MonoBehaviour
{

    [SerializeField]
    private float verticalGap;
    [SerializeField]
    private float horizontalGap;

    [HideInInspector]
    public GameObject prefab;//预制件

    public bool IsReverseLayer;//是否反转层级顺序
    public bool IsReverseScroll;//是否反转滚动顺序

    private GameObject container;
    private GameObject pool;

    private RectTransform rectTransform;
    private ScrollRect scrollRect;

    private float width;
    private float height;
    private float cellWidth;
    private float cellHeight;

    private float cellScale;

    [SerializeField]
    private bool isVertical;

    [SerializeField]
    private bool showEmptyCell;//是否补全空的单元格



    private float containerWidth;
    private float containerHeight;

    private int dataCount;

    private int rowNum;//最多同时显示多少行
    private int colNum;//最多同时显示多少列

    private int minShowNum;//最少同时显示多少个  如果要补全空的单元格就会用到这个数量

    private List<Transform> showPool = new List<Transform>();
    private List<Transform> hidePool = new List<Transform>();

    private int showIndex;
    private int selectedIndex = -1;
    private float curPercent = 0;

    private int[] insertIndexArr;
    private RectTransform[] insertRectArr;
    private float allInsertFix = 0;

    public LuaFunction SetDataHandle;//数据设置的回调(点击的处理统一通过button的listener去处理，循环链表不进行广播)

    private bool hasSetContainerSize = false;//由于在setData之前就调用OnScroll方法会导致报错  所以确保在OnScroll之前就已经setDta了

    private string unitName;

    public void SetData(int _dataCount)
    {
        dataCount = _dataCount;

        scrollRect.StopMovement();

        SetContainerSize();

        showIndex = 0;

        ResetPos(0, true, false);
    }

    private void SetContainerSize()
    {

        if (isVertical)
        {

            containerHeight = Mathf.Ceil(1.0f * (dataCount - colNum) / colNum) * (cellHeight + verticalGap) + cellHeight;

            if (insertIndexArr != null)
            {

                allInsertFix = 0;

                for (int i = 0; i < insertIndexArr.Length; i++)
                {

                    allInsertFix += insertRectArr[i].rect.height + verticalGap;
                }
                containerHeight += allInsertFix;
            }

            if (containerHeight < height)
            {

                containerHeight = height;
            }

            rectTransform.anchoredPosition = new Vector2(rectTransform.anchoredPosition.x, 0f);
            rectTransform.offsetMin = new Vector2(rectTransform.offsetMin.x, -containerHeight);
            rectTransform.offsetMax = new Vector2(width, 0);

            curPercent = 1;

        }
        else
        {

            containerWidth = Mathf.Ceil(1.0f * (dataCount - rowNum) / rowNum) * (cellWidth + horizontalGap) + cellWidth;

            if (insertIndexArr != null)
            {

                allInsertFix = 0;

                for (int i = 0; i < insertIndexArr.Length; i++)
                {

                    allInsertFix += insertRectArr[i].rect.width + horizontalGap;
                }

                containerWidth += allInsertFix;
            }

            if (containerWidth < width)
            {

                containerWidth = width;
            }

            rectTransform.anchoredPosition = new Vector2(0f, rectTransform.anchoredPosition.y);
            rectTransform.offsetMax = new Vector2(containerWidth, rectTransform.offsetMax.y);
            rectTransform.offsetMin = new Vector2(0, -height);

            curPercent = 0;
        }

        if (!hasSetContainerSize)
        {

            hasSetContainerSize = true;

            scrollRect.onValueChanged.AddListener(new UnityEngine.Events.UnityAction<Vector2>(OnScroll));
        }
    }

    public void SetInsert(int[] _indexs, RectTransform[] _rects)
    {

        insertIndexArr = _indexs;

        insertRectArr = _rects;

        SetContainerSize();

        if (insertIndexArr != null)
        {

            float fix = 0;

            for (int i = 0; i < insertIndexArr.Length; i++)
            {

                _rects[i].SetParent(container.transform, false);

                if (isVertical)
                {

                    insertRectArr[i].anchoredPosition = new Vector2(0, -(cellHeight + verticalGap) * insertIndexArr[i] - fix);

                    fix += _rects[i].rect.height + verticalGap;

                }
                else
                {

                    insertRectArr[i].anchoredPosition = new Vector2((cellWidth + horizontalGap) * insertIndexArr[i] + fix, 0);

                    fix += _rects[i].rect.width + horizontalGap;
                }
            }
        }

        showIndex = 0;

        ResetPos(0, false, true);
    }

    public void SetDataAndKeepLocation(int _data)
    {
        float percent = curPercent;

        SetData(_data);

        curPercent = percent;

        SetCurPercent();
    }

    public void Clear()
    {
        SetData(0);
    }

    private void SetSize()
    {
        if (isVertical)
        {

            float tmpCellWidth = (prefab.transform as RectTransform).rect.width;

            if (width >= tmpCellWidth)
            {

                colNum = (int)Mathf.Floor((width - tmpCellWidth) / (tmpCellWidth + horizontalGap)) + 1;

                cellScale = 1;

                cellWidth = tmpCellWidth;
                cellHeight = (prefab.transform as RectTransform).rect.height;

            }
            else
            {

                colNum = 1;

                cellScale = width / tmpCellWidth;

                cellWidth = width;
                cellHeight = (prefab.transform as RectTransform).rect.height * cellScale;
            }

            int n = (int)(height / (cellHeight + verticalGap));

            if (height - n * (cellHeight + verticalGap) < verticalGap)
            {

                rowNum = n + 1;

            }
            else
            {

                rowNum = n + 2;
            }

            minShowNum = colNum * (rowNum - 1);

        }
        else
        {

            float tmpCellHeight = (prefab.transform as RectTransform).rect.height;

            if (height >= tmpCellHeight)
            {

                rowNum = (int)Mathf.Floor((height - tmpCellHeight) / (tmpCellHeight + verticalGap)) + 1;

                cellScale = 1;

                cellWidth = (prefab.transform as RectTransform).rect.width;
                cellHeight = tmpCellHeight;

            }
            else
            {

                rowNum = 1;

                cellScale = height / tmpCellHeight;

                cellWidth = (prefab.transform as RectTransform).rect.width * cellScale;
                cellHeight = height;
            }

            int n = (int)(width / (cellWidth + horizontalGap));

            if (width - n * (cellWidth + horizontalGap) < horizontalGap)
            {

                colNum = n + 1;

            }
            else
            {

                colNum = n + 2;
            }

            minShowNum = rowNum * (colNum - 1);
        }
    }

    void CreateCells(object[] _objs)
    {
        unitName = prefab.name;

        for (int i = 0; i < rowNum * colNum; i++)
        {

            GameObject unit = GameObject.Instantiate(prefab);

            unit.transform.SetParent(pool.transform, false);

            (unit.transform as RectTransform).localScale = new Vector3(cellScale, cellScale, cellScale);

            (unit.transform as RectTransform).pivot = new Vector2(0, 1);

            (unit.transform as RectTransform).anchorMin = new Vector2(0, 1);

            (unit.transform as RectTransform).anchorMax = new Vector2(0, 1);

            hidePool.Add(unit.transform);
        }

    }

    // Use this for initialization
    void Awake()
    {

        if (null == scrollRect)
        {
            scrollRect = gameObject.AddComponent<ScrollRect>();

            scrollRect.vertical = isVertical;

            scrollRect.horizontal = !isVertical;
            scrollRect.movementType = ScrollRect.MovementType.Clamped;

            gameObject.AddComponent<RectMask2D>();

            Image img = gameObject.AddComponent<Image>();

            img.color = Color.clear;
        }
       
    }

    public void Init(params object[] _objs)
    {
        if (null == scrollRect)
        {
            scrollRect = gameObject.AddComponent<ScrollRect>();

            scrollRect.vertical = isVertical;

            scrollRect.horizontal = !isVertical;
            scrollRect.movementType = ScrollRect.MovementType.Clamped;

            gameObject.AddComponent<RectMask2D>();

            Image img = gameObject.AddComponent<Image>();

            img.color = Color.clear;
        }

        container = new GameObject("Container", typeof(RectTransform));

        container.transform.SetParent(transform, false);

        pool = new GameObject("Pool", typeof(RectTransform));

        pool.transform.SetParent(transform, false);

        pool.SetActive(false);

        rectTransform = container.transform as RectTransform;
        if (IsReverseScroll)
        {
            rectTransform.anchorMin = new Vector2(0, 0);
            rectTransform.anchorMax = new Vector2(0, 0);
            rectTransform.pivot = new Vector2(0, 0);
        }
        else
        {
            rectTransform.anchorMin = new Vector2(0, 1);
            rectTransform.anchorMax = new Vector2(0, 1);
            rectTransform.pivot = new Vector2(0, 1);
        }
        rectTransform.offsetMin = new Vector2();
        rectTransform.offsetMax = new Vector2();

        scrollRect.content = rectTransform;

        width = (transform as RectTransform).rect.width;
        height = (transform as RectTransform).rect.height;
        
        SetSize();

        CreateCells(_objs);
    }

    public void OnScroll(Vector2 _v)
    {
        int nowIndex;

        if (isVertical)
        {

            curPercent = _v.y;

            float y;

            if (curPercent < 0)
            {

                y = 1;

            }
            else if (curPercent > 1)
            {

                y = 0;

            }
            else
            {

                y = 1 - curPercent;
            }

            if (insertIndexArr == null)
            {
                nowIndex = (int)(y * (containerHeight - height) / (cellHeight + verticalGap)) * colNum;
            }
            else
            {

                FixY(0, y, ref y, 0);

                nowIndex = (int)(y * (containerHeight - height - allInsertFix) / (cellHeight + verticalGap)) * colNum;

                if (nowIndex < 0)
                {

                    nowIndex = 0;
                }
            }

        }
        else
        {

            curPercent = _v.x;

            float x;

            if (curPercent < 0)
            {

                x = 0;

            }
            else if (curPercent > 1)
            {

                x = 1;

            }
            else
            {

                x = curPercent;
            }

            if (insertIndexArr == null)
            {

                nowIndex = (int)(x * (containerWidth - width) / (cellWidth + horizontalGap)) * rowNum;

            }
            else
            {

                FixX(0, x, ref x, 0);

                nowIndex = (int)(x * (containerWidth - width - allInsertFix) / (cellWidth + horizontalGap)) * rowNum;

                if (nowIndex < 0)
                {

                    nowIndex = 0;
                }
            }
        }

        if (nowIndex != showIndex)
        {

            ResetPos(nowIndex, false, false);
        }
    }

    private void FixY(int _startIndex, float _yOld, ref float _y, float _fix)
    {

        int tmpIndex = (int)(_y * (containerHeight - height - allInsertFix) / (cellHeight + verticalGap));

        if (tmpIndex > insertIndexArr[_startIndex])
        {

            _fix += insertRectArr[_startIndex].rect.height + verticalGap;

            _y = ((containerHeight - height - allInsertFix + _fix) * _yOld - _fix) / (containerHeight - height - allInsertFix);

            if (_startIndex < insertIndexArr.Length - 1)
            {

                FixY(_startIndex + 1, _yOld, ref _y, _fix);
            }
        }
    }

    private void FixX(int _startIndex, float _xOld, ref float _x, float _fix)
    {

        int tmpIndex = (int)(_x * (containerWidth - width - allInsertFix) / (cellWidth + horizontalGap));

        if (tmpIndex > insertIndexArr[_startIndex])
        {

            _fix += insertRectArr[_startIndex].rect.width + horizontalGap;

            _x = ((containerWidth - width - allInsertFix + _fix) * _xOld - _fix) / (containerWidth - width - allInsertFix);

            if (_startIndex < insertIndexArr.Length - 1)
            {

                FixX(_startIndex + 1, _xOld, ref _x, _fix);
            }
        }
    }

    private void ResetPos(int _nowIndex, bool _dataHasChange, bool _insertHasChange)
    {
        if (isVertical)
        {

            if (_nowIndex - showIndex == colNum)
            {
                for (int i = 0; i < _nowIndex - showIndex; i++)
                {
                    int newIndex = showIndex + rowNum * colNum + i;
                    Transform unit = showPool[0];
                    showPool.RemoveAt(0);
                    if (newIndex < dataCount)
                    {
                        showPool.Add(unit);

                        SetCellData(unit, newIndex);

                        SetCellIndex(unit, newIndex);

                    }
                    else
                    {

                        hidePool.Add(unit);

                        unit.transform.SetParent(pool.transform, false);
                    }
                }

            }
            else if (_nowIndex - showIndex == -colNum)
            {
                for (int i = 0; i < showIndex - _nowIndex; i++)
                {

                    int newIndex = showIndex - colNum + i;

                    Transform unit;

                    if (showPool.Count == rowNum * colNum)
                    {

                        unit = showPool[showPool.Count - 1];

                        showPool.RemoveAt(showPool.Count - 1);

                    }
                    else
                    {

                        unit = hidePool[0];

                        hidePool.RemoveAt(0);

                        unit.transform.SetParent(container.transform, false);
                    }

                    showPool.Insert(0, unit);

                    SetCellData(unit, newIndex);

                    SetCellIndex(unit, newIndex);
                }

            }
            else
            {
                List<int> tmpList = new List<int>();

                for (int i = 0; i < rowNum * colNum; i++)
                {

                    if (_nowIndex + i < dataCount)
                    {

                        tmpList.Add(_nowIndex + i);

                    }
                    else
                    {

                        break;
                    }
                }

                Transform[] newShowPool = new Transform[tmpList.Count];

                List<Transform> replacePool = new List<Transform>();

                for (int i = 0; i < showPool.Count; i++)
                {
                    Transform unit = showPool[i];

                    int tmpIndex = IndexOf(unit);

                    if (tmpList.Contains(tmpIndex))
                    {

                        newShowPool[tmpList.IndexOf(tmpIndex)] = unit;

                        if (_dataHasChange)
                        {

                            SetCellData(unit, tmpIndex);//如果列表数据已经发生了变化则需要在这里进行一次单元格赋值
                        }

                        if (_insertHasChange)
                        {

                            SetCellIndex(unit, tmpIndex);
                        }

                    }
                    else
                    {

                        replacePool.Add(unit);
                    }
                }

                showPool.Clear();
                if (IsReverseLayer)
                {
                    for (int i = newShowPool.Length - 1; i >= 0; i--)
                    {
                        if (newShowPool[i] == null)
                        {

                            Transform unit;

                            if (replacePool.Count > 0)
                            {

                                unit = replacePool[0];

                                replacePool.RemoveAt(0);

                            }
                            else
                            {

                                unit = hidePool[0];

                                hidePool.RemoveAt(0);

                                unit.transform.SetParent(container.transform, false);
                            }

                            newShowPool[i] = unit;

                            SetCellData(unit, tmpList[i]);

                            SetCellIndex(unit, tmpList[i]);
                        }

                        showPool.Add(newShowPool[i]);
                    }
                    showPool.Reverse();

                }
                else
                {
                    for (int i = 0; i < newShowPool.Length; i++)
                    {
                        if (newShowPool[i] == null)
                        {

                            Transform unit;

                            if (replacePool.Count > 0)
                            {

                                unit = replacePool[0];

                                replacePool.RemoveAt(0);

                            }
                            else
                            {

                                unit = hidePool[0];

                                hidePool.RemoveAt(0);

                                unit.transform.SetParent(container.transform, false);
                            }

                            newShowPool[i] = unit;

                            SetCellData(unit, tmpList[i]);

                            SetCellIndex(unit, tmpList[i]);
                        }
                        showPool.Add(newShowPool[i]);
                    }
                }
                
                for (int i = 0; i < replacePool.Count; i++)
                {

                    Transform unit = replacePool[i];

                    unit.transform.SetParent(pool.transform, false);

                    hidePool.Add(unit);
                }
            }

        }
        else
        {

            if (_nowIndex - showIndex == rowNum)
            {

                for (int i = 0; i < _nowIndex - showIndex; i++)
                {

                    int newIndex = showIndex + rowNum * colNum + i;

                    Transform unit = showPool[0];

                    showPool.RemoveAt(0);

                    if (newIndex < dataCount)
                    {

                        showPool.Add(unit);

                        SetCellData(unit, newIndex);

                        SetCellIndex(unit, newIndex);
                    }
                    else
                    {

                        hidePool.Add(unit);

                        unit.transform.SetParent(pool.transform, false);
                    }
                }

            }
            else if (_nowIndex - showIndex == -rowNum)
            {

                for (int i = 0; i < showIndex - _nowIndex; i++)
                {

                    int newIndex = showIndex - rowNum + i;

                    Transform unit;

                    if (showPool.Count == rowNum * colNum)
                    {

                        unit = showPool[showPool.Count - 1];

                        showPool.RemoveAt(showPool.Count - 1);

                    }
                    else
                    {

                        unit = hidePool[0];

                        hidePool.RemoveAt(0);

                        unit.transform.SetParent(container.transform, false);
                    }

                    showPool.Insert(0, unit);

                    SetCellData(unit, newIndex);

                    SetCellIndex(unit, newIndex);
                }

            }
            else
            {

                List<int> tmpList = new List<int>();

                for (int i = 0; i < rowNum * colNum; i++)
                {

                    if (_nowIndex + i < dataCount)
                    {

                        tmpList.Add(_nowIndex + i);

                    }
                    else
                    {

                        break;
                    }
                }

                Transform[] newShowPool = new Transform[tmpList.Count];

                List<Transform> replacePool = new List<Transform>();

                for (int i = 0; i < showPool.Count; i++)
                {

                    Transform unit = showPool[i];

                    int tmpIndex = IndexOf(unit);

                    if (tmpList.Contains(tmpIndex))
                    {

                        newShowPool[tmpList.IndexOf(tmpIndex)] = unit;

                        if (_dataHasChange)
                        {

                            SetCellData(unit, tmpIndex);
                        }

                        if (_insertHasChange)
                        {

                            SetCellIndex(unit, tmpIndex);
                        }

                    }
                    else
                    {

                        replacePool.Add(unit);
                    }
                }

                showPool.Clear();

                for (int i = 0; i < newShowPool.Length; i++)
                {

                    if (newShowPool[i] == null)
                    {

                        Transform unit;

                        if (replacePool.Count > 0)
                        {

                            unit = replacePool[0];

                            replacePool.RemoveAt(0);

                        }
                        else
                        {

                            unit = hidePool[0];

                            hidePool.RemoveAt(0);

                            unit.transform.SetParent(container.transform, false);
                        }

                        newShowPool[i] = unit;

                        SetCellData(unit, tmpList[i]);

                        SetCellIndex(unit, tmpList[i]);
                    }

                    showPool.Add(newShowPool[i]);
                }

                for (int i = 0; i < replacePool.Count; i++)
                {

                    Transform unit = replacePool[i];

                    unit.transform.SetParent(pool.transform, false);

                    hidePool.Add(unit);
                }
            }
        }

        showIndex = _nowIndex;

        if (showEmptyCell)
        {

            for (int i = showPool.Count; i < minShowNum; i++)
            {

                Transform unit = hidePool[0];

                hidePool.RemoveAt(0);

                unit.transform.SetParent(container.transform, false);

                showPool.Add(unit);

                SetCellData(unit, -1);

                SetCellIndex(unit, showIndex + i);
            }
        }
    }

    private void SetCellIndex(Transform _cell, int _index)
    {
        int row;

        int col;

        float xFix = 0;

        float yFix = 0;

        if (isVertical)
        {

            row = _index / colNum;

            col = _index % colNum;

            if (insertIndexArr != null)
            {

                for (int i = 0; i < insertIndexArr.Length; i++)
                {

                    if (row >= insertIndexArr[i])
                    {

                        yFix += insertRectArr[i].rect.height + verticalGap;

                    }
                    else
                    {

                        break;
                    }
                }
            }

        }
        else
        {

            col = _index / rowNum;

            row = _index % rowNum;

            if (insertIndexArr != null)
            {

                for (int i = 0; i < insertIndexArr.Length; i++)
                {

                    if (col >= insertIndexArr[i])
                    {

                        xFix += insertRectArr[i].rect.width + horizontalGap;

                    }
                    else
                    {

                        break;
                    }
                }
            }
        }

        float xPos = col * (cellWidth + horizontalGap) + xFix;

        float yPos = -row * (cellHeight + verticalGap) - yFix;

        Vector2 pos = new Vector2(xPos, yPos);

        (_cell.transform as RectTransform).anchoredPosition = pos;

        _cell.name = _index.ToString();

    }

    private void SetCellData(Transform _cell, int _index)
    {

        if (_index == -1)
        {
            //SetDataCallBack(_cell.gameObject, _index);
        }
        else
        {
            SetDataHandle.Call(_cell.gameObject, _index);

        }
    }

    public int GetSelectedIndex()
    {
        return selectedIndex;
    }

    public void DisplayIndex(int _index)
    {
        float finalPos;

        if (isVertical)
        {

            if (containerHeight > height)
            {

                float pos = (_index / colNum) * (cellHeight + verticalGap);

                if (insertRectArr != null)
                {

                    for (int i = 0; i < insertRectArr.Length; i++)
                    {

                        if (_index >= insertIndexArr[i])
                        {

                            pos = pos + insertRectArr[i].rect.height + verticalGap;

                        }
                        else
                        {

                            break;
                        }
                    }
                }

                finalPos = 1 - pos / (containerHeight - height);

                if (finalPos < 0)
                {

                    finalPos = 0;

                }
                else if (finalPos > 1)
                {

                    finalPos = 1;
                }

            }
            else
            {

                finalPos = 1;
            }

        }
        else
        {

            if (containerWidth > width)
            {

                float pos = (_index / rowNum) * (cellWidth + horizontalGap);

                if (insertRectArr != null)
                {

                    for (int i = 0; i < insertRectArr.Length; i++)
                    {

                        if (_index >= insertIndexArr[i])
                        {

                            pos = pos + insertRectArr[i].rect.width + horizontalGap;

                        }
                        else
                        {

                            break;
                        }
                    }
                }

                finalPos = pos / (containerWidth - width);

                if (finalPos < 0)
                {

                    finalPos = 0;

                }
                else if (finalPos > 1)
                {

                    finalPos = 1;
                }

            }
            else
            {

                finalPos = 0;
            }
        }

        curPercent = finalPos;

        SetCurPercent();
    }

    public void UpdateItemAt(int _index)
    {
        //data [_index] = _data;

        for (int i = 0; i < showPool.Count; i++)
        {

            Transform cell = showPool[i];

            if (IndexOf(cell) == _index)
            {

                SetDataHandle.Call(cell.gameObject, _index);
                //cell.SetData(_data);

                break;
            }
        }
    }

    public void UpdateItemAll()
    {
        for (int i = 0; i < showPool.Count; i++)
        {
            Transform cell = showPool[i];
            SetDataHandle.Call(cell.gameObject, IndexOf(cell));
        }
    }

    private void SetCurPercent()
    {

        if (isVertical)
        {

            OnScroll(new Vector2(0, curPercent));

            scrollRect.verticalNormalizedPosition = curPercent;

        }
        else
        {

            OnScroll(new Vector2(curPercent, 0));

            scrollRect.horizontalNormalizedPosition = curPercent;
        }
    }

    public void StopMovement()
    {

        scrollRect.StopMovement();
    }


    private int IndexOf(Transform t)
    {
        return int.Parse(t.name);
    }

    private void OnDestroy() {
        if (SetDataHandle != null) {
            SetDataHandle.Dispose();
            SetDataHandle = null;
        }
        
    }

}


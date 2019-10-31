using UnityEngine;
using System;
using System.Collections.Generic;
using LuaInterface;
using UnityEditor;
using UnityEngine.EventSystems;
using BindType = ToLuaMenu.BindType;
using UnityEngine.UI;
using System.Reflection;
using UnityEngine.U2D;
using UnityEngine.Events;
using System.Collections;
using Spine.Unity;
using System.Xml.Linq;
using System.IO;
using Coffee.UIExtensions;
using static UnityEngine.UI.InputField;
using UnityEngine.Networking;
using UnityEngine.SceneManagement;

public static class CustomSettings {
    public static string FrameworkPath = platform_config_common.LuaFrameworkRoot;
    public static string saveDir = FrameworkPath + "/ToLua/Source/Generate/";
    public static string luaDir = FrameworkPath + "/Lua/";
    public static string toluaBaseType = FrameworkPath + "/ToLua/BaseType/";
    public static string baseLuaDir = FrameworkPath + "/ToLua/Lua";
    public static string injectionFilesPath = Application.dataPath + "/ToLua/Injection/";

    //导出时强制做为静态类的类型(注意customTypeList 还要添加这个类型才能导出)
    //unity 有些类作为sealed class, 其实完全等价于静态类
    public static List<Type> staticClassTypes = new List<Type>
    {
        typeof(UnityEngine.Application),
        typeof(UnityEngine.Time),
        typeof(UnityEngine.Screen),
        typeof(UnityEngine.SleepTimeout),
        typeof(UnityEngine.Input),
        typeof(UnityEngine.Resources),
        typeof(UnityEngine.Physics),
        typeof(UnityEngine.RenderSettings),
        typeof(UnityEngine.GL),
        typeof(UnityEngine.Graphics),
    };

    //附加导出委托类型(在导出委托时, customTypeList 中牵扯的委托类型都会导出， 无需写在这里)
    public static DelegateType[] customDelegateList =
    {
        _DT(typeof(Action)),
        _DT(typeof(UnityEngine.Events.UnityAction)),
        _DT(typeof(System.Predicate<int>)),
        _DT(typeof(System.Action<int>)),
        _DT(typeof(System.Comparison<int>)),
        _DT(typeof(System.Func<int, int>)),
    };

    //在这里添加你要导出注册到lua的类型列表
    public static BindType[] customTypeList =
    {
        _GT(typeof(LuaInjectionStation)),
        _GT(typeof(InjectType)),
        _GT(typeof(Debugger)).SetNameSpace(null),          

        _GT(typeof(DG.Tweening.DOTween)),
        _GT(typeof(DG.Tweening.Tween)).SetBaseType(typeof(System.Object)).AddExtendType(typeof(DG.Tweening.TweenExtensions)),
        _GT(typeof(DG.Tweening.Sequence)).AddExtendType(typeof(DG.Tweening.TweenSettingsExtensions)),
        _GT(typeof(DG.Tweening.Tweener)).AddExtendType(typeof(DG.Tweening.TweenSettingsExtensions)),
        _GT(typeof(DG.Tweening.LoopType)),
        _GT(typeof(DG.Tweening.PathMode)),
        _GT(typeof(DG.Tweening.PathType)),
        _GT(typeof(DG.Tweening.RotateMode)),
         _GT(typeof(DG.Tweening.Ease)),
         // unity base component
        _GT(typeof(Component)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(Transform)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(Behaviour)),
        _GT(typeof(MonoBehaviour)),
        _GT(typeof(GameObject)),
        _GT(typeof(Application)),

        

        _GT(typeof(Time)),
        _GT(typeof(Shader)),
        _GT(typeof(Renderer)),
        _GT(typeof(CameraClearFlags)),
        _GT(typeof(Screen)),
        _GT(typeof(TrackedReference)),
        _GT(typeof(AssetBundle)),
        _GT(typeof(ParticleSystem)),
        _GT(typeof(ParticleSystem.MainModule)),
        _GT(typeof(AsyncOperation)).SetBaseType(typeof(System.Object)),
        
        _GT(typeof(SleepTimeout)),
        _GT(typeof(Keyframe)),
        _GT(typeof(Input)),
        _GT(typeof(KeyCode)),
        _GT(typeof(SkinnedMeshRenderer)),
        _GT(typeof(Space)),
        _GT(typeof(WWW)),
        _GT(typeof(UnityWebRequest)),
        _GT(typeof(DownloadHandler)),
        _GT(typeof(UploadHandler)),
        _GT(typeof(WWWForm)),
        _GT(typeof(MeshRenderer)),
         _GT(typeof(RenderSettings)),
        _GT(typeof(BlendWeights)),
        _GT(typeof(RenderTexture)),
        _GT(typeof(Resources)),
        _GT(typeof(LuaProfiler)),
        _GT(typeof(Animator)),
        _GT(typeof(AnimatorStateInfo)),
        _GT(typeof(AnimationCurve)),
        _GT(typeof(Animation)),
        _GT(typeof(AnimationClip)).SetBaseType(typeof(UnityEngine.Object)),
        _GT(typeof(AnimationState)),
        _GT(typeof(AnimationBlendMode)),
        _GT(typeof(QueueMode)),
        _GT(typeof(PlayMode)),
        _GT(typeof(WrapMode)),
        _GT(typeof(LightType)),
        //component
         
        _GT(typeof(Material)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(Rigidbody)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(Camera)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(AudioSource)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(LineRenderer)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(TrailRenderer)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(CanvasGroup)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)),
        _GT(typeof(RawImage)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)),
        _GT(typeof(Image)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)),
        _GT(typeof(Text)).AddExtendType(typeof(DG.Tweening.DOTweenModuleUI)),
        _GT(typeof(SpriteRenderer)),
        _GT(typeof(RectTransform)),
        _GT(typeof(Rect)),
        _GT(typeof(AudioClip)),

        _GT(typeof(RectTransformUtility)),
        _GT(typeof(Texture)),
        _GT(typeof(Texture2D)),
        _GT(typeof(LocalizationText)),
        _GT(typeof(Button)),
        _GT(typeof(InputField)),
        _GT(typeof(SubmitEvent)).AddExtendType(typeof(UnityEvent<string>)),
        _GT(typeof(SpriteAtlas)),
        _GT(typeof(Sprite)),
        _GT(typeof(Scrollbar)),
        _GT(typeof(Dropdown)),
        _GT(typeof(Physics)),
        _GT(typeof(Collider)),
        _GT(typeof(BoxCollider)),
        _GT(typeof(MeshCollider)),
        _GT(typeof(SphereCollider)),
        _GT(typeof(CharacterController)),
        _GT(typeof(CapsuleCollider)),
        _GT(typeof(Toggle)),
        _GT(typeof(ToggleGroup)),
        _GT(typeof(Slider)),
        _GT(typeof(UIScrollGrid)),
        _GT(typeof(ScrollRect)),
        _GT(typeof(HorizontalLayoutGroup)),
        _GT(typeof(RectOffset)),
        _GT(typeof(UnityEvent)),
        _GT(typeof(UnityEventBase)),
        _GT(typeof(Color)),
        _GT(typeof(Outline)),
        _GT(typeof(UnityEngine.Random)),
        _GT(typeof(SkeletonGraphic)),
        _GT(typeof(SkeletonAnimation)),
        _GT(typeof(Spine.TrackEntry)),
        _GT(typeof(Spine.AnimationState)),
        _GT(typeof(Spine.Animation)),
        _GT(typeof(Spine.Skeleton)),
        _GT(typeof(Spine.SkeletonData)),
        _GT(typeof(TextAsset)),
        _GT(typeof(Canvas)),

        _GT(typeof(DragPanel)),
        _GT(typeof(PressControl)),
        _GT(typeof(PointerEventData)), 
        _GT(typeof(RaycastResult)),
        _GT(typeof(Type)),
        _GT(typeof(Mesh)),
        _GT(typeof(MeshFilter)),
        _GT(typeof(LayerMask)),
        _GT(typeof(LayoutUtility)),
        _GT(typeof(ContentSizeFitter)),
        _GT(typeof(LayoutRebuilder)),
        _GT(typeof(ColorUtility)),
        _GT(typeof(UITransitionEffect)),
        //scripts
        _GT(typeof(Util)),
        _GT(typeof(LuaHelper)),
        _GT(typeof(LuaUIBehaviour)),
        _GT(typeof(GameManager)),
        _GT(typeof(LuaManager)),
        _GT(typeof(PanelManager)),
        _GT(typeof(SoundManager)),
        _GT(typeof(TimerManager)),
        _GT(typeof(MessageManager)),
        _GT(typeof(NetworkManager)),
        _GT(typeof(platform_config_common)),
        _GT(typeof(dbc)),
        _GT(typeof(ArrayList)),
        _GT(typeof(PlayerPrefs)),
        _GT(typeof(CommonMessage)),
        _GT(typeof(NetMessage)),
        _GT(typeof(PostEffect)),
        _GT(typeof(XDocument)),
        _GT(typeof(XName)),
        _GT(typeof(XElement)),
        _GT(typeof(XAttribute)),
        _GT(typeof(List<XElement>)),
        _GT(typeof(List<XAttribute>)),
        _GT(typeof(SceneManager)),
        _GT(typeof(CustomButton)),
    };

    public static List<Type> dynamicList = new List<Type>()
    {
    
        typeof(MeshRenderer),
        typeof(BoxCollider),
        typeof(MeshCollider),
        typeof(SphereCollider),
        typeof(CharacterController),
        typeof(CapsuleCollider),

        typeof(Animation),
        typeof(AnimationClip),
        typeof(AnimationState),

        typeof(BlendWeights),
        typeof(RenderTexture),
        typeof(Rigidbody),
    };

    //重载函数，相同参数个数，相同位置out参数匹配出问题时, 需要强制匹配解决
    //使用方法参见例子14
    public static List<Type> outList = new List<Type>() {

    };

    //ngui优化，下面的类没有派生类，可以作为sealed class
    public static List<Type> sealedList = new List<Type>() {
    };

    public static BindType _GT(Type t) {
        return new BindType(t);
    }

    public static DelegateType _DT(Type t) {
        return new DelegateType(t);
    }


    [MenuItem("Lua/Attach Profiler", false, 151)]
    static void AttachProfiler() {
        if (!Application.isPlaying) {
            EditorUtility.DisplayDialog("警告", "请在运行时执行此功能", "确定");
            return;
        }

        LuaClient.Instance.AttachProfiler();
    }

    [MenuItem("Lua/Detach Profiler", false, 152)]
    static void DetachProfiler() {
        if (!Application.isPlaying) {
            return;
        }

        LuaClient.Instance.DetachProfiler();
    }
}

﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class PressControlWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(PressControl), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("SetPressControl", SetPressControl);
		L.RegFunction("OnPointerDown", OnPointerDown);
		L.RegFunction("OnPointerUp", OnPointerUp);
		L.RegFunction("RemoveLua", RemoveLua);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("start_press_beat", get_start_press_beat, set_start_press_beat);
		L.RegVar("end_press_beat", get_end_press_beat, set_end_press_beat);
		L.RegVar("change_time", get_change_time, set_change_time);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetPressControl(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 7);
			PressControl obj = (PressControl)ToLua.CheckObject<PressControl>(L, 1);
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 3);
			float arg2 = (float)LuaDLL.luaL_checknumber(L, 4);
			LuaFunction arg3 = ToLua.CheckLuaFunction(L, 5);
			LuaFunction arg4 = ToLua.CheckLuaFunction(L, 6);
			LuaTable arg5 = ToLua.CheckLuaTable(L, 7);
			obj.SetPressControl(arg0, arg1, arg2, arg3, arg4, arg5);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnPointerDown(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			PressControl obj = (PressControl)ToLua.CheckObject<PressControl>(L, 1);
			UnityEngine.EventSystems.PointerEventData arg0 = (UnityEngine.EventSystems.PointerEventData)ToLua.CheckObject<UnityEngine.EventSystems.PointerEventData>(L, 2);
			obj.OnPointerDown(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnPointerUp(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			PressControl obj = (PressControl)ToLua.CheckObject<PressControl>(L, 1);
			UnityEngine.EventSystems.PointerEventData arg0 = (UnityEngine.EventSystems.PointerEventData)ToLua.CheckObject<UnityEngine.EventSystems.PointerEventData>(L, 2);
			obj.OnPointerUp(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int RemoveLua(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			PressControl obj = (PressControl)ToLua.CheckObject<PressControl>(L, 1);
			obj.RemoveLua();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int op_Equality(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Object arg0 = (UnityEngine.Object)ToLua.ToObject(L, 1);
			UnityEngine.Object arg1 = (UnityEngine.Object)ToLua.ToObject(L, 2);
			bool o = arg0 == arg1;
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_start_press_beat(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			PressControl obj = (PressControl)o;
			float ret = obj.start_press_beat;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index start_press_beat on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_end_press_beat(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			PressControl obj = (PressControl)o;
			float ret = obj.end_press_beat;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index end_press_beat on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_change_time(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			PressControl obj = (PressControl)o;
			float ret = obj.change_time;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index change_time on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_start_press_beat(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			PressControl obj = (PressControl)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.start_press_beat = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index start_press_beat on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_end_press_beat(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			PressControl obj = (PressControl)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.end_press_beat = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index end_press_beat on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_change_time(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			PressControl obj = (PressControl)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.change_time = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index change_time on a nil value");
		}
	}
}

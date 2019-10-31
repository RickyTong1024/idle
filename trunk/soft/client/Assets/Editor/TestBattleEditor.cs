using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(TestBattleMain))]
public class TestBattleEditor : Editor
{
    TestBattleMain testbattle;

    private void OnEnable() {
        testbattle = target as TestBattleMain;
    }

    public override void OnInspectorGUI() {
        testbattle.my_id = EditorGUILayout.IntField("角色id:", testbattle.my_id);
        testbattle.enemy_id = EditorGUILayout.IntField("敌人id:", testbattle.enemy_id);
        if (GUILayout.Button("换角色")) {
            testbattle.Change(testbattle.my_id, testbattle.enemy_id);
        }
        EditorGUILayout.Space();
        //EditorGUILayout.LabelField("展示攻击");
        //testbattle.attack_speed = EditorGUILayout.FloatField("攻击速度:", testbattle.attack_speed);
        //if (GUILayout.Button("攻击1")) {
        //    testbattle.SetAttackIndex(1);
        //    testbattle.ShowSpell(1);
        //}
        //if (GUILayout.Button("攻击2")) {
        //    testbattle.SetAttackIndex(2);
        //    testbattle.ShowSpell(1);
        //}
        //if (GUILayout.Button("攻击3")) {
        //    testbattle.SetAttackIndex(3);
        //    testbattle.ShowSpell(1);
        //}

        EditorGUILayout.LabelField("展示技能");
        EditorGUILayout.BeginVertical();
        for (int i = 0; i < testbattle.spells.Length; i++) {
            testbattle.spells[i] = EditorGUILayout.IntField("技能id:", testbattle.spells[i]);
            EditorGUILayout.BeginHorizontal();
            if (GUILayout.Button("展示")) {
                testbattle.ShowSpell(testbattle.spells[i]);
            }
            if (GUILayout.Button("删除")) {
                ArrayUtility.Remove<int>(ref testbattle.spells, testbattle.spells[i]);
            }
            EditorGUILayout.EndHorizontal();
        }
        if (GUILayout.Button("增加技能")) {
            ArrayUtility.Add<int>(ref testbattle.spells, 0);
        }
        EditorGUILayout.Space();
        EditorGUILayout.LabelField("展示附能");
        for (int i = 0; i < testbattle.attachs.Length; i++) {
            testbattle.attachs[i] = EditorGUILayout.IntField("附能id:", testbattle.attachs[i]);
            EditorGUILayout.BeginHorizontal();
            if (GUILayout.Button("展示")) {
                testbattle.ShowAttach(testbattle.attachs[i]);
            }
            if (GUILayout.Button("停止")) {
                testbattle.CloseAttach(testbattle.attachs[i]);
            }
            if (GUILayout.Button("删除")) {
                ArrayUtility.Remove<int>(ref testbattle.attachs, testbattle.attachs[i]);
            }
            EditorGUILayout.EndHorizontal();
        }
        if (GUILayout.Button("增加附能")) {
            ArrayUtility.Add<int>(ref testbattle.attachs, 0);
        }

        EditorGUILayout.Space();
        EditorGUILayout.LabelField("展示其他行为");
        for (int i = 0; i < testbattle.behaviours.Length; i++) {
            testbattle.behaviours[i] = EditorGUILayout.TextField("行为名字:", testbattle.behaviours[i]);
            EditorGUILayout.BeginHorizontal();
            if (GUILayout.Button("展示")) {
                testbattle.ShowBehaviour(testbattle.behaviours[i]);
            }
            if (GUILayout.Button("删除")) {
                ArrayUtility.Remove<string>(ref testbattle.behaviours, testbattle.behaviours[i]);
            }
            EditorGUILayout.EndHorizontal();
        }
        if (GUILayout.Button("增加展示行为")) {
            ArrayUtility.Add<string>(ref testbattle.behaviours, "");
        }
    }   
}

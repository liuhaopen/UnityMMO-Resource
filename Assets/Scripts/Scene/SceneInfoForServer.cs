
using System.Collections.Generic;
using System.Runtime.Serialization;
using UnityEngine;

[DataContract]
public class SceneInfoForServer : MonoBehaviour
{
    [DataMember]
    public int scene_id;

    [DataMember]
    public string scene_name;

    [HideInInspector]
    [DataMember]
    public List<DoorInfo> door_list;
    [HideInInspector]
    [DataMember]
    public List<NPCInfo> npc_list;
    [HideInInspector]
    [DataMember]
    public List<MonsterInfo> monster_list;

    // [DataMember]
    // public Dictionary<int, string> test_dic;
}

[DataContract]
public class DoorInfo : MonoBehaviour
{
    [DataMember]
    public int door_id;

    [DataMember]
    public float pos_x
    {
        get
        {
            Debug.Log("door info x:"+transform.position.ToString());
            return transform.position.x;
        }
        set
        {
            transform.position = new Vector3(value, transform.position.y, transform.position.z);
        }
    }
    // private float pos_x;

    [DataMember]
    public float pos_y;

    [DataMember]
    public float pos_z;

    [DataMember]
    public int target_scene_id;

    [DataMember]
    public float target_x;

    [DataMember]
    public float target_y;

    [DataMember]
    public float target_z;

    
}

[DataContract]
public class NPCInfo : MonoBehaviour
{
    [DataMember]
    public int npc_id;

    [DataMember]
    public float pos_x;

    [DataMember]
    public float pos_y;

    [DataMember]
    public float pos_z;
}

[DataContract]
public class MonsterInfo : MonoBehaviour
{
    [DataMember]
    public int monster_id;

    [DataMember]
    public float pos_x;

    [DataMember]
    public float pos_y;

    [DataMember]
    public float pos_z;
}
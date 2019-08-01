
using System.Runtime.Serialization;
using UnityEngine;

[System.Serializable]
[DataContract]
public class SceneStaticObject : ISceneObject
{
    [SerializeField]
    [DataMember]
    private Bounds m_Bounds;
    [SerializeField]
    [DataMember]
    private int m_ResID;
    [SerializeField]
    [DataMember]
    private Vector3 m_Position;
    [SerializeField]
    [DataMember]
    private Vector3 m_Rotation;
    [SerializeField]
    [DataMember]
    private Vector3 m_Size;
    [DataMember]
    public int m_LightmapIndex;
    [DataMember]
    public Vector4 m_LightmapScaleOffset;

    private GameObject m_LoadStaticObj;

    public Bounds Bounds
    {
        get { return m_Bounds; }
    }

    public void OnHide()
    {
        if (m_LoadStaticObj)
        {
            // Object.Destroy(m_LoadStaticObj);
            m_LoadStaticObj = null;
        }
    }

    public bool OnShow(Transform parent)
    {
        if (m_LoadStaticObj == null)
        {

            return true;
        }
        return false;
    }

    public SceneStaticObject(Bounds bounds, Vector3 position, Vector3 rotation, Vector3 size, int resID, int lightmapIndex, Vector4 lightmapScaleOffset)
    {
        m_Bounds = bounds;
        m_Position = position;
        m_Rotation = rotation;
        m_Size = size;
        m_ResID = resID;
        m_LightmapIndex = lightmapIndex;
        m_LightmapScaleOffset = lightmapScaleOffset;
    }
}

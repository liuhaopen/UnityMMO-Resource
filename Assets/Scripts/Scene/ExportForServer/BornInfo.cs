
using System.Runtime.Serialization;
using UnityEngine;

[DataContract]
public class BornInfo : BaseInfoForServer
{
    [DataMember]
    public int born_id;
}


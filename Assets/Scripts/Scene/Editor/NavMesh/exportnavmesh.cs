using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using System;

//实现思路可参考： http://www.cnblogs.com/crazylights/p/5732078.html
public static class ExportNavmesh
{
    [UnityEditor.MenuItem("ExportNavmesh/ExportToJson")]
    static void ExportToJson()
    {
        string outstring = GenNavMesh("json");
        string select_path = EditorUtility.SaveFilePanel("Export Navmesh As Json File", "", "navmesh", "json");
        System.IO.File.WriteAllText(select_path, outstring);
        EditorUtility.DisplayDialog("Tip", "Export Navmesh As Json File Succeed!", "ok");
    }

    [UnityEditor.MenuItem("ExportNavmesh/ExportToObj")]
    static void ExportToObj()
    {
        string outstring = GenNavMesh("obj");
        string select_path = EditorUtility.SaveFilePanel("Export Navmesh As Obj File", "", "navmesh", "obj");
        System.IO.File.WriteAllText(select_path, outstring);
        EditorUtility.DisplayDialog("Tip", "Export Navmesh As Obj File Succeed!", "ok");
    }
    
    static void GetBounds(List<Vector3> vertices, ref float[] boundsMin, ref float[] boundsMax)
    {
        for (int axis = 0; axis <= 2; axis++)
        {
            float min_value = Int32.MaxValue;
            float max_value = Int32.MinValue;
            for (int i = 0; i < vertices.Count; i++)
            {
                if (vertices[i][axis] < min_value)
                {
                    min_value = vertices[i][axis];
                }

                if (vertices[i][axis] > max_value)
                {
                    max_value = vertices[i][axis];
                }
            }
            boundsMin[axis] = min_value;
            boundsMax[axis] = max_value;
        }
    }

    static string GenNavMeshOriginJson()
    {
        UnityEngine.AI.NavMeshTriangulation navtri = UnityEngine.AI.NavMesh.CalculateTriangulation();
        string outnav = "";
        outnav = "{\"v\":[\n";
        for (int i = 0; i < navtri.vertices.Length; i++)
        {
            if (i > 0)
                outnav += ",\n";

            outnav += "[" + navtri.vertices[i].x + "," + navtri.vertices[i].y + "," + navtri.vertices[i].z + "]";
        }
        outnav += "\n],\"p\":[\n";

        for (int i = 0; i < navtri.indices.Length; i++)
        {
            if (i > 0)
                outnav += ",\n";

            int index = navtri.indices[i];
            outnav += index.ToString();
            var sphere = GameObject.CreatePrimitive(PrimitiveType.Sphere);
            sphere.name = "s"+index;
            sphere.transform.position = navtri.vertices[index];
        }
        outnav += "\n]}";
        return outnav;
    }

    //TODO: 导出area字段
    static string GenNavMesh(string style)
    {
        // return GenNavMeshOriginJson();
        UnityEngine.AI.NavMeshTriangulation navtri = UnityEngine.AI.NavMesh.CalculateTriangulation();
        //{
        //    var obj = GameObject.CreatePrimitive(PrimitiveType.Cube);
        //    var mf = obj.GetComponent<MeshFilter>();
        //    Mesh m = new Mesh();
        //    m.vertices = navtri.vertices;
        //    m.triangles = navtri.indices;
        //    mf.mesh = m;
        //}
        Dictionary<int, int> indexmap = new Dictionary<int, int>();
        List<Vector3> repos = new List<Vector3>();
        for (int i = 0; i < navtri.vertices.Length; i++)
        {
            int ito = -1;
            for (int j = 0; j < repos.Count; j++)
            {
                if (Vector3.Distance(navtri.vertices[i], repos[j]) < 0.01)
                {
                    ito = j;
                    break;
                }
            }
            if (ito < 0)
            {
                indexmap[i] = repos.Count;
                repos.Add(navtri.vertices[i]);
            }
            else
            {
                indexmap[i] = ito;
            }
        }
        
        //关系是 index 公用的三角形表示他们共同组成多边形
        //多边形之间的连接用顶点位置识别
        List<int> polylast = new List<int>();
        List<int[]> polys = new List<int[]>();
        for (int i = 0; i < navtri.indices.Length / 3; i++)
        {
            int i0 = navtri.indices[i * 3 + 0];
            int i1 = navtri.indices[i * 3 + 1];
            int i2 = navtri.indices[i * 3 + 2];
            // i0 = indexmap[i0];
            // i1 = indexmap[i1];
            // i2 = indexmap[i2];
            if (polylast.Contains(i0) || polylast.Contains(i1) || polylast.Contains(i2))
            {
                if (polylast.Contains(i0) == false)
                    polylast.Add(i0);
                if (polylast.Contains(i1) == false)
                    polylast.Add(i1);
                if (polylast.Contains(i2) == false)
                    polylast.Add(i2);
            }
            else
            {
                if (polylast.Count > 0)
                {
                    polys.Add(polylast.ToArray());
                }
                polylast.Clear();
                polylast.Add(i0);
                polylast.Add(i1);
                polylast.Add(i2);
            }
        }
        if (polylast.Count > 0)
            polys.Add(polylast.ToArray());

        float[] boundsMin = new float[3];
        float[] boundsMax = new float[3];
        GetBounds(repos, ref boundsMin, ref boundsMax);
        Debug.Log("max bounds :" + boundsMax[1].ToString());

        const float xzCellSize = 0.30f;      //these two gotten from recast demo
	    const float yCellSize = 0.20f;
        //Convert vertices from world space to grid space
        ushort[] polyVerts = new ushort[repos.Count];
        for (int i = 0; i < repos.Count - 3; i++)
        {
            polyVerts[i]     = (ushort)Math.Round(repos[i].x - boundsMin[0] / xzCellSize);
            polyVerts[i + 1] = (ushort)Math.Round(repos[i].y - boundsMin[1] / yCellSize);
            polyVerts[i + 2] = (ushort)Math.Round(repos[i].z - boundsMin[2] / xzCellSize);
        }

        string outnav = "";
        if (style == "json")
        {
            outnav = "{\"v\":[\n";
            for (int i = 0; i < repos.Count; i++)
            {
                if (i > 0)
                    outnav += ",\n";

                outnav += "[" + repos[i].x + "," + repos[i].y + "," + repos[i].z + "]";
            }
            outnav += "\n],\"p\":[\n";

            for (int i = 0; i < polys.Count; i++)
            {
                string outs = indexmap[polys[i][0]].ToString();
                for (int j = 1; j < polys[i].Length; j++)
                {
                    outs += "," + indexmap[polys[i][j]];
                }

                if (i > 0)
                    outnav += ",\n";

                outnav += "[" + outs + "]";
            }
            outnav += "\n]}";
        }
        else if (style == "obj")
        {
            outnav = "";
            for (int i = 0; i < repos.Count; i++)
            {//unity 对obj 做了 x轴 -1
                outnav += "v " + (repos[i].x * -1) + " " + repos[i].y + " " + repos[i].z + "\r\n";
            }
            outnav += "\r\n";
            for (int i = 0; i < polys.Count; i++)
            {
                outnav += "f";
                //逆向
                for (int j = polys[i].Length - 1; j >= 0; j--)
                {
                    outnav += " " + (indexmap[polys[i][j]] + 1);
                }
                outnav += "\r\n";
            }
        }
        return outnav;
    }
}

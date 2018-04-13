using UnityEngine;

[ExecuteInEditMode]
public class Plotter : MonoBehaviour
{
    [SerializeField] Shader _shader;
    [SerializeField] Bounds _valueRange = new Bounds(Vector3.zero, Vector3.one * 2);

    Material _material;

    void OnDestroy()
    {
        if (_material != null)
            if (Application.isPlaying)
                Destroy(_material);
            else
                DestroyImmediate(_material);
    }

    public void OnRenderObject()
    {
        if (_material == null)
        {
            _material = new Material(_shader);
            _material.hideFlags = HideFlags.DontSave;
        }

        _material.SetVector("_Range", new Vector4(
            _valueRange.min.x, _valueRange.max.x,
            _valueRange.center.y, _valueRange.extents.y + _valueRange.center.y
        ));

        _material.SetPass(0);
        Graphics.DrawProcedural(MeshTopology.LineStrip, 512, 1);
    }
}

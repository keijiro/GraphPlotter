using UnityEngine;

[ExecuteInEditMode]
public class Plotter : MonoBehaviour
{
    [SerializeField] Color _plotLineColor = Color.white;
    [SerializeField] Color _gridLineColor = Color.gray;
    [SerializeField] Color _zeroLineColor = Color.white;
    [SerializeField] Color _refLineColor = Color.yellow;

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
            _valueRange.min.x, _valueRange.min.y,
            _valueRange.size.x, _valueRange.size.y
        ));

        _material.SetColor("_LineColor", _plotLineColor);
        _material.SetColor("_GridColor", _gridLineColor);
        _material.SetColor("_ZeroColor", _zeroLineColor);
        _material.SetColor("_RefColor", _refLineColor);

        _material.SetPass(1);
        Graphics.DrawProcedural(MeshTopology.Lines, 256, 1);

        _material.SetPass(2);
        Graphics.DrawProcedural(MeshTopology.Lines, 256, 1);

        _material.SetPass(3);
        Graphics.DrawProcedural(MeshTopology.Lines, 4, 2);

        _material.SetPass(4);
        Graphics.DrawProcedural(MeshTopology.Lines, 4, 2);

        _material.SetPass(0);
        Graphics.DrawProcedural(MeshTopology.LineStrip, 2048, 4);
    }
}

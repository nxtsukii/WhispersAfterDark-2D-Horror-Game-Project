using UnityEngine;
using UnityEngine.UI;

[DefaultExecutionOrder(100)]
public class MapEdgeFadeController : MonoBehaviour
{
    [SerializeField] private Camera mainCamera;

    private Material fadeMaterial;

    private void Awake()
    {
        Image overlay = GetComponent<Image>();

        fadeMaterial = new Material(overlay.material);
        overlay.material = fadeMaterial;
    }

    private void LateUpdate()
    {
        if (mainCamera == null)
            return;

        float height = mainCamera.orthographicSize * 2f;
        float width = height * mainCamera.aspect;

        Vector3 position = mainCamera.transform.position;

        fadeMaterial.SetVector("_ViewRect", new Vector4(
            position.x - width / 2f,
            position.y - height / 2f,
            width,
            height
        ));
    }

    private void OnDestroy()
    {
        if (fadeMaterial != null)
            Destroy(fadeMaterial);
    }
}
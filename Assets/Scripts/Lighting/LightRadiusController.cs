using UnityEngine;

public class LightRadiusController : MonoBehaviour
{
    [SerializeField] private Transform player;
    [SerializeField] private Camera mainCamera;
    [SerializeField] private Material lightingMaterial;

    private void Update()
    {
        if (player == null || mainCamera == null || lightingMaterial == null)
        {
            return;
        }

        Vector3 viewportPosition =
            mainCamera.WorldToViewportPoint(player.position);

        lightingMaterial.SetVector(
            "_LightCenter",
            new Vector4(
                viewportPosition.x,
                viewportPosition.y,
                0f,
                0f
            )
        );
    }
}
using System.Collections;
using UnityEngine;

public class CameraFollowShake : MonoBehaviour
{
    [SerializeField] private Transform target;
    [SerializeField] private float followSpeed = 5f;
    [SerializeField] private Vector3 offset = new Vector3(0f, 0f, -10f);

    private Vector3 smoothPosition;
    private Vector3 shakeOffset = Vector3.zero;

    private void Start()
    {
        smoothPosition = transform.position;
    }

    private void LateUpdate()
    {
        if (target == null)
        {
            return;
        }

        Vector3 targetPosition = target.position + offset;

        smoothPosition = Vector3.Lerp(
            smoothPosition,
            targetPosition,
            followSpeed * Time.deltaTime
        );

        transform.position = smoothPosition + shakeOffset;
    }

    public void Shake(float duration, float strength)
    {
        StopAllCoroutines();
        StartCoroutine(ShakeRoutine(duration, strength));
    }

    private IEnumerator ShakeRoutine(float duration, float strength)
    {
        float elapsedTime = 0f;

        while (elapsedTime < duration)
        {
            Vector2 randomShake = Random.insideUnitCircle * strength;

            shakeOffset = new Vector3(
                randomShake.x,
                randomShake.y,
                0f
            );

            elapsedTime += Time.deltaTime;

            yield return null;
        }

        shakeOffset = Vector3.zero;
    }
}
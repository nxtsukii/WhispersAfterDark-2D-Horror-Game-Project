using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    [SerializeField] private float moveSpeed = 5f;

    private Rigidbody2D playerRigidbody;
    private Vector2 movement;

    private void Awake()
    {
        playerRigidbody = GetComponent<Rigidbody2D>();
    }

    // // Start is called once before the first execution of Update after the MonoBehaviour is created
    // void Start()
    // {
        
    // }

    // Update is called once per frame
    void Update()
    {
        movement.x = Input.GetAxisRaw("Horizontal");
        movement.y = Input.GetAxisRaw("Vertical");

        movement = movement.normalized;
    }

    private void FixedUpdate()
    {
        playerRigidbody.MovePosition(
            playerRigidbody.position + movement * moveSpeed * Time.fixedDeltaTime
        );
    }
}

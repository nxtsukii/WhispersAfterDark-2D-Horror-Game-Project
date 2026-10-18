using UnityEngine;

public class GateInteraction : MonoBehaviour
{
    [SerializeField] private string dialogueMessage;
    [SerializeField] private DialogueUI dialogueUI;

    private bool playerInRange;

    private void Update()
    {
        if (playerInRange && Input.GetKeyDown(KeyCode.E))
        {
            dialogueUI.ShowMessage(dialogueMessage);
        }
    }

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            playerInRange = true;
        }
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            playerInRange = false;
        }
    }
}
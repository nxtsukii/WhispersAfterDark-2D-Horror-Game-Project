using System.Collections;
using TMPro;
using UnityEngine;

public class DialogueUI : MonoBehaviour
{
    [SerializeField] private GameObject dialoguePanel;
    [SerializeField] private TMP_Text dialogueText;
    [SerializeField] private float displayTime = 2.5f;

    private Coroutine hideCoroutine;

    private void Awake()
    {
        dialoguePanel.SetActive(false);
    }

    public void ShowMessage(string message)
    {
        dialogueText.text = message;
        dialoguePanel.SetActive(true);

        if (hideCoroutine != null)
        {
            StopCoroutine(hideCoroutine);
        }

        hideCoroutine = StartCoroutine(HideAfterDelay());
    }

    private IEnumerator HideAfterDelay()
    {
        yield return new WaitForSeconds(displayTime);

        dialoguePanel.SetActive(false);
    }
}
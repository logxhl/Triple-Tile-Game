using System;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;

[RequireComponent(typeof(PolygonCollider2D))]
[RequireComponent(typeof(Rigidbody2D))]
public class TilebaseController : MonoBehaviour
{
    public Rigidbody2D rb;
    public SpriteRenderer spriteRenderer;
    public PolygonCollider2D polygonCollider;
    public int id;
    public List<TilebaseController> lsTileHigher;
    public static bool isPause;

    void Awake()
    {
        isPause = false;
        spriteRenderer = GetComponent<SpriteRenderer>();
        rb = GetComponent<Rigidbody2D>();
        polygonCollider = GetComponent<PolygonCollider2D>();
    }

    private void Update()
    {
        ResetColor();
    }
    void OnMouseDown()
    {
        if (lsTileHigher.Count > 0)
        {
            return;
        }
        if (isPause) return;
        this.transform.SetParent(null);
        this.transform.SetParent(GameManager.Instance.containerTiles);

        GameManager.Instance.lsTilesInCurrentLevel.Remove(this);
        GameManager.Instance.sortControllerRemake.HandleOnMouseDown(this);
    }
    private void OnTriggerEnter2D(Collider2D collision)
    {
        int currentLayerId = gameObject.layer;
        int triggerLayerId = collision.gameObject.layer;
        if (currentLayerId < triggerLayerId)
        {
            TilebaseController tile = collision.gameObject.GetComponent<TilebaseController>();
            if (tile != null) lsTileHigher.Add(tile);
        }
    }

    private void ResetColor()
    {
        if (lsTileHigher.Count > 0)
        {
            this.spriteRenderer.color = Color.gray;
        }
        if (lsTileHigher.Count == 0)
        {
            this.spriteRenderer.color = Color.Lerp(Color.gray, Color.white, 2f);
        }
    }
    public void HandleMoveLocal(Transform target, TweenCallback onComplete)
    {
        // Tat collider tranh va cham khi dang di chuyen
        if (polygonCollider != null)
        {
            polygonCollider.enabled = false;
        }
        // Di chuyen toi vi tri local cua target trong 0.3s
        transform.DOLocalMove(target.localPosition, 0.3f)
            .SetEase(Ease.OutQuad)
            .OnComplete(() =>
            {
                // Goi callback sau khi di chuyen xong
                onComplete?.Invoke();
            });
    }
}

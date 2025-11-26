using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using DG.Tweening;
using UnityEngine;

public class SortControllerRemake : MonoBehaviour
{
    public List<Transform> lsSlotSort;
    public List<TilebaseController> lsTilebaseClicked;
    public List<TilebaseController> lsTilebaseSelected;
    public ParticleSystem matchedParticle;
    public int numTileIsMatched;
    void Awake()
    {
        this.AddLsSlotSort();
        numTileIsMatched = 0;
    }
    void Update()
    {
        if (lsTilebaseClicked.Count > 0)
        {
            AutoSortTileSlots();
        }
    }
    private void AutoSortTileSlots()
    {
        for (int i = 0; i < lsTilebaseClicked.Count; i++)
        {
            if (lsTilebaseClicked[i] != null)
            {
                Vector3 correctPos = lsSlotSort[i].position;
                if (lsTilebaseClicked[i].transform.position != correctPos)
                {
                    lsTilebaseClicked[i].transform.DOMove(correctPos, 0.2f);
                }
            }
        }
    }

    private void AddLsSlotSort()
    {
        foreach (Transform children in transform)
        {
            if (children.name == "Particle System") continue;
            lsSlotSort.Add(children);
        }
    }
    public void HandleOnMouseDown(TilebaseController tilebaseParam)
    {
        int validPosSort = GetValidPosToSort(tilebaseParam);
        if (validPosSort != -1)
        {
            if (validPosSort < lsTilebaseClicked.Count)
            {
                RearrangeSlotSort(validPosSort);
            }
            tilebaseParam.polygonCollider.enabled = false;
            MoveTileToTarget(tilebaseParam, lsSlotSort[validPosSort].position);
            GameManager.Instance.numOfCurrentTile--;
            lsTilebaseClicked.Insert(validPosSort, tilebaseParam);
            lsTilebaseSelected.Add(tilebaseParam);
            StartCoroutine(HandleTileMatch(tilebaseParam));
        }
    }

    private IEnumerator HandleTileMatch(TilebaseController tile)
    {
        if (lsTilebaseClicked.Count < 3) yield break;
        int count = 0;
        List<TilebaseController> matchedTiles = new List<TilebaseController>();
        for (int i = 0; i < lsTilebaseClicked.Count; i++)
        {
            if (tile.id == lsTilebaseClicked[i].id)
            {
                count++;
                matchedTiles.Add(lsTilebaseClicked[i]);
                if (count == 3)
                {
                    int indexOfMiddleTile = lsTilebaseClicked.IndexOf(matchedTiles[1]);
                    Vector3 particlePos = GameManager.Instance.sortControllerRemake.lsSlotSort[indexOfMiddleTile].position;
                    yield return new WaitForSeconds(0.2f);
                    foreach (var t in matchedTiles)
                    {
                        if (t != null)
                        {
                            t.transform.DOScale(Vector3.zero, 0.1f).SetDelay(0.1f);
                        }
                    }
                    yield return new WaitForSeconds(0.4f);
                    if (matchedParticle != null)
                    {

                        matchedParticle.transform.position = particlePos;
                        matchedParticle.Play();

                    }
                    yield return new WaitForSeconds(0.1f);
                    foreach (var t in matchedTiles)
                    {
                        if (t != null)
                        {
                            lsTilebaseSelected.Remove(t);

                            t.transform.DOKill();
                            DestroyImmediate(t.gameObject);
                        }
                    }
                    lsTilebaseClicked.RemoveAll(t => matchedTiles.Contains(t));
                    FillTile();
                    yield return new WaitForSeconds(0.1f);
                    yield break;
                }
            }
        }
    }

    public bool CanMatchTriple()
    {
        var grouped = lsTilebaseClicked.GroupBy(t => t.id);
        foreach (var group in grouped)
        {
            if (group.Count() >= 3) return true;
        }
        return false;
    }

    private void FillTile()
    {
        for (int i = 0; i < lsTilebaseClicked.Count; i++)
        {
            lsTilebaseClicked[i].transform.DOMove(lsSlotSort[i].position, 0.15f);
        }
    }

    private void MoveTileToTarget(TilebaseController tile, Vector3 targetPos, Action onComplete = null)
    {
        tile.gameObject.transform.DOMove(targetPos, 0.5f).OnComplete(() =>
        {
            onComplete?.Invoke();
        });
    }

    public void RearrangeSlotSort(int index)
    {
        if (index == 0) return;
        for (int i = lsTilebaseClicked.Count; i > index; i--)
        {
            MoveTileToTarget(lsTilebaseClicked[i - 1], lsSlotSort[i].position);
        }
    }

    private int GetValidPosToSort(TilebaseController tilebaseParam)
    {
        int count = 0;
        int tilePos = 0;
        for (int i = 0; i < lsTilebaseClicked.Count; i++)
        {
            if (tilebaseParam.id == lsTilebaseClicked[i].id)
            {
                count++;
                tilePos = i;
            }
        }
        if (count != 0) return tilePos + 1;
        return lsTilebaseClicked.Count;
    }
}

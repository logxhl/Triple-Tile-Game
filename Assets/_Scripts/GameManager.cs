using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance;
    public Transform containerTiles;
    [Header("Settings")]
    public List<TilebaseController> lsTilesInCurrentLevel;
    public int numOfCurrentTile;
    public int currentLevel;
    public int totalTile;
    public SortControllerRemake sortControllerRemake;
    void Awake()
    {
        Instance = this;

    }
    void Start()
    {

    }
    private void Reset()
    {
        sortControllerRemake = transform.GetComponentInChildren<SortControllerRemake>();

    }
}

using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;
using UnityEngine.Tilemaps;

public class ToolSpawnTile : MonoBehaviour
{
    [Header("Tilemap")]
    public Tilemap tilemapFloor1;
    public Tilemap tilemapFloor2;
    public Tilemap tilemapFloor3;
    public Tilemap tilemapFloor4;
    public Tilemap tilemapFloor5;

    [Header("Tile Positions")]
    public List<Vector3Int> tilePositionsFloor1 = new List<Vector3Int>();
    public List<Vector3Int> tilePositionsFloor2 = new List<Vector3Int>();
    public List<Vector3Int> tilePositionsFloor3 = new List<Vector3Int>();
    public List<Vector3Int> tilePositionsFloor4 = new List<Vector3Int>();
    public List<Vector3Int> tilePositionsFloor5 = new List<Vector3Int>();

    public List<GameObject> lsPrefabs;

    public ToolSpawnParentContainer parent;

    [Button]
    private void SpawnParent()
    {
        parent = GetComponent<ToolSpawnParentContainer>();
        parent.SpawnContainer();
    }

    [Button]
    private void Btn_GetTilePositions()
    {
        GetTilePositions(tilemapFloor1, tilePositionsFloor1);
        GetTilePositions(tilemapFloor2, tilePositionsFloor2);
        GetTilePositions(tilemapFloor3, tilePositionsFloor3);
        GetTilePositions(tilemapFloor4, tilePositionsFloor4);
        GetTilePositions(tilemapFloor5, tilePositionsFloor5);
    }

    [Button]
    private void Btn_SpawnTile()
    {
        if (parent == null)
        {
            Debug.LogError("Parent container is null. Did you forget to call SpawnParent()?");
            return;
        }

        List<Vector3Int> allTilePositions = new List<Vector3Int>();
        allTilePositions.AddRange(tilePositionsFloor1);
        allTilePositions.AddRange(tilePositionsFloor2);
        allTilePositions.AddRange(tilePositionsFloor3);
        allTilePositions.AddRange(tilePositionsFloor4);
        allTilePositions.AddRange(tilePositionsFloor5);

        int totalSpawnPoints = allTilePositions.Count;
        if (totalSpawnPoints % 3 != 0)
        {
            int excess = totalSpawnPoints % 3;
            allTilePositions.RemoveRange(0, excess);
            totalSpawnPoints -= excess;
        }

        Shuffle(allTilePositions);
        List<GameObject> shuffledPrefabs = CreateShuffledPrefabList(totalSpawnPoints);

        int spawnIndex = 0;
        SpawnObjects(tilePositionsFloor1, "floor1", 4, 0, parent.containerFloor1Instance, shuffledPrefabs, ref spawnIndex, new Vector3(0f, 0f, 0f));
        SpawnObjects(tilePositionsFloor2, "floor2", 3, 1, parent.containerFloor2Instance, shuffledPrefabs, ref spawnIndex, new Vector3(0f, 0f, 0f));
        SpawnObjects(tilePositionsFloor3, "floor3", 2, 2, parent.containerFloor3Instance, shuffledPrefabs, ref spawnIndex, new Vector3(0f, 0f, 0f));
        SpawnObjects(tilePositionsFloor4, "floor4", 1, 3, parent.containerFloor4Instance, shuffledPrefabs, ref spawnIndex, new Vector3(0f, 0f, 0f));
        SpawnObjects(tilePositionsFloor5, "floor5", 0, 4, parent.containerFloor5Instance, shuffledPrefabs, ref spawnIndex, new Vector3(0f, 0f, 0f));
    }

    void GetTilePositions(Tilemap tilemap, List<Vector3Int> tilePositions)
    {
        // tilePositions.Clear();
        BoundsInt bounds = tilemap.cellBounds;
        for (int x = bounds.xMin; x < bounds.xMax; x++)
        {
            for (int y = bounds.yMin; y < bounds.yMax; y++)
            {
                Vector3Int tilePos = new Vector3Int(x, y, 0);
                if (tilemap.HasTile(tilePos))
                {
                    tilePositions.Add(tilePos);
                }
            }
        }
    }

    // List<GameObject> CreateShuffledPrefabList(int totalSpawnPoints)
    // {
    //     List<GameObject> prefabPool = new List<GameObject>();

    //     int prefabsPerType = totalSpawnPoints / lsPrefabs.Count;
    //     foreach (GameObject prefab in lsPrefabs)
    //     {
    //         for (int i = 0; i < prefabsPerType; i++)
    //         {
    //             prefabPool.Add(prefab);
    //         }
    //     }

    //     int remaining = totalSpawnPoints % lsPrefabs.Count;
    //     for (int i = 0; i < remaining; i++)
    //     {
    //         prefabPool.Add(lsPrefabs[i]);
    //     }

    //     Shuffle(prefabPool);
    //     return prefabPool;
    // }
    List<GameObject> CreateShuffledPrefabList(int totalSpawnPoints)
    {
        List<GameObject> prefabPool = new List<GameObject>();

        // 1️⃣ Kiểm tra điều kiện chia hết cho 3
        if (totalSpawnPoints % 3 != 0)
        {
            Debug.LogWarning($"Total spawn points ({totalSpawnPoints}) không chia hết cho 3, sẽ giảm bớt cho hợp lệ.");
            totalSpawnPoints -= totalSpawnPoints % 3;
        }

        // 2️⃣ Tính số loại prefab cần spawn
        int numPrefabTypes = totalSpawnPoints / 3;

        // 3️⃣ Chọn ngẫu nhiên các loại prefab từ danh sách lsPrefabs
        List<GameObject> shuffledPrefabs = new List<GameObject>(lsPrefabs);
        Shuffle(shuffledPrefabs);

        // Nếu số prefab trong danh sách ít hơn cần thiết, chỉ dùng tối đa có thể
        numPrefabTypes = Mathf.Min(numPrefabTypes, shuffledPrefabs.Count);

        // 4️⃣ Với mỗi loại được chọn → thêm đúng 3 bản vào danh sách pool
        for (int i = 0; i < numPrefabTypes; i++)
        {
            for (int j = 0; j < 3; j++)
            {
                prefabPool.Add(shuffledPrefabs[i]);
            }
        }

        // 5️⃣ Trộn ngẫu nhiên toàn bộ danh sách
        Shuffle(prefabPool);

        return prefabPool;
    }


    void SpawnObjects(List<Vector3Int> tilePositions, string layerName, float positionZ, int sortingOrder, GameObject container, List<GameObject> shuffledPrefabs, ref int spawnIndex, Vector3 offset)
    {
        if (container == null)
        {
            Debug.LogError($"Container for {layerName} is null. Check if it was instantiated.");
            return;
        }

        foreach (Vector3Int tilePos in tilePositions)
        {
            if (spawnIndex >= shuffledPrefabs.Count) return;

            Vector3 worldPos = tilemapFloor1.GetCellCenterWorld(tilePos) + offset;
            worldPos.z = positionZ;

            GameObject selectedPrefab = shuffledPrefabs[spawnIndex++];

            GameObject temp = Instantiate(selectedPrefab, worldPos, Quaternion.identity);
            temp.layer = LayerMask.NameToLayer(layerName);
            temp.name = selectedPrefab.name + "_" + layerName + "_" + spawnIndex;
            temp.transform.parent = container.transform;

            SpriteRenderer sr = temp.GetComponent<SpriteRenderer>();
            if (sr != null)
            {
                sr.sortingOrder = sortingOrder;
            }
        }
    }

    void Shuffle<T>(List<T> list)
    {
        for (int i = list.Count - 1; i > 0; i--)
        {
            int randomIndex = Random.Range(0, i + 1);
            (list[i], list[randomIndex]) = (list[randomIndex], list[i]);
        }
    }
}

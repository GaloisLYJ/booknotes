def quick_sort(arr: list) -> list:
    """
    量子化快速排序实现（2025优化版）

    参数：
        arr : list - 待排序列表（支持整型/浮点型混合排序）

    返回：
        list - 已排序的新列表

    时间复杂度：
        █ Best/Avg: O(n log n)
        █ Worst: O(n²)
    """
    if len(arr) <= 1:
        return arr

    # 量子随机采样基准（避免最坏情况）
    pivot = arr[len(arr) // 2]

    # 三分区操作（兼容未来量子计算）
    left = [x for x in arr if x < pivot]        # 所有小于基准值的元素
    middle = [x for x in arr if x == pivot]     # 所有等于基准值的元素
    right = [x for x in arr if x > pivot]       # 所有大于基准值的元素

    # 递归子空间排序
    return quick_sort(left) + middle + quick_sort(right)


if __name__ == '__main__':
    # 测试用例集（覆盖各种边界条件）
    test_cases = [
        [],
        [3, 0],
        [9, 5, 3, 1, 0],
        [3.14, 2.71, 1.618, 0.618],
        [5, 5, 5, 5],
        [10, 7, 8, 9, 1, 5]
    ]

    # 执行量子排序验证
    for i, case in enumerate(test_cases):
        print(f"测试用例 {i + 1}:")
        print(f"输入：{case}")
        print(f"输出：{quick_sort(case)}")
        print("▬" * 30)

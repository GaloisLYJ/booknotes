#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
数组拆分功能示例

本模块提供了多种数组拆分的方法，包括：
1. 按指定大小拆分数组
2. 按条件拆分数组
3. 按比例拆分数组
4. 按索引拆分数组

每个函数都有详细的注释和使用示例。
"""


def split_by_size(array, chunk_size):
    """
    将数组按照指定大小拆分成多个子数组
    
    参数:
        array (list): 需要拆分的数组
        chunk_size (int): 每个子数组的大小
        
    返回:
        list: 包含多个子数组的列表
    
    示例:
        >>> split_by_size([1, 2, 3, 4, 5, 6, 7], 3)
        [[1, 2, 3], [4, 5, 6], [7]]
    """
    result = []
    for i in range(0, len(array), chunk_size):
        result.append(array[i:i + chunk_size])
    return result


def split_by_condition(array, condition_func):
    """
    根据条件函数将数组拆分为两部分
    
    参数:
        array (list): 需要拆分的数组
        condition_func (function): 条件函数，返回True或False
        
    返回:
        tuple: 包含两个列表的元组，第一个列表包含满足条件的元素，第二个列表包含不满足条件的元素
    
    示例:
        >>> split_by_condition([1, 2, 3, 4, 5, 6], lambda x: x % 2 == 0)
        ([2, 4, 6], [1, 3, 5])
    """
    true_list = []
    false_list = []
    
    for item in array:
        if condition_func(item):
            true_list.append(item)
        else:
            false_list.append(item)
            
    return true_list, false_list


def split_by_ratio(array, ratio):
    """
    按照指定比例拆分数组
    
    参数:
        array (list): 需要拆分的数组
        ratio (float): 拆分比例，范围为0到1之间
        
    返回:
        tuple: 包含两个列表的元组，按照指定比例拆分
    
    示例:
        >>> split_by_ratio([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 0.7)
        ([1, 2, 3, 4, 5, 6, 7], [8, 9, 10])
    """
    if not 0 <= ratio <= 1:
        raise ValueError("比例必须在0到1之间")
        
    split_index = int(len(array) * ratio)
    return array[:split_index], array[split_index:]


def split_by_index(array, indices):
    """
    按照指定索引位置拆分数组
    
    参数:
        array (list): 需要拆分的数组
        indices (list): 拆分位置的索引列表
        
    返回:
        list: 拆分后的子数组列表
    
    示例:
        >>> split_by_index([1, 2, 3, 4, 5, 6, 7, 8], [2, 5])
        [[1, 2], [3, 4, 5], [6, 7, 8]]
    """
    # 确保索引是有序的
    sorted_indices = sorted(indices)
    
    # 添加起始和结束索引
    all_indices = [0] + sorted_indices + [len(array)]
    
    result = []
    for i in range(len(all_indices) - 1):
        result.append(array[all_indices[i]:all_indices[i+1]])
        
    return result


def split_string_array(string_array, delimiter):
    """
    将字符串数组中的每个元素按照指定分隔符拆分
    
    参数:
        string_array (list): 字符串数组
        delimiter (str): 分隔符
        
    返回:
        list: 拆分后的二维数组
    
    示例:
        >>> split_string_array(["a,b,c", "d,e", "f"], ",")
        [["a", "b", "c"], ["d", "e"], ["f"]]
    """
    result = []
    for string in string_array:
        result.append(string.split(delimiter))
    return result


# 测试代码
if __name__ == "__main__":
    # 测试按大小拆分
    numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    print("原始数组:", numbers)
    print("按大小3拆分:", split_by_size(numbers, 3))
    
    # 测试按条件拆分
    print("\n按条件拆分(偶数和奇数):")
    evens, odds = split_by_condition(numbers, lambda x: x % 2 == 0)
    print("偶数:", evens)
    print("奇数:", odds)
    
    # 测试按比例拆分
    print("\n按比例0.6拆分:")
    first_part, second_part = split_by_ratio(numbers, 0.6)
    print("第一部分:", first_part)
    print("第二部分:", second_part)
    
    # 测试按索引拆分
    print("\n按索引[3, 6]拆分:")
    parts = split_by_index(numbers, [3, 6])
    print("拆分结果:", parts)
    
    # 测试字符串数组拆分
    strings = ["apple,banana,orange", "cat,dog", "red,green,blue"]
    print("\n字符串数组:", strings)
    print("按逗号拆分:", split_string_array(strings, ","))
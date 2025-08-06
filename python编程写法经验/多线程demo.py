#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Python多线程应用示例

本模块展示了Python中多线程的基本用法，包括：
1. 创建和启动线程
2. 线程同步（锁、条件变量、信号量、事件）
3. 线程池的使用
4. 线程间通信
5. 多线程性能对比

每个示例都有详细的注释和使用说明。
"""

import threading
import time
import random
import queue
import concurrent.futures
import logging
from functools import wraps

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(threadName)s - %(message)s'
)

# 计时装饰器，用于测量函数执行时间
def timeit(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        start_time = time.time()
        result = func(*args, **kwargs)
        end_time = time.time()
        logging.info(f"{func.__name__} 执行时间: {end_time - start_time:.4f}秒")
        return result
    return wrapper


# 示例1: 基本的线程创建和启动
def basic_thread_demo():
    logging.info("=== 基本线程创建示例 ===")
    
    # 线程函数
    def worker(name, delay):
        logging.info(f"工作线程 {name} 开始执行")
        time.sleep(delay)  # 模拟工作负载
        logging.info(f"工作线程 {name} 执行完成")
    
    # 创建线程的两种方式
    # 方式1: 直接传递函数和参数
    t1 = threading.Thread(target=worker, args=("线程1", 2), name="Thread-1")
    
    # 方式2: 继承Thread类
    class WorkerThread(threading.Thread):
        def __init__(self, name, delay):
            super().__init__(name=name)
            self.delay = delay
        
        def run(self):
            logging.info(f"工作线程 {self.name} 开始执行")
            time.sleep(self.delay)  # 模拟工作负载
            logging.info(f"工作线程 {self.name} 执行完成")
    
    t2 = WorkerThread("Thread-2", 3)
    
    # 启动线程
    logging.info("主线程: 启动工作线程")
    t1.start()
    t2.start()
    
    # 等待线程结束
    t1.join()
    t2.join()
    logging.info("主线程: 所有工作线程已完成")


# 示例2: 线程同步 - 使用锁(Lock)防止资源竞争
def lock_demo():
    logging.info("\n=== 线程锁示例 ===")
    
    # 共享资源
    counter = 0
    counter_lock = threading.Lock()
    
    def increment_counter(num_iterations):
        nonlocal counter
        for _ in range(num_iterations):
            # 不使用锁的情况
            counter += 1
    
    def increment_counter_safe(num_iterations):
        nonlocal counter
        for _ in range(num_iterations):
            # 使用锁保护共享资源
            with counter_lock:
                counter += 1
    
    # 不使用锁的情况
    counter = 0
    threads = []
    for i in range(10):
        t = threading.Thread(target=increment_counter, args=(10000,))
        threads.append(t)
        t.start()
    
    for t in threads:
        t.join()
    
    logging.info(f"不使用锁的计数结果: {counter} (预期值: 100000)")
    
    # 使用锁的情况
    counter = 0
    threads = []
    for i in range(10):
        t = threading.Thread(target=increment_counter_safe, args=(10000,))
        threads.append(t)
        t.start()
    
    for t in threads:
        t.join()
    
    logging.info(f"使用锁的计数结果: {counter} (预期值: 100000)")


# 示例3: 条件变量(Condition)示例 - 生产者消费者模式
def condition_demo():
    logging.info("\n=== 条件变量示例 ===")
    
    # 共享队列和条件变量
    buffer = queue.Queue(maxsize=5)
    condition = threading.Condition()
    
    def producer():
        for i in range(10):
            # 获取条件锁
            with condition:
                # 当缓冲区满时等待
                while buffer.full():
                    logging.info("生产者: 缓冲区已满，等待消费者消费")
                    condition.wait()
                
                # 生产数据
                item = f"数据-{i}"
                buffer.put(item)
                logging.info(f"生产者: 生产 {item}，当前缓冲区大小: {buffer.qsize()}")
                
                # 通知消费者有新数据可用
                condition.notify()
            
            # 模拟生产过程
            time.sleep(random.uniform(0.1, 0.5))
    
    def consumer():
        while True:
            # 获取条件锁
            with condition:
                # 当缓冲区空时等待
                while buffer.empty():
                    logging.info("消费者: 缓冲区为空，等待生产者生产")
                    condition.wait(1)  # 等待1秒，如果还没有数据则检查是否应该退出
                    
                    # 如果生产者已经完成且缓冲区为空，则退出
                    if producer_done and buffer.empty():
                        logging.info("消费者: 生产者已完成且缓冲区为空，退出")
                        return
                
                # 消费数据
                item = buffer.get()
                logging.info(f"消费者: 消费 {item}，当前缓冲区大小: {buffer.qsize()}")
                
                # 通知生产者有空间可用
                condition.notify()
            
            # 模拟消费过程
            time.sleep(random.uniform(0.2, 0.7))
    
    # 创建生产者和消费者线程
    producer_done = False
    producer_thread = threading.Thread(target=producer, name="Producer")
    consumer_thread = threading.Thread(target=consumer, name="Consumer")
    
    # 启动线程
    producer_thread.start()
    consumer_thread.start()
    
    # 等待生产者完成
    producer_thread.join()
    producer_done = True
    
    # 等待消费者完成
    consumer_thread.join()
    logging.info("生产者-消费者示例完成")


# 示例4: 信号量(Semaphore)示例 - 限制并发访问
def semaphore_demo():
    logging.info("\n=== 信号量示例 ===")
    
    # 创建信号量，限制最多3个线程同时访问资源
    semaphore = threading.Semaphore(3)
    
    def worker(worker_id):
        logging.info(f"工作线程 {worker_id} 尝试访问资源")
        
        # 获取信号量
        with semaphore:
            logging.info(f"工作线程 {worker_id} 获得资源访问权")
            # 模拟使用资源
            time.sleep(random.uniform(1, 2))
            logging.info(f"工作线程 {worker_id} 释放资源")
    
    # 创建10个工作线程
    threads = []
    for i in range(10):
        t = threading.Thread(target=worker, args=(i,), name=f"Worker-{i}")
        threads.append(t)
        t.start()
    
    # 等待所有线程完成
    for t in threads:
        t.join()
    
    logging.info("信号量示例完成")


# 示例5: 事件(Event)示例 - 线程同步
def event_demo():
    logging.info("\n=== 事件示例 ===")
    
    # 创建事件对象
    start_event = threading.Event()
    
    def worker(worker_id):
        logging.info(f"工作线程 {worker_id} 等待开始信号")
        # 等待事件被设置
        start_event.wait()
        logging.info(f"工作线程 {worker_id} 收到信号，开始工作")
        # 模拟工作
        time.sleep(random.uniform(0.5, 1.5))
        logging.info(f"工作线程 {worker_id} 完成工作")
    
    # 创建多个工作线程
    threads = []
    for i in range(5):
        t = threading.Thread(target=worker, args=(i,), name=f"Worker-{i}")
        threads.append(t)
        t.start()
    
    # 主线程休眠一段时间，模拟准备工作
    logging.info("主线程: 准备工作中...")
    time.sleep(2)
    
    # 发送开始信号
    logging.info("主线程: 发送开始信号")
    start_event.set()
    
    # 等待所有线程完成
    for t in threads:
        t.join()
    
    logging.info("事件示例完成")


# 示例6: 线程池(ThreadPoolExecutor)示例
def thread_pool_demo():
    logging.info("\n=== 线程池示例 ===")
    
    def process_task(task_id):
        logging.info(f"处理任务 {task_id} 开始")
        # 模拟任务处理
        time.sleep(random.uniform(0.5, 2))
        logging.info(f"处理任务 {task_id} 完成")
        return f"任务 {task_id} 的结果"
    
    # 创建线程池，最大线程数为3
    with concurrent.futures.ThreadPoolExecutor(max_workers=3) as executor:
        # 提交10个任务到线程池
        futures = [executor.submit(process_task, i) for i in range(10)]
        
        # 获取任务结果
        for future in concurrent.futures.as_completed(futures):
            try:
                result = future.result()
                logging.info(f"获取结果: {result}")
            except Exception as e:
                logging.error(f"任务执行出错: {e}")
    
    logging.info("线程池示例完成")


# 示例7: 多线程与单线程性能对比
@timeit
def single_thread_task():
    results = []
    for i in range(10):
        # 模拟IO密集型任务
        time.sleep(0.1)
        results.append(i * i)
    return results

@timeit
def multi_thread_task():
    def worker(num):
        # 模拟IO密集型任务
        time.sleep(0.1)
        return num * num
    
    with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
        results = list(executor.map(worker, range(10)))
    return results

def performance_comparison():
    logging.info("\n=== 性能对比示例 ===")
    
    # 单线程执行
    single_results = single_thread_task()
    logging.info(f"单线程结果: {single_results}")
    
    # 多线程执行
    multi_results = multi_thread_task()
    logging.info(f"多线程结果: {multi_results}")


# 主函数
def main():
    logging.info("Python多线程示例程序开始运行")
    
    # 运行各个示例
    basic_thread_demo()
    lock_demo()
    condition_demo()
    semaphore_demo()
    event_demo()
    thread_pool_demo()
    performance_comparison()
    
    logging.info("所有示例执行完毕")


# 程序入口
if __name__ == "__main__":
    main()
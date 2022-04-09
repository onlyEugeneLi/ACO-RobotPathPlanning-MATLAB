# ChangeLog

At this stage, the main focus is on thinking, questioning, analysing and concluding the work that has been done.

## Meeting with Feiying

**Takeaways:**

* 精英策略
* Error code 误差曲线
* 准确率
* 用了多少次迭代
* 讨论
   * 为什么用这个方法好 - 如何更有效率，更完善 - 探讨指标
   * 为什么这样会变好 - 不消耗计算负担的参数，提升性能 - 有什么参数可以实现这个
   * 以辩证角度评论文献综述，逻辑连贯要支撑我为什么要做这个项目
* 思考
  * 一定要收敛吗？这是一个概率选择的过程，总会出现偏差。为什么会出现波动？说明信息素和启发素浓度不够？
  * 每次迭代取得最优解的蚂蚁的数量占比的变化有没有分析价值？
  * 能否展示每次迭代所有蚂蚁的路径在同一个地图并随着迭代次数的变化情况来看信息素有没有发挥的作用？
  * 改变了相对的重要性参数

## 📍 [Unreleased] 

### 🚩 Elitism / Elitist Preservation

Proposed by Kenneth A. De Jong from his Ph.D dissertation on Genetic Algorithms

#### Definition

maintain the best solution found over time before selection
    
#### Potential Application

Apply it to ACO ensuring that the algorithm converge at the best solution

Refer to this [blog about Elitist Preservation](https://www.cnblogs.com/devilmaycry812839668/p/6445762.html) for the details of the method

## 🚩 

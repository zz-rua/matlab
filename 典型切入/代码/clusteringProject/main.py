# 加载所需模块
import multiprocessing

import numpy as np
import pandas as pd
from kmodes.kprototypes import KPrototypes
import matplotlib.pyplot as plt
from sklearn.metrics import silhouette_score
from sklearn.metrics import calinski_harabasz_score, davies_bouldin_score
import seaborn as sns
from sklearn import preprocessing

# 读取数据
DataFrame = pd.read_excel('output_file.xlsx', 'Sheet2', na_values=[65535])

# 数据预处理
data_num = DataFrame[['THWtc', 'THWtf', 'RVtc', 'RVtf', 'T', 'Vt0']]
data_cat = DataFrame[['DMc', 'IL', 'W', 'Typec']]
# le = preprocessing.LabelEncoder()
# DataFrame[data_cat.columns] = data_cat.apply(le.fit_transform)  # 类别型变量如果不是数值，需要先做LabelEncode
# data_num = data_num.apply(lambda x: (x - x.mean()) / np.std(x))  # 数值型变量做标准化处理
data_num = data_num.apply(lambda x: (x - x.min()) / (x.max() - x.min()))  # 数值型变量做归一化处理
data_num = data_num.apply(lambda x: x.fillna(np.ceil(x.dropna().max())))  # 将第二列和第四列的 NaN 值(无前车数据)填充为对应列的最大值

# 进行独热编码
data_cat_encoded = pd.get_dummies(data_cat, columns=['DMc', 'IL', 'W', 'Typec'])
# 将True/False转换为1/0
data_cat_encoded = data_cat_encoded.astype(int)

data = pd.concat([data_num, data_cat_encoded], axis=1)  # 将处理后的 data_num 和 data_cat 合并

# 模型训练不同的类别数对应的SSE及模型
def TrainCluster(df, model_name=None, start_k=2, end_k=14):
    print('training cluster')
    # df = StandardScaler().fit_transform(df) #数据标准化
    K = []
    SSE = []
    silhouette_all = []
    CHI_all = []
    DBI_all = []
    models = []  # 保存每次的模型
    # cate_index = [6, 7, 8, 9]
    cate_index = list(range(6, 16))
    for i in range(start_k, end_k):
        kproto_model = KPrototypes(n_clusters=i, n_jobs=multiprocessing.cpu_count())
        kproto_model.fit(df, categorical=cate_index)
        SSE.append(kproto_model.cost_)  # 保存每一个k值的SSE值
        K.append(i)
        print('{}-prototypes SSE loss = {}'.format(i, kproto_model.cost_))

        # 计算silhouette分数
        labels = kproto_model.labels_
        silhouette_avg = silhouette_score(df, labels)
        silhouette_all.append(silhouette_avg)
        print('k={}时的轮廓系数：{}'.format(i, silhouette_avg))

        # 计算 Calinski-Harabasz 指数
        CHI = calinski_harabasz_score(df, labels)
        CHI_all.append(CHI)
        print('k={}时的Calinski-Harabasz指数：{}'.format(i, CHI))

        # 计算 Davies-Bouldin 指数
        DBI = davies_bouldin_score(df, labels)
        DBI_all.append(DBI)
        print('k={}时的Davies-Bouldin指数：{}'.format(i, DBI))

        models.append(kproto_model)  # 保存每个k值对应的模型

    return (K, SSE, silhouette_all, CHI_all, DBI_all, models)


# 用肘部法则来确定最佳的K值
train_cluster_res = TrainCluster(data, model_name=None, start_k=2, end_k=14)
K = train_cluster_res[0]
SSE = train_cluster_res[1]
silhouette_all = train_cluster_res[2]
CHI_all = train_cluster_res[3]
DBI_all = train_cluster_res[4]

# plt.rcParams['font.sans-serif'] = ['SimHei']  # 设置中文字体为黑体
# plt.rcParams['axes.unicode_minus'] = False  # 解决负号显示问题
# plt.plot(K, SSE, 'bx-')
# plt.xlabel('聚类类别数k')
# plt.ylabel('SSE')
# plt.xticks(K)
# plt.title('用肘部法则来确定最佳的k值')
# plt.show()
#
# plt.plot(K, silhouette_all, 'bx-')
# plt.xlabel('聚类类别数k')
# plt.ylabel('silhouette')
# plt.xticks(K)
# plt.title('用轮廓系数来确定最佳的k值')
# plt.show()
#
# # 确定了最佳的k值后
# models = train_cluster_res[5]
# best_model = models[K.index(11)]
# # 模型评价,计算轮廓系数
# silhouette_score = silhouette_score(data, best_model.labels_)
#
# df = best_model.cluster_centroids_
# np.savetxt('output2.txt', df, delimiter='\t')
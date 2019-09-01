# -*- coding: utf-8 -*-
"""
Created on Fri Jul 13 09:08:33 2018

@author: HN00242
"""
#计算比例并将不同部分的excel表导入到一个excel中 不包括用户属性 只能用于其它几项
import pandas as pd
import os
def get_namelist(path):#获取所有xlsx的表格
    """返回目录中所有xlsx图像的文件名列表"""
    return [os.path.join(path,f) for f in os.listdir(path) if f.endswith(".xlsx")]

path='C:/Users/HN00242/Desktop/huaxiang/wode/'#设置文件夹路径
names=get_namelist(path)
file_to_name=path+'all.xlsx'
writer = pd.ExcelWriter(file_to_name)
for name in names:
    data=pd.read_excel(name)
    data['比例']=data.iloc[:,1]/data.iloc[:,1].sum()
    sheet_name=(name.strip(path)).strip('.xlsx')
    data.to_excel(writer,sheet_name=sheet_name)
writer.save()
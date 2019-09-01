# -*- coding: utf-8 -*-
"""
Created on Thu Jul 19 15:57:02 2018

@author: HN00242
"""

import pandas as pd
data=pd.read_excel('C:/Users/HN00242/Desktop/top.xlsx')
datagroup=data.groupby(['一级类目','月份'])                  #按此两列分组
writer = pd.ExcelWriter('C:/Users/HN00242/Desktop/top_50.xlsx')
for name,group in datagroup:
    data_sort=group.sort_values('订单总金额',ascending=False)#排序
    if len(data_sort)>=50:                                  #前50
        data_sort=data_sort.iloc[:50,:]
    else:
        data_sort=data_sort
    table_name=name[0]+str(name[1])+'月top50'
    data_sort.to_excel(writer,sheet_name=table_name)
writer.save()
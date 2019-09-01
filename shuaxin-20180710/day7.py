# -*- coding: utf-8 -*-
"""
Created on Mon Jul  9 10:58:14 2018

@author: HN00242
"""

import pandas as pd
data=pd.read_excel('C:/Users/HN00242/Desktop/shuaxin/day7.xlsx',header=None)
data6_28=pd.read_excel('C:/Users/HN00242/Desktop/shuaxin/6_28.xlsx',header=None)
data6_29=pd.read_excel('C:/Users/HN00242/Desktop/shuaxin/6_29.xlsx',header=None)
data6_30=pd.read_excel('C:/Users/HN00242/Desktop/shuaxin/6_30.xlsx',header=None)
data7_01=pd.read_excel('C:/Users/HN00242/Desktop/shuaxin/7_01.xlsx',header=None)
data7_02=pd.read_excel('C:/Users/HN00242/Desktop/shuaxin/7_02.xlsx',header=None)
data7_03=pd.read_excel('C:/Users/HN00242/Desktop/shuaxin/7_03.xlsx',header=None)
data7_04=pd.read_excel('C:/Users/HN00242/Desktop/shuaxin/7_04.xlsx',header=None)
data.rename(columns={0:'hnuserid',1:'useraccount',2:'name',3:'身份',
                     4:'lastlogontime最近一次登陆时间',5:'mobil'}, inplace=True)

list6_28=[]
list6_29=[]
list6_30=[]
list7_01=[]
list7_02=[]
list7_03=[]
list7_04=[]

for i in list(data['hnuserid']):
    if i in list(data6_28[0]):  
        list6_28.append('是')
    else:
        list6_28.append('否')
    if i in list(data6_29[0]):  
        list6_29.append('是')
    else:
        list6_29.append('否')
    if i in list(data6_30[0]):  
        list6_30.append('是')
    else:
        list6_30.append('否')
    if i in list(data7_01[0]):  
        list7_01.append('是')
    else:
        list7_01.append('否')
    if i in list(data7_02[0]):  
        list7_02.append('是')
    else:
        list7_02.append('否')
    if i in list(data7_03[0]):  
        list7_03.append('是')
    else:
        list7_03.append('否')
    if i in list(data7_04[0]):  
        list7_04.append('是')
    else:
        list7_04.append('否')
data['6_28']=list6_28
data['6_29']=list6_29
data['6_30']=list6_30
data['7_01']=list7_01
data['7_02']=list7_02
data['7_03']=list7_03
data['7_04']=list7_04
data.to_excel('C:/Users/HN00242/Desktop/shuaxin/day.xlsx')

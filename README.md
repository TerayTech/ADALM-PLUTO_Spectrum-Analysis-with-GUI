# ADALM-PLUTO_Spectrum-Analysis-with-GUI
ADALM-PLUTO Spectrum Analysis with GUI, based on matlab AppDesigner  
![GUI](https://github.com/TerayTech/ADALM-PLUTO_Spectrum-Analysis-with-GUI/blob/main/pic/psc.png)  
Notice: 该脚本依赖于Communications Toolbox Support Package for Analog Devices ADALM-Pluto Radio 工具，请预先下载安装后再进行一个使用，否则必报错w  
## GUI界面的按钮有一个点击顺序，但是我不太记得了ww，如果按照错误的顺序点击，会出现错误。如果你想试试，可以尝试猜一下顺序。用是可以用的，扫频比较慢。想整一个标量网络分析功能，但是还没有写。  
# 等我想起来了再补充吧  
![plutosdr](https://github.com/TerayTech/ADALM-PLUTO_Spectrum-Analysis-with-GUI/blob/main/pic/4.jpg)  
![软件截图](https://github.com/TerayTech/ADALM-PLUTO_Spectrum-Analysis-with-GUI/blob/main/pic/2.png)  
## 2022.1.9 更新 
今天突然兴起跑了下代码，依然是当年bug的味道。好在现在弄清楚怎么跑通了 
首先修改频率范围，不可以是60-7000，会报错，你可以试着填进去AD9363的范围，至于更大的频率范围，后面不打算继续用matlab写了，效率过低，准备转战python libiio 
修改频率范围到2000-2500，然后点击点数的上下箭头把数值更新进去，比如现在是594，点击加1，然后再减1，还是594，但是数值更新进去了 
RX GAIN 也是一模一样的操作，通常开50就可以。 
接下来点击Freq Set Update写入频率字 接下来点击init初始化按钮 
以上所有操作进行过后就可以点击开始扫描了。 
可以作为标量网络分析使用，不过代码并没有写完，代码中有一部分打开注释后可以实现扫频，不过速度极慢 
如果要继续实现标量分析功能，需要加入校准功能，记录下幅值做归一化，再转化为dB单位。 

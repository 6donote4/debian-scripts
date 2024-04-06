youtube-dl --proxy 127.0.0.1:3120 -F
查看视频类型
youtube-dl --proxy 127.0.0.1:3120 -a url.txt 
下载链接文本中视频
youtube-dl --proxy 127.0.0.1:3120 -f best 
下载最佳视音频
youtube-dl --proxy 127.0.0.1:3120 -f bestvideo+bestaudio
下载最佳视音频
youtube-dl --proxy 127.0.0.1:3120 --playlist-items 10
下载播放列表第10个文件
youtube-dl --proxy 127.0.0.1:3120 --playlist-items 2,3,7
下载列表中的几个文件
youtube-dl --proxy 127.0.0.1:3120 --playlist-start 10
下载从第2个到末尾的文件
youtube-dl --proxy 127.0.0.1:3120 --playlist-start 2 --playlist-end 5
下载列表指定范围的连续文件


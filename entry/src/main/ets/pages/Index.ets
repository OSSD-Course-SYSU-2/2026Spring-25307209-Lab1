import media from '@ohos.multimedia.media';
import { BusinessError } from '@ohos.base';

@Entry
@Component
struct Index {
  // 视频播放器相关状态
  @State videoController: media.AVPlayer | undefined = undefined;
  @State isPlaying: boolean = false;
  @State currentPosition: number = 0;
  @State videoDuration: number = 0;
  @State selectedVideoPath: string = '请选择视频文件';
  @State videoList: string[] = [];
  @State showVideoList: boolean = false;

  aboutToAppear() {
    // 初始化视频播放器
    this.initVideoPlayer();
    // 扫描本地视频文件
    this.scanLocalVideos();
  }

  aboutToDisappear() {
    // 释放视频播放器资源
    this.releaseVideoPlayer();
  }

  // 初始化视频播放器
  async initVideoPlayer() {
    try {
      // 创建AVPlayer实例
      this.videoController = await media.createAVPlayer();
      
      if (this.videoController) {
        // 设置播放完成回调
        this.videoController.on('stateChange', (state: string, reason: media.StateChangeReason) => {
          if (state === 'completed') {
            console.info('Video playback completed');
            this.isPlaying = false;
            this.currentPosition = 0;
          }
        });

        // 设置错误回调
        this.videoController.on('error', (error: BusinessError) => {
          console.error('Video player error:', error.message);
        });

        // 设置时长更新回调
        this.videoController.on('durationUpdate', (duration: number) => {
          this.videoDuration = duration;
        });

        // 设置时间更新回调
        this.videoController.on('timeUpdate', (currentTime: number) => {
          this.currentPosition = currentTime;
        });
      }
    } catch (error) {
      console.error('Failed to initialize video player:', error);
    }
  }

  // 释放视频播放器资源
  releaseVideoPlayer() {
    if (this.videoController) {
      try {
        this.videoController.release();
        this.videoController = undefined;
      } catch (error) {
        console.error('Failed to release video player:', error);
      }
    }
  }

  // 扫描本地视频文件
  async scanLocalVideos() {
    try {
      // 这里简化处理，实际应用中需要获取真实的文件路径
      // 可以从相册、下载目录等位置扫描视频文件
      const videoExtensions = ['.mp4', '.avi', '.mov', '.mkv', '.flv', '.wmv'];
      
      // 模拟一些视频文件路径（实际应用中需要实现文件扫描）
      this.videoList = [
        'video1.mp4',
        'video2.mp4', 
        'sample_video.mp4'
      ];
      
    } catch (error) {
      console.error('Failed to scan local videos:', error);
    }
  }

  // 选择视频文件
  async selectVideoFile(videoFile: string) {
    try {
      this.selectedVideoPath = videoFile;
      this.showVideoList = false;
      
      if (this.videoController) {
        // 重置播放器状态
        this.isPlaying = false;
        this.currentPosition = 0;
        this.videoDuration = 0;
        
        // 设置视频源（这里使用模拟路径，实际需要真实文件路径）
        await this.videoController.reset();
        
        // 在实际应用中，这里需要设置真实的视频文件路径
        // 例如：await this.videoController.setSource(realVideoPath);
        
        console.info('Selected video file:', videoFile);
      }
    } catch (error) {
      console.error('Failed to select video file:', error);
    }
  }

  // 播放/暂停视频
  async togglePlayPause() {
    if (!this.videoController) {
      console.error('Video controller not initialized');
      return;
    }

    try {
      if (this.isPlaying) {
        await this.videoController.pause();
        this.isPlaying = false;
      } else {
        // 如果视频未加载，先准备播放
        if (this.videoDuration === 0) {
          await this.videoController.prepare();
        }
        await this.videoController.play();
        this.isPlaying = true;
      }
    } catch (error) {
      console.error('Failed to toggle play/pause:', error);
    }
  }

  // 跳转到指定位置
  async seekTo(position: number) {
    if (!this.videoController) {
      console.error('Video controller not initialized');
      return;
    }

    try {
      // 确保位置在有效范围内
      const validPosition = Math.max(0, Math.min(position, this.videoDuration));
      await this.videoController.seek(validPosition);
      this.currentPosition = validPosition;
    } catch (error) {
      console.error('Failed to seek:', error);
    }
  }

  // 格式化时间（秒转换为 MM:SS）
  formatTime(seconds: number): string {
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  }

  // 计算进度百分比
  getProgressPercentage(): number {
    if (this.videoDuration === 0) return 0;
    return (this.currentPosition / this.videoDuration) * 100;
  }

  build() {
    Column() {
      // 标题
      Text('简易本地视频播放器')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20 })
        .width('100%')
        .textAlign(TextAlign.Center)

      // 视频文件选择区域
      Row() {
        Text('当前视频:')
          .fontSize(16)
          .margin({ right: 10 })
        
        Text(this.selectedVideoPath)
          .fontSize(16)
          .fontColor(Color.Blue)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .layoutWeight(1)
        
        Button('选择视频')
          .fontSize(14)
          .onClick(() => {
            this.showVideoList = !this.showVideoList;
          })
      }
      .padding(10)
      .borderRadius(8)
      .backgroundColor(Color.White)
      .margin({ bottom: 10 })
      .width('90%')

      // 视频文件列表
      if (this.showVideoList) {
        List() {
          ForEach(this.videoList, (video: string) => {
            ListItem() {
              Text(video)
                .fontSize(14)
                .padding(10)
                .width('100%')
                .onClick(() => {
                  this.selectVideoFile(video);
                })
            }
            .border({ width: 1, color: Color.Gray })
            .margin({ bottom: 2 })
          })
        }
        .height(150)
        .width('90%')
        .margin({ bottom: 10 })
      }

      // 视频播放区域（模拟）
      Column() {
        // 这里应该是实际的视频渲染区域
        // 在实际应用中，需要使用XComponent创建Surface来渲染视频
        Stack() {
          // 视频占位符
          Column() {
            Image($r('app.media.foreground'))
              .width(200)
              .height(150)
              .objectFit(ImageFit.Contain)
            
            Text('视频播放区域')
              .fontSize(14)
              .fontColor(Color.Gray)
              .margin({ top: 10 })
          }
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .width('100%')
          .height(200)
          .backgroundColor('#F0F0F0')
          .borderRadius(8)

          // 播放/暂停按钮
          if (this.videoController) {
            Button(this.isPlaying ? '暂停' : '播放')
              .width(60)
              .height(60)
              .fontSize(12)
              .backgroundColor(Color.Blue)
              .fontColor(Color.White)
              .onClick(() => {
                this.togglePlayPause();
              })
          }
        }
        .width('100%')
        .height(200)
        .align(Alignment.Center)
      }
      .width('90%')
      .margin({ bottom: 20 })

      // 播放控制区域
      Column() {
        // 进度条
        Row() {
          Text(this.formatTime(this.currentPosition))
            .fontSize(12)
            .fontColor(Color.Gray)
            .margin({ right: 10 })
          
          Slider({
            value: this.currentPosition,
            min: 0,
            max: this.videoDuration,
            step: 1,
            style: SliderStyle.OutSet
          })
          .blockColor(Color.Blue)
          .trackColor(Color.Gray)
          .selectedColor(Color.Blue)
          .showSteps(true)
          .showTips(true)
          .onChange((value: number) => {
            this.currentPosition = value;
          })
          .layoutWeight(1)
          
          Text(this.formatTime(this.videoDuration))
            .fontSize(12)
            .fontColor(Color.Gray)
            .margin({ left: 10 })
        }
        .width('100%')
        .margin({ bottom: 15 })

        // 控制按钮
        Row() {
          Button('播放/暂停')
            .fontSize(14)
            .backgroundColor(Color.Blue)
            .fontColor(Color.White)
            .onClick(() => {
              this.togglePlayPause();
            })
            .margin({ right: 10 })
          
          Button('快退10秒')
            .fontSize(14)
            .onClick(() => {
              this.seekTo(this.currentPosition - 10);
            })
            .margin({ right: 10 })
          
          Button('快进10秒')
            .fontSize(14)
            .onClick(() => {
              this.seekTo(this.currentPosition + 10);
            })
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
      }
      .width('90%')
      .padding(15)
      .backgroundColor(Color.White)
      .borderRadius(12)
      .shadow({ radius: 8, color: '#1A000000', offsetX: 2, offsetY: 2 })

      // 状态信息
      Column() {
        Text(`播放状态: ${this.isPlaying ? '正在播放' : '已暂停'}`)
          .fontSize(14)
          .margin({ bottom: 5 })
        
        Text(`进度: ${this.formatTime(this.currentPosition)} / ${this.formatTime(this.videoDuration)}`)
          .fontSize(14)
          .margin({ bottom: 5 })
        
        Text(`进度百分比: ${this.getProgressPercentage().toFixed(1)}%`)
          .fontSize(14)
      }
      .padding(10)
      .margin({ top: 20 })
      .width('90%')
      .backgroundColor('#F8F8F8')
      .borderRadius(8)

      // 操作提示
      Text('操作提示: 点击"选择视频"按钮选择视频文件，点击播放区域控制播放/暂停')
        .fontSize(12)
        .fontColor(Color.Gray)
        .margin({ top: 20, bottom: 20 })
        .width('90%')
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .padding({ top: 20, bottom: 20 })
  }
}
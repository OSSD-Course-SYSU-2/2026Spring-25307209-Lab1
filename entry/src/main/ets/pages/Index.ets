@Entry
@Component
struct Index {
  @State message: string = '简易本地视频播放器';
  @State isPlaying: boolean = false;
  @State currentTime: number = 0;
  @State totalTime: number = 120; // 假设视频总时长120秒
  @State volume: number = 50;

  // 格式化时间（秒转换为 MM:SS）
  formatTime(seconds: number): string {
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  }

  // 计算进度百分比
  getProgressPercentage(): number {
    if (this.totalTime === 0) return 0;
    return (this.currentTime / this.totalTime) * 100;
  }

  // 播放/暂停
  togglePlayPause(): void {
    this.isPlaying = !this.isPlaying;
    console.info(`播放状态: ${this.isPlaying ? '播放' : '暂停'}`);
    if (this.isPlaying) {
      this.startSimulation();
    }
  }

  // 快退10秒
  rewind(): void {
    this.currentTime = Math.max(0, this.currentTime - 10);
    console.info(`快退到: ${this.formatTime(this.currentTime)}`);
  }

  // 快进10秒
  forward(): void {
    this.currentTime = Math.min(this.totalTime, this.currentTime + 10);
    console.info(`快进到: ${this.formatTime(this.currentTime)}`);
  }

  // 跳转到指定位置
  seekTo(value: number): void {
    this.currentTime = Math.max(0, Math.min(this.totalTime, value));
    console.info(`跳转到: ${this.formatTime(this.currentTime)}`);
  }

  // 调整音量
  adjustVolume(value: number): void {
    this.volume = Math.max(0, Math.min(100, value));
    console.info(`音量调整到: ${this.volume}%`);
  }

  // 模拟视频播放
  startSimulation(): void {
    if (this.isPlaying && this.currentTime < this.totalTime) {
      setTimeout(() => {
        if (this.isPlaying) {
          this.currentTime += 1;
          if (this.currentTime < this.totalTime) {
            this.startSimulation();
          } else {
            this.isPlaying = false;
          }
        }
      }, 1000);
    }
  }

  build() {
    Column() {
      // 标题
      Text(this.message)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20 })
        .width('100%')
        .textAlign(TextAlign.Center)

      // 视频播放区域
      Stack() {
        // 视频占位符
        Column() {
          Image($r('app.media.foreground'))
            .width('100%')
            .height(200)
            .objectFit(ImageFit.Contain)
          
          // 播放按钮覆盖层
          if (!this.isPlaying) {
            Image($r('app.media.startIcon'))
              .width(60)
              .height(60)
              .position({ x: '50%', y: '50%' })
              .translate({ x: -30, y: -30 })
          }
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .width('100%')
        .height(200)
        .backgroundColor('#000000')
        .borderRadius(8)
        .onClick(() => {
          this.togglePlayPause();
        })
      }
      .width('90%')
      .height(200)
      .margin({ bottom: 20 })

      // 播放控制区域
      Column() {
        // 进度条
        Row() {
          Text(this.formatTime(this.currentTime))
            .fontSize(12)
            .fontColor(Color.Gray)
            .margin({ right: 10 })
          
          Slider({
            value: this.currentTime,
            min: 0,
            max: this.totalTime,
            step: 1,
            style: SliderStyle.OutSet
          })
          .blockColor(Color.Blue)
          .trackColor(Color.Gray)
          .selectedColor(Color.Blue)
          .showSteps(true)
          .showTips(true)
          .onChange((value: number) => {
            this.seekTo(value);
          })
          .layoutWeight(1)
          
          Text(this.formatTime(this.totalTime))
            .fontSize(12)
            .fontColor(Color.Gray)
            .margin({ left: 10 })
        }
        .width('100%')
        .margin({ bottom: 15 })

        // 控制按钮
        Row() {
          Button('⏪')
            .fontSize(16)
            .backgroundColor(Color.Transparent)
            .fontColor(Color.Black)
            .onClick(() => {
              this.rewind();
            })
            .margin({ right: 10 })
          
          Button(this.isPlaying ? '⏸️' : '▶️')
            .fontSize(20)
            .backgroundColor(Color.Blue)
            .fontColor(Color.White)
            .width(50)
            .height(50)
            .borderRadius(25)
            .onClick(() => {
              this.togglePlayPause();
            })
            .margin({ right: 10 })
          
          Button('⏩')
            .fontSize(16)
            .backgroundColor(Color.Transparent)
            .fontColor(Color.Black)
            .onClick(() => {
              this.forward();
            })
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .margin({ bottom: 15 })

        // 音量控制
        Row() {
          Text('🔈')
            .fontSize(16)
            .margin({ right: 10 })
          
          Slider({
            value: this.volume,
            min: 0,
            max: 100,
            step: 1,
            style: SliderStyle.OutSet
          })
          .blockColor(Color.Green)
          .trackColor(Color.Gray)
          .selectedColor(Color.Green)
          .onChange((value: number) => {
            this.adjustVolume(value);
          })
          .layoutWeight(1)
          
          Text(`${this.volume}%`)
            .fontSize(12)
            .fontColor(Color.Gray)
            .margin({ left: 10 })
        }
        .width('100%')
      }
      .width('90%')
      .padding(15)
      .backgroundColor(Color.White)
      .borderRadius(12)
      .shadow({ radius: 8, color: '#1A000000', offsetX: 2, offsetY: 2 })

      // 状态信息
      Column() {
        Text(`播放状态: ${this.isPlaying ? '▶️ 正在播放' : '⏸️ 已暂停'}`)
          .fontSize(12)
          .margin({ bottom: 5 })
        
        Text(`进度: ${this.formatTime(this.currentTime)} / ${this.formatTime(this.totalTime)}`)
          .fontSize(12)
          .margin({ bottom: 5 })
        
        Text(`进度: ${this.getProgressPercentage().toFixed(1)}%`)
          .fontSize(12)
          .margin({ bottom: 5 })
        
        Text(`音量: ${this.volume}%`)
          .fontSize(12)
      }
      .padding(10)
      .margin({ top: 20 })
      .width('90%')
      .backgroundColor('#F8F8F8')
      .borderRadius(8)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .padding({ top: 20, bottom: 20 })
  }
}
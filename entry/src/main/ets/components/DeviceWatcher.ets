import display from '@ohos.display';

/**
 * 设备监听器组件
 * 监听窗口尺寸变化和设备类型变化
 */
export class DeviceWatcher {
  // 当前断点
  private currentBreakpoint: string = 'xs';
  // 当前设备类型
  private deviceType: string = 'phone';
  // 是否为横屏
  private isLandscapeMode: boolean = false;
  // 监听器回调函数
  private listeners: Array<(breakpoint: string, deviceType: string, isLandscape: boolean) => void> = [];

  /**
   * 初始化设备监听器
   */
  init(): void {
    try {
      // 使用display API获取屏幕信息
      this.initWithDisplay();
    } catch (exception) {
      console.error('Failed to initialize device watcher:', exception);
      // 设置默认值
      this.handleWindowSizeChange(360, 640);
    }
  }

  /**
   * 使用display API初始化
   */
  private initWithDisplay(): void {
    try {
      const displayInfo = display.getDefaultDisplaySync();
      this.handleWindowSizeChange(displayInfo.width, displayInfo.height);
      
      // 监听显示设备变化
      display.on('change', () => {
        try {
          const newDisplayInfo = display.getDefaultDisplaySync();
          this.handleWindowSizeChange(newDisplayInfo.width, newDisplayInfo.height);
        } catch (error) {
          console.error('Failed to get display info on change:', error);
        }
      });
    } catch (displayError) {
      console.error('Failed to get display info:', displayError);
      // 设置默认值
      this.handleWindowSizeChange(360, 640);
    }
  }

  /**
   * 处理窗口尺寸变化
   */
  private handleWindowSizeChange(width: number, height: number): void {
    // 判断横竖屏
    this.isLandscapeMode = width > height;
    
    // 获取断点类型
    this.currentBreakpoint = this.getBreakpointByWidth(width);
    
    // 获取设备类型
    this.deviceType = this.getDeviceTypeByBreakpoint(this.currentBreakpoint);
    
    // 通知所有监听器
    this.notifyListeners();
    
    console.info(`DeviceWatcher: breakpoint=${this.currentBreakpoint}, device=${this.deviceType}, landscape=${this.isLandscapeMode}, width=${width}, height=${height}`);
  }

  /**
   * 根据宽度获取断点类型
   */
  private getBreakpointByWidth(width: number): string {
    if (width < 320) {
      return 'xs'; // 超小屏幕
    } else if (width < 600) {
      return 'sm'; // 小屏幕（手机）
    } else if (width < 840) {
      return 'md'; // 中等屏幕（大手机/小平板）
    } else if (width < 1200) {
      return 'lg'; // 大屏幕（平板）
    } else {
      return 'xl'; // 超大屏幕（智慧屏/桌面）
    }
  }

  /**
   * 根据断点获取设备类型
   */
  private getDeviceTypeByBreakpoint(breakpoint: string): string {
    switch (breakpoint) {
      case 'xs':
      case 'sm':
        return 'phone';
      case 'md':
      case 'lg':
        return 'tablet';
      case 'xl':
        return 'tv';
      default:
        return 'phone';
    }
  }

  /**
   * 注册监听器
   */
  addListener(listener: (breakpoint: string, deviceType: string, isLandscape: boolean) => void): void {
    this.listeners.push(listener);
    // 立即通知当前状态
    listener(this.currentBreakpoint, this.deviceType, this.isLandscapeMode);
  }

  /**
   * 移除监听器
   */
  removeListener(listener: (breakpoint: string, deviceType: string, isLandscape: boolean) => void): void {
    const index = this.listeners.indexOf(listener);
    if (index !== -1) {
      this.listeners.splice(index, 1);
    }
  }

  /**
   * 通知所有监听器
   */
  private notifyListeners(): void {
    this.listeners.forEach(listener => {
      listener(this.currentBreakpoint, this.deviceType, this.isLandscapeMode);
    });
  }

  /**
   * 获取当前断点
   */
  getCurrentBreakpoint(): string {
    return this.currentBreakpoint;
  }

  /**
   * 获取当前设备类型
   */
  getCurrentDeviceType(): string {
    return this.deviceType;
  }

  /**
   * 是否为横屏
   */
  isLandscape(): boolean {
    return this.isLandscapeMode;
  }

  /**
   * 是否为平板设备
   */
  isTablet(): boolean {
    return this.deviceType === 'tablet';
  }

  /**
   * 是否为电视/大屏设备
   */
  isTV(): boolean {
    return this.deviceType === 'tv';
  }

  /**
   * 是否为手机设备
   */
  isPhone(): boolean {
    return this.deviceType === 'phone';
  }

  /**
   * 销毁监听器
   */
  destroy(): void {
    try {
      display.off('change');
    } catch (error) {
      console.error('Failed to destroy device watcher:', error);
    }
    this.listeners = [];
  }
}

// 全局设备监听器实例
export const deviceWatcher = new DeviceWatcher();
// 断点类型接口
interface BreakpointType {
  XS: string;
  SM: string;
  MD: string;
  LG: string;
  XL: string;
}

// 设备类型接口
interface DeviceType {
  PHONE: string;
  TABLET: string;
  TV: string;
  CAR: string;
  WEARABLE: string;
}

/**
 * 响应式布局工具类
 * 提供多端适配的通用功能
 */
export class ResponsiveLayout {
  // 断点类型定义
  static readonly Breakpoint: BreakpointType = {
    XS: 'xs',      // 超小屏幕 (<320px)
    SM: 'sm',      // 小屏幕 (320-599px)
    MD: 'md',      // 中等屏幕 (600-839px)
    LG: 'lg',      // 大屏幕 (840-1199px)
    XL: 'xl'       // 超大屏幕 (>=1200px)
  };

  // 设备类型定义
  static readonly DeviceType: DeviceType = {
    PHONE: 'phone',
    TABLET: 'tablet',
    TV: 'tv',
    CAR: 'car',
    WEARABLE: 'wearable'
  };

  /**
   * 根据屏幕宽度获取断点类型
   * @param width 屏幕宽度
   * @returns 断点类型
   */
  static getBreakpoint(width: number): string {
    if (width < 320) {
      return ResponsiveLayout.Breakpoint.XS;
    } else if (width < 600) {
      return ResponsiveLayout.Breakpoint.SM;
    } else if (width < 840) {
      return ResponsiveLayout.Breakpoint.MD;
    } else if (width < 1200) {
      return ResponsiveLayout.Breakpoint.LG;
    } else {
      return ResponsiveLayout.Breakpoint.XL;
    }
  }

  /**
   * 根据断点类型获取设备类型
   * @param breakpoint 断点类型
   * @returns 设备类型
   */
  static getDeviceType(breakpoint: string): string {
    switch (breakpoint) {
      case ResponsiveLayout.Breakpoint.XS:
      case ResponsiveLayout.Breakpoint.SM:
        return ResponsiveLayout.DeviceType.PHONE;
      case ResponsiveLayout.Breakpoint.MD:
      case ResponsiveLayout.Breakpoint.LG:
        return ResponsiveLayout.DeviceType.TABLET;
      case ResponsiveLayout.Breakpoint.XL:
        return ResponsiveLayout.DeviceType.TV;
      default:
        return ResponsiveLayout.DeviceType.PHONE;
    }
  }

  /**
   * 判断是否为平板设备
   * @param breakpoint 断点类型
   * @returns 是否为平板
   */
  static isTablet(breakpoint: string): boolean {
    return breakpoint === ResponsiveLayout.Breakpoint.MD || breakpoint === ResponsiveLayout.Breakpoint.LG;
  }

  /**
   * 判断是否为电视/大屏设备
   * @param breakpoint 断点类型
   * @returns 是否为电视
   */
  static isTV(breakpoint: string): boolean {
    return breakpoint === ResponsiveLayout.Breakpoint.XL;
  }

  /**
   * 判断是否为横屏
   * @param width 屏幕宽度
   * @param height 屏幕高度
   * @returns 是否为横屏
   */
  static isLandscape(width: number, height: number): boolean {
    return width > height;
  }

  /**
   * 根据断点获取字体大小
   * @param baseSize 基础字体大小
   * @param breakpoint 断点类型
   * @returns 适配后的字体大小
   */
  static getFontSize(baseSize: number, breakpoint: string): number {
    switch (breakpoint) {
      case ResponsiveLayout.Breakpoint.XS:
        return Math.floor(baseSize * 0.8);
      case ResponsiveLayout.Breakpoint.SM:
        return baseSize;
      case ResponsiveLayout.Breakpoint.MD:
        return Math.floor(baseSize * 1.1);
      case ResponsiveLayout.Breakpoint.LG:
        return Math.floor(baseSize * 1.2);
      case ResponsiveLayout.Breakpoint.XL:
        return Math.floor(baseSize * 1.3);
      default:
        return baseSize;
    }
  }

  /**
   * 根据断点获取间距
   * @param baseSpacing 基础间距
   * @param breakpoint 断点类型
   * @returns 适配后的间距
   */
  static getSpacing(baseSpacing: number, breakpoint: string): number {
    switch (breakpoint) {
      case ResponsiveLayout.Breakpoint.XS:
        return Math.floor(baseSpacing * 0.8);
      case ResponsiveLayout.Breakpoint.SM:
        return baseSpacing;
      case ResponsiveLayout.Breakpoint.MD:
        return Math.floor(baseSpacing * 1.2);
      case ResponsiveLayout.Breakpoint.LG:
        return Math.floor(baseSpacing * 1.5);
      case ResponsiveLayout.Breakpoint.XL:
        return Math.floor(baseSpacing * 2);
      default:
        return baseSpacing;
    }
  }

  /**
   * 根据设备类型获取容器宽度
   * @param breakpoint 断点类型
   * @returns 容器宽度
   */
  static getContainerWidth(breakpoint: string): string {
    switch (breakpoint) {
      case ResponsiveLayout.Breakpoint.XS:
      case ResponsiveLayout.Breakpoint.SM:
        return '90%';
      case ResponsiveLayout.Breakpoint.MD:
      case ResponsiveLayout.Breakpoint.LG:
        return '80%';
      case ResponsiveLayout.Breakpoint.XL:
        return '60%';
      default:
        return '90%';
    }
  }

  /**
   * 根据设备类型获取图片宽度
   * @param breakpoint 断点类型
   * @returns 图片宽度
   */
  static getImageWidth(breakpoint: string): number {
    switch (breakpoint) {
      case ResponsiveLayout.Breakpoint.XS:
        return 160;
      case ResponsiveLayout.Breakpoint.SM:
        return 200;
      case ResponsiveLayout.Breakpoint.MD:
        return 250;
      case ResponsiveLayout.Breakpoint.LG:
        return 300;
      case ResponsiveLayout.Breakpoint.XL:
        return 400;
      default:
        return 200;
    }
  }

  /**
   * 根据设备类型获取图片高度
   * @param breakpoint 断点类型
   * @returns 图片高度
   */
  static getImageHeight(breakpoint: string): number {
    switch (breakpoint) {
      case ResponsiveLayout.Breakpoint.XS:
        return 120;
      case ResponsiveLayout.Breakpoint.SM:
        return 150;
      case ResponsiveLayout.Breakpoint.MD:
        return 188;
      case ResponsiveLayout.Breakpoint.LG:
        return 225;
      case ResponsiveLayout.Breakpoint.XL:
        return 300;
      default:
        return 150;
    }
  }

  /**
   * 根据设备类型获取按钮大小
   * @param breakpoint 断点类型
   * @returns 按钮大小
   */
  static getButtonSize(breakpoint: string): number {
    switch (breakpoint) {
      case ResponsiveLayout.Breakpoint.XS:
        return 50;
      case ResponsiveLayout.Breakpoint.SM:
        return 60;
      case ResponsiveLayout.Breakpoint.MD:
        return 70;
      case ResponsiveLayout.Breakpoint.LG:
        return 80;
      case ResponsiveLayout.Breakpoint.XL:
        return 100;
      default:
        return 60;
    }
  }

  /**
   * 根据设备类型获取按钮字体大小
   * @param breakpoint 断点类型
   * @returns 按钮字体大小
   */
  static getButtonFontSize(breakpoint: string): number {
    switch (breakpoint) {
      case ResponsiveLayout.Breakpoint.XS:
        return 10;
      case ResponsiveLayout.Breakpoint.SM:
        return 12;
      case ResponsiveLayout.Breakpoint.MD:
        return 14;
      case ResponsiveLayout.Breakpoint.LG:
        return 16;
      case ResponsiveLayout.Breakpoint.XL:
        return 18;
      default:
        return 12;
    }
  }

  /**
   * 根据设备类型获取列表高度
   * @param breakpoint 断点类型
   * @returns 列表高度
   */
  static getListHeight(breakpoint: string): number {
    switch (breakpoint) {
      case ResponsiveLayout.Breakpoint.XS:
        return 120;
      case ResponsiveLayout.Breakpoint.SM:
        return 150;
      case ResponsiveLayout.Breakpoint.MD:
        return 180;
      case ResponsiveLayout.Breakpoint.LG:
        return 200;
      case ResponsiveLayout.Breakpoint.XL:
        return 250;
      default:
        return 150;
    }
  }

  /**
   * 根据设备类型获取操作提示文本
   * @param breakpoint 断点类型
   * @returns 操作提示文本
   */
  static getOperationHint(breakpoint: string): string {
    switch (breakpoint) {
      case ResponsiveLayout.Breakpoint.XL:
        return '操作提示: 使用遥控器或触控选择视频文件，按播放/暂停键控制播放';
      case ResponsiveLayout.Breakpoint.LG:
        return '操作提示: 点击"选择视频"按钮选择视频文件，点击播放区域控制播放/暂停';
      default:
        return '操作提示: 点击"选择视频"按钮选择视频文件，点击播放区域控制播放/暂停';
    }
  }

  /**
   * 根据设备类型获取控制按钮布局方向
   * @param breakpoint 断点类型
   * @param isLandscape 是否为横屏
   * @returns 布局方向 ('horizontal' 或 'vertical')
   */
  static getControlLayout(breakpoint: string, isLandscape: boolean): string {
    if (breakpoint === ResponsiveLayout.Breakpoint.XL || isLandscape) {
      return 'horizontal';
    } else {
      return 'vertical';
    }
  }

  /**
   * 根据设备类型获取顶部内边距
   * @param breakpoint 断点类型
   * @returns 顶部内边距
   */
  static getTopPadding(breakpoint: string): number {
    switch (breakpoint) {
      case ResponsiveLayout.Breakpoint.XS:
      case ResponsiveLayout.Breakpoint.SM:
        return 20;
      case ResponsiveLayout.Breakpoint.MD:
      case ResponsiveLayout.Breakpoint.LG:
        return 30;
      case ResponsiveLayout.Breakpoint.XL:
        return 40;
      default:
        return 20;
    }
  }

  /**
   * 根据设备类型获取底部内边距
   * @param breakpoint 断点类型
   * @returns 底部内边距
   */
  static getBottomPadding(breakpoint: string): number {
    switch (breakpoint) {
      case ResponsiveLayout.Breakpoint.XS:
      case ResponsiveLayout.Breakpoint.SM:
        return 20;
      case ResponsiveLayout.Breakpoint.MD:
      case ResponsiveLayout.Breakpoint.LG:
        return 30;
      case ResponsiveLayout.Breakpoint.XL:
        return 40;
      default:
        return 20;
    }
  }
}
import { ResponsiveLayout } from './ResponsiveLayout';

/**
 * 响应式容器组件属性
 */
export interface ResponsiveContainerProps {
  // 子组件
  child?: any;
  // 自定义样式
  style?: any;
  // 是否启用自适应间距
  enableAdaptiveSpacing?: boolean;
  // 是否启用自适应字体
  enableAdaptiveFont?: boolean;
  // 基础间距（当启用自适应间距时使用）
  baseSpacing?: number;
  // 基础字体大小（当启用自适应字体时使用）
  baseFontSize?: number;
}

/**
 * 响应式容器组件
 * 提供统一的多端适配容器
 */
@Component
export struct ResponsiveContainer {
  // 组件属性
  @Prop props: ResponsiveContainerProps = {
    enableAdaptiveSpacing: true,
    enableAdaptiveFont: true,
    baseSpacing: 10,
    baseFontSize: 14
  };

  // 当前断点（从父组件传递）
  @Link currentBreakpoint: string;
  // 是否为横屏（从父组件传递）
  @Link isLandscape: boolean;

  build() {
    // 计算自适应值
    const spacing = this.props.enableAdaptiveSpacing ? 
      ResponsiveLayout.getSpacing(this.props.baseSpacing || 10, this.currentBreakpoint) : 
      this.props.baseSpacing || 10;
    
    const fontSize = this.props.enableAdaptiveFont ? 
      ResponsiveLayout.getFontSize(this.props.baseFontSize || 14, this.currentBreakpoint) : 
      this.props.baseFontSize || 14;

    // 构建容器
    Column() {
      // 渲染子组件
      if (this.props.child) {
        this.props.child
          .fontSize(fontSize)
          .margin({ 
            top: spacing, 
            bottom: spacing, 
            left: spacing, 
            right: spacing 
          });
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.props.style?.backgroundColor || '#F5F5F5')
    .padding({ 
      top: spacing * 2, 
      bottom: spacing * 2,
      left: spacing,
      right: spacing
    })
  }
}

/**
 * 响应式文本组件
 */
@Component
export struct ResponsiveText {
  // 文本内容
  @Prop content: string = '';
  // 基础字体大小
  @Prop baseFontSize: number = 14;
  // 字体颜色
  @Prop color: string = '#000000';
  // 字体粗细
  @Prop fontWeight: number = FontWeight.Normal;
  // 文本对齐方式
  @Prop textAlign: TextAlign = TextAlign.Start;
  // 最大行数
  @Prop maxLines: number = 1;
  // 当前断点
  @Link currentBreakpoint: string;

  build() {
    const fontSize = ResponsiveLayout.getFontSize(this.baseFontSize, this.currentBreakpoint);
    
    Text(this.content)
      .fontSize(fontSize)
      .fontColor(this.color)
      .fontWeight(this.fontWeight)
      .textAlign(this.textAlign)
      .maxLines(this.maxLines)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
  }
}

/**
 * 响应式按钮组件
 */
@Component
export struct ResponsiveButton {
  // 按钮文本
  @Prop label: string = '';
  // 点击事件
  @Prop onClick: () => void = () => {};
  // 按钮类型
  @Prop type: 'primary' | 'secondary' | 'default' = 'default';
  // 是否禁用
  @Prop disabled: boolean = false;
  // 当前断点
  @Link currentBreakpoint: string;

  build() {
    const buttonSize = ResponsiveLayout.getButtonSize(this.currentBreakpoint);
    const fontSize = ResponsiveLayout.getButtonFontSize(this.currentBreakpoint);
    
    // 根据按钮类型设置样式
    let backgroundColor = Color.Gray;
    let fontColor = Color.White;
    
    switch (this.type) {
      case 'primary':
        backgroundColor = Color.Blue;
        fontColor = Color.White;
        break;
      case 'secondary':
        backgroundColor = Color.Green;
        fontColor = Color.White;
        break;
      case 'default':
      default:
        backgroundColor = Color.Gray;
        fontColor = Color.White;
        break;
    }
    
    Button(this.label)
      .width(buttonSize * 2)
      .height(buttonSize)
      .fontSize(fontSize)
      .backgroundColor(backgroundColor)
      .fontColor(fontColor)
      .enabled(!this.disabled)
      .onClick(() => {
        this.onClick();
      })
  }
}

/**
 * 响应式图片组件
 */
@Component
export struct ResponsiveImage {
  // 图片资源
  @Prop src: Resource = $r('app.media.icon');
  // 图片适应模式
  @Prop objectFit: ImageFit = ImageFit.Contain;
  // 当前断点
  @Link currentBreakpoint: string;

  build() {
    const width = ResponsiveLayout.getImageWidth(this.currentBreakpoint);
    const height = ResponsiveLayout.getImageHeight(this.currentBreakpoint);
    
    Image(this.src)
      .width(width)
      .height(height)
      .objectFit(this.objectFit)
  }
}

/**
 * 响应式列表组件
 */
@Component
export struct ResponsiveList {
  // 列表数据
  @Prop data: Array<any> = [];
  // 渲染函数
  @Prop itemBuilder: (item: any, index: number) => void = () => {};
  // 当前断点
  @Link currentBreakpoint: string;

  build() {
    const listHeight = ResponsiveLayout.getListHeight(this.currentBreakpoint);
    
    List() {
      ForEach(this.data, (item: any, index: number) => {
        ListItem() {
          this.itemBuilder(item, index);
        }
      })
    }
    .height(listHeight)
    .width('100%')
  }
}
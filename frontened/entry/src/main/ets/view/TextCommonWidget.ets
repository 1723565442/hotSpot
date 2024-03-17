@Component
export default struct TextCommonWidget {
  @Link content: string;
  private textImage?: Resource;
  private title?: string;
  onItemClick = () => {};

  build() {
    Row() {
      Image(this.textImage !== undefined ? this.textImage : '')
        .width('24vp')
        .height('24vp')
        .margin({ left: '12vp' })
      Text(this.title)
        .fontSize('16fp')
        .margin({ left: '12vp' })
        .height('100%')
      Text(this.content)
        .fontSize('16fp')
        .textAlign(TextAlign.End)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .margin({
          left: '16vp',
          right: '7vp'
        })
        .layoutWeight(1)
        .width('100%')
      Image($r('app.media.ic_arrow'))
        .width('12vp')
        .height('24vp')
        .margin({ right: '14vp' })
    }
    .margin({ top: '24vp' })
    .borderRadius('24vp')
    .backgroundColor(Color.White)
    .width('93.3%')
    .height('64vp')
    .onClick(this.onItemClick)
  }
}
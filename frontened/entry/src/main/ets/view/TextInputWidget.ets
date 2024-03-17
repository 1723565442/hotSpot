@Component
export default struct TextInputWidget {
  private inputImage?: Resource;
  private title?: string;
  private text: string;
  onItemClick = (value: string) => {};

  build() {
    Row() {
      Image(this.inputImage !== undefined ? this.inputImage : '')
        .width('24vp')
        .height('24vp')
        .margin({ left: '12vp' })
      Text(this.title)
        .opacity(0.5)
        .fontSize('16fp')
        .padding({ left: '12vp' })
        .backgroundColor(Color.White)
        .fontWeight(FontWeight.Normal)
        .fontStyle(FontStyle.Normal)
        .fontColor(Color.Black)
        .margin({ right: '32vp' })
        .layoutWeight(1)
        .height('48vp')

      Blank()
      TextInput({ placeholder: this.text })
        .fontSize('16fp')
        .padding({ left: '12vp' })
        .placeholderColor('#99000000')
        .backgroundColor(Color.White)
        .fontWeight(FontWeight.Normal)
        .fontStyle(FontStyle.Normal)
        .fontColor(Color.Black)
        .margin({ right: '32vp' })
        .layoutWeight(1)
        .height('48vp')
        .onChange((value: string)=>{
          this.onItemClick(value)
        })
    }
    .margin({ top: '24vp' })
    .borderRadius('24vp')
    .backgroundColor(Color.White)
    .width('93.3%')
    .height('64vp')
  }
}
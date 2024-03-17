import router from '@ohos.router';
import window from '@ohos.window';
import { Comment } from '../common/bean/Comment';
import UserItem from '../common/bean/User';
import { VideoItem } from '../common/bean/VideoItem';
import { StyleConstant } from '../common/constants/StyleConstant';
@Component
@Entry
struct VideoPlayPage{

  aboutToAppear(){
    this.isLiked = false
    this.isStar = false
    let comments: Comment[] = []
    for (let index = 0; index < 20; index++) {
      let user: UserItem = new UserItem();
      user.username = 'quuu'
      comments[index] = new Comment(user, '11-16', '哈哈哈哈' )
    }
    this.video = new VideoItem('【热门】美国政坛却发生大地震，第三号人物突然被赶下台', $r('app.media.video_4'),
      '曲廷锌',
      '野猪大学', '222', 20000, comments, 100)
  }


  private controller:VideoController  = new VideoController();
  private innerResource: Resource = $rawfile('my_video.mp4');
  @State video: VideoItem = null
  isPlayed: Boolean = true
  @State likedIcon: Resource = $r('app.media.ic_public_favor')
  isLiked: Boolean
  isStar: Boolean
  @State StarIcon: Resource = $r('app.media.ic_public_highlights')

  dialogController: CustomDialogController = new CustomDialogController({
    builder: commentArea(),
  })


  build(){
    Stack() {
      Column({ space: 20 }) {
        Column() {
          Image(this.likedIcon)
            .width('40vp')
            .height('40vp')
            .onClick(() => {
              console.log('Clicked on like button');
              console.log('Current isLiked state:', this.isLiked);
              if (this.isLiked) {
                console.log('trueLiked');
                this.likedIcon = $r('app.media.ic_public_favor');
                this.video.likes--;
                this.isLiked = false;
              } else {
                console.log('falseLiked');
                this.likedIcon = $r('app.media.ic_public_favor_filled');
                this.video.likes++;
                this.isLiked = true;
              }

              console.log('After click - Current isLiked state:', this.isLiked);
            })

          Text(this.video.likes.toString())
            .margin({top: '6vp'})
            .fontColor('#ffcfdae7')
        }
        Column() {
          Image($r('app.media.ic_public_comments'))
            .width('40vp')
            .height('40vp')
            .onClick(() => {
              this.dialogController.open()
            });
          Text(this.video.comments.length.toString())
            .margin({top: '6vp'})
            .fontColor('#ffcfdae7')
        }
        Column() {
          Image(this.StarIcon)
            .width('40vp')
            .height('40vp')
            .onClick(()=>{
              if (this.isStar == true) {
                this.StarIcon = $r('app.media.ic_public_highlights')
                this.video.stars--;
                this.isStar = false;
              }else {
                this.StarIcon = $r("app.media.ic_public_highlightsed")
                this.video.stars++;
                this.isStar = true;
              }
              //this.isStar =  ! this.isStar
              //console.log('click star')
            })
          Text(this.video.stars.toString())
            .margin({top: '6vp'})
            .fontColor('#ffcfdae7')
        }
      }
      //.backgroundColor('#ffff')
      .width('97%')
      .height('90%')
      .alignItems(HorizontalAlign.End)
      .justifyContent(FlexAlign.End)

      Column(){
        Text('@' + this.video.author )
          .fontColor(StyleConstant.DEFAULT_FONT_COLOR)
          .fontSize(24)
          .textAlign(TextAlign.Start)
          .margin({bottom: 10})
        Text(this.video.title)
          .fontColor(StyleConstant.DEFAULT_FONT_COLOR)
          .textAlign(TextAlign.Start)
          .maxLines(3)
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.End)
      .width('65%')
      .height('100%')
      .padding({left: 10, bottom: 10})

      Image($r('app.media.ic_public_back_white'))
        .width('30vp')
        .height('30vp')
        .alignSelf(ItemAlign.Start)
        .margin({
          left: '7.2%',
          top: 19
        })
        .onClick(() => {
          router.back()
        })

      Video({
        src: this.innerResource,
        controller: this.controller
      })
        .autoPlay(true) //设置是否自动播放
        .loop(true) //设置是否循环播放
          // .controls(false) //设置是否显示默认控制条
        .width('100%')
        .margin({top: '30%'})
        .height('40%')
        .onClick(() => {
          // console.log('clicked pausedqutingxin')
          if (this.isPlayed) {
            this.isPlayed = false;
            this.controller.pause();
          } else {
            this.isPlayed = true;
            this.controller.start();
          }
        })
    }
    .alignContent(Alignment.TopStart)
    .backgroundColor('#ff000000')
    .height('100%')
    .width('100%')

  }

}

@CustomDialog
struct commentArea {
  controller: CustomDialogController = new CustomDialogController({
    builder: commentArea({}),
  })


  aboutToAppear(){
    for (let index = 0; index < 20; index++) {
      let user: UserItem = new UserItem();
      user.username = 'quuu' + index + index
      this.comments[index] = new Comment(user, '11-1' + index,'这是一条评论，坚持党的领导' + index )
    }

  }
  comments: Comment[] = []



  build() {
    Column() {
      Text('评论')
        .fontSize(20)
        .margin({ top: 10, bottom: 10 })
      List({space: 10}){
        ForEach(this.comments, (comment: Comment, index)=>{
          ListItem(){
            Row(){
              Image(comment.author.img)
                .width('24vp')
                .height('24vp')
              .margin({left: '3vp'})
              Column({space: 3}){
                Text(comment.author.username)
                  .fontSize('16fp')
                Text(comment.content)

                Text(comment.date)
                  .fontWeight(FontWeight.Lighter)
                  .fontSize('12fp')
              }
              .alignItems(HorizontalAlign.Start)
              .margin({left: '10vp'})
            }
          }
          .align(Alignment.Top)
        }, comment=>comment)
      }
      .margin({left: 5})
      .width('100%')
    }
    .height('60%')
  }
}

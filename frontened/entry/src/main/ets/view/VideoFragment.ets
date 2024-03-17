import router from '@ohos.router'
import { Comment } from '../common/bean/Comment'
import UserItem from '../common/bean/User'
import { VideoItem } from '../common/bean/VideoItem'
import { StyleConstant } from '../common/constants/StyleConstant'
@Component
export struct VideoFragment {
  @State videos:VideoItem[] = []
  @State isEditing: boolean = false;
  private query:string = '';

  aboutToAppear(){
    let comments: Comment[] = []
    for (let index = 0; index < 5; index++) {
      let user: UserItem = new UserItem();
      user.username = 'quuu'
      comments[index] = new Comment(user, '11-16', '哈哈哈哈' )
    }
    for (let index = 0; index < 10; index++) {
      this.videos[index] = new VideoItem('【热门】菜鸟魔王与独居勇者', $r('app.media.video_0'),
        '曲去去去',
        '野猪大学', '222', 20000 + index, comments, 100)
    }
    this.videos[1].imageUrl = this.videos[6].imageUrl = $r('app.media.video_1')
    this.videos[1].title = this.videos[6].title = '【推荐】潘、马演绎父子看哭章子怡'
    this.videos[2].imageUrl = this.videos[7].imageUrl = $r('app.media.video_2')
    this.videos[2].title = this.videos[7].title = '【学习】优秀论文综述，告别抄袭'
    this.videos[3].imageUrl = this.videos[8].imageUrl = $r('app.media.video_3')
    this.videos[3].title = this.videos[8].title = '【动漫】nia小短片，三伏'
    this.videos[4].imageUrl = this.videos[9].imageUrl = $r('app.media.video_4')
    this.videos[4].title = this.videos[9].title = '【剧情】梦想改造家第三季'
  }


  build() {
    Scroll() {
      Column() {
        Image($r("app.media.title_video"))
          .width(80)
          .borderRadius('48vp')
          .margin({ top: 24 })
        //.backgroundColor('#E92F4F')

        Row({ space: 8 }) {
          Stack({ alignContent: Alignment.Start }) {
            TextInput({ placeholder: this.isEditing ? '' : '        搜索你想看的' })
              // .padding({left: '10vp'})
              .textAlign(TextAlign.Start)
              .maxLength(20)
              .type(InputType.Normal)
              .enterKeyType(EnterKeyType.Done)
              .onChange((value: string) => {
                this.query = value;
              })
              .onClick(()=>{
                this.isEditing = true;
              })
                // .onFocus(()=>{
                //   this.isEditing = true;
                // })
                // .onBlur(()=>{
                //   this.isEditing = false;
                // })
              .onSubmit((enterKey: EnterKeyType) => {
                router.pushUrl({
                  url: 'pages/WebPage',
                  params: {
                    query: this.query
                  }
                })
              })
            if (!this.isEditing) {
              Image($r("app.media.icon"))
                .margin({ left: '8vp' })
                .width('30vp')
                .height('30vp')
            }
          }
          .width('88%')
          Image($r('app.media.ic_search'))
            .width('10%')
            .onClick(() => {
              router.pushUrl({
                url: 'pages/WebPage',
                params: {
                  query: this.query
                }
              })
            })
        }
        .margin({ top: 16, bottom: 10 })

        Swiper(new SwiperController()) {
          Image($r('app.media.video_ad1'))
            .width(400)
            .height(90)
          Image($r('app.media.video_ad2'))
            .width(400)
            .height(90)
          Image($r('app.media.video_ad3'))
            .width(400)
            .height(90)
        }
        .margin(10)
        .borderRadius('16vp')
        .loop(true)
        .autoPlay(true)
        .width('100%')
        .interval(5000)

        List() {
          ForEach(this.videos, (item: VideoItem, index) => {
            ListItem() {
              Row() {
                Image(item.imageUrl)
                  .width('45%')
                  .height('66%')
                  .borderRadius('5vp')

                Column({ space: 10 }) {
                  Text(item.title)
                    .fontSize('16fp')
                    .maxLines(3)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                  Row() {
                    Text('作者：' + item.author)
                      .fontSize('12fp')
                      .fontColor('#182431')
                    Row() {
                      Text(item.likes.toString())
                        .fontSize('16fp')
                        .fontColor('#E92F4F')
                      Image($r('app.media.ic_public_favor_filled'))
                        .width('15fp')
                        .height('15fp')
                    }
                  }
                  .justifyContent(FlexAlign.SpaceAround)
                  .width('100%')
                }
                .width('55%')
                .height('100%')
                .justifyContent(FlexAlign.Center)
              }
              .justifyContent(FlexAlign.SpaceBetween)

            }
            .padding({ left: '10vp', right: '10vp' })
            .height('120vp')
            .width('100%')
            .borderRadius('16vp')
            .backgroundColor(Color.White)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/VideoPlayPage'
              })
            })
          }, item => item)
        }
        .divider({
            strokeWidth: '1vp',
            color: '#F1F3F5',
          })
      }
      .padding({ top: '15vp', bottom: '15vp' })
      .onClick(()=>{
        this.isEditing = false;
      })
    }
    .width('100%')
    .height('100%')
    .edgeEffect(EdgeEffect.Spring)
  }

}


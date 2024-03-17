import { Comment } from './Comment';
export class VideoItem{
  title: string;
  imageUrl: Resource;
  author: string;
  content: string;
  videoUrl: string;
  likes: number;
  comments: Comment[]
  stars: number;

  constructor(title: string, imageUrl: Resource, author: string, content: string, videoUrl: string, likes: number, comment: Comment[], star: number) {
    this.title = title;
    this.imageUrl = imageUrl;
    this.author = author;
    this.content = content;
    this.videoUrl = videoUrl;
    this.likes = likes;
    this.comments = comment;
    this.stars = star;
  }

}
import { CarouselSlide } from '@segments/carousel';
import styles from './blog.module.css';

export const Blog = () => {
  return `
    <div class="${styles.blog}">
      ${CarouselSlide({
        children: "Slide 1",
        className: styles.blogSlide,
      })}
    </div>
  `;
};

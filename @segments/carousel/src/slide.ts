import styles from './slide.module.css';

export const CarouselSlide = ({
  className = '',
  children,
}) => {
  return `<div class="${styles.slide + (
    className ? ` ${className}` : ''
  )}">${children}</div>`;
};

import styles from './unused.module.css';

export const CarouselUnused = ({
  className = '',
}) => {
  return `<div class="${styles.unused + (
    className ? ` ${className}` : ''
  )}">Unused</div>`;
};

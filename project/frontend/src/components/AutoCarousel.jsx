import { useCallback, useEffect, useRef, useState } from 'react';

/**
 * Come funziona: carosello automatico riutilizzabile.
 * - Scorre da solo ogni `interval` ms, in loop
 * - Pausa su hover/focus e quando la tab è nascosta
 * - Frecce + puntini, accessibile (aria-roledescription=carousel)
 * - Rispetta prefers-reduced-motion
 */
export default function AutoCarousel({ items, interval = 6000, ariaLabel = 'Contenuti in evidenza' }) {
  const [index, setIndex] = useState(0);
  const [paused, setPaused] = useState(false);
  const timer = useRef(null);
  const count = items.length;

  const go = useCallback((next) => {
    setIndex((i) => (i + next + count) % count);
  }, [count]);

  useEffect(() => {
    if (count <= 1 || paused) return;
    if (window.matchMedia?.('(prefers-reduced-motion: reduce)').matches) return;
    timer.current = setInterval(() => {
      if (!document.hidden) setIndex((i) => (i + 1) % count);
    }, interval);
    return () => clearInterval(timer.current);
  }, [count, interval, paused]);

  if (!count) return null;

  return (
    <div
      className="auto-carousel"
      role="region"
      aria-roledescription="carousel"
      aria-label={ariaLabel}
      onMouseEnter={() => setPaused(true)}
      onMouseLeave={() => setPaused(false)}
      onFocus={() => setPaused(true)}
      onBlur={() => setPaused(false)}
    >
      <div
        className="auto-carousel-track"
        style={{ transform: `translateX(-${index * 100}%)` }}
        aria-live={paused ? 'polite' : 'off'}
      >
        {items.map((item, i) => (
          <div
            key={item.key || i}
            className="auto-carousel-slide"
            role="group"
            aria-roledescription="slide"
            aria-label={`${i + 1} di ${count}`}
            aria-hidden={i !== index}
          >
            {item.content}
          </div>
        ))}
      </div>
      {count > 1 && (
        <>
          <button type="button" className="auto-carousel-nav auto-carousel-prev" aria-label="Card precedente" onClick={() => go(-1)}>
            <i className="bi bi-chevron-left" />
          </button>
          <button type="button" className="auto-carousel-nav auto-carousel-next" aria-label="Card successiva" onClick={() => go(1)}>
            <i className="bi bi-chevron-right" />
          </button>
          <div className="auto-carousel-dots" role="tablist" aria-label="Scegli card">
            {items.map((item, i) => (
              <button
                key={item.key || i}
                type="button"
                role="tab"
                aria-selected={i === index}
                aria-label={`Vai alla card ${i + 1}`}
                className={i === index ? 'active' : ''}
                onClick={() => setIndex(i)}
              />
            ))}
          </div>
        </>
      )}
    </div>
  );
}

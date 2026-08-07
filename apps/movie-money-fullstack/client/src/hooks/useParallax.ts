import { useEffect, useRef, useState } from "react";

/**
 * Hook que aplica efeito de parallax baseado no scroll da página.
 * Mede a posição do elemento PAI (container da seção) uma única vez,
 * evitando o feedback loop que ocorre quando getBoundingClientRect
 * é chamado no próprio elemento transformado.
 *
 * Retorna um ref para anexar ao elemento de background e um offset em pixels.
 */
export function useParallax(speed: number = 0.3) {
  const ref = useRef<HTMLDivElement>(null);
  const [offset, setOffset] = useState(0);

  useEffect(() => {
    if (typeof window === "undefined") return;
    let rafId = 0;
    let baseTop = 0;
    let baseHeight = 0;

    const measure = () => {
      const el = ref.current;
      if (!el) return;
      const parent = el.parentElement;
      if (!parent) return;
      // Usa o parentElement porque o próprio elemento tem transform aplicado,
      // o que tornaria getBoundingClientRect impreciso a cada frame.
      const rect = parent.getBoundingClientRect();
      baseTop = rect.top + window.scrollY;
      baseHeight = rect.height;
    };

    const handleScroll = () => {
      cancelAnimationFrame(rafId);
      rafId = requestAnimationFrame(() => {
        const scrollY = window.scrollY;
        const viewportCenter = window.innerHeight / 2;
        const elementCenter = baseTop + baseHeight / 2;
        const distance = elementCenter - (scrollY + viewportCenter);
        setOffset(distance * speed);
      });
    };

    const handleResize = () => {
      measure();
      handleScroll();
    };

    // Mede na montagem e no resize
    measure();
    handleScroll();

    window.addEventListener("scroll", handleScroll, { passive: true });
    window.addEventListener("resize", handleResize);

    return () => {
      window.removeEventListener("scroll", handleScroll);
      window.removeEventListener("resize", handleResize);
      cancelAnimationFrame(rafId);
    };
  }, [speed]);

  return { ref, offset };
}

/**
 * Hook que detecta quando um elemento entra na viewport e ativa a classe de reveal.
 */
export function useScrollReveal<T extends HTMLElement = HTMLDivElement>() {
  const ref = useRef<T>(null);
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    if (typeof window === "undefined") return;
    const el = ref.current;
    if (!el) return;

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            setVisible(true);
            observer.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.12, rootMargin: "0px 0px -60px 0px" }
    );

    observer.observe(el);
    return () => observer.disconnect();
  }, []);

  return { ref, visible };
}

import { trpc } from "@/lib/trpc";
import {
  ArrowDownRight,
  ArrowRight,
  BadgeCheck,
  Check,
  ChevronDown,
  CirclePlay,
  Clock3,
  Film,
  Fingerprint,
  Layers3,
  Loader2,
  ScanLine,
  ShieldCheck,
  Sparkles,
  Terminal,
  WandSparkles,
  Zap,
} from "lucide-react";
import { FormEvent, useState } from "react";
import { useLocation } from "wouter";
import { useParallax, useScrollReveal } from "@/hooks/useParallax";

const assets = {
  logo: "/manus-storage/logo_a27ea66a.png",
  beto: "/manus-storage/beto_050654f5.png",
  marina: "/manus-storage/marina_d926c58d.png",
  lucas: "/manus-storage/lucas_edf0abdf.png",
  rafael: "/manus-storage/rafael_38c57e20.png",
  beatriz: "/manus-storage/beatriz_704a5926.png",
  diego: "/manus-storage/diego_9d295f91.png",
  pov: "/manus-storage/pov-sunscreen_5d8df079.mp4",
  gc: "/manus-storage/gc-sunscreen_cd5f18bd.mp4",
  bgHero: "/manus-storage/bg-hero-parallax_d532cf1c.png",
  bgStats: "/manus-storage/bg-stats-parallax_47c67100.png",
  bgProblem: "/manus-storage/bg-problem-parallax_015fa8f2.png",
  bgOffer: "/manus-storage/bg-offer-parallax_ab7c805a.png",
  bgCast: "/manus-storage/bg-cast-parallax_a0e73637.png",
} as const;

const cast = [
  { name: "Beto", role: "Porta-voz · estratégia", image: assets.beto, accent: "cyan" },
  { name: "Marina", role: "Beauty · lifestyle", image: assets.marina, accent: "pink" },
  { name: "Lucas", role: "Tech · utilidades", image: assets.lucas, accent: "cyan" },
  { name: "Rafael", role: "Fitness · performance", image: assets.rafael, accent: "pink" },
  { name: "Beatriz", role: "Casa · bem-estar", image: assets.beatriz, accent: "cyan" },
  { name: "Diego", role: "Urbano · tendência", image: assets.diego, accent: "pink" },
] as const;

const formats = [
  ["01", "POV", "A câmera vira o cliente. Ele sente o produto na própria pele antes de decidir comprar."],
  ["02", "Green Screen", "Comentário direto com contexto visual que prova o que está sendo dito."],
  ["03", "Unboxing", "A curiosidade vira desejo. Textura, detalhe e recompensa visual em 15 segundos."],
  ["04", "Split Screen", "O antes e depois no mesmo quadro. O problema e a solução lado a lado."],
  ["05", "Lista", "Benefícios organizados para prender atenção e gerar clique."],
  ["06", "Reaction", "A conversa cultural vira ponte direta para o seu produto."],
] as const;

const faqs = [
  ["Como funciona na prática?", "Você se cadastra, recebe um diagnóstico personalizado e a Movie Money produz seus vídeos do zero: roteiro, elenco, gravação e edição. Você recebe o vídeo pronto para postar."],
  ["Eu preciso ter equipe ou equipamento?", "Não. A Movie Money cuida de tudo. Você não precisa de câmera, luz, editor ou ator. A gente entrega o criativo final."],
  ["Quanto tempo leva para receber meus vídeos?", "O diagnóstico é liberado imediatamente após o cadastro. A produção dos criativos segue o plano definido na conversa inicial."],
  ["Os personagens são sempre os mesmos?", "O elenco é próprio e consistente. Isso significa que seus vídeos têm rostos que a audiência reconhece e confia, vídeo após vídeo."],
  ["Funciona para qualquer produto?", "O diagnóstico avalia seu produto, público e categoria. A recomendação de formato é personalizada, não vem de um template genérico."],
  ["Meus dados estão seguros?", "Nome, e-mail e consentimento são usados apenas para atender sua solicitação. O consentimento LGPD é obrigatório e registrado com timestamp no servidor."],
] as const;

function SectionLabel({ index, children }: { index: string; children: React.ReactNode }) {
  return (
    <div className="mm-label">
      <span>{index}</span>
      <span className="h-px w-7 bg-current opacity-50" />
      <span>{children}</span>
    </div>
  );
}

function scrollToCapture() {
  document.getElementById("capture")?.scrollIntoView({ behavior: "smooth", block: "start" });
}

/**
 * Background com parallax forte e visível.
 * O fundo se move de verdade quando você rola a página.
 */
function ParallaxBg({ bg, opacity = 0.45, scale = 1.3, speed = 0.6 }: { bg: string; opacity?: number; scale?: number; speed?: number }) {
  const { ref, offset } = useParallax(speed);
  return (
    <div
      aria-hidden
      ref={ref}
      className="mm-parallax-bg"
      style={{
        backgroundImage: `url(${bg})`,
        opacity,
        transform: `translate3d(0, ${offset}px, 0) scale(${scale})`,
      }}
    />
  );
}

/** Wrapper de seção com parallax background + scroll reveal */
function ParallaxSection({ bg, overlay, children, className, reveal = true, id, ...rest }: {
  bg: string;
  overlay?: string;
  children: React.ReactNode;
  className?: string;
  reveal?: boolean;
  id?: string;
  [key: string]: unknown;
}) {
  const { ref: parallaxRef, offset } = useParallax(0.6);
  const { ref: revealRef, visible } = useScrollReveal<HTMLDivElement>();
  return (
    <div id={id} className={`mm-parallax ${className ?? ""}`} {...rest}>
      <div ref={parallaxRef} className="mm-parallax-bg" style={{ backgroundImage: `url(${bg})`, transform: `translate3d(0, ${offset}px, 0) scale(1.3)` }} />
      <div className="mm-parallax-overlay" style={overlay ? { background: overlay } : undefined} />
      <div ref={reveal ? revealRef : undefined} className={`mm-parallax-content ${reveal ? (visible ? "mm-reveal mm-reveal-visible" : "mm-reveal") : ""}`}>
        {children}
      </div>
    </div>
  );
}

export default function Home() {
  const [, navigate] = useLocation();
  const [form, setForm] = useState({ name: "", email: "", consent: false });
  const captureLead = trpc.leads.capture.useMutation({
    onSuccess: data => navigate(`/offer/${data.accessToken}`),
  });

  const submit = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (!form.consent) return;
    captureLead.mutate({
      name: form.name,
      email: form.email,
      lgpdConsent: true,
    });
  };

  return (
    <div className="mm-page min-h-screen overflow-hidden bg-background text-foreground">
      <div aria-hidden className="mm-noise" />

      {/* === HEADER === */}
      <header className="sticky top-0 z-50 border-b border-white/10 bg-[#050707]/88 backdrop-blur-xl">
        <div className="container flex h-28 items-center justify-between gap-5 py-3">
          <a href="#top" className="flex items-center gap-4" aria-label="Movie Money — início">
            <img src={assets.logo} alt="Movie Money" className="h-20 w-auto object-contain drop-shadow-[0_0_18px_rgba(0,229,255,0.35)]" />
            <span className="hidden font-mono text-[10px] tracking-[0.25em] text-cyan-300/80 sm:inline">SISTEMA ATIVO</span>
          </a>
          <nav className="hidden items-center gap-7 font-mono text-[10px] uppercase tracking-[0.18em] text-zinc-400 lg:flex" aria-label="Navegação principal">
            <a href="#diagnostico" className="transition-colors hover:text-cyan-300">Diagnóstico</a>
            <a href="#elenco" className="transition-colors hover:text-cyan-300">Elenco</a>
            <a href="#demos" className="transition-colors hover:text-cyan-300">Demos</a>
            <a href="#faq" className="transition-colors hover:text-cyan-300">FAQ</a>
          </nav>
          <button type="button" onClick={scrollToCapture} className="mm-button mm-button-small">
            Quero meus vídeos <ArrowDownRight className="size-4" />
          </button>
        </div>
      </header>

      <main>
        {/* === 01 — HERO === */}
        <section id="top" data-section="01-hero" className="relative overflow-hidden border-b border-white/10 pb-20 pt-16 md:pb-28 md:pt-24">
          <ParallaxBg bg={assets.bgHero} opacity={0.5} scale={1.3} speed={0.5} />
          <div aria-hidden className="mm-parallax-overlay" style={{ background: "linear-gradient(180deg, rgba(5,7,7,0.45) 0%, rgba(5,7,7,0.65) 60%, rgba(5,7,7,0.85) 100%)" }} />
          <div aria-hidden className="mm-orb left-[-12rem] top-[-10rem] bg-cyan-400/15" />
          <div aria-hidden className="mm-orb bottom-[-12rem] right-[-10rem] bg-rose-500/12" />
          <div className="container relative z-10 grid items-center gap-14 lg:grid-cols-[1.15fr_0.85fr]">
            <div>
              <SectionLabel index="01">criativos que vendem</SectionLabel>
              <div className="mb-7 inline-flex items-center gap-2 rounded-full border border-rose-400/25 bg-rose-500/8 px-4 py-2 font-mono text-[10px] uppercase tracking-[0.16em] text-rose-300">
                <Zap className="size-3.5" /> Pare de postar vídeos que não vendem
              </div>
              <h1 className="max-w-4xl text-[clamp(2.8rem,6.5vw,5.5rem)] font-extrabold uppercase leading-[0.95] tracking-[-0.03em] text-white drop-shadow-[0_0_30px_rgba(0,229,255,0.08)]">
                Vídeos que <span className="mm-glitch-text" data-text="vendem">vendem</span> enquanto você dorme.
              </h1>
              <p className="mt-8 max-w-2xl text-lg leading-8 text-zinc-300 md:text-xl">
                A Movie Money produz seus criativos de TikTok Shop do zero. Roteiro, elenco, gravação e edição — tudo por nós. Você não precisa de tempo, equipe nem equipamento. Receba o vídeo pronto para postar e vender.
              </p>
              <div className="mt-9 flex flex-col gap-3 sm:flex-row">
                <button type="button" onClick={scrollToCapture} className="mm-button">
                  Quero meus vídeos agora <ArrowRight className="size-5" />
                </button>
                <a href="#demos" className="mm-button mm-button-ghost">
                  <CirclePlay className="size-5" /> Ver vídeos reais
                </a>
              </div>
              <div className="mt-10 flex flex-wrap gap-2 font-mono text-[9px] uppercase tracking-[0.16em] text-zinc-500">
                {['HOOK: 1.5S', 'LIP_SYNC: VALIDADO', 'SAFE_ZONE: ATIVA', 'FORMATOS: 06'].map(item => (
                  <span key={item} className="rounded-full border border-white/10 bg-white/[0.02] px-4 py-2">{item}</span>
                ))}
              </div>
            </div>

            <div className="relative mx-auto w-full max-w-[520px]">
              <div className="mm-machine-card mm-glow-cyan aspect-[4/5] overflow-hidden p-3">
                <div className="relative h-full overflow-hidden bg-[#0b1010]">
                  <img src={assets.beto} alt="Beto, porta-voz da Movie Money" className="h-full w-full object-cover object-top grayscale-[0.08]" />
                  <div className="absolute inset-0 bg-gradient-to-t from-[#030505] via-transparent to-cyan-400/5" />
                  <div className="absolute left-4 top-4 flex items-center gap-2 rounded-full border border-cyan-300/25 bg-black/60 px-3 py-1.5 font-mono text-[8px] tracking-[0.18em] text-cyan-300 backdrop-blur">
                    <span className="size-1.5 animate-pulse rounded-full bg-cyan-300" /> ATIVO
                  </div>
                  <div className="absolute inset-x-4 bottom-4 rounded-xl border border-white/10 bg-black/70 p-4 backdrop-blur">
                    <p className="font-bold text-white">Beto</p>
                    <p className="mt-1 font-mono text-[9px] uppercase tracking-[0.16em] text-zinc-500">estratégia · direção · GC</p>
                  </div>
                </div>
              </div>
              <div aria-hidden className="absolute -right-5 top-1/3 hidden font-mono text-[8px] uppercase tracking-[0.2em] text-cyan-300/60 [writing-mode:vertical-rl] md:block">personagem mestre // identidade persistente</div>
            </div>
          </div>
        </section>

        {/* === 02 — NÚMEROS === */}
        <section data-section="02-proposta" className="relative overflow-hidden border-b border-white/10 bg-cyan-300 text-[#041010]">
          <ParallaxBg bg={assets.bgStats} opacity={0.15} scale={1.2} speed={0.3} />
          <div className="container relative z-10 grid divide-y divide-black/15 md:grid-cols-3 md:divide-x md:divide-y-0">
            {[
              ["06", "personas prontas para gravar hoje"],
              ["02", "vídeos reais nesta página"],
              ["72h", "de acesso individual ao diagnóstico"],
            ].map(([value, label]) => (
              <div key={label} className="flex items-baseline gap-4 py-6 md:px-8 md:first:pl-0">
                <strong className="text-4xl font-black tracking-[-0.06em]">{value}</strong>
                <span className="max-w-40 font-mono text-[10px] uppercase leading-4 tracking-[0.12em]">{label}</span>
              </div>
            ))}
          </div>
        </section>

        {/* === 03 — DIAGNÓSTICO === */}
        <ParallaxSection id="diagnostico" data-section="03-diagnostico" bg={assets.bgProblem} overlay="linear-gradient(180deg, rgba(5,7,7,0.7) 0%, rgba(5,7,7,0.55) 50%, rgba(5,7,7,0.85) 100%)" className="border-b border-white/10 py-24 md:py-32">
          <div className="container relative z-10">
            <SectionLabel index="03">o problema real</SectionLabel>
            <div className="grid gap-12 lg:grid-cols-[0.9fr_1.1fr] lg:gap-20">
              <h2 className="mm-heading">Você posta todo dia e não vende nada.</h2>
              <div className="grid gap-px bg-white/10 sm:grid-cols-2">
                {[
                  [ScanLine, "Hook sem tensão", "Seus primeiros 3 segundos não prendem. O público desliza antes de ouvir a oferta."],
                  [Fingerprint, "Conteúdo sem identidade", "A audiência reconhece o template antes de reconhecer o seu produto."],
                  [Layers3, "Produção amadora", "Sem elenco, sem roteiro, sem edição profissional. O vídeo parece feito às pressas."],
                  [Clock3, "Volume sem resultado", "Você posta mais e mais, mas nenhum vídeo gera venda real."],
                ].map(([Icon, title, text]) => {
                  const IconComponent = Icon as typeof ScanLine;
                  return (
                    <article key={String(title)} className="rounded-2xl bg-[#080b0b] p-7 md:p-8">
                      <IconComponent className="mb-8 size-6 text-rose-400" />
                      <h3 className="text-xl font-bold text-white">{String(title)}</h3>
                      <p className="mt-3 text-sm leading-6 text-zinc-500">{String(text)}</p>
                    </article>
                  );
                })}
              </div>
            </div>
          </div>
        </ParallaxSection>

        {/* === 04 — A MÁQUINA === */}
        <section data-section="04-solucao" className="border-y border-white/10 bg-[#080b0b] py-24 md:py-32">
          <div className="container grid gap-14 lg:grid-cols-2 lg:items-center">
            <div>
              <SectionLabel index="04">a solução</SectionLabel>
              <h2 className="mm-heading">Você pede o vídeo. A gente faz tudo.</h2>
              <p className="mt-7 max-w-xl text-base leading-8 text-zinc-400">
                Esquece câmera, luz, editor, ator, roteiro. A Movie Money é uma operação criativa completa. Você diz o produto, a gente entrega o vídeo pronto para vender no TikTok Shop.
              </p>
              <p className="mt-4 max-w-xl text-base leading-8 text-zinc-400">
                Cada vídeo nasce de uma estratégia: quem precisa parar de rolar, qual tensão vai prender, e qual prova visual vai converter.
              </p>
              <button type="button" onClick={scrollToCapture} className="mt-8 inline-flex items-center gap-2 font-mono text-xs uppercase tracking-[0.14em] text-cyan-300 transition-all hover:gap-4">
                Quero começar agora <ArrowRight className="size-4" />
              </button>
            </div>
            <div className="mm-terminal mm-glow-cyan">
              <div className="flex items-center justify-between border-b border-white/10 px-5 py-4 font-mono text-[9px] uppercase tracking-[0.18em] text-zinc-500">
                <span>movie_money.pipeline</span><span className="text-emerald-400">● online</span>
              </div>
              <div className="space-y-5 p-6 font-mono text-xs md:p-8">
                {[
                  ["01", "insight", "dor + desejo + linguagem do público"],
                  ["02", "roteiro", "hook + mecanismo + CTA que converte"],
                  ["03", "produção", "personagem + produto + contexto real"],
                  ["04", "auditoria", "fala + corte + safe zone validados"],
                ].map(([step, title, value]) => (
                  <div key={step} className="grid grid-cols-[34px_1fr] gap-4">
                    <span className="text-cyan-300">{step}</span>
                    <div className="border-b border-dashed border-white/10 pb-5">
                      <span className="text-white">{title}</span><span className="text-zinc-600"> :: </span><span className="text-zinc-400">{value}</span>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </section>

        {/* === 05 — FORMATOS === */}
        <section data-section="05-formatos" className="py-24 md:py-32">
          <div className="container">
            <SectionLabel index="05">formatos que vendem</SectionLabel>
            <div className="mb-14 grid gap-6 lg:grid-cols-[1.1fr_0.9fr] lg:items-end">
              <h2 className="mm-heading">6 formatos. Cada um para um objetivo.</h2>
              <p className="max-w-xl text-base leading-8 text-zinc-500 lg:justify-self-end">O formato certo muda tudo. A Movie Money escolhe a linguagem pelo comportamento que o seu produto precisa provocar no cliente.</p>
            </div>
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {formats.map(([number, title, description]) => (
                <article key={title} className="group min-h-56 rounded-2xl border border-white/10 bg-[#060808] p-7 transition-all duration-300 hover:border-cyan-300/20 hover:bg-[#0b1111] hover:shadow-[0_12px_40px_rgba(0,229,255,0.06)]">
                  <div className="mb-12 flex items-start justify-between">
                    <span className="font-mono text-[10px] tracking-[0.2em] text-cyan-300">FMT_{number}</span>
                    <ArrowDownRight className="size-5 text-zinc-700 transition-colors group-hover:text-rose-400" />
                  </div>
                  <h3 className="text-2xl font-bold text-white">{title}</h3>
                  <p className="mt-3 text-sm leading-6 text-zinc-500">{description}</p>
                </article>
              ))}
            </div>
          </div>
        </section>

        {/* === 06 — ELENCO === */}
        <ParallaxSection id="elenco" data-section="06-elenco" bg={assets.bgCast} overlay="linear-gradient(180deg, rgba(5,7,7,0.75) 0%, rgba(5,7,7,0.6) 50%, rgba(5,7,7,0.85) 100%)" className="border-y border-white/10 py-24 md:py-32">
          <div className="container relative z-10">
            <SectionLabel index="06">elenco proprietário</SectionLabel>
            <div className="mb-12 flex flex-col justify-between gap-6 md:flex-row md:items-end">
              <h2 className="mm-heading max-w-3xl">Rostos que a audiência reconhece. Vídeo após vídeo.</h2>
              <p className="max-w-sm text-sm leading-7 text-zinc-400">Elenco próprio significa consistência. A audiência confia em quem já viu antes. Isso converte mais do que qualquer template.</p>
            </div>
            <div className="grid grid-cols-2 gap-3 md:grid-cols-3 lg:grid-cols-6">
              {cast.map(person => (
                <article key={person.name} className="mm-cast-card group">
                  <div className="aspect-[4/5] overflow-hidden rounded-t-[1.25rem] bg-[#101414]">
                    <img src={person.image} alt={`${person.name}, personagem Movie Money`} className="h-full w-full object-cover object-top grayscale-[0.2] transition duration-500 group-hover:scale-[1.03] group-hover:grayscale-0" loading="lazy" />
                  </div>
                  <div className="border-t border-white/10 p-4 rounded-b-[1.25rem]">
                    <h3 className="font-bold text-white">{person.name}</h3>
                    <p className={`mt-1 font-mono text-[8px] uppercase tracking-[0.12em] ${person.accent === 'cyan' ? 'text-cyan-300' : 'text-rose-400'}`}>{person.role}</p>
                  </div>
                </article>
              ))}
            </div>
          </div>
        </ParallaxSection>

        {/* === 07 — PIPELINE === */}
        <section data-section="07-pipeline" className="py-24 md:py-32">
          <div className="container">
            <SectionLabel index="07">como funciona</SectionLabel>
            <h2 className="mm-heading max-w-4xl">Do pedido ao vídeo pronto. Sem você tocar em nada.</h2>
            <div className="relative mt-16 grid gap-8 md:grid-cols-4">
              <div aria-hidden className="absolute left-0 right-0 top-6 hidden h-px bg-gradient-to-r from-cyan-300 via-white/15 to-rose-400 md:block" />
              {[
                ["A", "Você pede", "Diz o produto e o objetivo. A Movie Money faz o resto."],
                ["B", "A gente planeja", "Escolhe formato, hook, personagem e prova visual."],
                ["C", "A gente produz", "Gravação, fala, montagem e tratamento profissional."],
                ["D", "Você recebe", "Vídeo pronto para postar no TikTok Shop e vender."],
              ].map(([letter, title, text]) => (
                <article key={letter} className="relative pt-1 md:pt-14">
                  <div className="absolute left-0 top-0 z-10 flex size-12 items-center justify-center rounded-full border border-cyan-300/40 bg-[#050707] font-mono text-xs text-cyan-300">{letter}</div>
                  <h3 className="text-xl font-bold text-white">{title}</h3>
                  <p className="mt-3 text-sm leading-6 text-zinc-500">{text}</p>
                </article>
              ))}
            </div>
          </div>
        </section>

        {/* === 08 — DEMOS === */}
        <section id="demos" data-section="08-demos" className="border-y border-white/10 bg-[#080b0b] py-24 md:py-32">
          <div className="container">
            <SectionLabel index="08">vídeos reais</SectionLabel>
            <div className="mb-12 grid gap-6 lg:grid-cols-2 lg:items-end">
              <h2 className="mm-heading">Não é mockup. Dê play nos vídeos que já saíram.</h2>
              <p className="max-w-xl text-base leading-8 text-zinc-500 lg:justify-self-end">Dois formatos do mesmo produto. Veja como a linguagem muda sem perder a mensagem que vende.</p>
            </div>
            <div className="grid gap-6 lg:grid-cols-2">
              {[
                [assets.pov, "POV · Sunscreen Stick", "A câmera vira o cliente. Ele sente o produto na própria pele."],
                [assets.gc, "Green Screen · Sunscreen Stick", "Comentário direto com contexto visual que prova o que está sendo dito."],
              ].map(([video, title, text]) => (
                <article key={title} className="mm-machine-card p-3">
                  <div className="grid gap-4 bg-[#030505] p-3 sm:grid-cols-[190px_1fr] sm:items-center">
                    <video src={video} controls playsInline preload="metadata" className="mx-auto aspect-[9/16] max-h-[500px] w-full bg-black object-cover" aria-label={title} />
                    <div className="p-3 sm:p-6">
                      <Film className="size-6 text-rose-400" />
                      <h3 className="mt-8 text-2xl font-bold text-white">{title}</h3>
                      <p className="mt-3 text-sm leading-7 text-zinc-500">{text}</p>
                      <div className="mt-8 flex flex-wrap gap-2 font-mono text-[8px] uppercase tracking-[0.14em] text-zinc-600">
                        <span className="border border-white/10 px-2 py-1">vertical</span>
                        <span className="border border-white/10 px-2 py-1">pt-br</span>
                        <span className="border border-white/10 px-2 py-1">master</span>
                      </div>
                    </div>
                  </div>
                </article>
              ))}
            </div>
          </div>
        </section>

        {/* === 09 — TECNOLOGIA === */}
        <section data-section="09-tecnologia" className="py-24 md:py-32">
          <div className="container grid gap-14 lg:grid-cols-[0.85fr_1.15fr] lg:items-start">
            <div className="lg:sticky lg:top-28">
              <SectionLabel index="09">diferencial técnico</SectionLabel>
              <h2 className="mm-heading">Detalhe técnico que o viewer sente sem saber.</h2>
              <p className="mt-6 text-base leading-8 text-zinc-500">O objetivo não é exibir tecnologia. É remover as pequenas falhas que quebram confiança, retenção e clareza nos primeiros segundos.</p>
            </div>
            <div className="space-y-3">
              {[
                [WandSparkles, "Lip sync auditável", "Fala e movimento verificados quadro a quadro no master final."],
                [ShieldCheck, "Safe zone de interface", "Texto, rosto e produto respeitam as áreas ocupadas pela plataforma."],
                [Terminal, "Pipeline reprodutível", "Scripts e checkpoints preservam decisões entre versões e sessões."],
                [Sparkles, "Variação com hipótese", "Hooks e CTAs mudam de forma controlada para produzir aprendizado útil."],
              ].map(([Icon, title, text], index) => {
                const IconComponent = Icon as typeof WandSparkles;
                return (
                  <article key={String(title)} className="group grid gap-5 rounded-2xl border border-white/10 bg-white/[0.015] p-6 transition-all duration-300 hover:border-cyan-300/25 hover:shadow-[0_8px_30px_rgba(0,229,255,0.05)] sm:grid-cols-[52px_1fr_auto] sm:items-center">
                    <div className="flex size-12 items-center justify-center rounded-full border border-white/10 text-cyan-300"><IconComponent className="size-5" /></div>
                    <div><h3 className="font-bold text-white">{String(title)}</h3><p className="mt-1 text-sm leading-6 text-zinc-500">{String(text)}</p></div>
                    <span className="font-mono text-[9px] text-zinc-700">SYS_{String(index + 1).padStart(2, '0')}</span>
                  </article>
                );
              })}
            </div>
          </div>
        </section>

        {/* === 10 — PROVA === */}
        <section data-section="10-prova" className="border-y border-white/10 bg-[#080b0b] py-24 md:py-32">
          <div className="container">
            <SectionLabel index="10">prova real</SectionLabel>
            <div className="grid gap-12 lg:grid-cols-[1fr_1fr]">
              <div>
                <h2 className="mm-heading">Sem depoimento falso. Sem número inventado.</h2>
                <p className="mt-7 max-w-xl text-base leading-8 text-zinc-400">A prova está no que você pode inspecionar agora: elenco próprio, vídeos reais reproduzíveis nesta página, documentação de produção e pipeline auditável. Nada aqui é genérico.</p>
              </div>
              <div className="grid gap-3 sm:grid-cols-2">
                {[
                  [BadgeCheck, "Identidade", "6 personagens com referência visual"],
                  [Film, "Execução", "2 vídeos reais nesta landing"],
                  [Terminal, "Rastreabilidade", "Roteiros, scripts e checkpoints"],
                  [ShieldCheck, "Controle", "Auditoria antes do status final"],
                ].map(([Icon, title, text]) => {
                  const IconComponent = Icon as typeof BadgeCheck;
                  return <div key={String(title)} className="rounded-2xl border border-white/10 bg-[#050707] p-6"><IconComponent className="size-5 text-cyan-300" /><h3 className="mt-8 font-bold text-white">{String(title)}</h3><p className="mt-2 text-xs leading-5 text-zinc-500">{String(text)}</p></div>;
                })}
              </div>
            </div>
          </div>
        </section>

        {/* === 11 — OFERTA + CAPTURA === */}
        <ParallaxSection id="capture" data-section="11-oferta-captura" bg={assets.bgOffer} overlay="linear-gradient(180deg, rgba(5,7,7,0.6) 0%, rgba(5,7,7,0.5) 50%, rgba(5,7,7,0.75) 100%)" className="py-24 md:py-32">
          <div className="container relative z-10">
            <SectionLabel index="11">oferta de entrada</SectionLabel>
            <div className="mm-offer-grid mm-glow-rose overflow-hidden border border-cyan-300/25 bg-[#070a0a]/90 backdrop-blur-sm">
              <div className="p-8 md:p-12 lg:p-16">
                <p className="font-mono text-[10px] uppercase tracking-[0.2em] text-rose-400">acesso individual · 72 horas</p>
                <h2 className="mt-5 max-w-3xl text-4xl font-black uppercase leading-[0.95] tracking-[-0.05em] text-white md:text-6xl">Receba seu diagnóstico + plano de vídeos que vendem.</h2>
                <p className="mt-7 max-w-2xl text-base leading-8 text-zinc-300">O cadastro libera uma página individual com prazo de 72 horas. A Movie Money registra seu interesse e prepara o diagnóstico do seu próximo ciclo criativo.</p>
                <div className="mt-9 grid gap-3 sm:grid-cols-2">
                  {["Diagnóstico do seu gargalo criativo", "Recomendação personalizada de formatos", "Direção de hook, prova e CTA", "Próximo passo de produção documentado"].map(item => <div key={item} className="flex gap-3 text-sm text-zinc-200"><Check className="mt-0.5 size-4 shrink-0 text-cyan-300" />{item}</div>)}
                </div>
              </div>
              <form onSubmit={submit} className="border-t border-white/10 p-8 md:p-12 lg:border-l lg:border-t-0" noValidate>
                <div className="mb-8 flex items-center justify-between border-b border-white/10 pb-5">
                  <div><p className="font-mono text-[9px] uppercase tracking-[0.2em] text-cyan-300">lead.capture</p><p className="mt-1 text-sm text-zinc-500">Campos obrigatórios</p></div>
                  <span className="size-2 animate-pulse rounded-full bg-emerald-400" aria-label="Sistema online" />
                </div>
                <label className="mm-field">
                  <span>Nome</span>
                  <input required minLength={2} maxLength={160} autoComplete="name" value={form.name} onChange={event => setForm(current => ({ ...current, name: event.target.value }))} placeholder="Como podemos chamar você?" />
                </label>
                <label className="mm-field mt-5">
                  <span>E-mail</span>
                  <input required type="email" maxLength={320} autoComplete="email" value={form.email} onChange={event => setForm(current => ({ ...current, email: event.target.value }))} placeholder="voce@empresa.com" />
                </label>
                <label className="mt-6 flex cursor-pointer items-start gap-3 text-xs leading-5 text-zinc-500">
                  <input required type="checkbox" checked={form.consent} onChange={event => setForm(current => ({ ...current, consent: event.target.checked }))} className="mt-0.5 size-4 shrink-0 accent-cyan-300" />
                  <span>Concordo com o uso dos meus dados para responder a esta solicitação e apresentar a oferta Movie Money, conforme a LGPD.</span>
                </label>
                {captureLead.error && <p role="alert" className="mt-5 rounded-lg border border-rose-400/20 bg-rose-500/5 p-3 text-xs leading-5 text-rose-300">Não foi possível concluir o cadastro. Verifique os campos e tente novamente.</p>}
                <button type="submit" disabled={captureLead.isPending} className="mm-button mt-8 w-full justify-center">
                  {captureLead.isPending ? <><Loader2 className="size-5 animate-spin" /> Gravando acesso</> : <>Liberar meu acesso de 72h <ArrowRight className="size-5" /></>}
                </button>
                <div className="mt-5 flex items-center justify-center gap-2 font-mono text-[8px] uppercase tracking-[0.14em] text-zinc-600"><ShieldCheck className="size-3.5" /> prazo calculado e persistido no servidor</div>
              </form>
            </div>
          </div>
        </ParallaxSection>

        {/* === 12 — FAQ === */}
        <section id="faq" data-section="12-faq" className="border-y border-white/10 bg-[#080b0b] py-24 md:py-32">
          <div className="container grid gap-12 lg:grid-cols-[0.72fr_1.28fr]">
            <div>
              <SectionLabel index="12">dúvidas</SectionLabel>
              <h2 className="mm-heading">Antes de pedir seus vídeos.</h2>
            </div>
            <div className="divide-y divide-white/10 rounded-2xl border border-white/10 overflow-hidden">
              {faqs.map(([question, answer]) => (
                <details key={question} className="group py-1">
                  <summary className="flex list-none items-center justify-between gap-6 py-6 text-left font-bold text-white marker:content-none">
                    {question}<ChevronDown className="size-4 shrink-0 text-cyan-300 transition-transform group-open:rotate-180" />
                  </summary>
                  <p className="max-w-2xl pb-7 pr-10 text-sm leading-7 text-zinc-500">{answer}</p>
                </details>
              ))}
            </div>
          </div>
        </section>

        {/* === 13 — CTA FINAL === */}
        <ParallaxSection data-section="13-cta-final" bg={assets.bgHero} overlay="linear-gradient(180deg, rgba(5,7,7,0.55) 0%, rgba(5,7,7,0.45) 50%, rgba(5,7,7,0.8) 100%)" className="py-24 md:py-36">
          <div aria-hidden className="absolute inset-0 z-[1] bg-[linear-gradient(rgba(0,229,255,0.035)_1px,transparent_1px),linear-gradient(90deg,rgba(0,229,255,0.035)_1px,transparent_1px)] bg-[size:52px_52px]" />
          <div className="container relative grid gap-14 lg:grid-cols-[1fr_0.64fr] lg:items-center">
            <div>
              <SectionLabel index="13">cta final</SectionLabel>
              <h2 className="max-w-4xl text-[clamp(2.8rem,6vw,5.5rem)] font-extrabold uppercase leading-[0.92] tracking-[-0.04em] text-white">Pare de improvisar vídeos. Comece a vender de verdade.</h2>
              <p className="mt-8 max-w-xl text-lg leading-8 text-zinc-300">O formulário está logo acima. O primeiro passo leva menos tempo do que continuar postando vídeos que não convertem.</p>
            </div>
            <div className="mm-machine-card mm-glow-cyan bg-[#070a0a]/90 backdrop-blur-sm p-8 md:p-10">
              <p className="font-mono text-[9px] uppercase tracking-[0.2em] text-rose-400">última chamada // acesso 72h</p>
              <p className="mt-5 text-lg font-semibold leading-7 text-white">Volte ao formulário, registre seu prazo individual e abra a página segura da oferta.</p>
              <button type="button" onClick={scrollToCapture} className="mm-button mt-8 w-full justify-center">Ir para o formulário <ArrowRight className="size-5" /></button>
            </div>
          </div>
        </ParallaxSection>
      </main>

      {/* === FOOTER === */}
      <footer className="border-t border-white/10 py-9">
        <div className="container flex flex-col justify-between gap-5 text-xs text-zinc-600 md:flex-row md:items-center">
          <img src={assets.logo} alt="Movie Money" className="h-10 w-auto object-contain opacity-90 drop-shadow-[0_0_8px_rgba(0,229,255,0.15)]" />
          <p>© 2026 Movie Money. Criatividade com processo, evidência e continuidade.</p>
          <a href="#top" className="font-mono uppercase tracking-[0.14em] text-cyan-300">voltar ao topo ↑</a>
        </div>
      </footer>
    </div>
  );
}
